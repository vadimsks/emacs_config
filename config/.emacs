(server-start)
(global-auto-revert-mode 1)
(setq load-path (cons (expand-file-name "~/.emacs.d/el") load-path))

; workaround to fix keyboard issues caused by VMPlayer
(shell-command "xmodmap -e \"remove control = Caps_Lock\" && xmodmap "  "*xmodmap*" )


(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; ============================================================
;; Load CEDET
; begin commented region
;; (load "~/.emacs.d/rc/emacs-rc-cedet.el")


;; (load-file "~/work/ceded/cedet-1.0/contrib/eassist.el")
;; (defun my-c-mode-common-hook ()
;;    (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp)
;;    (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))
;; (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;; (add-hook 'lisp-mode-common-hook 'my-c-mode-common-hook)
;; (global-set-key [f5] 'semantic-ia-fast-jump)
(global-set-key [f5] 'recompile)

;(setq x-alt-keysym 'meta)
; end commented region

;; XRefactory
;(setq load-path (cons (expand-file-name "~/xref/emacs") load-path))
;(setq exec-path (cons (expand-file-name "~/xref") exec-path))
;(load "xrefactory")

(setq c-default-style
       '((java-mode . "java") (other . "bsd")))

;(setq frame-title-format "%b - Emacs")

(setq-default tab-width 8)
(setq-default c-basic-offset 2)

(setq-default ffap-file-finder 'find-file)

;(custom-set-faces ; only one 'custom-set-faces' entry must exist in custom.el
; '(default ((t (:foreground "white" :background "black" :size "12"))) t)
; )

;;        (setq auto-save-directory (expand-file-name "~/autosave/")
;;              auto-save-directory-fallback auto-save-directory
;;              auto-save-hash-p nil
;;              ange-ftp-auto-save t
;;              ange-ftp-auto-save-remotely nil
;;              auto-save-interval 2000;; for better interactive response.
;;              )
;;        (require 'auto-save)


; helm
(require 'helm-config)
(helm-mode 1)
(setq helm-candidate-number-limit           500
      helm-idle-delay                       0.0
      helm-input-idle-delay                 0.01
      helm-quick-update                     t
      helm-ff-skip-boring-files             t
      helm-ff-file-name-history-use-recentf t
      helm-M-x-fuzzy-match                  t)
;; (bind-keys :map helm-map
;;            ("<tab>" . helm-execute-persistent-action)
;;            ("C-i"   . helm-execute-persistent-action)
;;            ("C-z"   . helm-select-action))

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(helm-flx-mode +1)
(require 'helm-fuzzier)
(helm-fuzzier-mode 1)

(require 'smex)
(smex-initialize)
(setq smex-save-file "~/.emacs.d/smex-save-file")

(require 'helm-smex)
(global-set-key (kbd "M-x") #'helm-smex)
(global-set-key (kbd "M-X") 'helm-smex-major-mode-commands)

;; Bookmarks
(setq 
  bookmark-default-file "~/.emacs.d/bookmarks" ;; keep my ~/ clean
  bookmark-save-flag 1)                        ;; autosave each change)

; ???
;(add-to-list 'load-path "/media/data/user/work/emacs-tests/f")
;(load "vka-bookmark")

; (add-to-list 'load-path "/my/path/to/icicles/")
;(load "~/.emacs.d/libs/icicles-install")

; Icicles
;(add-to-list 'load-path "~/.emacs.d/libs/icicles/")
;(require 'icicles)
;(icy-mode 1)

;icicle-show-Completions-initially-flag
;icicle-incremental-completion-flag

(setq-default line-spacing 0)
;(set-default-font "-*-Courier New-normal-r-*-*-12-100-*-*-m-70-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-18-*-*-*-*-*-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-16-*-*-*-*-*-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-13-120-*-*-m-90-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-14-120-*-*-m-90-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-16-120-*-*-m-90-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-17-*-*-*-m-90-*-ansi-")
;
;(set-default-font "-*-Courier New-normal-r-*-*-18-*-*-*-*-*-*-ansi-")
;(set-default-font "-*-Courier-normal-r-*-*-11-90-*-*-m-100-*-ansi-")
;(set-default-font "-*-Courier New-normal-r-*-*-11-100-*-*-m-70-*-ansi-")
;	;
;   ;
;(set-default-font "-*-MS Sans Serif-normal-r-*-*-10-130-*-*-p-120-*-ansi-")

;;(set-default-font "-*-MS Sans Serif-normal-r-*-*-10-120-*-*-p-80-*-ansi-")

;;(set-default-font "-*- Sans Serif-normal-r-*-*-14-120-*-*-p-80-*-ansi-")
;;(set-default-font "-*- Courier New-normal-r-*-*-13-120-*-*-p-80-*-ansi-")

;; >>(set-default-font "-*-Courier-bold-r-*-*-13-97-*-*-c-*-*-ansi-")
;; >>                    a b       c    d e * f g  h  i j k   l
;; >>means, when taken to bits?
;; > -a-b-c-d-e--f-g-h-i-j-k-l-
;; >
;; >the letter stand for
;; >
;; >a = foundry
;; >b = font family
;; >c = weight
;; >d = slant
;; >e = set width
;; >f = pixels
;; >g = points in tenths of a point
;; >h = horiz resolution in dpi
;; >i = vertical resolution in dpi
;; >j = spacing
;; >k = average width in tenths of a pixel
;; >l = character set
;; >Hope this is what you asked for. If not...never mind. :-)



;;


;;(load "bubble-original" nil t)
;;(global-set-key [\C-tab] 'bubble-buffer) ; or some such pair of keys
;;(global-set-key [backtab] 'bubble-buffer-back)

(global-set-key "\M-n" 'next-error)
(global-set-key "\M-p" 'previous-error)

; move between buffer using M-<arrows>
(windmove-default-keybindings 'meta) ; new

;; (setq auto-save-and-recover-context t)
;; (setq save-buffer-context t)
;; (require 'saveconf)

;; Autosave
;(setq auto-save-directory (expand-file-name "~/autosave/"))
;(require 'auto-save)

;; Desktop
(desktop-save-mode 1)

;(setq grep-find-command "fp.sh && cat file.txt | xargs -0 -e grep -n ")
;(setq compile-command "fp.sh && make -k ")

;;(setq grep-find-command "fp.sh ")
;;(setq compile-command "fpm.sh ")

(setq compilation-scroll-output t)
(setq column-number-mode t)

(global-set-key "\C-c\C-f" 'imenu)
(setq visible-bell t)

;;(setq grep-find-command "find . -type f -not -regex '.*\\.svn.*' -and -not -name 'TAGS' -and -not -regex '.*~' -print0 | xargs -0 -e grep -nHi -e ")
(setq grep-find-command "find . -type f -not -regex '.*\\.svn.*' -and -not -name 'TAGS' -and -not -regex '.*~' -print0 | xargs -0 -e grep -nH -e ")

;;find . -type d -name '.svn' -prune -o -name 'semantic.cache' -prune -o -type f -print0 | xargs -0 -e grep -n ")
;(setq c-indentation-style 'k&r)
(setq which-function-mode t)

;(setq grep-find-command "find . -type d -name '.svn' -prune -o -name 'semantic.cache' -prune -o -type f -print0 | xargs -0 -e grep -n ")
;;find . -type f -not -regex ".*\.svn.*" -and -regex ".*\.h\|.*\.c\|.*\.cpp" -print0 | xargs -0 -e grep -nH -e

;;find . -type f -not -regex ".*\.svn.*" -and -not -name "TAGS" -and -not -regex ".*~\|.*#" -print0 | xargs -0 -e grep -nHi -e 

(global-set-key "\C-x\C-o" 'find-file-at-point)

;;(if (null (cdr command-line-args))
;;      (setq inihibit-startup-message (recover-context)))

;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(case-fold-search t)
;;  '(column-number-mode t)
;;  '(current-language-environment "Latin-4")
;;  '(default-input-method "latin-4-postfix")
;;  '(ediff-patch-options "-f -p5")
;;  '(global-font-lock-mode t nil (font-lock))
;;  '(menu-bar-mode t)
;;  '(semantic-complete-inline-analyzer-idle-displayor-class (quote semantic-displayor-ghost))
;;  '(show-paren-mode t)
;;  '(x-select-enable-clipboard t))
;; ;; (custom-set-faces
;; ;;   ;; custom-set-faces was added by Custom.
;; ;;   ;; If you edit it by hand, you could mess it up, so be careful.
;; ;;   ;; Your init file should contain only one such instance.
;; ;;   ;; If there is more than one, they won't work right.
;; ;;  )


;; (mapcar
;;  'create-fontset-from-fontset-spec
;;  '("-ETL-Fixed-Medium-R-Normal--16-160-72-72-C-80-ISO8859-1"
;;    "-ETL-fixed-bold-r-normal--16-160-72-72-C-80-ISO8859-1"
;;    "-ETL-fixed-bold-i-normal--16-160-72-72-C-80-ISO8859-1" 
;;    "-ETL-fixed-medium-i-normal--16-160-72-72-C-80-ISO8859-1" 
;;    "-ETL-fixed-medium-r-normal--16-160-72-72-C-80-ISO8859-5"
;;    "-ETL-Fixed-Medium-R-Normal--16-160-72-72-C-80-ISO8859-7"
;;    "-ETL-Fixed-Medium-R-Normal--16-160-72-72-C-80-KOI8-R"))
;; (set-default-font "-etl-fixed-medium-r-normal--16-*-*-*-*-*-*-*")

(which-func-mode 1)

(ediff-toggle-multiframe)

;;(setq-default ediff-patch-optiosn "-f -p5")

;;(load "gdb-mi" nil t)


;; (defun my-translate-cygwin-paths (file)
;;   "Adjust paths generated by cygwin so that they can be opened by tools running under emacs."

;;   ;; If it's not a windows system, or the file doesn't begin with /, don't do any filtering
;;   (if (and (eq system-type 'windows-nt) (string-match "^/" file))
        
;;       ;; Replace paths of the form /cygdrive/c/... or //c/... with c:/...
;;       (if (string-match "^\\(//\\|/cygdrive/\\)\\([a-zA-Z]\\)/" file)
;;           (setq file (file-truename (replace-match "\\2:/" t nil file)))

;;         ;; ELSE
;;         ;; Replace names of the form /... with <cygnus installation>/...
;;         ;; try to find the cygwin installation
;;         (let ((paths (parse-colon-path (getenv "path"))) ; Get $(PATH) from the environment
;;               (found nil))

;;           ;; While there are unprocessed paths and cygwin is not found
;;           (while (and (not found) paths)
;;             (setq path (car paths)) ; grab the first path
;;             (setq paths (cdr paths)) ; walk down the list
          
;;             (if (and (string-match "/bin/?$" path) ; if it ends with /bin
;;                      (file-exists-p     n           ; and cygwin.bat is in the parent
;;                       (concat
;;                        (if (string-match "/$" path) path (concat path "/"))
;;                        "../cygwin.bat")))
;;                 (progn
;;                   (setq found t) ; done looping
;;                   (string-match "^\\(.*\\)/bin/?$" path)
;;                   (setq file (file-truename (concat (match-string 1 path) file))))
;;               )))))
;;   file)


;; This "advice" is a way of hooking a function to supply additional
;; functionality. In this case, we want to pre-filter the argument to the
;; function gud-find-file which is used by the emacs debugging mode to open
;; files specified by debug info.
;; (defadvice gud-find-file (before my-translate-cygwin-paths activate)
;;   (ad-set-arg 0 (my-translate-cygwin-paths (ad-get-arg 0)) t))

;;(menu-bar-mode nil)
;;(tool-bar-mode nil)
(scroll-bar-mode nil)

(put 'upcase-region 'disabled nil)

(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
        (beginning-of-line))))

(add-hook 'eshell-mode-hook
          '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

(tool-bar-mode -1)
(menu-bar-mode -1)

(autoload 'gnugo "gnugo" "GNU Go" t)
;;(add-hook 'gnugo-board-mode-hook
;;          '(lambda () (define-key eshell-mode-map "\C-j" 'gnugo-refresh)))


;;(load "workspaces" nil t)

;;(load "escreen")
;;(escreen-install)

;;(require 'workspaces)
;;(load "workspaces")


(defun my-app-load ()
  (interactive)
  (shell-command "cd /media/data/user/work/alarm-olimex/s/b1usart/test/ && make -k &" )
)
(defun my-app-test ()
  (interactive)
  (shell-command "cd /media/data/user/work/alarm-olimex/s/b1usart/test/ && make -k test &" )
  )

(defun my-git-push ()
  (interactive)
  ;; (shell-command "~/my-git-push.sh" )
  (shell-command "~/work/screeps.com/grunt_screeps/inst.sh" )
  )

(defun my-git-status ()
  (interactive)
 (switch-to-buffer "*git-status*" )
  )


(global-set-key [C-f6] 'my-app-load)
(global-set-key [C-f7] 'my-app-test)
(global-set-key [f2] 'sunrise)
(global-set-key [C-f2] 'sunrise-cd)
(global-set-key [f9] 'my-git-push)
(global-set-key [C-f9] 'my-git-status)
(require 'git)

(require 'imenu)

(global-set-key (kbd "C-m") 'newline)
;(global-set-key [C-tab] 'ido-switch-buffer)


; use Shift with the arrow keys to switch between windows (instead of C-x o)
(when (fboundp 'windmove-default-keybindings)
      (windmove-default-keybindings))

 ;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)


;; org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("/.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

; capture mode
;(setq org-default-notes-file (concat org-directory "/notes.org"))
;(setq org-default-notes-file  "~/org/notes.org")
;(define-key global-map "\C-cc" 'org-capture)

;; use google chrome web browser
(setq browse-url-browser-function (quote browse-url-generic))
(setq browse-url-generic-program "/usr/bin/google-chrome")

;; use conkeror as a default web browser
;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "/usr/bin/conkeror")


(defun my-org-move-down ()
  " "
  (interactive)
;  (outline-back-to-heading)
  (show-children)
  (show-entry)

  (let ((my-found)
        (my-level (funcall outline-level)))
    (save-excursion
      (outline-next-visible-heading 1)
      (if (< my-level (funcall outline-level))
          (setq my-found t)
        )
      )
    (if my-found
        (outline-next-visible-heading 1)
      )
    )
)

(defun my-org-move-up ()
  " "
  (interactive)
  (if ( and (outline-on-heading-p) (bolp))
      (outline-up-heading 1)
    (outline-back-to-heading)
    )
  )

(add-hook 'org-mode-hook
  '(lambda ()
	 (define-key org-mode-map "\M-\C-p"       'outline-backward-same-level)
	 (define-key org-mode-map "\M-\C-n"       'outline-forward-same-level)
;	 (define-key org-mode-map "\M-\C-u"       'outline-up-heading)
	 (define-key org-mode-map "\M-\C-u"       'my-org-move-up)
	 (setq org-use-speed-commands t)
	 (define-key org-mode-map "\M-\C-d"       'my-org-move-down)
	 (define-key org-mode-map "\C-ce"         'org-encrypt-entry)
	 (define-key org-mode-map "\C-cd"         'org-decrypt-entry)
	 ))

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

(defun open-test-srv ()
  (interactive) 
  (remote-term "term-test-srv" "ssh" "user@188.127.231.12"))

(require 'org-crypt)
; Encrypt all entries before saving
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
; GPG key to use for encryption
(setq org-crypt-key "F6270D37")

;; haskell mode
;;;(load "~/.emacs.d/rc/emacs-rc-haskell.el")

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(require 'git)


(require 'org)
(org-add-link-type "mydoc" 'org-mydoc-open)
;(org-add-link-type "file" 'org-mydoc-open)

;; (defun org-mydoc-open (path)
;;   "Visit the document PATH."
;;   (interactive)
;;   (save-excursion
;;     (let ((buf (generate-new-buffer "*Org Shell Output"))
;; 	  (cmd
;; 	   (concat "xdg-open " path)))
;; 					;    (async-shell-command cmd "*output*" nil) )
;; 					;      (shell-command-to-string cmd)

;;       (progn
;; 	(message "Executing %s" cmd)
;; 	(shell-command cmd buf))

;;       ))
;;   )
(defun org-mydoc-open (path)

  (let ((buf (generate-new-buffer "*testbuffer"))
	(cmd (concat "/home/user/work/emacs/runner/runner " path)))
    
    (progn
      (message "Executing %s" cmd)
      (call-process "xdg-open" nil 0 nil path) ; 0 - means don't wait for exit
      )
    )
  )

;; Capture
(setq org-default-notes-file (concat org-directory "/capture.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      (quote
       (("w"
         "Web capture"
         entry
         (file+headline "~/org/capture.org" "Notes")
         "* %:description %? %^g\n%t \n  Source: %u, %c\n\n  %i"
	 :prepend
         :empty-lines 1)
	("t" "Todo" entry (file+headline "~/org/capture.org" "Tasks")
	 "* TODO %?\n%T  %i\n  %a")
	("i" "Idea" entry (file+headline "~/org/capture.org" "Idea")
	 "* %?\n%T %i\n")

        ;; ... more templates here ...
        ) ))

;(server-start)
(require 'org-protocol)

;; (defun org-mydoc-open (path)
;;   "Visit the document PATH."
;;   (let ((cmd 
;; 	 (concat "nohup ./dv.sh " path)))
;;     (shell-command-to-string cmd)
;;     )
;;   )

;; perspective package - !!! seems to conflict with ido mode - ido-kill-buffer works weird.
;; Load Perspective
;(require 'perspective)
;; Toggle the perspective mode
;(persp-mode)

(require 'sunrise-commander)

(define-key sr-mode-map "c"        'my/sr-open-file)

(defun my/sr-open-file (&optional arg)
  "Open file using xdg-open"
  (interactive "P")
  (if arg
      (sr-quick-view-kill)
    (let ((name (dired-get-filename nil t)))
      (org-mydoc-open name))))

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)
;(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-x C-g") 'magit-dispatch-popup)

(if nil
    (transient-replace-suffix 'magit-branch 'magit-checkout
			      '("b" "dwim" magit-branch-or-checkout))
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-dispatch-arguments nil)
 '(package-selected-packages
   (quote
    (helm-swoop helm-smex helm-fuzzier company eyebrowse magit helm-projectile helm-org-rifle helm-helm-commands helm-grepint helm-google helm-gitignore helm-git-grep helm-git-files helm-git helm-fuzzy-find helm-flx helm-filesets helm-dirset helm-dired-recent-dirs helm-dash flx-ido))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; eyebrowse
(require 'eyebrowse)
(eyebrowse-mode t)
