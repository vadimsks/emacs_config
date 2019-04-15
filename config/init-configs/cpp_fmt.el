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


;;; cmake
(setq cmake-tab-width 4)

(defun my-c-mode-hook ()
  (c-set-offset 'innamespace 0)
  (c-set-offset 'case-label '+)
  (setq-default tab-width 4)
  (setq-default c-basic-offset 4)
  (setq-default indent-tabs-mode nil)
  )

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)
