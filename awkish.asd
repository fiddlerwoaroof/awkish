;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Package: ASDF-USER -*-
(in-package :asdf-user)

(defsystem :awkish
  :description ""
  :author "Ed L <edward@elangley.org>"
  :license "MIT"
  :depends-on (#:alexandria
               #:data-lens/beta/transducers
               #:named-readtables
               #:serapeum
               #:spinneret
               #:uiop
               #:yason)
  :serial t
  :components ((:file "package")
               (:file "awkish")
               ))
