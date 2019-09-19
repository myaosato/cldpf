(uiop/package:define-package :cldpf/item (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/pathname
                              :ensure-directory-pathname :merge-pathnames*)
                             (:export :make-item-file) (:intern))
(in-package :cldpf/item)
;;don't edit above

(defun make-item-file (name program-dir)
  (let* ((items-dir (ensure-directory-pathname (merge-pathnames* program-dir "items")))
         (item-file (merge-pathnames* items-dir name)))
    (with-open-file (out item-file :direction :output)
      (format out "(:enclosure (:url ~S" "")
      (format out "~%             :type ~S" "")
      (format out "~%             :length ~S)" "")
      (format out "~% :title ~S" "")
      (format out "~% :description ~S" "")
      (format out "~% :explicit nil)"))))
