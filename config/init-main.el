;; .emacs contents
;; (load "~/work/emacs/emacs_config/config/init-main.el" 'noerror)

(setq my-config-variant 'my-config-main)
;; (setq my-config-variant 'my-config-wsl)

(setq custom-file "~/work/emacs/emacs_config/config/init-custom.el")
(load custom-file 'noerror)

;;(server-start)
(global-auto-revert-mode 1)
(setq load-path (cons (expand-file-name "~/.emacs.d/el") load-path))
;; (setq load-path (cons (expand-file-name "~/.emacs.d/el/company-0.9.9") load-path))


;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;(require 'package)
;; (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
;;                     (not (gnutls-available-p))))
;;        (proto (if no-ssl "http" "https")))
;;   (when no-ssl
;;     (warn "\
;; Your version of Emacs does not support SSL connections,
;; which is unsafe because it allows man-in-the-middle attacks.
;; There are two things you can do about this warning:
;; 1. Install an Emacs version that does support SSL and be safe.
;; 2. Remove this warning from your init file so you won't see it again."))
;;   ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
;;   (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
;;   ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
;;   (when (< emacs-major-version 24)
;;     ;; For important compatibility libraries like cl-lib
;;     (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (setq package-archives '(("melpa" . "http://melpa.org/packages/")) )
;; (package-initialize)
;;package-archives
;;package-check-signature

(require 'use-package)

(setq confirm-kill-emacs 'y-or-n-p)


;; (if (eq system-type 'gnu/linux)
;; (if (eq system-type 'windows-nt)

;; Windows
(if (eq system-type 'windows-nt)
    (progn
      ;; try to improve slow performance on windows.
      (setq w32-get-true-file-attributes nil)

      ;; font
      (setq-default line-spacing 0)
      (set-frame-font "-*-Consolas-normal-r-*-*-14-*-*-*-*-*-*-ansi-")
      (setq grep-find-command "find . -type f -not -regex '.*\\.svn.*' -and -not -name 'TAGS' -and -not -regex '.*~' -print0 | xargs -0 -e grep -n ")

      ;; cygwing
      (defun my-translate-cygwin-paths (file)
        "Adjust paths generated by cygwin so that they can be opened by tools running under emacs."

        ;; If it's not a windows system, or the file doesn't begin with /, don't do any filtering
        (if (and (eq system-type 'windows-nt) (string-match "^/" file))
        
            ;; Replace paths of the form /cygdrive/c/... or //c/... with c:/...
            (if (string-match "^\\(//\\|/cygdrive/\\)\\([a-zA-Z]\\)/" file)
                (setq file (file-truename (replace-match "\\2:/" t nil file)))

              ;; ELSE
              ;; Replace names of the form /... with <cygnus installation>/...
              ;; try to find the cygwin installation
              (let ((paths (parse-colon-path (getenv "path"))) ; Get $(PATH) from the environment
                    (found nil))

                ;; While there are unprocessed paths and cygwin is not found
                (while (and (not found) paths)
                  (setq path (car paths))  ; grab the first path
                  (setq paths (cdr paths)) ; walk down the list
          
                  (if (and (string-match "/bin/?$" path) ; if it ends with /bin
                           (file-exists-p     n ; and cygwin.bat is in the parent
                                              (concat
                                               (if (string-match "/$" path) path (concat path "/"))
                                               "../cygwin.bat")))
                      (progn
                        (setq found t)  ; done looping
                        (string-match "^\\(.*\\)/bin/?$" path)
                        (setq file (file-truename (concat (match-string 1 path) file))))
                    )))))
        file)

      ;; This "advice" is a way of hooking a function to supply additional
      ;; functionality. In this case, we want to pre-filter the argument to the
      ;; function gud-find-file which is used by the emacs debugging mode to open
      ;; files specified by debug info.
      (defadvice gud-find-file (before my-translate-cygwin-paths activate)
        (ad-set-arg 0 (my-translate-cygwin-paths (ad-get-arg 0)) t))

      ;; WinContextMenu.el
      ;;; (load "c:/working/WinContextMenu/WinContextMenu/WinContextMenu/lisp/WinContextMenu.el")

      ;; Python
      (setq python-shell-interpreter "c:/Python33/pythonw.exe")
      
      ))

;; Bookmarks
(setq 
  bookmark-default-file "~/.emacs.d/bookmarks" ;; keep my ~/ clean
  bookmark-save-flag 1)                        ;; autosave each change)

;(add-to-list 'load-path "/media/data/user/work/emacs-tests/f")
;(load "vka-bookmark")


;; Desktop
(desktop-save-mode 1)

;(if (null (cdr command-line-args))
;      (setq inihibit-startup-message (recover-context)))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  )

;; '(current-language-environment "Latin-4") - !!! this breaks melpa !!!

(when window-system 
  (ediff-toggle-multiframe))


;;(setq-default ediff-patch-optiosn "-f -p5")

;;(load "gdb-mi" nil t)

;; (defun my-app-load ()
;;   (interactive)
;;   (shell-command "cd /media/data/user/work/alarm-olimex/s/b1usart/test/ && make -k &" )
;; )
;; (defun my-app-test ()
;;   (interactive)
;;   (shell-command "cd /media/data/user/work/alarm-olimex/s/b1usart/test/ && make -k test &" )
;; )

;; (global-set-key [C-f6] 'my-app-load)
;; (global-set-key [C-f7] 'my-app-test)

(require 'imenu)

;; ansi-term
(defun open-localhost ()
  (interactive)
  (ansi-term "bash" "term-localhost"))

;; Use this for remote so I can specify command line arguments
(defun remote-term (new-buffer-name cmd &rest switches)
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
  (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (term-set-escape-char ?\C-x)
  (switch-to-buffer term-ansi-buffer-name))

;;; ibuffer - C-x C-b
(autoload 'ibuffer "ibuffer" "List buffers." t)

;;; psvn
(if (not (eq system-type 'windows-nt))
    (progn
      (require 'psvn)
      (setq svn-status-track-user-input 't)
      ;; (setq svn-status-edit-svn-command 't)
      ;; svn-psvn-revision - version

      (defun svn-pre-run-add-force-interactive ()
        ""
        (add-to-list 'arglist "--force-interactive")
        (message "calling svn %s: %S" cmdtype arglist)
        )

      (add-hook 'svn-pre-run-hook 'svn-pre-run-add-force-interactive)
      ))

;; setting LC_ALL=en_US.UTF-8 fixes gpg-agent comms
(setq svn-status-svn-environment-var-list '("LC_MESSAGES=C" "LC_ALL=en_US.UTF-8") )

;; (setq svn-status-svn-executable "svn")
;; (setq svn-status-svn-executable "/home/developer/work/psvn/svn")
;; (setq svn-status-svn-executable "/home/developer/work/Investigations/mytty_cpp/build/mytty")


;; OpenWith
;(require 'openwith)
;; (when (require 'openwith nil 'noerror)
;;       (setq openwith-associations
;;             (list
;;              (list (openwith-make-extension-regexp
;;                     '("mpg" "mpeg" "mp3" "mp4"
;;                       "avi" "wmv" "wav" "mov" "flv"
;;                       "ogm" "ogg" "mkv"))
;;                    "vlc"
;;                    '(file))
;;              (list (openwith-make-extension-regexp
;;                     '("xbm" "pbm" "pgm" "ppm" "pnm"
;;                       "png" "gif" "bmp" "tif" "jpeg" "jpg"))
;;                    "geeqie"
;;                    '(file))
;;              (list (openwith-make-extension-regexp
;;                     '("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
;;                    "libreoffice"
;;                    '(file))
;;              '("\\.lyx" "lyx" (file))
;;              '("\\.chm" "kchmviewer" (file))
;;              (list (openwith-make-extension-regexp
;;                     '("pdf" "ps" "ps.gz" "dvi"))
;;                    "okular"
;;                    '(file))
;;              ))
;;       (openwith-mode 1)
;;       )


;;(setq tramp-default-method "ssh")
;; rsyncc , scpc

;;(setq tramp-default-method "rsyncc")
(setq tramp-default-method "scp")

;; ediff-directories-recursive
(eval
 (let ((directory-files-original (symbol-function 'directory-files)))
   `(defun directory-files-recursive (directory &optional full match nosort)
      "Like `directory-files' but recurses into subdirectories. Does not follow symbolic links."
      (let* ((prefix (or (and full "") directory))
         dirs
         files)
    (mapc (lambda (p)
        (let ((fullname (if full p (concat prefix "/" p))))
          (when (and (file-directory-p fullname)
                 (null (or (string-match "\\(^\\|/\\).$" p)
                       (string-match "\\(^\\|/\\)..$" p)
                       (file-symlink-p fullname))))
            (setq dirs (cons p dirs)))))
          (funcall ,directory-files-original directory full nil nosort))
    (setq dirs (nreverse dirs))
    (mapc (lambda (p)
        (when (null (file-directory-p (if full p (concat prefix "/" p))))
          (setq files (cons p files))))
          (funcall ,directory-files-original directory full match nosort))
    (setq files (nreverse files))
    (mapc (lambda (d)
        (setq files
              (append files
                  (if full
                  (apply 'directory-files-recursive (list d full match nosort))
                (mapcar (lambda (n)
                      (concat d "/" n))
                    (apply 'directory-files-recursive (list (concat prefix "/" d) full match nosort)))))))
          dirs)
    files))))


;; Elisp: Get Script Name at Run Time, Call by Relative Path
;; http://ergoemacs.org/emacs/elisp_relative_path.html
;;(setq my-init-configs-dir "~/work/emacs/emacs_config/config/init-configs/")

(setq my-init-configs-dir
      (concat
       (file-name-directory (or load-file-name buffer-file-name))
       "init-configs/" ))

(defun my-load-init-config (file-name)
  ""
  (load (concat my-init-configs-dir file-name)))

;; https://blog.patshead.com/2013/12/emacs-elpa-and-use-package-blog.html - use-package
;; https://github.com/jwiegley/use-package
(my-load-init-config "helm.el")
(my-load-init-config "helm-make.el")
(my-load-init-config "init-magit.el")
;; ;;(my-load-init-config "ido.el")
(my-load-init-config "init-ffap.el")
(my-load-init-config "smex.el")
(my-load-init-config "gui.el")
(my-load-init-config "sunrise.el")
(my-load-init-config "company.el")
;; ;(my-load-init-config "cedet.el")
(my-load-init-config "cpp_fmt.el")
(my-load-init-config "autosave.el")
(my-load-init-config "init-eshell.el")
(my-load-init-config "org.el")
;; ;(my-load-init-config "init-pdf.el")
(my-load-init-config "browse-url.el")
(my-load-init-config "bindings.el")
(my-load-init-config "init-modes.el")
(if (not (eq system-type 'windows-nt))
    (progn
      (my-load-init-config "init-wsl.el")
      (my-load-init-config "init-clang.el")

      (my-load-init-config "init-html.el")
      (my-load-init-config "init-python.el")
      ;; (my-load-init-config "init-typescript.el")
      ;; (my-load-init-config "init-org-roam.el")
      ;; (my-load-init-config "init-beancount.el")
      ))

(if (and (getenv "DISPLAY")
      (not (string= (getenv "DISPLAY") ":0")))
    (set-frame-size (selected-frame) 1640 950 t)
   )

