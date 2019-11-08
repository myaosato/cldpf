(uiop/package:define-package :cldpf/tests/main (:nicknames)
                             (:use :cldpf/path :rove :cl) (:shadow) (:export)
                             (:intern))
(in-package :cldpf/tests/main)
;;don't edit above
(defvar *system-dir*
  (asdf:system-source-directory :cldpf))
(defvar *test-data-dir* 
  (merge-pathnames "tests/data/" (asdf:system-source-directory :cldpf)))
(defvar *test-program-dir* (merge-pathnames "sample/" *test-data-dir*))
(defun sample-dir-path (path)
  (merge-pathnames path *test-program-dir*))

(deftest sample
  (testing "sample"
    (ok nil)))

(deftest cldpf/path
  (testing "make project path"
    (ok (equal (get-feed-list-path *test-program-dir*)
               (sample-dir-path ".cldpf-feed")))
    (ok (equal (get-items-list-path *test-program-dir*)
               (sample-dir-path ".cldpf-items")))
    (ok (equal (get-program-list-path *test-program-dir*)
               (sample-dir-path "program")))
    (ok (equal (get-items-dir-path *test-program-dir*)
               (sample-dir-path "items/")))
    (ok (equal (get-item-list-path "1" *test-program-dir*)
               (sample-dir-path "items/1")))
    (ok (equal (get-item-list-path "hoge" *test-program-dir*)
               (sample-dir-path "items/hoge"))))
  (testing "make pages path"
    (ok (equal (get-pages-dir-path *test-program-dir*)
               (sample-dir-path "pages/")))
    (ok (equal (get-notes-dir-path *test-program-dir*)
               (sample-dir-path "pages/notes/")))
    (ok (equal (get-audios-dir-path *test-program-dir*)
               (sample-dir-path "pages/audios/")))
    (ok (equal (get-index-file-path *test-program-dir*)
               (sample-dir-path "pages/index.html")))
    (ok (equal (get-feed-file-path *test-program-dir*)
               (sample-dir-path "pages/feed.xml")))
    (ok (equal (get-note-file-path "1" *test-program-dir*)
               (sample-dir-path "pages/notes/1.html")))
    (ok (equal (get-note-file-path "hoge" *test-program-dir*)
               (sample-dir-path "pages/notes/hoge.html")))
    (ok (equal (get-audio-file-path "1" *test-program-dir*)
               (sample-dir-path "pages/audios/1.mp3")))
    (ok (equal (get-audio-file-path "hoge" *test-program-dir*)
               (sample-dir-path "pages/audios/hoge.mp3"))))
  (testing "get templates"
    (ok (equal (get-index-template-path)
               (merge-pathnames "templates/index.html" *system-dir*)))
    (ok (equal (get-note-template-path)
               (merge-pathnames "templates/note.html" *system-dir*)))))
    
