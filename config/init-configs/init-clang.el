;; lsp-find-references

;; temp files /tmp/preamble*.pch

;; (use-package eglot
;;   :ensure t)
;; (require 'eglot)

(let ((candidates '(
                    "~/work/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04"
                    "~/work/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04"
                    "~/work/clang9") ))
  (setq my-clang-dir (seq-find (lambda (elt) (file-exists-p elt)) candidates) )
  )

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (push "[/\\\\]build$" lsp-file-watch-ignored)
  (if (equal my-config-variant 'my-config-wsl)
      (progn
        (setq lsp-clients-clangd-executable "/home/developer/local/bin/clangd" )
        (setq lsp-disabled-clients '(ccls)))
    (setq lsp-clients-clangd-executable "~/work/clang11/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/clangd" ))
  )

;;(use-package lsp-ui :commands lsp-ui-mode)

;; performance optimization - https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-completion-provider :capf)

(if (not (equal my-config-variant 'my-config-wsl))
    (use-package ccls
      :ensure t
      ;;  :hook ((c-mode c++-mode objc-mode) .
      ;;          (lambda () (require 'ccls) (lsp)))
      ))

(if (not (equal my-config-variant 'my-config-wsl))
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

  ;; /home/developer/work/clang-format/share/clang-format.el
  (let* ((my-clang-dir "/home/developer/work/clang-format")
         (dir my-clang-dir)
         ;; (ccls-dir (expand-file-name my-ccls-dir))
         (el-file (concat dir "/share/clang-format.el") )
         (exe-file (concat dir "/clang-format") ) )
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
      (message "Cannot find clang in %s\n %s" my-clang-dir el-file) ) )
  )

(setq clang-format-executable "clang-format.sh")

;; eglot - starts clangd, requires <root>/compile_commands.json
;; xref-find-definitions
;; company-capf

;;; cmake
(use-package cmake-mode
  :ensure t)
(setq cmake-tab-width 4)

