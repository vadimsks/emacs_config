;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)
;; (define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
;; (define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)

; clang backend
;(setq company-backends (delete 'company-semantic company-backends))
;(define-key c-mode-map  (kbd "M-/") 'company-complete)
;(define-key c++-mode-map  (kbd "M-/") 'company-complete)

(setq completion-ignored-extensions
      '(".o" ".elc" "~" ".bin" ".class" ".exe" ".ps" ".abs" ".mx"
        ".~jv" ".rbc" ".pyc" ".beam" ".aux" ".out" ".pdf" ".hbc"))

(use-package company
  :ensure t
  :diminish company-mode
  :init
  :config
  ;; (add-hook 'prog-mode-hook 'company-mode)
  ;; (add-hook 'comint-mode-hook 'company-mode)
  :config

  (require 'cc-mode)
  (setq company-backends (cons 'company-capf (delete 'company-capf company-backends))) ; capf backend
  ; (global-company-mode)
  (setq company-tooltip-limit 10)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0)
  (setq company-echo-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-require-match nil)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-align-annotations t)
  ;; (setq company-tooltip-flip-when-above t)
  (setq company-transformers '(company-sort-by-occurrence)) ; weight by frequency
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  ;;(define-key c-mode-map  [(tab)] 'company-capf)
  ;;(define-key c++-mode-map  [(tab)] 'company-capf)
  (define-key c-mode-map  (kbd "M-/") 'company-complete)
  (define-key c++-mode-map  (kbd "M-/") 'company-complete)
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous)

  :hook ((c-mode c++-mode objc-mode) .
          (lambda () (require 'company) (company-mode)))

  )
