
;; https://github.com/smihica/emmet-mode
(use-package emmet-mode
  :ensure t)

(use-package web-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))


(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
