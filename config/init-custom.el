
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(font-lock-comment-face ((t (:foreground "#008200"))))
 '(font-lock-constant-face ((t (:foreground "#000000"))))
 '(font-lock-doc-string-face ((t (:foreground "#FF0000"))))
 '(font-lock-function-name-face ((t (:foreground "black"))))
 '(font-lock-keyword-face ((t (:foreground "#0000FF"))))
 '(font-lock-preprocessor-face ((t (:foreground "#0000AF"))))
 '(font-lock-reference-face ((t (:foreground "black"))))
 '(font-lock-string-face ((t (:foreground "black"))))
 '(font-lock-type-face ((t (:foreground "#000000"))))
 '(font-lock-variable-name-face ((t (:foreground "black")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(default-input-method "latin-4-postfix")
 '(ediff-patch-options "-f -p5")
 '(global-font-lock-mode t nil (font-lock))
 '(helm-pdfgrep-default-command "pdfgrep --cache --color always -niH %s %s")
 '(magit-completing-read-function 'helm--completing-read-default)
 '(menu-bar-mode t)
 '(package-selected-packages
   '(xclip ztree py-yapf web-mode emmet-mode cmake-mode ccls lsp-mode helm-config dockerfile-mode yaml-mode helm-rg avy expand-region markdown-mode yatemplate buttercup helm-c-yasnippet yasnippet-snippets yasnippet company helm-smex smex helm-projectile helm-make helm-tramp helm-swoop helm-ag helm-flx helm use-package magit haskell-mode))
 '(safe-local-variable-values '((indent-tabs-mode quote t)))
 '(select-enable-clipboard t)
 '(semantic-complete-inline-analyzer-idle-displayor-class 'semantic-displayor-ghost)
 '(show-paren-mode t))
