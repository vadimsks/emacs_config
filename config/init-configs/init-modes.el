
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
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)


(defun my/mark-one-param ()
  ;;(defun er/mark-inside-pairs ()
  "Mark inside pairs (as defined by the mode), not including the pairs."
  (interactive)
  (when (er--point-inside-pairs-p)

    (let* (start end inside-paren)
      (save-excursion
        (goto-char (nth 1 (syntax-ppss)))
        (setq start (point))
        (setq inside-paren (looking-at "("))
        (when inside-paren
          (forward-list)
          (setq end (point)) )
        )
      (when inside-paren
        (set-mark (save-excursion 
                    (skip-chars-backward "^(,)" start)
                    (forward-char)
                    (skip-chars-forward er--space-str)
                    (message "p1 %s" (point) )
                    (point)))

        (skip-chars-forward "^(,)" end )
        (skip-chars-backward er--space-str)

        (message "p2 %s" (point) )
            
        (exchange-point-and-mark)
        
        )
      )
    )
  )

(defun er/add-cc-mode-expansions ()
  "Adds expansions for buffers in c-mode."
  (set (make-local-variable 'er/try-expand-list)
       (append er/try-expand-list
               '(my/mark-one-param
                 er/c-mark-statement
                 er/c-mark-fully-qualified-name
                 er/c-mark-function-call-1   er/c-mark-function-call-2
                 er/c-mark-statement-block-1 er/c-mark-statement-block-2
                 er/c-mark-vector-access-1   er/c-mark-vector-access-2))))

;; (message "my-ctrl-q-handler _arg=%s" _arg )




;; Transpose stuff with M-t
;; (global-unset-key (kbd "M-t")) ;; which used to be transpose-words
;; (global-set-key (kbd "M-t l") 'transpose-lines)
;; (global-set-key (kbd "M-t w") 'transpose-words)
;; (global-set-key (kbd "M-t s") 'transpose-sexps)
;; (global-set-key (kbd "M-t p") 'transpose-params)


