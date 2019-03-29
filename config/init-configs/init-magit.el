(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  )

;; customize-variable magit-completing-read-function
;; helm--completing-read-default
;; helm-completing-read-with-cands-in-buffer
;; helm-completing-read-default-1
