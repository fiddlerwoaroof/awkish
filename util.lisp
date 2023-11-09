(in-package :co.fwoar.awkish.util)

(defun tm (string)
  (serapeum:string-join
   (data-lens.transducers:into ()
                               (data-lens:•
                                (data-lens.transducers:mapping 'serapeum:trim-whitespace)
                                (data-lens.transducers:mapping (lambda (it)
                                                                 (string-left-trim "|" it))))
                               (fwoar.string-utils:split #\newline string))
   #\newline))

(defmacro with-command-output ((s command &rest args &key (output nil output-p)
                                &allow-other-keys)
                               &body body)
  (declare (ignore output))
  (when output-p
    (error "can't override :output"))
  `(let ((,s (uiop:process-info-output
              (uiop:launch-program ,command :output :stream ,@args))))
     ,@body))
