(defpackage :co.fwoar.awkish.readtable
  (:use :cl)
  (:export ))

(in-package :co.fwoar.awkish.readtable)

(named-readtables:defreadtable :fwoar.awk
  (:macro-char #\@ 'read-col-designator t))

(named-readtables:defreadtable :fwoar.awk+standard
  (:merge :common-lisp :fwoar.awk))

(defun read-col-designator (s _)
  (declare (ignore _))
  (let ((designator (read s t nil t)))
    `(co.fwoar.awkish:resolve-column
      co.fwoar.awkish:*client*
      co.fwoar.awkish:*record*
      ,(etypecase designator
         (fixnum designator)
         (symbol (string-downcase designator))
         (string designator)))))
