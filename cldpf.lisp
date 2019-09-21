(uiop/package:define-package :cldpf/cldpf (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/pathname
                              :ensure-directory-pathname :merge-pathnames*)
                             (:import-from :local-time :+rfc-1123-format+
                              :format-timestring :now)
                             (:import-from :cldpf/html :make-note-page
                              :make-index-page)
                             (:import-from :cldpf/item :make-item-file)
                             (:import-from :cldpf/feed :write-feed-file
                              :make-feed)
                             (:import-from :cldpf/program :make-program)
                             (:import-from :cldpf/list :read-item-file
                              :read-program-file)
                             (:export :make-item-file :make-program :add-item)
                             (:intern))
(in-package :cldpf/cldpf)
;;don't edit above
(defun add-item (name program-dir)
  (let ((program (read-program-file program-dir))
        (item (read-item-file name program-dir))
        (feed (read-feed-file program-dir)))
    (setf (getf feed :title) (getf program :title))
    (setf (getf feed :link) (getf program :link))
    (setf (getf feed :author) (getf program :author))
    (setf (getf feed :category) (getf program :category))
    (setf (getf feed :description) (getf program :description))
    (setf (getf feed :language) (getf program :language))
    (setf (getf feed :explicit) (getf program :explicit))
    (setf (getf feed :image) (getf program :image))
    (push item (getf feed :items))
    (write-feed-file feed program-dir)))

(defun update-pages (name program-dir)
  (let ((program (read-program-file program-dir))
        (item (read-item-file name program-dir))
        )
    (make-index-page (getf program :title)
                     (format nil "~Afeed.rss" (getf program :link))
                     '() ;; items ;; TODO
                     (get-template-index-path)
                     (get-pages-index-path program-dir))
    (make-note-page (getf item :title)
                    (getf program :title)
                    (getf (getf item :enclosure) :url)
                    (getf item :notes)
                    (get-template-note-path)
                    (get-pages-note-path name program-dir))))

(defun get-pages-dir-path (program-dir)
  (ensure-directory-pathname
   (merge-pathnames* program-dir "pages")))

(defun get-notes-dir-path (program-dir)
  (ensure-directory-pathname
   (merge-pathnames* (get-pages-dir-path program-dir) "notes")))

(defun get-pages-note-path (name program-dir)
  (merge-pathnames* (get-notes-dir-path program-dir) (format nil "~A.html" name)))

(defun get-pages-index-path (program-dir)
  (merge-pathnames* (get-pages-dir-path program-dir) "index.html"))

(defun get-templates-dir-path ()
  (ensure-directory-pathname
   (merge-pathnames* (asdf:system-source-directory :cldpf) "templates")))

(defun get-template-index-path ()
  (merge-pathnames* (get-templates-dir-path) "index.html"))

(defun get-template-note-path ()
  (merge-pathnames* (get-templates-dir-path) "note.html"))

(defun now-as-pubdate ()
  (format-timestring nil (now) :format +rfc-1123-format+))