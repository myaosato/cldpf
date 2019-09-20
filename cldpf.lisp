(uiop/package:define-package :cldpf/cldpf (:nicknames) (:use :cl) (:shadow)
                             (:import-from :cldpf/item :make-item-file)
                             (:import-from :cldpf/feed :make-feed)
                             (:import-from :cldpf/program :make-program)
                             (:import-from :cldpf/list :read-item-file 
                              :read-program-file)
                             (:export) (:intern))
(in-package :cldpf/cldpf)
;;don't edit above
