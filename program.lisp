(uiop/package:define-package :cldpf/program (:nicknames) (:use :cl) (:shadow)
                             (:import-from :uiop/filesystem :file-exists-p
                              :directory-exists-p)
                             (:import-from :uiop/pathname :merge-pathnames*
                              :ensure-directory-pathname)
                             (:export :make-program) (:intern))
(in-package :cldpf/program)
;;don't edit above

(defun make-program (name &key dir)
  (let ((program-dir (make-program-directory name dir)))
    (make-program-config-file program-dir)
    (make-program-notes-directory program-dir)
    (make-program-pages-directory program-dir)))

(defun make-program-directory (name dir)
  (unless (directory-exists-p dir) (error "~A dose not exists" dir))
  (let* ((base-dir (ensure-directory-pathname dir))
         (program-dir (ensure-directory-pathname (merge-pathnames* base-dir name))))
    (when (or (directory-exists-p program-dir)
              (file-exists-p program-dir))
      (error "~A already exists" program-path))
    (ensure-directories-exist program-dir)
    program-dir))

(defun make-program-config-file (program-dir)
  (let ((config-file (merge-pathnames* program-dir "program")))
    (with-open-file (out config-file :direction :output)
      (format out "~S" '(:title "your podcast name"
                         :link "your podcast page url"
                         :author "your name"
                         :category ""
                         :image "image url"
                         :language "your podcast language ISO 639-1"
                         :explicit nil)))))

(defun make-program-notes-directory (program-dir)
  (let ((notes-dir (ensure-directory-pathname 
                    (merge-pathnames* program-dir "notes"))))
    (ensure-directories-exist notes-dir)))

(defun make-program-pages-directory (program-dir)
  (let ((pages-dir (ensure-directory-pathname 
                    (merge-pathnames* program-dir "pages"))))
    (ensure-directories-exist pages-dir)))
