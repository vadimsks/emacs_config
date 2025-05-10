(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (setq magit-diff-refine-hunk t)
  (setq magit-section-initial-visibility-alist
        '((tags . hide) (stashes . hide) (untracked . hide) (unpushed . hide))
        )
  ;; show skip‐worktree files in magit-status
  (magit-add-section-hook
   'magit-status-sections-hook
   'magit-insert-skip-worktree-files
   nil                                 ; insert after default sections
   t)                                  ; append at end
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

;; full screen magit-status
(defun magit-status-fullscreen (prefix)
  (interactive "P")
  (magit-status)
  (unless prefix
    (delete-other-windows)))

;; move cursor into position when entering commit message
(defun my/magit-cursor-fix ()
  (beginning-of-buffer)
  (when (looking-at "#")
    (forward-line 2)))

(add-hook 'git-commit-mode-hook 'my/magit-cursor-fix)
