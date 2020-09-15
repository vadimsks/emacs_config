
;; pdf-tools-install
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  )

(use-package org-pdftools
  :ensure t
  ;;:hook (org-load-hook . org-pdftools-setup-link )
  )

(org-pdftools-setup-link)

;; workaround for Symbol's function definition is void: org-link-store-props
(defun org-link-store-props (&rest args)
  (apply 'org-store-link-props args))

;; o - outline
;; org-store-link
;; C-c C-l - org-insert-link
;; C-c C-o
;; C-s - isearch
;; pdf-occur
;; B N - history
;; Q - kill buffer
;; H P W 0 - scale
