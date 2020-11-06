
(use-package markdown-mode
  :ensure t)

(require 'whitespace)
; whitespace-mode
                                        ; tabify

;;; record two different file's last change. cycle them
;; from http://shenfeng.me/emacs-last-edit-location.html

(defvar feng-last-change-pos1 nil)
(defvar feng-last-change-pos2 nil)

(defun feng-swap-last-changes ()
  (when feng-last-change-pos2
    (let ((tmp feng-last-change-pos2))
      (setf feng-last-change-pos2 feng-last-change-pos1
            feng-last-change-pos1 tmp))))

(defun feng-goto-last-change ()
  (interactive)
  (when feng-last-change-pos1
    (let* ((buffer (find-file-noselect (car feng-last-change-pos1)))
           (win (get-buffer-window buffer)))
      (if win
          (select-window win)
        ;;(switch-to-buffer-other-window buffer)
        (switch-to-buffer buffer)
        )
      (goto-char (cdr feng-last-change-pos1))
      (feng-swap-last-changes))))

(defun feng-buffer-change-hook (beg end len)
  (let ((bfn (buffer-file-name))
        (file (car feng-last-change-pos1)))
    (when bfn
      (if (or (not file) (equal bfn file)) ;; change the same file
          (setq feng-last-change-pos1 (cons bfn end))
        (progn (setq feng-last-change-pos2 (cons bfn end))
               (feng-swap-last-changes))))))

(add-hook 'after-change-functions 'feng-buffer-change-hook)
;;; just quick to reach
;; (global-set-key (kbd "M-`") 'feng-goto-last-change)

(defun my-ctrl-q-handler (&optional _arg)
  "Call either feng-goto-last-change or quoted-insert"
  (interactive "P")
  ;; (message "my-ctrl-q-handler _arg=%s" _arg )
  (if _arg
      (feng-goto-last-change)
    (funcall-interactively 'quoted-insert 1)
    ))

(global-set-key (kbd "C-q") 'my-ctrl-q-handler)


;; =======================================================================

(use-package expand-region :ensure t)
(global-set-key (kbd "C-=") 'er/expand-region)

;; (message "my-ctrl-q-handler _arg=%s" _arg )




;; Transpose stuff with M-t
;; (global-unset-key (kbd "M-t")) ;; which used to be transpose-words
;; (global-set-key (kbd "M-t l") 'transpose-lines)
;; (global-set-key (kbd "M-t w") 'transpose-words)
;; (global-set-key (kbd "M-t s") 'transpose-sexps)
;; (global-set-key (kbd "M-t p") 'transpose-params)



;; avy
(use-package avy
  :ensure t
  :bind (
         ;;("M-g w" . avy-goto-word-1)
         ("M-g M-g" . avy-goto-char-timer)
         ))

(global-set-key (kbd "M-g M-g") 'avy-goto-char-timer)
(global-set-key (kbd "M-g a") 'avy-resume)
(global-set-key (kbd "M-g l") 'avy-goto-line)
(setq avy-style 'pre)
(setq avy-all-windows nil)
(setq avy-timeout-seconds 0.5)
(setq avy-orders-alist
      '((avy-goto-char-timer . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)))
