
(setq my-clang-dir "/home/developer/work/clang/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04/")

(let* ((el-file (concat my-clang-dir "share/clang/clang-format.el") )
       (exe-file (concat my-clang-dir "/bin/clang-format") ) )
  (if (and (file-directory-p my-clang-dir) (file-exists-p el-file))
      (progn
        (load el-file)
        (require 'clang-format)
        (setq clang-format-executable exe-file)
        (global-set-key [C-tab] 'clang-format-region) )
    (message "Cannot find clan in %s" my-clang-dir) ) )

