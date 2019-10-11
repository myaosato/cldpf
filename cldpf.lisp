(uiop/package:define-package :cldpf/cldpf (:nicknames) (:use :cldpf/path :cl)
                             (:shadow)
                             (:import-from :cldpf/audio :get-file-length
                              :copy-audio)
                             (:import-from :cldpf/path)
                             (:import-from :uiop/pathname
                              :ensure-directory-pathname :merge-pathnames*)
                             (:import-from :local-time :+rfc-1123-format+
                              :format-timestring :now)
                             (:import-from :cldpf/html :make-note-page
                              :make-index-page)
                             (:import-from :cldpf/item :item-list-template)
                             (:import-from :cldpf/feed :make-feed)
                             (:import-from :cldpf/program :make-program)
                             (:import-from :cldpf/list :write-items-list
                              :read-items-list :read-feed-list :write-feed-list
                              :read-item-list :read-program-list)
                             (:export :update-pages :update-item :make-item 
                              :make-program :add-item)
                             (:intern))
(in-package :cldpf/cldpf)
;;don't edit above
(defun make-item (name program-dir audio-source)
  (let ((item-file (get-item-list-path name program-dir)))
    (with-open-file (out item-file :direction :output)
      (format out (item-list-template :length (get-file-length audio-source))))
    (copy-audio name program-dir audio-source)))

(defun add-item (name program-dir)
  (%update-item name program-dir t))

(defun update-item (name program-dir)
  (%update-item name program-dir nil))

(defun %update-item (name program-dir &optional (add-item? nil))
  (let ((program (read-program-list program-dir))
        (item (read-item-list name program-dir))
        (feed (read-feed-list program-dir))
        (items (read-items-list program-dir)))
    (setf feed (update-feed program item feed))
    (write-feed-list feed program-dir)
    (when add-item?
      (setf items (register-item name item items))
      (write-items-list items program-dir))
    (add-page name program-dir)
    (make-feed-file feed program-dir)))

(defun update-feed (program item feed)
  (setf (getf feed :title) (getf program :title))
  (setf (getf feed :link) (getf program :link))
  (setf (getf feed :author) (getf program :author))
  (setf (getf feed :category) (getf program :category))
  (setf (getf feed :description) (getf program :description))
  (setf (getf feed :language) (getf program :language))
  (setf (getf feed :explicit) (getf program :explicit))
  (setf (getf feed :image) (getf program :image))
  (push item (getf feed :items))
  feed)

(defun register-item (name item items)
  (setf (getf item :name) name)
  (push item items)
  items)

(defun add-page (name program-dir)
  (let ((program (read-program-list program-dir))
        (item (read-item-list name program-dir))
        (items (read-items-list program-dir)))
    (make-index-page program items
                     (get-index-template-path)
                     (get-index-file-path program-dir))
    (make-note-page item program
                    (get-note-template-path)
                    (get-note-file-path name program-dir))))

(defun update-pages (program-dir)
  (let ((program (read-program-list program-dir))
        (items (read-items-list program-dir)))
    (make-index-page program items
                     (get-index-template-path)
                     (get-index-file-path program-dir))
    (loop for data in items
          do (let ((item (read-item-list (getf data :name) program-dir)))
               (make-note-page item program
                               (get-note-template-path)
                               (get-note-file-path (getf data :name) program-dir))))))
  
(defun make-feed-file (feed program-dir)
  (let ((rss (get-feed-file-path program-dir)))
    (with-open-file (out rss :direction :output :if-exists :supersede)
      (format out "~A" (make-feed feed)))))

(defun now-as-pubdate ()
  (format-timestring nil (now) :format +rfc-1123-format+))