(use-package py-yapf
  :ensure t)

(require 'py-yapf)

;;(add-hook 'python-mode-hook 'py-yapf-enable-on-save)

(setq my-py-yapf-executable (expand-file-name "~/work/python/yapf.sh"))

;; override
(defun my-py-yapf--call-executable (errbuf file line-param)
  (let ((status
         (apply 'call-process my-py-yapf-executable nil errbuf nil
                (append py-yapf-options `("--in-place" ,file "-l" ,line-param)))))
    (cond
     ((stringp status)
      (error "(yapf killed by signal %s)" status)
      nil)
     ((not (zerop status))
      (error "(yapf failed with code %d)" status)
      nil)
     ( t t ))
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
  (if arg
      (my-py-yapf-bf--apply-executable-to-buffer (point-min) (point-max) "yapf.sh" 'py-yapf--call-executable t "py" t)
    (my-py-yapf-bf--apply-executable-to-buffer start end "yapf.sh" 'py-yapf--call-executable t "py" t)
    ))

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


(defun my-py-yapf-bf--apply-executable-to-buffer (start
                                                  end
                                                  executable-name
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
                            (line-number-at-pos start t)
                            (line-number-at-pos end t))))
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

