(defpackage :co.fwoar.awkish.package
  (:use :cl)
  (:export))
(in-package :co.fwoar.awkish.package)

(defpackage :co.fwoar.awkish.util
  (:use :cl)
  (:export #:tm #:with-command-output))

(defpackage :co.fwoar.awkish.protocol
  (:use :cl)
  (:import-from :co.fwoar.awkish.util #:tm)
  (:export #:*eof-sentinel* #:*eof-sentinel* #:field-count
           #:make-client #:next-record #:parse-record #:resolve-column
           #:unpack-binders))

(defpackage :co.fwoar.awkish.lines
  (:use :cl :co.fwoar.awkish.protocol)
  (:export))

(defpackage :co.fwoar.awkish
  (:use :cl :co.fwoar.awkish.protocol)
  (:export #:*client* #:*eof-sentinel* #:*nf* #:*nr* #:*pattern-binds*
           #:*record* #:awk #:defawk #:field-count #:make-client #:next-record
           #:parse-record #:resolve-column #:unpack-binders
           #:with-command-output #:~))
