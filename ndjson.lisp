(defpackage :co.fwoar.awkish.ndjson
  (:use :cl :co.fwoar.awkish.protocol)
  (:export ))

(in-package :co.fwoar.awkish.ndjson)

(defclass ndjson ()
  ((%delimiter :initarg :delimiter :reader delimiter)))

(defmethod make-client ((client (eql :ndjson)) (source stream) &key (delimiter #\newline))
  (fw.lu:new 'ndjson delimiter))

(defmethod next-record ((client ndjson) (source stream))
  (let ((line (read-line source nil *eof-sentinel*)))
    (if (eql line *eof-sentinel*)
        line
        (let ((yason:*parse-json-arrays-as-vectors* t))
          (yason:parse line)))))

(defmethod resolve-column ((client ndjson) (record hash-table) column-designator)
  (gethash column-designator record))

(defmethod resolve-column ((client ndjson) (record vector) (column-designator number))
  (aref record (1- column-designator)))

(defmethod parse-record ((client ndjson) raw-record)
  raw-record)

(defmethod field-count ((client ndjson) record)
  0)

(defmethod field-count ((client ndjson) (record vector))
  (length record))

(defmethod unpack-binders ((client ndjson) record)
  nil)

(defmethod unpack-binders ((client ndjson) (record vector))
  (coerce record 'list))
