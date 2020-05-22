(use-package typescript-mode
  :ensure t
  :config
  (require 'ansi-color)
  (defun colorize-compilation-buffer ()
    (ansi-color-apply-on-region compilation-filter-start (point-max)))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
  
  ;;  (global-set-key (kbd "C-x g") 'magit-status)
  )

(use-package lsp-mode
  :ensure t
  )

(use-package company-lsp
  :ensure t
  :config
  (require 'company-lsp)
  (push 'company-lsp company-backends)
  )



