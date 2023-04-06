;; clipboard

;; (use-package xclip :ensure t)
;; (require 'xclip)
;; (setq xclip-method 'xclip)
;; (setq xclip-program "clip.exe")
;; (xclip-mode 1)

; wsl-copy
;; (defun wsl-copy (start end)
;;   (interactive "r")
;;   (shell-command-on-region start end "clip.exe")
;;   (deactivate-mark))

;; (defun my-gui-set-selection-advice (orig-fun type data)
;;   (message "gui-set-selection called with args %S" (list type ))
;;   (let ((res (apply orig-fun (list 'CLIPBOARD data))))
;;     ;; (message "gui-set-selection returned %S" res)
;;     ;; (apply orig-fun (list 'CLIPBOARD data))
;;     res))

;; (advice-add 'gui-set-selection :around #'my-gui-set-selection-advice)

(defun my-trace-advice (orig-fun &rest data)
  ;;(message "pgtk-own-selection-internal called with args %S" (string= (car data) "PRIMARY"))
  (let ((res
         (if (string= (car data) "PRIMARY")
             t
           (apply orig-fun data))
         ))
    ;; (message "gui-set-selection returned %S" res)
    ;; (apply orig-fun (list 'CLIPBOARD data))
    res))

(advice-add 'pgtk-own-selection-internal :around #'my-trace-advice)

;; gui-set-selection

;; (defun my-trace-advice2 (orig-fun &rest data)
;;   (message "pgtk-disown-selection-internal called with args %S" data)
;;   (let ((res (apply orig-fun data)))
;;     ;; (message "gui-set-selection returned %S" res)
;;     ;; (apply orig-fun (list 'CLIPBOARD data))
;;     res))

;; (advice-add 'pgtk-disown-selection-internal :around #'my-trace-advice2)

;; (defun my-tracing-function ()
;;   (message "Proc received" ))

;;(add-function :before (pgtk-own-selection-internal selection  ) #'my-tracing-function)

;;(my-gui-set-selection-advice 'gui-set-selection 'PRIMARY "clip" )
