(uiop/package:define-package :cldpf/audio (:nicknames) (:use :cldpf/path :cl)
                             (:shadow) (:import-from :uiop/stream :copy-file)
                             (:export :copy-audio :get-file-length) (:intern))
(in-package :cldpf/audio)
;;don't edit above
(defun get-file-length (pathname)
  (with-open-file (s pathname :element-type '(unsigned-byte 8))
    (file-length s)))

(defun copy-audio (name program-dir source-pathname)
  (let ((audio-file (get-audio-file-path name program-dir)))
    (copy-file source-pathname audio-file)))

