(uiop/package:define-package :cldpf/feed (:nicknames) (:use :cl) (:shadow)
                             (:export :make-feed) (:intern))
(in-package :cldpf/feed)
;;don't edit above
(defun inident-space (indent &optional (width 4))
  (format nil "~{~A~}" (make-list (* indent width) :initial-element " ")))

(defun render-list (lines indent)
  (let ((indent-space (inident-space indent)))
    (with-output-to-string (out)
      (dolist (line lines)
        (format out "~%~A~A" indent-space line)))))

(defun getff (place &rest keys)
  (if keys 
      (apply #'getff (cons (getf place (car keys)) (cdr keys)))
      place))
 
(defun tag (name content)
  (if content 
      (format nil "<~A>~A</~A>" name content name)
      ""))
 
(defun make-item-content (plist)
  (list
   (format nil "<enclosure url=\"~A\"" (getff plist :enclosure :url))
   (format nil "           type=\"~A\" length=\"~A\" />" 
           (getff plist :enclosure :type) (getff plist :enclosure :length))
   (tag "title" (getf plist :title))
   (tag "description" (getf plist :description))
   (tag "googleplay:description" (getf plist :description))
   (tag "itunes:description" (getf plist :description))
   (tag "googleplay:explicit" (if (getf plist :explicit) "yes" "no"))
   (tag "itunes:explicit" (if (getf plist :explicit) "yes" "no"))
   ;; TODO guid
   ;; TODO itunes:duration
   (tag "pubDate" (getf plist :pubDate))))

(defun make-item (plist indent)
  (with-output-to-string (out)
    (format out "~%~A<item>" (inident-space indent))
    (format out "~A" (render-list (make-item-content plist) (1+ indent)))
    (format out "~%~A</item>" (inident-space indent))))

(defun make-channel-head (plist)
  (list 
    (tag "title" (getf plist :title))
    (tag "link" (getf plist :link))
    (tag "language" (getf plist :language))
    (tag "googleplay:author" (getf plist :author))
    (tag "itunes:author" (getf plist :author))
    (tag "googleplay:category" (getf plist :category))
    (tag "itunes:category" (getf plist :category))
    (tag "description" (getf plist :description))
    (tag "googleplay:description" (getf plist :description))
    (tag "itunes:description" (getf plist :description))
    (tag "googleplay:explicit" (if (getf plist :explicit) "yes" "no"))
    (tag "itunes:explicit" (if (getf plist :explicit) "yes" "no"))))

(defun make-channel-image (plist indent)
  (with-output-to-string (out)
    (format out "~%~A~A" (inident-space indent) 
            (tag "googleplay:image" (getf plist :image)))
    (format out "~%~A~A" (inident-space indent) 
            (tag "itunes:image" (getf plist :image)))
    (format out "~%~A<image>" (inident-space indent))
    (format out "~A" (render-list (list
                                   (tag "link" (getf plist :link))
                                   (tag "title" (getf plist :title))
                                   (tag "url" (getf plist :image)))
                                  (1+ indent)))
    (format out "~%~A</image>" (inident-space indent))))

(defun make-channel (plist indent)
  (with-output-to-string (out)
    (format out "~%~A<channel>" (inident-space indent))
    (format out "~A" (render-list (make-channel-head plist) (1+ indent)))
    (format out "~A" (make-channel-image plist (1+ indent)))
    (dolist (item (getf plist :items))
      (format out "~A" (make-item item (1+ indent))))
    (format out "~%~A</channel>" (inident-space indent))))

(defun make-feed (plist)
  (with-output-to-string (out)
    (format out "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
    (format out "~%<rss version=\"2.0\"")
    (format out "~%     xmlns:googleplay=\"http://www.google.com/schemas/play-podcasts/1.0\"")
    (format out "~%     xmlns:itunes=\"http://www.itunes.com/dtds/podcast-1.0.dtd\">")
    (format out "~A" (make-channel plist 1))
    (format out "~%</rss>")
    (format out "~%")))
