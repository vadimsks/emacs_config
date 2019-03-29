
(defun abbreviate-file-name (filename)
  "Return a version of FILENAME shortened using `directory-abbrev-alist'.
This also substitutes \"~\" for the user's home directory (unless the
home directory is a root directory) and removes automounter prefixes
\(see the variable `automount-dir-prefix').

When this function is first called, it caches the user's home
directory as a regexp in `abbreviated-home-dir', and reuses it
afterwards (so long as the home directory does not change;
if you want to permanently change your home directory after having
started Emacs, set `abbreviated-home-dir' to nil so it will be recalculated)."
  ;; Get rid of the prefixes added by the automounter.
  ;;(message "abbreviate-file-name %s" filename)
  filename)

(defun helm-buffer--format-mode-name (buf)
  "Prevent using `format-mode-line' as much as possible."
  "test")

;; (defun orig-helm-url-unhex-string (str)
;;   "Same as `url-unhex-string' but ensure STR is completely decoded."
;;   (setq str (or str ""))
;;   (with-temp-buffer
;;     (save-excursion (insert str))
;;     (while (re-search-forward "%[A-Za-z0-9]\\{2\\}" nil t)
;;       (replace-match (byte-to-string (string-to-number
;;                                       (substring (match-string 0) 1)
;;                                       16))
;;                      t t)
;;       ;; Restart from beginning until string is completely decoded.
;;       (goto-char (point-min)))
;;     (decode-coding-string (buffer-string) 'utf-8)))

;; (defun helm-url-unhex-string (str)
;;   "Same as `url-unhex-string' but ensure STR is completely decoded."
;;   (let ((result (orig-helm-url-unhex-string(str))))
;;     (message "helm-url-unhex-string %s -> %s" str result)
;;     result ) )


(defun helm-buffer--show-details (buf-name prefix help-echo
                                  size mode dir face1 face2
                                  proc details type)
  (append
   (list
    (concat prefix
            (propertize buf-name 'face face1
                        'help-echo help-echo
                        'type type)))
   (and details
        (list size mode
              (propertize
               (if proc
                   (format "(%s %s in `%s')"
                           (process-name proc)
                           (process-status proc) dir)
                 (format "(in `%s')" dir))
               'face face2)))))

(defun helm-buffer--show-details (buf-name prefix help-echo
                                  size mode dir face1 face2
                                  proc details type)
  (append
   (list
    (concat prefix
            (propertize buf-name 'face face1
                        'help-echo help-echo
                        'type type)))
   (and details
        (list size mode
              (propertize
                 (format "(in `%s')" dir)
                 'face face2)))))

(defun helm-buffer--show-details (buf-name prefix help-echo
                                  size mode dir face1 face2
                                  proc details type)
   (list buf-name) )

(helm-buffer--show-details "buf-name" "prefix" "help" "size" "mode" "dir" "face1" "face2" nil nil nil)



(defun helm-buffer--details (buffer &optional details)
  (require 'dired)
  (let* ((mode (helm-buffer--format-mode-name buffer))
         (buf (get-buffer buffer))
         (size (propertize (helm-buffer-size buf)
                           'face 'helm-buffer-size))
         (proc (get-buffer-process buf))
         (dir (with-current-buffer buffer
                (helm-aif default-directory (abbreviate-file-name it))))
         (file-name (helm-aif (buffer-file-name buf) (abbreviate-file-name it)))
         (name (buffer-name buf))
         (name-prefix (when (and dir (file-remote-p dir))
                        (propertize "@ " 'face 'helm-ff-prefix)))
         (archive-p (and (fboundp 'tramp-archive-file-name-p)
                         (tramp-archive-file-name-p dir))))
    (when name-prefix
      ;; Remote tramp buffer names may be hexified, make them more readable.
      (setq dir  (helm-url-unhex-string dir)
            name (helm-url-unhex-string name)))
    ;; Handle tramp archive buffers specially.
    (if archive-p
        (helm-buffer--show-details
         name name-prefix file-name size mode dir
         'helm-buffer-archive 'helm-buffer-process nil details 'filebuf)
      ;; No fancy things on remote buffers.
      (if (and name-prefix helm-buffer-skip-remote-checking)
          (helm-buffer--show-details
           name name-prefix file-name size mode dir
           'helm-buffer-file 'helm-buffer-process nil details 'filebuf)
        (cond
          (;; A dired buffer.
           (rassoc buf dired-buffers)
           (helm-buffer--show-details
            name name-prefix dir size mode dir
            'helm-buffer-directory 'helm-buffer-process nil details 'dired))
          ;; A buffer file modified somewhere outside of emacs.=>red
          ((and file-name
                (file-exists-p file-name)
                (not (verify-visited-file-modtime buf)))
           (helm-buffer--show-details
            name name-prefix file-name size mode dir
            'helm-buffer-saved-out 'helm-buffer-process nil details 'modout))
          ;; A new buffer file not already saved on disk (or a deleted file) .=>indianred2
          ((and file-name (not (file-exists-p file-name)))
           (helm-buffer--show-details
            name name-prefix file-name size mode dir
            'helm-buffer-not-saved 'helm-buffer-process nil details 'notsaved))
          ;; A buffer file modified and not saved on disk.=>orange
          ((and file-name (buffer-modified-p buf))
           (helm-buffer--show-details
            name name-prefix file-name size mode dir
            'helm-buffer-modified 'helm-buffer-process nil details 'mod))
          ;; A buffer file not modified and saved on disk.=>green
          (file-name
           (helm-buffer--show-details
            name name-prefix file-name size mode dir
            'helm-buffer-file 'helm-buffer-process nil details 'filebuf))
          ;; A non-file, modified buffer
          ((with-current-buffer name
             (and helm-buffers-tick-counter
                  (/= helm-buffers-tick-counter (buffer-modified-tick))))
           (helm-buffer--show-details
            name (and proc name-prefix) dir size mode dir
            'helm-buffer-modified 'helm-buffer-process proc details 'nofile-mod))
          ;; Any non--file buffer.=>italic
          (t
           (helm-buffer--show-details
            name (and proc name-prefix) dir size mode dir
            'helm-non-file-buffer 'helm-buffer-process proc details 'nofile)))))))


(defun helm-buffer--details (buffer &optional details)
  (require 'dired)
  (let* ((mode "test")
         (buf (get-buffer buffer))
         (size nil ;; (propertize (helm-buffer-size buf)
                   ;;             'face 'helm-buffer-size)
               )
         (proc nil  ;; (get-buffer-process buf)
               )
         (dir "~/" ;; (with-current-buffer buffer
                ;; (helm-aif default-directory (abbreviate-file-name it)))
              )
         (file-name (buffer-file-name buf) ;; (helm-aif (buffer-file-name buf) (abbreviate-file-name it))
                    )
         (name (buffer-name buf))
         (name-prefix nil;;  (when (and dir (file-remote-p dir))
                         ;; (propertize "@ " 'face 'helm-ff-prefix))
                      )
         (archive-p (and (fboundp 'tramp-archive-file-name-p)
                         (tramp-archive-file-name-p dir))))
    (when name-prefix
      ;; Remote tramp buffer names may be hexified, make them more readable.
      (setq dir  (helm-url-unhex-string dir)
            name (helm-url-unhex-string name)))
    ;; Handle tramp archive buffers specially.
    (if 't ;archive-p
        (helm-buffer--show-details
         name name-prefix file-name size mode dir
         'helm-buffer-archive 'helm-buffer-process nil details 'filebuf)
      ;; No fancy things on remote buffers.
      (if 't ;(and name-prefix helm-buffer-skip-remote-checking)
          (helm-buffer--show-details
           name name-prefix file-name size mode dir
           'helm-buffer-file 'helm-buffer-process nil details 'filebuf)
        (cond
          ;; (;; A dired buffer.
          ;;  (rassoc buf dired-buffers)
          ;;  (helm-buffer--show-details
          ;;   name name-prefix dir size mode dir
          ;;   'helm-buffer-directory 'helm-buffer-process nil details 'dired))
          ;; ;; A buffer file modified somewhere outside of emacs.=>red
          ;; ((and file-name
          ;;       (file-exists-p file-name)
          ;;       (not (verify-visited-file-modtime buf)))
          ;;  (helm-buffer--show-details
          ;;   name name-prefix file-name size mode dir
          ;;   'helm-buffer-saved-out 'helm-buffer-process nil details 'modout))
          ;; ;; A new buffer file not already saved on disk (or a deleted file) .=>indianred2
          ;; ((and file-name (not (file-exists-p file-name)))
          ;;  (helm-buffer--show-details
          ;;   name name-prefix file-name size mode dir
          ;;   'helm-buffer-not-saved 'helm-buffer-process nil details 'notsaved))
          ;; ;; A buffer file modified and not saved on disk.=>orange
          ;; ((and file-name (buffer-modified-p buf))
          ;;  (helm-buffer--show-details
          ;;   name name-prefix file-name size mode dir
          ;;   'helm-buffer-modified 'helm-buffer-process nil details 'mod))
          ;; ;; A buffer file not modified and saved on disk.=>green
          ;; (file-name
          ;;  (helm-buffer--show-details
          ;;   name name-prefix file-name size mode dir
          ;;   'helm-buffer-file 'helm-buffer-process nil details 'filebuf))
          ;; ;; A non-file, modified buffer
          ;; ((with-current-buffer name
          ;;    (and helm-buffers-tick-counter
          ;;         (/= helm-buffers-tick-counter (buffer-modified-tick))))
          ;;  (helm-buffer--show-details
          ;;   name (and proc name-prefix) dir size mode dir
          ;;   'helm-buffer-modified 'helm-buffer-process proc details 'nofile-mod))
          ;; ;; Any non--file buffer.=>italic
          (t
           (helm-buffer--show-details
            name (and proc name-prefix) dir size mode dir
            'helm-non-file-buffer 'helm-buffer-process proc details 'nofile)))))))



(defun helm-highlight-buffers (buffers _source)
  "Transformer function to highlight BUFFERS list.
Should be called after others transformers i.e (boring buffers)."
buffers)
