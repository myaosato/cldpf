(uiop/package:define-package :cldpf/html (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/stream :read-file-string)
                             (:export :make-note-page :make-index-page)
                             (:intern))
(in-package :cldpf/html)
;;don't edit above

(defun make-index-page (program-title feed-url items index-template-path index-file-path)
  (let ((template (read-file-string index-template-path)))
    (with-open-file (out index-file-path :direction :output :if-exists :supersede)
      (format out template
              program-title
              feed-url
              program-title
              program-title
              (make-item-links items)))))

(defun make-item-links (items)
  (loop for item in items
        collect (format nil 
                        "<a href=\"./notes/~A.html\">~A</a>" 
                        (getf item :name) (getf item :title))))

(defun make-note-page (item-title program-title audio-url notes note-template-path note-file-path)
  (let ((template (read-file-string note-template-path)))
    (with-open-file (out note-file-path :direction :output :if-exists :supersede)
      (format out template
              program-title item-title
              item-title
              audio-url
              notes))))
