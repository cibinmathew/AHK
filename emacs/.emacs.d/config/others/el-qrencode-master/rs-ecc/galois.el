;; -*- lexical-binding: t -*-

;;;; Copyright (c) 2011-2014 jnjcc, Yste.org. All rights reserved.
;;;;
;;;; Galois Field with primitive element 2, as used by Reed-Solomon code

;; (in-package #:cl-qrencode)
(require 'cl)
(require 'eieio)

(defclass galois ()
  ((power :initform nil :initarg :power :reader gf-power
          :documentation "Galois Field GF(2^POWER)")
   (prime-poly :initform nil :initarg :ppoly :reader prime-poly
               :documentation "prime polynomial")
   (order :initform nil :reader gf-order)
   (exp-table :initform nil)
   (log-table :initform nil)))

(defmethod initialize-instance :after ((gf galois) &rest args)
  (declare (ignore args))
  (setf (slot-value gf 'order) (ash 1 (slot-value gf 'power)))
  (let* ((order (gf-order gf))
         (ppoly (prime-poly gf))
         ;; 2^0 = 1 && (log 0) = -1
         (exptab (make-vector order 1))
         (logtab (make-vector order -1)))
    (do ((i 1 (1+ i)))
        ((>= i order))
      (setf (aref exptab i) (* (aref exptab (- i 1)) 2))
      (when (>= (aref exptab i) order)
        (setf (aref exptab i)
              (logand (- order 1)
                     (logxor (aref exptab i) ppoly))))
      (setf (aref logtab (aref exptab i)) i))
    (setf (aref logtab 1) 0)
    (setf (slot-value gf 'exp-table) exptab)
    (setf (slot-value gf 'log-table) logtab)))

;;; value accessor
(defgeneric gf-exp (gf pow)
  "2^POW under Galois Field GF")
(defgeneric gf-log (gf value)
  "VALUE should be within range [0, 2^POW - 1]")

(defmethod gf-exp ((gf galois) pow)
  (let* ((sz (- (gf-order gf) 1))
         (idx (mod pow sz)))
    (aref (slot-value gf 'exp-table) idx)))

(defmethod gf-log ((gf galois) value)
  (let* ((sz (gf-order gf))
         (idx (mod value sz)))
    (aref (slot-value gf 'log-table) idx)))

;;; Galois Field arithmetic
(defgeneric gf-add (gf a b))
(defgeneric gf-subtract (gf a b))
(defgeneric gf-multiply (gf a b))
(defgeneric gf-divide (gf a b))

(defmethod gf-add ((gf galois) a b)
  (logxor a b))

(defmethod gf-subtract ((gf galois) a b)
  (logxor a b))

(defmethod gf-multiply ((gf galois) a b)
  (let ((sum (+ (gf-log gf a) (gf-log gf b))))
    (gf-exp gf sum)))

(defmethod gf-divide ((gf galois) a b)
  (when (= b 0)
    (error "divide by zero"))
  (if (= a 0)
      0
      (let ((sub (- (gf-log gf a) (gf-log gf b))))
        (gf-exp gf sub))))

;;; open-paren at beg of line confuses `slime-compile-defun` which uses
;;; elisp function `beginning-of-defun`, which in turn involves
;;; backward-searching open-paren at beg of line
;;;   there seems to be no easy way to fix this problem
;; with an extra leading '\', docstring is kind of ulgy now, though
(defmacro with-gf-accessors (accessors gf &body body)
  "shortcuts for gf-exp & gf-log, usage:
\(with-gf-accessors ((gfexp gf-exp)) *gf-instance* ...)"
  `(cl-labels ,(mapcar (lambda (acc-entry)
                      (let ((acc-name (car acc-entry))
                            (method-name (cadr acc-entry)))
                        `(,acc-name (a)
                                    (,method-name ,gf a))))
                    accessors)
     ,@body))

(defmacro with-gf-arithmetics (ariths gf &body body)
  "shortcuts for gf-add, gf-subtract, gf-multiply & gf-divide, usage:
\(with-gf-arithmetics ((gf+ gf-add)) *gf-instance* ...)"
  `(cl-labels ,(mapcar (lambda (arith-entry)
                      (let ((arith-name (car arith-entry))
                            (method-name (cadr arith-entry)))
                        `(,arith-name (a b)
                                      (,method-name ,gf a b))))
                    ariths)
     ,@body))

(defmacro with-gf-shortcuts (accessors ariths gf &body body)
  "combined with-gf-accessors & with-gf-arithmetics, usage:
\(with-gf-shortcuts ((gflog gf-log)) ((gf* gf-multiply)) *gf-instance* ...)"
  `(cl-labels ,(append
             (mapcar (lambda (acc-entry)
                       (let ((acc-name (car acc-entry))
                             (method-name (cadr acc-entry)))
                         `(,acc-name (a)
                                     (,method-name ,gf a))))
                     accessors)
             (mapcar (lambda (arith-entry)
                       (let ((arith-name (car arith-entry))
                             (method-name (cadr arith-entry)))
                         `(,arith-name (a b)
                                       (,method-name ,gf a b))))
                     ariths))
     ,@body))
