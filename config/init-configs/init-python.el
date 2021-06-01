
;; allow upper case in -*- coding: UTF-8 -*-
(define-coding-system-alias 'UTF-8 'utf-8)

(use-package py-yapf
  :ensure t)

(require 'py-yapf)

;;(add-hook 'python-mode-hook 'py-yapf-enable-on-save)

(setq my-py-yapf-executable "yapf.sh")

;; override
(defun my-py-yapf--call-executable (errbuf file line-param)
  (let ((status
         (apply 'call-process my-py-yapf-executable nil errbuf nil
                (append py-yapf-options `("--in-place" "--output-lines-only" ,file "-l" ,line-param)))))
    (cond
     ((stringp status)
      (message "(yapf killed by signal %s)" status)
      nil)
     ((not (zerop status))
      (message "(yapf failed with code %d)" status)
      nil)
     (t
      t))
    ;;(message (format "status: %s" status))
    ;;status
    ))


(defun my-py-yapf-region (start end &optional arg)
  "Uses the \"yapf\" tool to reformat the current region."
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end) current-prefix-arg)
     (list (point) (point) current-prefix-arg)))
  ;; (if (not (use-region-p))
  ;;     (error (format "No region selected.")))
  (if (not (use-region-p))
      (save-excursion
        (beginning-of-line)
        (setq start (point))
        (end-of-line)
        (setq end (point))
        )
    )
  (if (= start end)
      (error (format "Empty region selected.")))
  (save-excursion
    (goto-char end)
    (beginning-of-line)
    (if (= (point) end)
        (setq end (- end 1))
      (end-of-line)
      (setq end (point))
      ))
  ;;(message "(yapf region %d, %d)" start end)
  
  (my-py-yapf-bf--apply-executable-to-buffer start end "yapf.sh" 'py-yapf--call-executable "py" nil)
)

(defalias 'my-py-yapf--bufferpos-to-filepos
  (if (fboundp 'bufferpos-to-filepos)
      'bufferpos-to-filepos
    (lambda (position &optional _quality _coding-system)
      (1- (position-bytes position)))))

(defalias 'my-py-yapf--filepos-to-bufferpos
  (if (fboundp 'filepos-to-bufferpos)
      'filepos-to-bufferpos
    (lambda (byte &optional _quality _coding-system)
      (byte-to-position (1+ byte)))))

(defun my-py-yapf-replace-region-from-file (target-buffer start end filename)
  "copy file contents replacing region"
  (save-excursion
    (with-current-buffer target-buffer
      (goto-char start)
      (delete-region start end)
      )    
    (with-temp-buffer
      (insert-file-contents filename)
      (goto-char (point-min))

      (while (and (not (eobp)) (looking-at-p "^ *$"))
        (forward-line))

      (let ((text ""))
        (while (not (eobp))
          (let ((start (point)))
            (forward-line)
            (let ((text (buffer-substring start (point))))
              (with-current-buffer target-buffer
                (insert text) )
              ;;(setq text text2)
              )
            )
          ))
      )
    )
  )

(defun my-py-yapf-bf--apply-executable-to-buffer (start
                                                  end
                                                  executable-name
                                                  executable-call
                                                  file-extension
                                                  ignore-return-code)
  "Formats the current buffer according to the executable"
  ;; (when (not (executable-find executable-name))
  ;;   (error (format "%s command not found." executable-name)))
  ;; Make sure tempfile is an absolute path in the current directory so that
  ;; YAPF can use its standard mechanisms to find the project's .style.yapf
  (let ((kr-head kill-ring)
        (tmpfile (make-temp-file (concat default-directory executable-name)
                                 nil (concat "." file-extension)))
        (patchbuf (get-buffer-create (format "*%s patch*" executable-name))))
    (kill-new "test")
    (unwind-protect
        (let ((errbuf (get-buffer-create (format "*%s Errors*" executable-name)))
              (coding-system-for-read buffer-file-coding-system)
              (coding-system-for-write buffer-file-coding-system)
              (line-param (format "%d-%d"
                                  (line-number-at-pos start t)
                                  (line-number-at-pos end t))))

          (message "line-param: %s" line-param)
          (with-current-buffer errbuf
            (setq buffer-read-only nil)
            (erase-buffer))
          (with-current-buffer patchbuf
            (erase-buffer))
          (write-region nil nil tmpfile)

          (if (or (my-py-yapf--call-executable errbuf tmpfile line-param)
                  ignore-return-code)
              (progn
                (my-py-yapf-replace-region-from-file (current-buffer) start (+ end 1) tmpfile)
                (kill-buffer errbuf)
                (message (format "Applied %s" executable-name)) )
              
            (error (format "Could not apply %s. Check *%s Errors* for details"
                           executable-name executable-name)))
          )
      (kill-buffer patchbuf)
      (delete-file tmpfile)
      (setq kill-ring kr-head)
      )
    ))

(defun my-py-yapf-bf--apply-executable-to-buffer-orig (start
                                                  end
                                                  executable-name
                                                  executable-call
                                                  file-extension
                                                  ignore-return-code)
  "Formats the current buffer according to the executable"
  ;; (when (not (executable-find executable-name))
  ;;   (error (format "%s command not found." executable-name)))
  ;; Make sure tempfile is an absolute path in the current directory so that
  ;; YAPF can use its standard mechanisms to find the project's .style.yapf
  (let ((kr-head kill-ring)
        (tmpfile (make-temp-file (concat default-directory executable-name)
                                 nil (concat "." file-extension)))
        (patchbuf (get-buffer-create (format "*%s patch*" executable-name))))
    (kill-new "test")
    (unwind-protect
        (let ((errbuf (get-buffer-create (format "*%s Errors*" executable-name)))
              (coding-system-for-read buffer-file-coding-system)
              (coding-system-for-write buffer-file-coding-system)
              (line-param (format "%d-%d"
                                  (line-number-at-pos start t)
                                  (line-number-at-pos end t))))

          (message "line-param: %s" line-param)
          (with-current-buffer errbuf
            (setq buffer-read-only nil)
            (erase-buffer))
          (with-current-buffer patchbuf
            (erase-buffer))
          (write-region nil nil tmpfile)

          (if (or (my-py-yapf--call-executable errbuf tmpfile line-param)
                  ignore-return-code)
              (if (zerop (call-process-region (point-min) (point-max) "diff" nil
                                              patchbuf nil "-n" "-" tmpfile))
                  (progn
                    (kill-buffer errbuf)
                    (message (format "Buffer is already %sed" executable-name)))

                (my-py-yapf-bf--apply-rcs-patch patchbuf)          

                (kill-buffer errbuf)
                (message (format "Applied %s" executable-name)))
            (error (format "Could not apply %s. Check *%s Errors* for details"
                           executable-name executable-name)))
          )
      (kill-buffer patchbuf)
      (delete-file tmpfile)
      (setq kill-ring kr-head)
      )
    ))

(defun my-py-yapf-bf--apply-rcs-patch (patch-buffer)
  "Apply an RCS-formatted diff from PATCH-BUFFER to the current buffer."
  (let ((target-buffer (current-buffer))
        (line-offset 0))
    (save-excursion
      (with-current-buffer patch-buffer
        (goto-char (point-min))
        (while (not (eobp))
          (unless (looking-at "^\\([ad]\\)\\([0-9]+\\) \\([0-9]+\\)")
            (error "invalid rcs patch or internal error in py-yapf-bf--apply-rcs-patch"))
          (forward-line)
          (let ((action (match-string 1))
                (from (string-to-number (match-string 2)))
                (len  (string-to-number (match-string 3))))
            (cond
             ((equal action "a")
              (let ((start (point)))
                (forward-line len)
                (let ((text (buffer-substring start (point))))
                  (with-current-buffer target-buffer
                    (setq line-offset (- line-offset len))
                    (goto-char (point-min))
                    (forward-line (- from len line-offset))
                    (insert text)))))
             ((equal action "d")
              (with-current-buffer target-buffer
                (goto-char (point-min))
                (forward-line (- from line-offset 1))
                (setq line-offset (+ line-offset len))
                (kill-whole-line len)
                ;;(pop kill-ring)
                ))
             (t
              (error "invalid rcs patch or internal error in py-yapf-bf--apply-rcs-patch")))))))))


(require 'python)
(define-key python-mode-map (kbd "M-q") 'my-py-yapf-region)

