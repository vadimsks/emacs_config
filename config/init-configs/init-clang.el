;; todo compare with ccls

;; temp files /tmp/preamble*.pch

;; (use-package eglot
;;   :ensure t)
;; (require 'eglot)

(let ((candidates '(
                    "~/work/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04"
                    "~/work/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04" ) ))
  (setq my-clang-dir (seq-find (lambda (elt) (file-exists-p elt)) candidates) )
  )

;; (setq my-ccls-dir "~/disks/VOL/work/ccls/ccls" )

(use-package lsp-mode :ensure t :commands lsp)
;;(use-package lsp-ui :commands lsp-ui-mode)
;;(use-package company-lsp :commands company-lsp)

(use-package ccls
  :ensure t
  :hook ((c-mode c++-mode objc-mode) .
          (lambda () (require 'ccls) (lsp)))
  )

;; (require 'ccls)

(when my-clang-dir
  (let* ((dir (expand-file-name my-clang-dir))
         ;; (ccls-dir (expand-file-name my-ccls-dir))
         (el-file (concat dir "/share/clang/clang-format.el") )
         (exe-file (concat dir "/bin/clang-format") ) )
    (if (and (file-directory-p my-clang-dir) (file-exists-p el-file))
        (progn
          (load el-file)
          (require 'clang-format)
          (setq clang-format-executable exe-file)
          (global-set-key [M-q] 'clang-format-region)
          (define-key c-mode-map (kbd "M-q") 'clang-format-region)
          (define-key c++-mode-map (kbd "M-q") 'clang-format-region)
          ;; (add-to-list 'eglot-server-programs (list '(c++-mode c-mode)
          ;;                                           ;;(concat dir "/bin/clangd")
          ;;                                           "ccls"
          ;;                                           ))
          )
      (message "Cannot find clang in %s" my-clang-dir) ) ) )

;; eglot - starts clangd, requires <root>/compile_commands.json
;; xref-find-definitions
;; company-capf

(use-package cmake-mode
  :ensure t)
