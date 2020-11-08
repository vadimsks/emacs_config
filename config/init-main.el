;; .emacs contents
;; (setq custom-file "/home/user/work/emacs/emacs_config/config/init-main.el")
;; (load custom-file 'noerror)


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

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(font-lock-comment-face ((t (:foreground "#008200"))))
 '(font-lock-constant-face ((t (:foreground "#000000"))))
 '(font-lock-doc-string-face ((t (:foreground "#FF0000"))))
 '(font-lock-function-name-face ((t (:foreground "black"))))
 '(font-lock-keyword-face ((t (:foreground "#0000FF"))))
 '(font-lock-preprocessor-face ((t (:foreground "#0000AF"))))
 '(font-lock-reference-face ((t (:foreground "black"))))
 '(font-lock-string-face ((t (:foreground "black"))))
 '(font-lock-type-face ((t (:foreground "#000000"))))
 '(font-lock-variable-name-face ((t (:foreground "black")))))

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(default-input-method "latin-4-postfix")
 '(ediff-patch-options "-f -p5")
 '(global-font-lock-mode t nil (font-lock))
 '(helm-pdfgrep-default-command "pdfgrep --cache --color always -niH %s %s")
 '(magit-completing-read-function (quote helm--completing-read-default))
 '(menu-bar-mode t)
 '(package-selected-packages
   (quote
    (emmet-mode buttercup yatemplate helm-c-yasnippet yasnippet-snippets yasnippet cmake-mode eglot web-mode markdown-mode magit helm-mode helm-flx helm-projectile helm-make helm-tramp helm-swoop helm-ag helm-smex helm use-package ztree smart-tabs-mode)))
 '(safe-local-variable-values (quote ((indent-tabs-mode quote t))))
 '(select-enable-clipboard t)
 '(semantic-complete-inline-analyzer-idle-displayor-class (quote semantic-displayor-ghost))
 '(show-paren-mode t))
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
;(require 'git)
(require 'psvn)
(setq svn-status-track-user-input 't)
;; (setq svn-status-edit-svn-command 't)
;; svn-psvn-revision - version

(defun svn-pre-run-add-force-interactive ()
  ""
  (add-to-list 'arglist "--force-interactive")
  (message "asdf %s: %S" cmdtype arglist)
  )

(add-hook 'svn-pre-run-hook 'svn-pre-run-add-force-interactive)

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
;;(my-load-init-config "ido.el")
(my-load-init-config "init-ffap.el")
(my-load-init-config "smex.el")
(my-load-init-config "gui.el")
(my-load-init-config "sunrise.el")
(my-load-init-config "company.el")
;(my-load-init-config "cedet.el")
(my-load-init-config "cpp_fmt.el")
(my-load-init-config "autosave.el")
(my-load-init-config "init-eshell.el")
(my-load-init-config "org.el")
;(my-load-init-config "init-pdf.el")
(my-load-init-config "browse-url.el")
(my-load-init-config "bindings.el")
(my-load-init-config "init-modes.el")
(my-load-init-config "init-clang.el")

(my-load-init-config "init-html.el")
(my-load-init-config "init-python.el")
;;(my-load-init-config "init-typescript.el")
