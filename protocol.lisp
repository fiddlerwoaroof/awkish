(in-package :co.fwoar.awkish.protocol)

(defparameter *eof-sentinel* '#:eof)

(defgeneric make-client (client-designator source &key &allow-other-keys)
  (:documentation
   #.(tm "Given a CLIENT-DESIGNATOR, a SOURCE and optional initargs,
         |return an instance of the client.  This is called once
         |before anything else happens and the client can be used to
         |store state between records.")))

(defgeneric next-record (client-designator source)
  (:documentation
   #.(tm "Given a CLIENT-DESIGNATOR and a SOURCE, return the next
          |record. Before and after methods on this function can be
          |used to manage things like per-record caches.")))

(defgeneric parse-record (client-designator raw-record)
  (:documentation
   #.(tm "Given a record returned by NEXT-RECORD, parse out the
         |\"positional\" fields.")))

(defgeneric unpack-binders (client-designator record))

(defgeneric field-count (client-designator record))

(defgeneric resolve-column (client-designator record column-designator))
