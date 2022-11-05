(add-function :before-until tree-sitter-hl-face-mapping-function
            (lambda (capture-name)
                (pcase capture-name
                ("python.self" 'custom-set))))

(add-hook 'python-mode-hook
        (lambda ()
            (tree-sitter-hl-add-patterns nil
            [((function_definition (parameters (identifier) @python.self))
                (.match? @python.self "self"))])))