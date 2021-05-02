
(add-to-list 'load-path "/home/user/work/beancount/beancount/editors/emacs")
(require 'beancount)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))

;; Support for external accounts file
(defvar beancount-accounts-file nil)
(make-variable-buffer-local 'beancount-accounts-file)
(put 'beancount-accounts-file 'safe-local-variable (lambda (_) t))

(defun my-beancount-accounts-list ()
  ;; (message "my-beancount-accounts-list %s" beancount-accounts-file )
  (if (null beancount-accounts-file)
      (sort (beancount-collect beancount-account-regexp 0) #'string<)
    (let ((file-name beancount-accounts-file))
      (with-temp-buffer
        (insert-file-contents file-name)
        (sort (beancount-collect beancount-account-regexp 0) #'string<)
        )
      )
    )
  )

(eval-after-load "beancount"
  '(defun beancount-account-completion-table (string pred action)
     (if (eq action 'metadata) '(metadata (category . beancount-account))
       (if (null beancount-accounts)
           (setq beancount-accounts
                 (my-beancount-accounts-list)))
       (complete-with-action action beancount-accounts string pred)))
  )
(eval-after-load "beancount"
  '(setq beancount-use-ido nil)
)

;; (add-hook 'beancount-mode-hook
;;   (lambda () (setq-local electric-indent-chars nil)) )

(add-hook 'beancount-mode-hook #'outline-minor-mode)

;;; outline mode bindings
(define-key beancount-mode-map (kbd "C-c C-n")
  'outline-next-visible-heading)

(define-key beancount-mode-map (kbd "C-c C-p")
  'outline-previous-visible-heading)

(define-key beancount-mode-map (kbd "\C-cm") 'helm-semantic-or-imenu)

