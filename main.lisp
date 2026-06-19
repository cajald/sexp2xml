(in-package #:sexp2xml)

(defun escape-xml (s)
  "Escape XML special characters."
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

(defun raw-p (x)
  (and (consp x)
       (eq (car x) :raw)
       (stringp (second x))
       (null (cddr x))))

(defun element-p (x)
  (and (consp x)
       (or (symbolp (car x))
           (stringp (car x)))
       (not (keywordp (car x)))))

(defun attr-plist-p (x)
  (and (consp x)
       (keywordp (first x))
       (evenp (length x))))

(defun xml-name (x)
  (etypecase x
    (symbol (string-downcase (symbol-name x)))
    (string x)))

(defun render-attrs (attrs)
  (if (null attrs)
      ""
      (with-output-to-string (out)
        (loop for (k v) on attrs by #'cddr do
          (format out " ~a=\"~a\""
                  (xml-name k)
                  (escape-xml (princ-to-string v)))))))

(defun render-node (node &optional (indent 0))
  (labels ((pad (n) (make-string n :initial-element #\Space)))
    (cond
      ;; NIL
      ((null node) "")

      ;; STRING
      ((stringp node)
       (escape-xml node))

      ;; RAW HTML
      ((raw-p node)
       (second node))

      ;; ELEMENT
      ((element-p node)
       (let* ((tag (car node))
              (rest (cdr node))
              (attrs (when (and rest (attr-plist-p (car rest)))
                       (car rest)))
              (children (if attrs (cdr rest) rest))
              (indent-str (pad indent))
              (child-indent (+ indent 2))
              (tag-name (xml-name tag))
              (attr-str (render-attrs attrs)))

         (if (null children)
             (format nil "~a<~a~a />"
                     indent-str tag-name attr-str)
             (let ((inner
                     (with-output-to-string (out)
                       (loop for child in children do
                         (write-string (render-node child child-indent) out)
                         (terpri out)))))
               (format nil "~a<~a~a>~%~a~a</~a>"
                       indent-str tag-name attr-str
                       inner
                       indent-str
                       tag-name)))))

      ;; FRAGMENT
      ((consp node)
       (with-output-to-string (out)
         (loop for child in node do
           (write-string (render-node child indent) out)
           (terpri out))))

      ;; fallback
      (t ""))))

(defmacro toxml (&body body)
  `(render-node ',(if (= (length body) 1)
                      (first body)
                      body)))
