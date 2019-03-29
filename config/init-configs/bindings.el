(global-set-key "\M-n" 'next-error)
(global-set-key "\M-p" 'previous-error)

(global-set-key "\C-c\C-f" 'imenu)

(global-set-key "\C-x\C-o" 'find-file-at-point)

(put 'upcase-region 'disabled nil) ; enable C-x C-u

(global-set-key (kbd "C-m") 'newline)

;(global-set-key (kbd "C-x C-b") 'ibuffer)

;; helm-smex
(global-set-key [remap execute-extended-command] #'helm-smex)
(global-set-key (kbd "M-X") #'helm-smex-major-mode-commands)
;;(global-set-key (kbd "C-x b") #'helm-buffers-list)
;; (global-set-key (kbd "C-x b") #'helm-mini)
(global-set-key (kbd "C-x b") #'helm-mini)

;; helm - see helm.el

;; helm-make
(global-set-key [f5] 'helm-make-f5)
(global-set-key [C-f5] 'helm-make-C-f5)

(global-set-key [f9] 'gdb-many-windows)
;;(global-set-key [f5] 'recompile)

;(setq-default ffap-file-finder 'ido-find-file)
(setq-default ffap-file-finder 'find-file)

;;(setq grep-find-command "find . -type f -not -regex '.*\\.svn.*' -and -not -name 'TAGS' -and -not -regex '.*~' -print0 | xargs -0 -e grep -nHi -e ")
(setq grep-find-command "find . -type f -not -regex '.*\\.svn.*' -and -not -name 'TAGS' -and -not -regex '.*~' -print0 | xargs -0 -e grep -nH -e ")

; use Shift with the arrow keys to switch between windows (instead of C-x o)
(when (fboundp 'windmove-default-keybindings)
      (windmove-default-keybindings))

 ;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

(define-key global-map [(f12)]
  (lambda ()
    (interactive)
    (sr-dired "c:/Temp/sr")))

; move between buffer using M-<arrows>
(windmove-default-keybindings 'meta) ; new

;; disable f11
(global-set-key [f11] 'help-for-help)

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
