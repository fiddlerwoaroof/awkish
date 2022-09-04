(in-package :co.fwoar.awkish)

(defmacro with-command-output ((s command &rest args &key (output nil output-p)
                                &allow-other-keys)
                               &body body)
  (declare (ignore output))
  (when output-p
    (error "can't override :output"))
  `(let ((,s (uiop:process-info-output
              (uiop:launch-program ,command :output :stream ,@args))))
     ,@body))


(defvar *client*)
(defvar *record*)
(defvar *nr*)
(defvar *nf*)
(defmacro do-lines ((line s &optional (client :lines)) &body body)
  (multiple-value-bind (body decls)
      (alexandria:parse-body body)
    (alexandria:with-gensyms (client-instance)
      (alexandria:once-only (s)
        `(let* ((,client-instance (make-client ,client ,s))
                (*client* ,client-instance))
           (loop for ,line = (next-record *client* ,s)
                 until (eql ,line *eof-sentinel*)
                 do ((lambda (,line)
                       ,@decls
                       (let ((*client* ,client-instance))
                         ,@body))
                     ,line)))))))

(defvar *pattern-binds* nil)
(defmacro awk ((s &key (args nil args-p) (client :lines)) &body pattern-actions)
  (let* ((begin (when (eql (caar pattern-actions) :begin)
                  (car pattern-actions)))
         (end (when (eql (caar (last pattern-actions)) :end)
                (car (last pattern-actions))))
         (pattern-actions (if begin
                              (cdr pattern-actions)
                              pattern-actions))
         (pattern-actions (if end
                              (butlast pattern-actions)
                              pattern-actions))
         (binders (when args-p
                    (mapcar (lambda (n)
                              (intern (format nil "$~d" n)))
                            (alexandria:iota args :start 1)))))
    `(block nil
       ,@(cdr begin)
       (let ((*nr* 0))
         (do-lines ($0 ,s ,client)
           (declare (ignorable $0))
           (let* (($* (parse-record *client* $0))
                  (*record* $*)
                  (*nf* (field-count *client* $*)))
             (declare (ignorable $*))
             (destructuring-bind (&optional ,@binders &rest $@)
                 (unpack-binders *client* $*)
               (declare (ignorable $@ ,@binders))
               ,@(mapcar (lambda (it)
                           (if (= 1 (length it))
                               (alexandria:with-gensyms (v)
                                 `(let ((,v ,(car it)))
                                    (when ,v
                                      (princ $0)
                                      (terpri))))
                               (let ((pattern (car it))
                                     (rest (cdr it)))
                                 (alexandria:with-gensyms (result binds)
                                   `(multiple-value-bind (,result ,binds) ,pattern
                                      (let ((*pattern-binds* (list* ,result (coerce ,binds 'list))))
                                        (when ,result
                                          ,@rest)))))))
                         pattern-actions)))
           (incf *nr*)))
       ,@(cdr end)
       (values))))

(defun ~ (regex thing)
  (cl-ppcre:scan-to-strings regex (string thing)))

(defmacro defawk (name (s args) &body body)
  `(defun ,name (,s)
     (awk (,s :args ,args)
       ,@body)))

#+(or)
(
 (defun preview-html (s)
   (alexandria:with-output-to-file (o "/tmp/out.html" :if-exists :supersede)
     (uiop:vomit-output-stream s o)
     (uiop:run-program (list "/usr/bin/open" "-a" "Safari" (namestring o)))
     #+(or)
     (uiop:run-program (list "/usr/bin/open" "-a" "Emacs" (namestring o)))))


 (spinneret:with-html
   (:table
    (with-input-from-string (s (format nil "a b~%c d~% e f"))
      (awk (s :args 2)
        (:begin (:thead (:th "first") (:th "second")))
        (t (:tr (mapc (lambda (cell)
                        (:td $1 cell))
                      $*)))
        (:end (:tfoot (:td "end first") (:td "end second")))))))

 (spinneret:with-html
   (:table
    (awk ((format nil "a b~%c d~% e f~%g") :args 2)
      (t (:tr (mapc (lambda (cell)
                      (:td $1 cell))
                    $*)))
      (:end (:tfoot (:td "end first") (:td "end second"))))))

 (spinneret:with-html
   (:table
    (with-command-output (s "ps aux")
      (awk (s :args 9)
        (:begin (:thead (:th "first") (:th "second")))
        (t (:tr (:td $1) (:td $2) (:td $3 "%") (:td $4)
                (:td (serapeum:string-join $@ " "))))
        (:end (:tfoot (:td "end first") (:td "end second")))))))

 (serapeum:with-collector (c)
   (with-command-output (s "ps aux")
     (awk (s :args 10)
       ((> *nf* 30) (c *nf* (car $@))))))

 )
