(setq c-default-style
       '((java-mode . "java") (other . "bsd")))

;(setq frame-title-format "%b - Emacs")

;; (setq-default tab-width 8)
;; (setq-default c-basic-offset 4)

(setq c-default-style
       '((java-mode . "java") (other . "bsd")))

;(setq frame-title-format "%b - Emacs")
;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;; (package-initialize)
;; list-packages 

;; smart-indent-mode - begin
;; (require 'smart-tabs-mode)
;; (smart-tabs-insinuate 'c 'c++)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(add-hook 'c-mode-common-hook
              (lambda () 
                (setq indent-tabs-mode nil)
;                (c-set-offset 'case-label '+) ;indent case labels by c-indent-level, too
                ))
;; smart-indent-mode - end
;(setq c-indentation-style 'k&r)

(setq compilation-scroll-output t)
(setq column-number-mode t)

(setq which-function-mode t)

(defun my-c-mode-hook ()
  (c-set-offset 'innamespace 0)
  (c-set-offset 'case-label '+)
  (setq-default tab-width 4)
  (setq-default c-basic-offset 4)
  (setq-default indent-tabs-mode nil)
  )

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)


;; helm-c-yasnippet
  ;; yasnippet          0.13.0        available  gnu        Yet another snippet extension for Emacs.
  ;; yasnippet          20190414.1606 available  melpa      Yet another snippet extension for Emacs.
  ;; yasnippet-class... 1.0.2         available  gnu        "Classic" yasnippet snippets
  ;; yasnippet-snippets 20190316.1019 available  melpa      Collection of yasnippet snippets
;;  yatemplate         20180617.952  available  melpa      File templates with yasnippet


(use-package yasnippet
  :ensure t)
(use-package yasnippet-snippets
  :ensure t)
(use-package helm-c-yasnippet
  :ensure t)

(require 'yasnippet)
(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t) ;[default: nil]
(global-set-key (kbd "C-c y") 'helm-yas-complete)
(yas-global-mode 1)
;; (yas-load-directory "<path>/<to>/snippets/")


;; yatemplate
(use-package buttercup
  :ensure t)
(use-package yatemplate
  :ensure t)

(require 'yatemplate)

(yatemplate-fill-alist)

;;yas--parse-template

;; (defun yatemplate-expand-yas-buffer ()
;;   "Expand the whole buffer with `yas-expand-snippet'."
;;   (yas-expand-snippet (buffer-string) (point-min) (point-max)))

(defun yatemplate-expand-yas-buffer ()
  "Expand the whole buffer with `yas-expand-snippet'."
  (let* ((parsed (yas--parse-template))
         (key (pop parsed))
         (template (pop parsed))
         (name (pop parsed))
         (condition (pop parsed))
         (group (pop parsed))
         (expand-env (pop parsed))
         )
    (yas-expand-snippet template (point-min) (point-max) expand-env)) )

;;(yas-lookup-snippet "and")


(define-key c-mode-map (kbd "\C-cm") 'helm-semantic-or-imenu)
(define-key c++-mode-map (kbd "\C-cm") 'helm-semantic-or-imenu)
