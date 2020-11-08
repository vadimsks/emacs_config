
(add-to-list 'load-path "/home/user/work/beancount/beancount/editors/emacs")
(require 'beancount)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))


;; (add-hook 'beancount-mode-hook
;;   (lambda () (setq-local electric-indent-chars nil)) )

(add-hook 'beancount-mode-hook #'outline-minor-mode)

;;; outline mode bindings
(define-key beancount-mode-map (kbd "C-c C-n")
  'outline-next-visible-heading)

(define-key beancount-mode-map (kbd "C-c C-p")
  'outline-previous-visible-heading)

(define-key beancount-mode-map (kbd "\C-cm") 'helm-semantic-or-imenu)
