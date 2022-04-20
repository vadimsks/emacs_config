;;  "Find shell command `C-c /'" 'helm-ff-find-sh-command
;; "C-]"
;; C-x c b - resume

(use-package helm
  :ensure t)

;; (setq helm-buffer-max-length 50)
;;(use-package helm-mode
;;  :ensure t)

(require 'helm-config)

(use-package helm-flx :ensure t)
(helm-flx-mode +1)

(use-package helm-ag
  :ensure t)
(use-package helm-swoop
  :ensure t)

(use-package helm-tramp
  :ensure t)

(use-package helm-make
  :ensure t)

(use-package helm-projectile
  :ensure t)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)


(setq helm-split-window-inside-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line        t
      helm-buffer-max-length                50 ; helm-mini filename column width
      )

(setq
      helm-idle-delay                       0.0
      helm-input-idle-delay                 0.01
      helm-quick-update                     t
      )

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hookk
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 80)
(helm-autoresize-mode 1)

;; --------------------------------------------------
;; recentf 
;; --------------------------------------------------
(recentf-mode 1)
(setq-default recent-save-file "~/.emacs.d/recentf")

;; (defun helm-ff-recentf (_candidate)
;;   "Browse project in current directory.
;; See `helm-browse-project'."
;;   (with-helm-default-directory helm-ff-default-directory
;;     (helm-recentf)))

(defun my-helm-ff-run-recent ()
  "Run helm-recentf action from `helm-source-find-files'."
  (interactive)
  (with-helm-alive-p
    ;;(helm-exit-and-execute-action 'helm-ff-recentf)
    (helm-run-after-exit 'helm-recentf)
    ))

(define-key helm-find-files-map (kbd "C-r") 'my-helm-ff-run-recent)
;;(define-key helm-find-files-map (kbd "C-j") 'helm-find-files-up-one-level)
;; (define-key helm-find-files-map (kbd "C-l") 'helm-execute-persistent-action)

(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

;;(setq helm-follow-mode-persistent t )

(require 'helm-eshell)

;; (add-hook 'eshell-mode-hook
;;           (lambda ()
;;               (eshell-cmpl-initialize)
;;               (define-key eshell-mode-map [remap eshell-pcomplete] 'helm-esh-pcomplete)
;;               (define-key eshell-mode-map (kbd "M-s f") 'helm-eshell-prompts-all)
;;               (define-key eshell-mode-map (kbd "M-r") 'helm-eshell-history)))

(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-hist-mode-map (kbd "C-c C-l")  'helm-eshell-history)))

;; don't use a new frame for shell history
(setq helm-show-completion-display-function #'helm-show-completion-default-display-function)

;;; projectile

;;(projectile-global-mode)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(projectile-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(setq projectile-mode-line
         '(:eval (format " Projectile[%s]"
                        (projectile-project-name))))

;; projectile-svn-command
(setq projectile-indexing-method 'alien)
;;(setq projectile-indexing-method 'native)
;; 
;;(setq projectile-svn-command "find . -type f -print0" )
(setq projectile-svn-command "find . -path ./build -prune -o -type f -and -not -regex '.*\\.svn.*' -and -not -name 'TAGS' -and -not -regex '.*~' -print0" )

;; Help ffap (C-c C-o) find files in compilation output
;; (push (cons 'compilation-mode
;;             (lambda (name)
;;               (let ((newname (expand-file-name name (projectile-project-root))))
;;                 (when (file-exists-p newname)
;;                   newname))))
;;       ffap-alist)

;;compilation-search-path
;;compilation-directory-matcher
;; default-directory
;; M-x eval-expression
;(setq compilation-search-path '(nil))
;(setq compilation-directory-matcher '(nil))
;;(setq default-directory "/home/user/app")
;; C-c p f
;; C-c p a - other file
;; C-c p p - select project

;; Help ffap (C-c C-o) find files in compilation output
;; Add project root dir to the compilation-search-path
(defun my-compilation-find-file ( orig marker filename dir &rest formats )
  "Find a buffer for file FILENAME."
  (let* ((lst (if (projectile-project-p dir)
               (append compilation-search-path (cons (projectile-project-root dir) nil) )
             compilation-search-path ))
         (compilation-search-path lst))
    (message "compilation-search-path: %s" compilation-search-path)
    (apply orig marker filename dir formats) )
  )

(advice-add 'compilation-find-file :around #'my-compilation-find-file )


;; how to set buffer local project root
;; M-x eval-expression
;; (setq projectile-project-root "~/app" )
                                           

;; TODO
;; (defun helm-buffer--format-mode-name (buf)
;;   "Prevent using `format-mode-line' as much as possible."
;;   (with-current-buffer buf
;;     "test"))


(global-set-key (kbd "C-x C-f") #'helm-find-files)

;; helm-swoop
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)


;; (define-key sr-mode-map "\C-x\C-f"    'helm-find-file)


;; don't reorder buffers list
;; (defun helm-buffers-sort-transformer (candidates _source)
;;   (if (string= helm-pattern "")
;;       candidates
;;     (sort candidates
;;           (lambda (s1 s2)
;;               (< (string-width s1) (string-width s2))))))

(defun helm-buffers-sort-transformer@donot-sort (_ candidates _)
  candidates)

(advice-add 'helm-buffers-sort-transformer :around 'helm-buffers-sort-transformer@donot-sort)

(helm-mode)

