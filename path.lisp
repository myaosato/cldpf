(uiop/package:define-package :cldpf/path (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/pathname
                              :ensure-directory-pathname :merge-pathnames*)
                             (:export :get-feed-list-path 
                              :get-items-list-path :get-program-list-path
                              :get-items-dir-path :get-item-list-path
                              :get-pages-dir-path :get-notes-dir-path
                              :get-audios-dir-path :get-index-file-path
                              :get-feed-file-path :get-note-file-path
                              :get-audio-file-path
                              :get-index-template-path
                              :get-note-template-path)
                             (:intern))
(in-package :cldpf/path)
;;don't edit above

#|
program-dir
 |- .cldpf-feed
 |- .cldpf-items
 |- program
 |- items/
 |   |- ...
 |   
 |- pages/
     |- main-image.png
     |- feed.xml
     |- index.html
     |- notes/
     |   |- ...
     |
     |- audios/
     |   |- ...
|#

;; LIST (SEXP) FILES
(defun get-feed-list-path (program-dir)
  (merge-pathnames* program-dir ".cldpf-feed"))

(defun get-items-list-path (program-dir)
  (merge-pathnames* program-dir ".cldpf-items"))

(defun get-program-list-path (program-dir)
  (merge-pathnames* program-dir "program"))

(defun get-items-dir-path (program-dir)
  (ensure-directory-pathname
   (merge-pathnames* program-dir "items")))

(defun get-item-list-path (name program-dir)
   (merge-pathnames* (get-items-dir-path program-dir) name))

;; PAGE (XML/HTML) FILES
(defun get-pages-dir-path (program-dir)
  (ensure-directory-pathname
   (merge-pathnames* program-dir "pages")))

(defun get-notes-dir-path (program-dir)
  (ensure-directory-pathname
   (merge-pathnames* (get-pages-dir-path program-dir) "notes")))

(defun get-audios-dir-path (program-dir)
  (ensure-directory-pathname
   (merge-pathnames* (get-pages-dir-path program-dir) "audios")))

(defun get-index-file-path (program-dir)
  (merge-pathnames* (get-pages-dir-path program-dir) "index.html"))

(defun get-feed-file-path (program-dir)
  (merge-pathnames* (get-pages-dir-path program-dir) "feed.xml"))

(defun get-note-file-path (name program-dir)
  (merge-pathnames* (get-notes-dir-path program-dir) (format nil "~A.html" name)))

(defun get-audio-file-path (name program-dir)
  (merge-pathnames* (get-audios-dir-path program-dir) (format nil "~A.mp3" name)))

;; TEMPLATES
(defun get-templates-dir-path ()
  (ensure-directory-pathname
   (merge-pathnames* (asdf:system-source-directory :cldpf) "templates")))

(defun get-index-template-path ()
  (merge-pathnames* (get-templates-dir-path) "index.html"))

(defun get-note-template-path ()
  (merge-pathnames* (get-templates-dir-path) "note.html"))
