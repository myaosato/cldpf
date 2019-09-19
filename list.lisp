(uiop/package:define-package :cldpf/list (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/pathname
                              :ensure-directory-pathname :merge-pathnames*)
                             (:export :read-item-file :read-program-file)
                             (:intern))
(in-package :cldpf/list)
;;don't edit above
(defun read-program-file (program-dir)
  (let ((config-file (merge-pathnames* program-dir "program")))
    (with-open-file (in config-file :direction :input)
      (read in nil nil))))

(defun read-item-file (name program-dir)
  (let* ((items-dir (ensure-directory-pathname (merge-pathnames* program-dir "items")))
         (item-file (merge-pathnames* items-dir name)))
    (with-open-file (in item-file :direction :input)
      (read in nil nil))))
