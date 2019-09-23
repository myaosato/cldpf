(uiop/package:define-package :cldpf/list (:nicknames) (:use :cldpf/path :cl) (:shadow)
                             (:export :write-items-list :read-items-list
                              :read-feed-list :write-feed-list
                              :read-item-list :read-program-list)
                             (:intern))
(in-package :cldpf/list)
;;don't edit above
(defun read-program-list (program-dir)
  (let ((program-list (get-program-list-path program-dir)))
    (with-open-file (in program-list :direction :input)
      (read in nil nil))))

(defun read-item-list (name program-dir)
  (let ((item-list (get-item-list-path name program-dir)))
    (with-open-file (in item-list :direction :input)
      (read in nil nil))))

(defun read-feed-list (program-dir)
  (let ((feed-list (get-feed-list-path program-dir)))
    (with-open-file (in feed-list :direction :input)
      (read in nil nil))))

(defun write-feed-list (feed program-dir)
  (let ((feed-list (get-feed-list-path program-dir)))
    (with-open-file (out feed-list :direction :output :if-exists :supersede)
      (print feed out))))

(defun read-items-list (program-dir)
  (let ((items-list (get-items-list-path program-dir)))
    (with-open-file (in items-list :direction :input)
      (read in nil nil))))

(defun write-items-list (items program-dir)
  (let ((items-list (get-items-list-path program-dir)))
    (with-open-file (out items-list :direction :output :if-exists :supersede)
      (print items out))))
