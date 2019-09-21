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
    (make-feed-list-file program-dir)
    (make-items-list-file program-dir)
    (make-program-items-directory program-dir)
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
      (format out "(:title ~S" "your podcast name")
      (format out "~% :link ~S" "your podcast page url")
      (format out "~% :author ~S" "your name")
      (format out "~% :language ~S" "your podcast language ISO 639-1")
      (format out "~% :category ~S" "")
      (format out "~% :image ~S" "image url")
      (format out "~% :description ~S" "")
      (format out "~% :explicit nil)"))))

(defun make-feed-list-file (program-dir)
  (let ((config-file (merge-pathnames* program-dir ".cldpf-feed")))
    (with-open-file (out config-file :direction :output)
      (format out "()"))))

(defun make-items-list-file (program-dir)
  (let ((config-file (merge-pathnames* program-dir ".cldpf-items")))
    (with-open-file (out config-file :direction :output)
      (format out "()"))))

(defun make-program-items-directory (program-dir)
  (let ((notes-dir (ensure-directory-pathname
                    (merge-pathnames* program-dir "items"))))
    (ensure-directories-exist notes-dir)))

(defun make-program-pages-directory (program-dir)
  (let ((pages-dir (ensure-directory-pathname
                    (merge-pathnames* program-dir "pages"))))
    (ensure-directories-exist pages-dir)
    (make-pages-audios-directory pages-dir)
    (make-pages-notes-directory pages-dir)))

(defun make-pages-audios-directory (pages-dir)
  (let ((audio-dir (ensure-directory-pathname
                    (merge-pathnames* pages-dir "audios"))))
    (ensure-directories-exist audio-dir)))

(defun make-pages-notes-directory (pages-dir)
  (let ((audio-dir (ensure-directory-pathname
                    (merge-pathnames* pages-dir "notes"))))
    (ensure-directories-exist audio-dir)))
