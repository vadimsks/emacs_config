;; https://org-roam.readthedocs.io/en/master/configuration/

;; To build the cache manually, one can run M-x org-roam-db-build-cache.

(use-package org-roam
  :ensure t
  :hook  (after-init . org-roam-mode)
  :custom  (org-roam-directory "~/work/org/")
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph-show))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

; (define-key org-roam-mode-map (kbd "C-c n j") #'org-roam-jump-to-index)
; (define-key org-roam-mode-map (kbd "C-c n b") #'org-roam-switch-to-buffer)

(setq org-roam-completion-system 'helm)

(server-start)
(require 'org-roam-protocol)



;; C-c C-o to open in the current window
;; https://stackoverflow.com/questions/17590784/how-to-let-org-mode-open-a-link-like-file-file-org-in-current-window-inste
(defun org-force-open-current-window ()
  (interactive)
  (let ((org-link-frame-setup (quote
                               ((vm . vm-visit-folder)
                                (vm-imap . vm-visit-imap-folder)
                                (gnus . gnus)
                                (file . find-file)
                                (wl . wl)))
                              ))
    (org-open-at-point)))
;; Depending on universal argument try opening link
(defun org-open-maybe (&optional arg)
  (interactive "P")
  (if arg
      (org-open-at-point)
    (org-force-open-current-window)
    )
  )
;; Redefine file opening without clobbering universal argumnet
(define-key org-mode-map "\C-c\C-o" 'org-open-maybe)


;;(add-hook 'after-init-hook 'org-roam-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; org roam server

;; (use-package org-roam-server
;;   :ensure t
;;   :config
;;   (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 8081
;;         org-roam-server-authenticate nil
;;         org-roam-server-export-inline-images t
;;         org-roam-server-serve-files nil
;;         org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;         org-roam-server-network-poll t
;;         org-roam-server-network-arrows nil
;;         org-roam-server-network-label-truncate t
;;         org-roam-server-network-label-truncate-length 60
;;         org-roam-server-network-label-wrap-length 20))

;;(org-roam-server-mode)

;; http://localhost:8081
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TODO
;; https://github.com/jkitchin/org-ref
;; https://www.youtube.com/watch?v=2t925KRBbFc - org-ref demo
;; https://github.com/raxod502/straight.el

;; (use-package company-org-roam
;;   :straight (:host github :repo "org-roam/company-org-roam")
;;   :config
;;   (push 'company-org-roam company-backends))

;; sudo apt-get install sqlite3 libsqlite3-dev


