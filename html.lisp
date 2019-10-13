(uiop/package:define-package :cldpf/html (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/stream :read-file-string)
                             (:export :make-note-page :make-index-page)
                             (:intern))
(in-package :cldpf/html)
;;don't edit above

(defun make-index-page (program items index-template-path index-file-path)
  (let ((template (read-file-string index-template-path)))
    (with-open-file (out index-file-path :direction :output :if-exists :supersede)
      (format out template
              (getf program :twitter)
              (getf program :link)
              (getf program :title)
              (getf program :card-image)
              (getf program :description)
              (getf program :title)
              "./feed.xml"
              (getf program :title)
              (getf program :title)
              (make-item-links items)))))

(defun make-item-links (items)
  (loop for item in items
        collect (format nil 
                        "<a href=\"./notes/~A.html\">~A</a>" 
                        (getf item :name) (getf item :title))))

(defun make-note-page (name item program note-template-path note-file-path)
  (let ((template (read-file-string note-template-path)))
    (with-open-file (out note-file-path :direction :output :if-exists :supersede)
      (format out template
              (getf program :twitter)
              (format nil "~Anotes/~A.html" (getf program :link) name)
              (getf item :title)
              (getf program :card-image)
              (getf item :description)
              (getf program :title)
              (getf item :title)
              (getf item :title)
              (getf (getf item :enclosure) :url)
              (getf item :notes)))))

                             
                             
                             