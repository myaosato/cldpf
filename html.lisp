(uiop/package:define-package :cldpf/html (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/stream :read-file-srting)
                             (:export :make-note-page :make-index-page)
                             (:intern))
(in-package :cldpf/html)
;;don't edit above

(defun make-index-page (program-title items index-template-path index-file-path)
  (let ((template (read-file-string index-template-path)))
    (with-open-file (out index-file-path :direction :output)
      (foramt out template
              program-title
              program-title
              (make-item-links items)))))

(defun make-item-links (items)
  (loop for item in items
        do (format "<a href=\"~A\">~A</a>" (getf :url item) (getf :title item))))

(defun make-note-page (item-title program-title audio-url notes note-template-path note-file-path)
  (let ((template (read-file-string note-template-path)))
    (with-open-file (out notefile-path :direction :output)
      (foramt out template
              program-title item-title
              item-title
              audio-url
              (make-notes-list notes)))))
