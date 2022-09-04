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
