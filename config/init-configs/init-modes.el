
(use-package markdown-mode
  :ensure t)

(require 'whitespace)
; whitespace-mode
                                        ; tabify

;; =======================================================================

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
      (message "feng-buffer-change-hook %s" (buffer-file-name) )
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

;; =======================================================================
(progn
  (defun boundary ()
    (and      (= (char-syntax (char-after))  ?w)
              (not (= (char-syntax (char-before)) ?w))))
  (defun boundary_end ()
    (and (not (= (char-syntax (char-after))  ?w))
              (= (char-syntax (char-before)) ?w)))  
  (defun my-forward-word ()
    (interactive) 
    (while (progn (forward-char)  (not (boundary)))))
  (defun my-backward-word ()
    (interactive)
    (let* ((beforepos (point)))
      (while (progn (backward-char) (not (boundary_end))))
      ;;(forward-word)
      ;;(backward-word)
      ;;(backward-word)
      ;;(forward-word)
      )
    )
  (global-unset-key (kbd "M-f"))
  (global-unset-key (kbd "M-b"))
  (global-set-key (kbd "M-f") 'my-forward-word)
  (global-set-key (kbd "C-M-f") 'forward-word)
  (global-set-key (kbd "M-b")  'backward-word)
  (global-set-key (kbd "C-M-b")  'my-backward-word)
  )

;; avy
(use-package avy
  :ensure t
  :bind (
         ;;("M-g w" . avy-goto-word-1)
         ("M-g M-g" . avy-goto-char-timer)
         ))
(require 'avy)

(global-set-key (kbd "M-g M-g") 'avy-goto-char-timer)
(global-set-key (kbd "C-;") 'avy-goto-char-timer)
(global-set-key (kbd "M-g a") 'avy-resume)
(global-set-key (kbd "M-g l") 'avy-goto-line)
(setq avy-style 'at-full)
;;(setq avy-style 'de-bruijn)
(setq avy-all-windows t)
(setq avy-timeout-seconds 0.3)
(setq avy-orders-alist
      '((avy-goto-char-timer . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)))

(defun avy-goto-char-timer (&optional arg)
  "Read one or many consecutive chars and jump to the first one.
The window scope is determined by `avy-all-windows' (ARG negates it)."
  (interactive "P")
  (let ((avy-all-windows (if arg
                             (not avy-all-windows)
                           avy-all-windows)))
    (avy-with avy-goto-char-timer
      (setq avy--old-cands (avy--read-candidates))
;;;(avy-process avy--old-cands)
      (let ((avy-command 'avy-goto-char-timer)) ;;
        (avy-process (copy-tree avy--old-cands)))
      )))


;; comment-region
(global-set-key (kbd "C-c C-c") 'comment-region)


(use-package yaml-mode :ensure t)
(use-package dockerfile-mode :ensure t)

