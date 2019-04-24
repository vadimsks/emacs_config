(use-package py-yapf
  :ensure t)

(require 'py-yapf)

;;(add-hook 'python-mode-hook 'py-yapf-enable-on-save)

(setq my-py-yapf-executable (expand-file-name "~/work/python/yapf.sh"))

;; override
(defun my-py-yapf--call-executable (errbuf file line-param)
  (apply 'call-process my-py-yapf-executable nil errbuf nil
         (append py-yapf-options `("--in-place" ,file "-l" ,line-param))))


(defun my-py-yapf-region ()
  "Uses the \"yapf\" tool to reformat the current buffer."
  (interactive)
  (if (not (use-region-p))
      (error (format "No region selected.")))
  (py-yapf-bf--apply-executable-to-buffer "yapf.sh" 'py-yapf--call-executable t "py" t))

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


(defun py-yapf-bf--apply-executable-to-buffer2 (executable-name
                                           executable-call
                                           only-on-region
                                           file-extension
                                           ignore-return-code)
  "Formats the current buffer according to the executable"
  ;; (when (not (executable-find executable-name))
  ;;   (error (format "%s command not found." executable-name)))
  ;; Make sure tempfile is an absolute path in the current directory so that
  ;; YAPF can use its standard mechanisms to find the project's .style.yapf

  (let* ((tmpfile (make-temp-file (concat default-directory executable-name)
                                 nil (concat "." file-extension)))
        (patchbuf (get-buffer-create (format "*%s patch*" executable-name)))
        (errbuf (get-buffer-create (format "*%s Errors*" executable-name)))
        (coding-system-for-read buffer-file-coding-system)
        (coding-system-for-write buffer-file-coding-system)
        ;; (region-start (my-py-yapf--bufferpos-to-filepos (region-beginning) 'approximate
        ;;                                               'utf-8-unix))
        ;; (region-end (my-py-yapf--bufferpos-to-filepos (region-end) 'approximate
        ;;                                             'utf-8-unix))
        (line-param (format "%d-%d"
                            (line-number-at-pos (region-beginning) t)
                            (line-number-at-pos (region-end) t)))
        )
    (with-current-buffer errbuf
      (setq buffer-read-only nil)
      (erase-buffer))
    (with-current-buffer patchbuf
      (erase-buffer))
    (write-region nil nil tmpfile)
    (unwind-protect
        (let ((status (call-process-region
                       (point-min) (point-max)
                       my-py-yapf-executable
                       t               ; don't delete
                       t               ; buffer
                       ;;`(t ,errbuf) ; current buffer
                       ;;`(,temp-buffer ,temp-file)
                       t ;; DISPLAY
                       tmpfile
                       "-l"
                       line-param
                       )))
          (cond
           ((stringp status)
            (error "(format killed by signal %s)" status))
           ((not (zerop status))
            (error "(format failed with code %d)" status)))
          (message "status - 0")
          )
      ;;(delete-file tmpfile)
      )
    ))

(defun py-yapf-bf--apply-executable-to-buffer (executable-name
                                           executable-call
                                           only-on-region
                                           file-extension
                                           ignore-return-code)
  "Formats the current buffer according to the executable"
  ;; (when (not (executable-find executable-name))
  ;;   (error (format "%s command not found." executable-name)))
  ;; Make sure tempfile is an absolute path in the current directory so that
  ;; YAPF can use its standard mechanisms to find the project's .style.yapf
  (let ((tmpfile (make-temp-file (concat default-directory executable-name)
                                 nil (concat "." file-extension)))
        (patchbuf (get-buffer-create (format "*%s patch*" executable-name)))
        (errbuf (get-buffer-create (format "*%s Errors*" executable-name)))
        (coding-system-for-read buffer-file-coding-system)
        (coding-system-for-write buffer-file-coding-system)
        (line-param (format "%d-%d"
                            (line-number-at-pos (region-beginning) t)
                            (line-number-at-pos (region-end) t))))
    (with-current-buffer errbuf
      (setq buffer-read-only nil)
      (erase-buffer))
    (with-current-buffer patchbuf
      (erase-buffer))
    (write-region nil nil tmpfile)    

    (if (or (my-py-yapf--call-executable errbuf tmpfile line-param)
            (ignore-return-code))
        (if (zerop (call-process-region (point-min) (point-max) "diff" nil
                                        patchbuf nil "-n" "-" tmpfile))
            (progn
              (kill-buffer errbuf)
              (pop kill-ring)
              (message (format "Buffer is already %sed" executable-name)))

          (py-yapf-bf--apply-rcs-patch patchbuf)          

          (kill-buffer errbuf)
          (pop kill-ring)
          (message (format "Applied %s" executable-name)))
      (error (format "Could not apply %s. Check *%s Errors* for details"
                     executable-name executable-name)))
    (kill-buffer patchbuf)
    (pop kill-ring)
    (delete-file tmpfile)))

(require 'python)
(define-key python-mode-map (kbd "M-q") 'my-py-yapf-region)

