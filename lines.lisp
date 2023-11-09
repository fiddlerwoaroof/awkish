(in-package :co.fwoar.awkish.lines)

(defclass lines ()
  ((%column-cache :initform (make-hash-table))))
(fw.lu:defclass+ stream-lines (lines)
  ())
(fw.lu:defclass+ string-lines (lines)
  ((%pos :initform 0 :accessor lines-pos)))

(defmethod resolve-column ((client lines) (record cons) (column-designator number))
  (if (= column-designator 0)
      record
      (let ((column-designator (1- column-designator)))
        (with-slots (%column-cache) client
          ;; manually tuned
          (if (> column-designator 60)
              (alexandria:ensure-gethash column-designator
                                         %column-cache
                                         (nth column-designator record))
              (nth column-designator record))))))

(defmethod parse-record ((client lines) (raw-record string))
  (serapeum:tokens raw-record))
(defmethod field-count ((client lines) (record list))
  (length record))
(defmethod unpack-binders ((client lines) (record list))
  record)


(defmethod make-client ((client (eql :lines)) (source stream) &key)
  (stream-lines))
(defmethod make-client ((client (eql :lines)) (source string) &key)
  (string-lines))

(defmethod next-record :before ((client lines) (source stream))
  (clrhash (slot-value client '%column-cache)))
(defmethod next-record ((client stream-lines) (source stream))
  (read-line source nil *eof-sentinel*))
(defmethod next-record ((client string-lines) (source string))
  (let ((next-newline (position #\newline source :start (lines-pos client))))
    (if (< (lines-pos client) (length source))
        (prog1 (subseq source (lines-pos client) next-newline)
          (setf (lines-pos client) (if next-newline
                                       (1+ next-newline)
                                       (length source))))
        *eof-sentinel*)))
