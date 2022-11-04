(defun meain/go-default-returns (type errformat)
  "Making it a function instead of an alist so that we can handle unknown TYPE."
  (pcase type
    ("error" errformat)
    ("bool" "false")
    ("string" "\"\"")
    ("byte" "0") ("rune" "0")
    ("int" "0") ("int32" "0") ("int64" "0") ("uint64" "0")
    ("float32" "0.0") ("float64" "0.0")
    ("chan" "nil")
    ("interface" "nil")
    ("map" "nil")
    ("func" "nil")
    ((pred (string-prefix-p "<-")) "nil")
    ((pred (string-prefix-p "[")) "nil")
    ((pred (string-match " ")) nil) ; for situations with return name
    ((pred (string-prefix-p "*")) (concat (replace-regexp-in-string "\*" "&" type) "{}"))
    (_ (concat type "{}"))))
(defun meain/go-return-string (errformat)
  "Get return string for go by looking up the return type of current func."
  (let* ((f-declaration (tree-sitter-node-at-pos 'function_declaration))
         (m-declaration (tree-sitter-node-at-pos 'method_declaration))
         (func-node (if (eq f-declaration nil) m-declaration f-declaration))
         (return-node (tsc-get-child-by-field func-node ':result)))
    ;; remove extra whitespace if nothing at end
    (replace-regexp-in-string
     " $"
     ""
     (concat "return "
             (if return-node
                 (let ((return-node-type (tsc-node-type return-node))
                       (return-node-text (tsc-node-text return-node)))
                   (pcase return-node-type
                     ('parameter_list
                      (string-join
                       (remove-if #'null
                                  (mapcar (lambda (x)
                                            (meain/go-default-returns x errformat))
                                          (mapcar 'string-trim
                                                  (split-string
                                                   (string-trim return-node-text "(" ")")
                                                   ","))))
                       ", "))
                     (_ (meain/go-default-returns return-node-text errformat)))))))))