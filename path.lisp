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
  (merge-pathnames* ".cldpf-feed" program-dir))

(defun get-items-list-path (program-dir)
  (merge-pathnames* ".cldpf-items" program-dir))

(defun get-program-list-path (program-dir)
  (merge-pathnames* "program" program-dir))

(defun get-items-dir-path (program-dir)
  (merge-pathnames* "items/" program-dir))

(defun get-item-list-path (name program-dir)
   (merge-pathnames* name (get-items-dir-path program-dir)))

;; PAGE (XML/HTML) FILES
(defun get-pages-dir-path (program-dir)
  (merge-pathnames* "pages/" program-dir))

(defun get-notes-dir-path (program-dir)
  (merge-pathnames* "notes/" (get-pages-dir-path program-dir)))

(defun get-audios-dir-path (program-dir)
  (merge-pathnames* "audios/" (get-pages-dir-path program-dir)))

(defun get-index-file-path (program-dir)
  (merge-pathnames* "index.html" (get-pages-dir-path program-dir)))

(defun get-feed-file-path (program-dir)
  (merge-pathnames* "feed.xml" (get-pages-dir-path program-dir)))

(defun get-note-file-path (name program-dir)
  (merge-pathnames* (format nil "~A.html" name) (get-notes-dir-path program-dir)))

(defun get-audio-file-path (name program-dir)
  (merge-pathnames* (format nil "~A.mp3" name) (get-audios-dir-path program-dir)))

;; TEMPLATES
(defun get-templates-dir-path ()
  (merge-pathnames* "templates/" (asdf:system-source-directory :cldpf)))

(defun get-index-template-path ()
  (merge-pathnames* "index.html" (get-templates-dir-path)))

(defun get-note-template-path ()
  (merge-pathnames* "note.html" (get-templates-dir-path)))
