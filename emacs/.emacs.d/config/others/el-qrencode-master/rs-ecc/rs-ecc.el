;; -*- lexical-binding: t -*-

;;;; Copyright (c) 2011-2014 jnjcc, Yste.org. All rights reserved.
;;;;
;;;; Reed-Solomon error correction code as used by QR code

;;(in-package #:cl-qrencode)
(require 'cl)
(require 'eieio)

;;; Reed-Solomon code uses GF(2^8) with prime polynomial 285,
;;; or 1,0001,1101, or (x^8 + x^4 + x^3 + x^2 + 1)
(defvar gf256 (make-instance 'galois :power 8 :ppoly 285))
(defun gf* (a b) (gf-multiply gf256 a b))
(defun gf+ (a b) (gf-add gf256 a b))
(defun gf- (a b) (gf-subtract gf256 a b))
(defun gfexp (pw) (gf-exp gf256 pw))
(defun gflog (pw) (gf-log gf256 pw))

;; Polynomial arithmetics under GF(2^8), as used by Reed-Solomon ecc
(defun rs* (poly b)
  "multiply B on every element of POLY under GF(2^8)"
  (poly-multiply poly b #'gf*))

(defun rs- (lhs rhs)
  (poly-substract lhs rhs #'gf-))

(defun rs% (msg gen rem)
  (poly-mod msg gen rem #'rs- #'rs*))

(defclass rs-ecc ()
  ((k :initform nil :initarg :k
      :documentation "# of data codewords")
   (ec :initform nil :initarg :ec
       :documentation "# of error correction codewords")
   (gpoly :initform nil :reader gpoly
          :documentation "with EC, we calculate generator poly immediately")))

(defmethod initialize-instance :after ((rs rs-ecc) &rest args)
  (declare (ignore args))
  (setf (slot-value rs 'gpoly) (gen-poly rs)))

(defgeneric gen-poly (rs))
(defmethod gen-poly ((rs rs-ecc))
  "Generator Polynomial: (x-a^0) * (x-a^1) * ... * (x-a^(ec-1))"
  (with-slots (ec) rs
    (let* ((size (+ ec 1))
           (poly (make-list size nil)))
      (setf (nth 0 poly) 1
            (nth 1 poly) 1)
      (do ((i 2 (1+ i)))
          ((> i ec) poly)
        (setf (nth i poly) 1)
        (do ((j (- i 1) (1- j)))
            ((<= j 0))
          (if (not (= (nth j poly) 0))
              (setf (nth j poly)
                    (gf+ (nth (- j 1) poly)
                         (gf* (nth j poly) (gfexp (- i 1)))))
            (setf (nth j poly) (nth (- j 1) poly))))
        (setf (nth 0 poly) (gf* (nth 0 poly) (gfexp (- i 1)))))
      (reverse poly))))

(defgeneric gen-poly-gflog (rs))
(defgeneric ecc-poly (rs msg))

(defmethod gen-poly-gflog ((rs rs-ecc))
  ;; GPOLY already calculated when making new instance
  (mapcar #'gflog (gpoly rs)))

(defmethod ecc-poly ((rs rs-ecc) msg-poly)
  "Error Correction codewords Polynomial for MSG-POLY"
  (with-slots (k ec gpoly) rs
    (unless (= (length msg-poly) k)
      (dbg "wrong msg-poly length, expect: ~A~%" k))
    (rs% msg-poly gpoly ec)))

