(require "asdf")

(asdf:load-system "sexp2xml")

(defun print-help ()
  (format t "sexp2xml usage:~%")
  (format t "  sexp2xml~30tRead S-expression from stdin~%")
  (format t "  sexp2xml <FILE>~30tRead S-expression from file~%")
  (format t "Options:~%")
  (format t "  -h, --help~30tShow this help message~%")
  (format t "  -v, --version~30tShow the installed sexp2cli version~%"))

(defun print-version ()
  (format t "sexp2xml ~A~%" sexp2xml:*version*))

(defun read-in (path)
  (cond
    ((null path)
     (read *standard-input* nil nil))
    (t
     (with-open-file (in path :direction :input)
       (read in nil nil)))))

(defun main ()
  (handler-case
      (let* ((args (uiop:command-line-arguments))
             (arg (car args)))
        (cond
          ((member arg '("-h" "--help") :test #'string=)
           (print-help)
           (uiop:quit 0))

          ((member arg '("-v" "--version") :test #'string=)
           (print-version)
           (uiop:quit 0)))

        (let ((data (read-in arg)))
          (if data
              (progn
                (princ (sexp2xml:render-node data))
                (terpri))
              (progn
                (format *error-output* "sexp2xml: no input provided~%")
                (uiop:quit 2)))))

    (error (e)
      (format *error-output* "sexp2xml: error: ~A~%" e)
      (uiop:quit 1))))

(save-lisp-and-die "sexp2xml"
  :toplevel #'main
  :executable t
  :compression t)
