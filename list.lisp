(uiop/package:define-package :cldpf/list (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/pathname
                              :ensure-directory-pathname :merge-pathnames*)
                             (:export :write-items-list :read-items-list
                              :read-feed-list :write-feed-list
                              :read-item-list :read-program-list)
                             (:intern))
(in-package :cldpf/list)
;;don't edit above
(defun read-program-list (program-dir)
  (let ((config-file (merge-pathnames* program-dir "program")))
    (with-open-file (in config-file :direction :input)
      (read in nil nil))))

(defun read-item-list (name program-dir)
  (let* ((items-dir (ensure-directory-pathname (merge-pathnames* program-dir "items")))
         (item-file (merge-pathnames* items-dir name)))
    (with-open-file (in item-file :direction :input)
      (read in nil nil))))

(defun read-feed-list (program-dir)
  (let ((feed-file (merge-pathnames* program-dir ".cldpf-feed")))
    (with-open-file (in feed-file :direction :input)
      (read in nil nil))))

(defun write-feed-list (feed program-dir)
  (let ((feed-file (merge-pathnames* program-dir ".cldpf-feed")))
    (with-open-file (out feed-file :direction :output :if-exists :supersede)
      (print feed out))))

(defun read-items-list (program-dir)
  (let ((items-file (merge-pathnames* program-dir ".cldpf-items")))
    (with-open-file (in items-file :direction :input)
      (read in nil nil))))

(defun write-items-list (items program-dir)
  (let ((items-file (merge-pathnames* program-dir ".cldpf-items")))
    (with-open-file (out items-file :direction :output :if-exists :supersede)
      (print items out))))