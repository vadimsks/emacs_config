;; Smex (M-x with ido)
;; (add-to-list 'load-path "~/.emacs.d/libs/smex/")
(require 'smex)
(smex-initialize)
(setq smex-save-file "~/.emacs.d/smex-save-file")
;;(global-set-key (kbd "M-x") 'smex)
;;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;;(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(use-package helm-smex
  :ensure t)
(require 'helm-smex)
