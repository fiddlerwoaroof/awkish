;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Package: ASDF-USER -*-

(defsystem :awkish
  :description ""
  :author "Ed L <edward@elangley.org>"
  :license "MIT"
  :depends-on (#:alexandria
               #:data-lens/beta/transducers
               #:serapeum
               #:spinneret
               #:uiop)
  :serial t
  :components ((:file "package")
               (:file "util")
               (:file "protocol")
               (:file "awkish")
               (:file "lines")))

(defsystem :awkish/readtable
  :depends-on (#:awkish
               #:named-readtables)
  :components ((:file "readtable")))

(defsystem :awkish/ndjson
  :depends-on (#:awkish
               #:yason)
  :components ((:file "ndjson")))
