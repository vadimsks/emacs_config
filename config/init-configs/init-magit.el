(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  )

;; customize-variable magit-completing-read-function
;; helm--completing-read-default
;; helm-completing-read-with-cands-in-buffer
;; helm-completing-read-default-1

;; push all branches (instead of matching (m))
;; https://emacs.stackexchange.com/questions/47703/pushing-fetching-all-branches-at-once-in-magit
(defun my/magit-push-all ()
  "Push all branches."
  (interactive)
  (magit-run-git-async "push" "-v"
                       (magit-read-remote "Remote")
                       "--all"))


;; Transients
;; https://github.com/magit/magit/wiki/Converting-popup-modifications-to-transient-modifications
