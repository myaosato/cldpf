(uiop/package:define-package :cldpf/tests/main (:nicknames)
                             (:use :cldpf/cldpf :rove :cl) (:shadow) (:export)
                             (:intern))
(in-package :cldpf/tests/main)
;;don't edit above
(deftest sample
  (testing "sample"
    (ok nil)))
