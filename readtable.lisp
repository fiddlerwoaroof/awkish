(in-package :co.fwoar.awkish.readtable)

(named-readtables:defreadtable :fwoar-awk
  (:macro-char #\@ 'read-col-designator t))

(defun read-col-designator (s _)
  (declare (ignore _))
  (let ((designator (read s t nil t)))
    `(resolve-column *client*
                     *record*
                     ,(etypecase designator
                        (fixnum designator)
                        (symbol (string-downcase designator))
                        (string designator)))))
