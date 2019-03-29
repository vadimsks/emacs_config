
;; https://www.gnu.org/software/emacs/manual/html_node/cl/Sequences.html#Sequences
;; helm-make-target-history

(use-package helm-make
  :ensure t)

(require 'helm-make)

(defun helm--make-action (target)
  "Make TARGET."
  (let* ((targets (and (eq helm-make-completion-method 'helm)
                       (or (> (length (helm-marked-candidates)) 1)
                           ;; Give single marked candidate precedence over current selection.
                           (unless (equal (car (helm-marked-candidates)) target)
                             (setq target (car (helm-marked-candidates))) nil))
                       (mapconcat 'identity (helm-marked-candidates) " ")))
         (make-command (format helm-make-command (or targets target)))
         (compile-buffer (compile make-command helm-make-comint))
         (tgt-lst (split-string (or targets target))))
    (when helm-make-named-buffer
      (helm--make-rename-buffer compile-buffer (or targets target)))
    ;; update helm-make-target-history
    (setq helm-make-target-history
          (cl-set-difference helm-make-target-history tgt-lst  :test #'equal))
    (setcdr (last tgt-lst) helm-make-target-history)
    (setq helm-make-target-history tgt-lst)
    ))

(defun my-cl-difference( lst1 lst2 )
  "Return lst1 - lst2"
  (cl-remove lst2 lst1 :test #'(lambda(lst elem) (cl-find elem lst :test #'equal) ) ) )

(defun my-cl-intersection( lst1 lst2 )
  "Return lst1 - lst2"
  (let* ((tmp (cl-intersection lst1 lst2 :test #'equal)))
    (cl-remove tmp lst1 :test #'(lambda(lst elem) (not (cl-find elem lst :test #'equal) ) ) ) ))


;; targets = (history & targets) ++ (targets - history)

(defun my-helm--make-cached-targets ( orig &rest r )
  "sort the list "
  (let* ((orig-result (apply orig r))
         (temp1 (my-cl-intersection helm-make-target-history orig-result))
         (temp2 (my-cl-difference orig-result helm-make-target-history))
         (result ( append temp1 temp2 ))
         )
    (message "helm-make-target-history = %S" helm-make-target-history)
    (message "temp1 = %S" temp1)
    (message "temp2 = %S" temp2)    
    (message "return targets %S" result)
    result ))

(advice-add 'helm--make-cached-targets :around #'my-helm--make-cached-targets )

(defvar helm-make-f5-dir nil
  "Store the last make dir.")

(defun helm-make-f5 (&optional arg)
  "Call \"make -j ARG target\". Target is selected with completion."
  (interactive "p")
  (let ((makefile (helm--make-makefile-exists default-directory)))
    (if (not makefile)
        (error "No build file in %s" default-directory)
      (setq helm-make-f5-dir default-directory)
      (setq helm-make-command (helm--make-construct-command arg makefile))
      (helm--make makefile))))

;; (defun helm-make-C-f5 (&optional arg)
;;   "Call \"make -j ARG target\". Target is selected with completion."
;;   (interactive "p")
;;   (let ((makefile (helm--make-makefile-exists helm-make-f5-dir)))
;;     (if (not makefile)
;;         (error "No build file in %s" helm-make-f5-dir)
;;       (setq helm-make-command (helm--make-construct-command arg makefile))
;;       (setq default-directory helm-make-f5-dir)
;;       (let ((compilation-search-path helm-make-f5-dir))
;;         (helm--make makefile))
;;       )))

(defun helm-make-C-f5 (&optional arg)
  "Call \"make -j ARG target\". Target is selected with completion."
  (interactive "p")
  (let ((makefile (helm--make-makefile-exists helm-make-f5-dir)))
    (if (not makefile)
        (error "No build file in %s" helm-make-f5-dir)
      (setq helm-make-command (helm--make-construct-command arg makefile))
      ; (setq default-directory helm-make-f5-dir)
      (let ((compilation-search-path helm-make-f5-dir)
            (default-directory helm-make-f5-dir))
        (helm--make makefile))
      )))

;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Advice-combinators.html

    ;; (message "helm-make-target-history 3 = %s"
    ;;          (mapconcat (lambda (f) (format " %s, " f)) helm-make-target-history "") )
    

;; (setq asdf helm-make-target-history)
;; (del '("run" "test") helm-make-target-history )

;; (setq lst1 (list "aaa" "bbb" "ccc" "111") )
;; (setq lst2 (list "111" "222" "aaa") )

;; (setq tmp1 (cl-intersection lst1 lst2 :test #'equal))
;; (cl-remove tmp1 lst1 :test #'(lambda(lst elem) (not (cl-find elem lst :test #'equal) ) ) )


;; (my-cl-intersection lst1 lst2 )

;; (my-cl-difference lst2 lst1)

;; ( apply (lambda(lst elem) (cl-find elem lst :test #'equal) ) lst1 "aaa" () )
;; (cl-remove "aaa" lst1 :test #'equal )



;; (setcdr (last lst) lst2)
;; (setq xxx lst)
;; (cl-set-difference lst (list "aaa" "bbb") :test #'equal )
;; (setcdr lst helm-make-target-history)

;; (split-string "a")
;; (split-string ())

;; (setq tgt "asdf" )
;; (setq tgts (cons tgt ()) )
;; (setq tgts (list tgt) )


(defun helm--make (makefile)
  "Call make for MAKEFILE."
  (when helm-make-do-save
    (let* ((regex (format "^%s" default-directory))
           (buffers
            (cl-remove-if-not
             (lambda (b)
               (let ((name (buffer-file-name b)))
                 (and name
                      (string-match regex (expand-file-name name)))))
             (buffer-list))))
      (mapc
       (lambda (b)
         (with-current-buffer b
           (save-buffer)))
       buffers)))
  (let ((targets (helm--make-cached-targets makefile))
        (default-directory (file-name-directory makefile)))
    (delete-dups helm-make-target-history)
    (cl-case helm-make-completion-method
      (helm
       (helm :sources (helm-build-sync-source (concat "Targets" " from " makefile)
                        :candidates 'targets
                        :fuzzy-match helm-make-fuzzy-matching
                        :action 'helm--make-action)
             :history 'helm-make-target-history
             :preselect (when helm-make-target-history
                          (car helm-make-target-history))))
      (ivy
       (ivy-read "Target: "
                 targets
                 :history 'helm-make-target-history
                 :preselect (car helm-make-target-history)
                 :action 'helm--make-action
                 :require-match helm-make-require-match))
      (ido
       (let ((target (ido-completing-read
                      "Target: " targets
                      nil nil nil
                      'helm-make-target-history)))
         (when target
           (helm--make-action target)))))))


;; helm-min slowness - https://github.com/emacs-helm/helm/issues/2089

;; When non-nil, run helm-make in Comint mode instead of Compilation mode.
;; compilation-next-error [M-C-n]
(setq helm-make-comint t)

;;
;; (defun run-it ()
;;   "Run it on the current file."
;;   (interactive)
;;   (save-buffer)
;;   (shell-command
;;    (format "my_command %s &"
;;        (shell-quote-argument (buffer-name)))))
;; (global-set-key "\C-ct" 'run-it)
