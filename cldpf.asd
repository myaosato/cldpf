;;don't edit
(defsystem "cldpf"
  :depends-on("cldpf/cldpf")
  :class :package-inferred-system
  :author "myaosato"
  :license "MIT"
  :pathname "src/"
  :mailto "tetu60u@yahoo.co.jp"
  :in-order-to ((test-op (test-op "cldpf/tests"))))

(defsystem "cldpf/tests"
  :author "myaosato"
  :depends-on ("cldpf/tests/main"
               "rove")
  :license "MIT"
  :class :package-inferred-system
  :perform (test-op (op c) (symbol-call :rove :run c)))
