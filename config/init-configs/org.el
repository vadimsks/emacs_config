;; org-mode
(require 'org-install)
(require 'org)
(add-to-list 'auto-mode-alist '("/.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;; capture mode
;;(setq org-default-notes-file (concat org-directory "/notes.org"))
;;(setq org-default-notes-file  "~/org/notes.org")
;;(define-key global-map "\C-cc" 'org-capture)

(require 'org-crypt)
; Encrypt all entries before saving
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
; GPG key to use for encryption
;(setq org-crypt-key "F6270D37")

(defun my-org-move-down ()
  " "
  (interactive)
;  (outline-back-to-heading)
  (outline-show-children)
  (outline-show-entry)

  (let ((my-found)
        (my-level (funcall outline-level)))
    (save-excursion
      (outline-next-visible-heading 1)
      (if (< my-level (funcall outline-level))
          (setq my-found t)
        )
      )
    (if my-found
        (outline-next-visible-heading 1)
      )
    )
)

(defun my-org-move-up ()
  " "
  (interactive)
  (if ( and (outline-on-heading-p) (bolp))
      (outline-up-heading 1)
    (outline-back-to-heading)
    )
  )

(add-hook 'org-mode-hook
  '(lambda ()
	 (define-key org-mode-map "\M-\C-p"       'outline-backward-same-level)
	 (define-key org-mode-map "\M-\C-n"       'outline-forward-same-level)
;	 (define-key org-mode-map "\M-\C-u"       'outline-up-heading)
	 (define-key org-mode-map "\M-\C-u"       'my-org-move-up)
	 (setq org-use-speed-commands t)
	 (define-key org-mode-map "\M-\C-d"       'my-org-move-down)
	 (define-key org-mode-map "\C-ce"         'org-encrypt-entry)
	 (define-key org-mode-map "\C-cd"         'org-decrypt-entry)
	 ))
