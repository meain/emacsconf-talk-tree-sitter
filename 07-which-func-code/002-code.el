(setq meain/tree-sitter-class-like '((rust-mode . (impl_item))
                                    (python-mode . (class_definition))))
(setq meain/tree-sitter-function-like '((rust-mode . (function_item))
                                        (go-mode . (function_declaration method_declaration))
                                        (sh-mode . (function_definition))
                                        (python-mode . (function_definition))))
(defun meain/tree-sitter-thing-name (kind)
"Get name of tree-sitter KIND thing."
(when-let (tree-sitter-mode
            (node-types (pcase kind
                            ('class-like meain/tree-sitter-class-like)
                            ('function-like meain/tree-sitter-function-like)))
            (node-at-point (cl-some #'tree-sitter-node-at-point
                                    (alist-get major-mode node-types)))
            (node-name (tsc-get-child-by-field node-at-point :name)))
    (tsc-node-text node-name)))