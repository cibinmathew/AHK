;; -*- lexical-binding: t -*-

;;;; Copyright (c) 2011-2014 jnjcc, Yste.org. All rights reserved.
;;;;
;;;; Data masking

;;(in-package #:cl-qrencode)
(require 'cl)

;;; only encoding region modules (excluding format information) are masked
(defun encoding-module-p (matrix i j)
  "modules belong to encoding region, excluding format & version information"
  (or (eq (aref (aref matrix i) j) :light)
      (eq (aref (aref matrix i) j) :dark)))
(defun non-mask-module-p (matrix i j)
  (not (encoding-module-p matrix i j)))
(defun reverse-module-color (matrix i j)
  (case (aref (aref matrix i) j)
    (:dark :light) (:light :dark)))

;;; all modules are evaluated:
;;;  there should be only :dark :light :fdark :flight modules left by now
(defun dark-module-p (matrix i j)
  (or (eq (aref (aref matrix i) j) :fdark)
      (eq (aref (aref matrix i) j) :dark)))

(defun copy-and-mask (matrix modules level mask-ind)
  "make a new matrix and mask using MASK-IND for later evaluation"
  (let ((ret (make-modules-matrix modules nil))
        (mask-p (mask-condition mask-ind))
        (darks 0))
    (dotimes (i modules)
      (dotimes (j modules)
        (cond
          ((non-mask-module-p matrix i j)
           (setf (aref (aref ret i) j) (aref (aref matrix i) j)))
          ((funcall mask-p i j) ; need mask
           (setf (aref (aref ret i) j) (reverse-module-color matrix i j)))
          (t
           (setf (aref (aref ret i) j) (aref (aref matrix i) j))))
        (when (dark-module-p ret i j)
          (incf darks))))
    (multiple-value-bind (dummy fi-darks)
        (format-information ret modules level mask-ind)
      (declare (ignore dummy))
      ;; add format information dark modules
      (values ret (+ darks fi-darks)))))

(defun mask-matrix (matrix modules level mask-ind)
  "do not evaluate, just go ahead and mask MATRIX using MASK-IND mask pattern"
  (let ((mask-p (mask-condition mask-ind)))
    (dotimes (i modules)
      (dotimes (j modules)
        (and (encoding-module-p matrix i j)
             (funcall mask-p i j)
             (setf (aref (aref matrix i) j) (reverse-module-color matrix i j)))))
    ;; paint format information
    (format-information matrix modules level mask-ind)
    matrix))

(defun choose-masking (matrix modules level)
  "mask and evaluate using each mask pattern, choose the best mask result"
  (let ((n4 10)
        (best-matrix nil)
        (mask-indicator nil)
        (min-penalty nil)
        (square (* modules modules))
        (cur-penalty 0))
    (dotimes (i *mask-pattern-num*)
      (multiple-value-bind (cur-matrix darks)
          (copy-and-mask matrix modules level i)
        ;; feature 4: proportion of dark modules in entire symbol
        (let ((bratio (/ (+ (* darks 200) square) square 2)))
          (setf cur-penalty (* (/ (abs (- bratio 50)) 5) n4)))
        (incf cur-penalty (evaluate-feature-123 cur-matrix modules))
        (when (or (null min-penalty)
                  (< cur-penalty min-penalty))
          (setf min-penalty cur-penalty
                mask-indicator i
                best-matrix cur-matrix))))
    (values best-matrix mask-indicator)))

;;; feature 1 & 2 & 3
(defun evaluate-feature-123 (matrix modules)
  (let ((penalty 0))
    (incf penalty (evaluate-feature-2 matrix modules))
    (dotimes (col modules)
      (let ((rlength (calc-run-length matrix modules col :row)))
        (incf penalty (evaluate-feature-1 rlength))
        (incf penalty (evaluate-feature-3 rlength))))
    (dotimes (row modules)
      (let ((rlength (calc-run-length matrix modules row :col)))
        (incf penalty (evaluate-feature-1 rlength))
        (incf penalty (evaluate-feature-3 rlength))))
    penalty))

(defun calc-run-length (matrix modules num direction)
  "list of number of adjacent modules in same color"
  (when (null direction) (setf direction :row))
  (let ((rlength nil)
        (ridx 0))
    (cl-labels ((get-elem (idx)
               (case direction
                 (:row (aref (aref matrix num) idx))
                 (:col (aref (aref matrix idx) num))))
             (add-to-list (list elem)
               (append list (list elem))))
      ;; we make sure (NTH 1 rlength) is for dark module
      (when (same-color-p (get-elem 0) :dark)
        (setf rlength (add-to-list rlength -1)
              ridx 1))
      (setf rlength (add-to-list rlength 1))

      (loop for i from 1 to (- modules 1) do
           (if (same-color-p (get-elem i) (get-elem (- i 1)))
               (incf (nth ridx rlength))
               (progn
                 (incf ridx)
                 (setf rlength (add-to-list rlength 1)))))
      rlength)))

(defun evaluate-feature-1 (rlength)
  "(5 + i) adjacent modules in row/column in same color. (N1 + i) points, N1 = 3"
  (let ((n1 3)
        (penalty 0))
    (dolist (sz rlength penalty)
      (when (> sz 5)
        (incf penalty (+ n1 sz -5))))))

(defun evaluate-feature-3 (rlength)
  "1:1:3:1:1 ration (dark:light:dark:light:dark) pattern in row/column,
preceded or followed by light area 4 modules wide. N3 points, N3 = 40"
  (let ((n3 40)
        (len (length rlength))
        (penalty 0))
    (do ((i 3 (+ i 2)))
        ((>= i (- len 2)) penalty)
      (when (and (= (mod i 2) 1) ; for dark module
                 (= (mod (nth i rlength) 3) 0)
        (let ((fact (floor (nth i rlength) 3)))
          ;; 1:1:3:1:1
          (when (= fact
                   (nth (- i 2) rlength)
                   (nth (- i 1) rlength)
                   (nth (+ i 1) rlength)
                   (nth (+ i 2) rlength))
            (cond
              ((<= (- i 3) 0) (incf penalty n3))
              ((>= (+ i 4) len) (incf penalty n3))
              ((>= (nth (- i 3) rlength) (* 4 fact)) (incf penalty n3))
              ((>= (nth (+ i 3) rlength) (* 4 fact)) (incf penalty n3))))))))))

(defun evaluate-feature-2 (matrix modules)
  "block m * n of modules in same color. N2 * (m-1) * (n-1) points, N2=3"
  (let ((n2 3)
        (penalty 0)
        (bcount 0))
    (dotimes (i (- modules 1) penalty)
      (dotimes (j (- modules 1))
        (when (dark-module-p matrix i j)
          (incf bcount))
        (when (dark-module-p matrix (+ i 1) j)
          (incf bcount))
        (when (dark-module-p matrix i (+ j 1))
          (incf bcount))
        (when (dark-module-p matrix (+ i 1) (+ j 1))
          (incf bcount))
        (when (or (= bcount 0) (= bcount 4))
          (incf penalty n2))))))
