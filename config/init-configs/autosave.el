(setq backup-directory-alist
      `((".*" . ,"~/backup_files")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/backup_files" t)))

;;        (setq auto-save-directory (expand-file-name "~/autosave/")
;;              auto-save-directory-fallback auto-save-directory
;;              auto-save-hash-p nil
;;              ange-ftp-auto-save t
;;              ange-ftp-auto-save-remotely nil
;;              auto-save-interval 2000;; for better interactive response.
;;              )
;;        (require 'auto-save)

