;; sunrise
(require 'sunrise-commander)

(add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))
(global-set-key [f2] 'sunrise)
(global-set-key [f3] 'sunrise-cd)
