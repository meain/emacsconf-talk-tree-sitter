(add-function :before-until tree-sitter-hl-face-mapping-function
            (lambda (capture-name)
                (pcase capture-name
                ("python.docstring" 'diff-refine-added))))

(add-hook 'python-mode-hook
        (lambda ()
            (tree-sitter-hl-add-patterns nil
            [(function_definition (block (expression_statement (string)
                                                                @python.docstring)))])))