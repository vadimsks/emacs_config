
(setq my-clang-dir "~/work/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04")

(let* ((dir (expand-file-name my-clang-dir))
       (el-file (concat dir "/share/clang/clang-format.el") )
       (exe-file (concat dir "/bin/clang-format") ) )
  (if (and (file-directory-p my-clang-dir) (file-exists-p el-file))
      (progn
        (load el-file)
        (require 'clang-format)
        (setq clang-format-executable exe-file)
        (global-set-key [C-tab] 'clang-format-region) )
    (message "clang not found in %s" dir) ) )

