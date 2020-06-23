(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
        (beginning-of-line))))

(add-hook 'eshell-mode-hook
          '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

(defun my-eshell-get-buffer-create (&optional arg)
  "Create an interactive Eshell buffer.  Return the Eshell buffer,
creating it if needed.  The buffer used for Eshell sessions is
determined by the value of `eshell-buffer-name'.  A numeric prefix
arg (as in `C-u 42 M-x eshell RET') switches to the session with
that number, creating it if necessary.  A nonnumeric prefix arg
means to createa new session.  Returns the buffer selected (or created)."
  (interactive "P")
  (cl-assert eshell-buffer-name)
  (let ((buf (cond ((numberp arg)
                    (get-buffer-create (format "%s<%d>"
                                               eshell-buffer-name
                                               arg)))
                   (arg
                    (generate-new-buffer eshell-buffer-name))
                   (t
                    (get-buffer-create eshell-buffer-name)))))
    (cl-assert (and buf (buffer-live-p buf)))
    (with-current-buffer buf
      (unless (derived-mode-p 'eshell-mode)
        (eshell-mode)))
    buf))

(defun my-eshell-fnc (&optional arg)
  ""
  (interactive)
  (let* ((buf (my-eshell-get-buffer-create arg))
         (buf-wnd (get-buffer-window buf))
         (dir (expand-file-name default-directory)))
    (cond ((eq buf (window-buffer (selected-window)))
           (message "Visible and focused"))
          (buf-wnd
           (message "Visible and unfocused")
           (select-window buf-wnd))
          (t
           (message "Not visible")
           (pop-to-buffer-same-window buf)))    
    (with-current-buffer buf            ; "*eshell*"
      (end-of-buffer)
      ;; (insert "ls")
      (insert (concat "cd " (shell-quote-wildcard-pattern dir)))
      (eshell-send-input)
      (end-of-buffer))

    ) )

;;; (setq sr-ti-openterms (delete (current-buffer) sr-ti-openterms))
;;; display-buffer-mark-dedicated

(defun my-eshell-clear ()
  "Clear `eshell' buffer, comint-style."
  (interactive)
  (let ((input (eshell-get-old-input)))
    (eshell/clear-scrollback)
    ;; (eshell/clear)
    (eshell-emit-prompt)
    (insert input)))

;; (add-hook 'eshell-mode-hook
;;           '(lambda () (define-key eshell-mode-map "\C-l" 'my-eshell-clear)))


;; redefine ?- and ?. as word Word constituents ( 'w' )
;; (modify-syntax-entry ?- "w   " eshell-mode-syntax-table)
;; (modify-syntax-entry ?. "w   " eshell-mode-syntax-table)


;; TODO
;;(add-hook 'eshell-mode-hook
;;          '(lambda () (define-key eshell-mode-map "\C-\M-h" 'kill-region-or-backward-word)))
