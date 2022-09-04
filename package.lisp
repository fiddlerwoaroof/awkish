(defpackage :co.fwoar.awkish.package
  (:use :cl)
  (:export))
(in-package :co.fwoar.awkish.package)

(defpackage :co.fwoar.awkish.util
  (:use :cl )
  (:export #:tm))

(defpackage :co.fwoar.awkish.protocol
  (:use :cl )
  (:import-from :co.fwoar.awkish.util
                #:tm)
  (:export #:*eof-sentinel*
           #:make-client
           #:next-record
           #:parse-record
           #:unpack-binders
           #:field-count
           #:resolve-column
           #:*eof-sentinel*))

(defpackage :co.fwoar.awkish.lines
  (:use :cl :co.fwoar.awkish.protocol)
  (:export ))

(defpackage :co.fwoar.awkish.readtable
  (:use :cl)
  (:export ))


(defpackage :co.fwoar.awkish
  (:use :cl :co.fwoar.awkish.protocol)
  (:export #:*eof-sentinel*
           #:make-client
           #:next-record
           #:parse-record
           #:unpack-binders
           #:field-count
           #:resolve-column
           #:*client*
           #:*nr*
           #:*nf*
           #:*record*
           #:awk
           #:*pattern-binds*
           #:~
           #:defawk
           #:with-command-output))
