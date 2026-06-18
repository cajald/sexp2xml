(in-package #:sexp2xml)

(defun escape-xml (s)
  "Escape XML special characters. For text nodes."
  (with-output-to-string (out)
    (loop for c across s do
      (write-string
       (case c
         (#\< "&lt;")
         (#\> "&gt;")
         (#\& "&amp;")
         (#\" "&quot;")
         (t (string c)))
       out))))

(defun attr-plist-p (x)
  "Check if a given list is in the format of (:key val ...)"
  (and (consp x)
       (keywordp (first x))
       (evenp (length x))))

(defun render-attrs (attrs)
  "Render attributes in XML format"
  (if (null attrs)
      ""
      (with-output-to-string (out)
        (loop for (k v) on attrs by #'cddr do
          (format out " ~a=\"~a\""
                  (string-downcase (symbol-name k))
                  (escape-xml (princ-to-string v)))))))

(defun render-node (node &optional (indent 0))
  "Render any node into XML."
  (cond
    ;; TEXT node
    ((stringp node)
     (escape-xml node))

    ;; ELEMENT node
    ((consp node)
     (let* ((tag (car node))
            (rest (cdr node))
            (attrs (when (and rest (attr-plist-p (car rest)))
                     (car rest)))
            (children (if attrs (cdr rest) rest))
            (attr-str (render-attrs attrs))
            (indent-str (make-string indent :initial-element #\Space))
            (child-indent (+ indent 2)))

       (if (null children)
           (format nil "~a<~a~a />"
                   indent-str tag attr-str)
           (let ((inner
                   (with-output-to-string (out)
                     (dolist (child children)
                       (write-string
                        (render-node child child-indent)
                        out)
                       (write-string (string #\Newline) out)))))

             (format nil "~a<~a~a>~%~a~a~a</~a>"
                     indent-str tag attr-str
                     inner
                     indent-str
                     (make-string child-indent :initial-element #\Space)
                     tag)))))

    ;; fallback
    (t "")))

(defmacro toxml (x)
  `(render-node ,x))
