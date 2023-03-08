;; https://github.com/magit/transient/wiki/Developer-Quick-Start-Guide

(require 'transient)

(defclass mype-option (transient-option)
  ((mype-usage    :initarg :mype-usage    :initform (list))
   (mype-hide-arg :initarg :mype-hide-arg :initform nil)
   )
  )

(cl-defmethod transient-format-value ((obj mype-option))
  (if (not (oref obj mype-hide-arg))
      (cl-call-next-method obj)
    (let ((argument (oref obj argument)))
      (if-let ((value (oref obj value)))
          ;;   (propertize
          ;;    (cl-ecase (oref obj multi-value)
          ;;      ((nil)    (concat argument value))
          ;;      ((t rest) (concat argument
          ;;                        (and (not (string-suffix-p " " argument)) " ")
          ;;                        (mapconcat #'prin1-to-string value " ")))
          ;;      (repeat   (mapconcat (lambda (v) (concat argument v)) value " ")))
          ;;    'face 'transient-value)
          ;; (propertize argument 'face 'transient-inactive-value)

          (propertize
           (cl-ecase (oref obj multi-value)
             ((nil)    (concat value))
             ((t rest) (concat ;;argument
                        ;; (and (not (string-suffix-p " " argument)) " ")
                        (mapconcat #'prin1-to-string value " ")))
             (repeat   (mapconcat (lambda (v) (concat argument v)) value " ")))
           'face 'transient-value)
        (propertize " " 'face 'transient-inactive-value)      
        ))
    )
  )

(defclass mype-switch (transient-switch)
  ((mype-usage    :initarg :mype-usage    :initform (list))
   ;;(mype-hide-arg :initarg :mype-hide-arg :initform nil)
   )
  )

(cl-defmethod transient-infix-read ((obj mype-switch))
  "Toggle the switch on or off."
  (if (oref obj value) nil (oref obj argument)))

(transient-define-argument mype-build:--config ()
  :description "config   "
  :class 'mype-option
  :mype-usage '(build install)
  :mype-hide-arg t
  :key "-c"
  :always-read t
  :argument "--config="
  ;; :multi-value t
  :choices '("Debug" "Testing" "Release" "Sanitizer" "Coverage" "Profiling")
)

(transient-define-argument mype-build:--platform ()
  :description "platform "
  :class 'mype-option
  :mype-usage '(build)
  :mype-hide-arg t
  :key "-p"
  :always-read t
  :argument "--platform="
  :choices '("Luxe" "x86"))

(transient-define-argument mype-build:--toolchain ()
  :description "toolchain"
  :class 'mype-option
  :mype-usage '(build)
  :mype-hide-arg t
  :key "-t"
  :always-read t
  :argument "--toolchain="
  :choices '("gcc" "clang"))

(transient-define-argument mype-build:--device ()
  :description "device"
  :class 'mype-option
  :mype-usage '(build install)
  :mype-hide-arg t
  :key "-d"
  ;;:always-read t
  :argument "--device="
  :choices '("8000" "6000"))

(transient-define-argument mype-build:--app ()
  :description "app"
  :class 'mype-option
  :mype-usage '(build)
  :mype-hide-arg t
  :key "ab"
  :always-read t
  ;; :argument "--app="
  :argument ""
  :multi-value t
  :choices '("fpe" "kili" "cma")
  )

(transient-define-argument mype-build:--app-inst ()
  :description "app install"
  :class 'mype-option
  :mype-usage '(install)
  :mype-hide-arg t
  :key "ai"
  :always-read t
  ;; :argument "--app="
  :argument "--app-install="
  :multi-value t
  :choices '("fpe" "payment" "cma" "pinpad")
  )

;; (transient-define-argument transient-toys--snowcone-flavor ()
;;   :description "Flavor of snowcone"
;;   :class 'transient-switches
;;   :key "-s"
;;   :argument-format "--%s-snowcone"
;;   :argument-regexp "\\(--\\(grape\\|orange\\|cherry\\|lime\\)-snowcone\\)"
;;   :choices '("grape" "orange" "cherry" "lime"))


(defun mype--arg-value ( key args)
  (let* ((v1 (transient-arg-value key args))
         (v2 (assoc key args))
         (v (or v1 v2))
         )
    (cl-typecase v
      (string (concat key v))
      (boolean
       (if v
           key
         nil))
      (list
       (concat "" ;;key
               (mapconcat 'identity (cdr v) " ")))
      (t "nil")
      )        
    )
  )

(defun mype--build-args (expected-args prefix-args )
  (let* ((arg-lst (cl-loop for e in expected-args
                           collect (mype--arg-value e prefix-args)
                           ) )
         (arg-lst (seq-filter
                   (lambda (s) s) 
                   arg-lst
                   ) )
         (arg-str (mapconcat 'identity arg-lst " "))
         )
    arg-str
    )
  )

;; (setq abc '("--platform=Luxe" "--config=Debug" "--toolchain=gcc" "-j=3" "--verbose" ("--app=" "fpe" )))
;; (transient-arg-value "--platform=" abc)
;; (transient-arg-value "--verbose" abc)
;; (transient-arg-value "--app=" abc)
;; (assoc "--app=" abc)

;; (mype--arg-value "--platform=" abc)
;; (mype--arg-value "--verbose" abc)
;; (mype--arg-value "--app=" abc)
;; (mype--arg-value "--j=" abc)
;; (mype--arg-value "-j=" abc)
;; (mype--arg-value "xxx" abc)


;; (mype--build-args '("--platform=" "-j=" "--app=" "-asdf=" "--verbose") abc)

(defun mype--args-for-cmd ( cmd )
  (let* ((sfxs (transient-suffixes 'mype-build))
         (usages 
          (cl-loop for sfx in sfxs
                   collect (and (slot-exists-p sfx 'argument)
                                (slot-exists-p sfx 'mype-usage)
                                (member cmd (oref sfx mype-usage))
                                (oref sfx argument)
                                )
                   )
          )
         (usages (seq-filter
                  (lambda (s) s) 
                  usages
                  ) )
         
         )
    usages
    )
  )

;; (mype--args-for-cmd 'build)

(transient-define-suffix mype-build-it ( cmd &optional args)
  "Run command"
;;  (interactive (list (transient-args transient-current-command)))
  (let* (
         (exp-args (mype--args-for-cmd cmd))
         (it_cmd (cl-ecase cmd
                   ('build "./build.py")
                   ('install "./install.py")
                   ))
         (dc_cmd "/home/developer/work/dc.sh" )
         )

    (message "exp-args: %s" exp-args )
    (compilation-start (format "cd /home/developer/Kili && %s %s %s"
                               dc_cmd
                               it_cmd
                               (mype--build-args exp-args args)) t)
    )
  )

(transient-define-prefix mype-build ()
  "build.py"
  ;; :man-page "git-merge"
  ;; :command 'mype-command
  ;; :incompatible '(("--ff-only" "--no-ff"))
  :incompatible '(
                  ;; update your transient version if you experience #129 / #155
                  ("--reinstall" "--no-install" "--remove")
                  )
  ["Arguments"
  ["Config"
   ;; ("-f" "Fast-forward only" "--ff-only")
   ;;("-n" "No fast-forward"   "--no-ff")
   (mype-build:--config)
   (mype-build:--platform)
   (mype-build:--toolchain)
   (mype-build:--device)
   ]
  [
   "Options"
   ;;("t" "toggle" "--toggle")
   ;; ("I" "argument with inline" ("-i" "--inline-shortarg="))
   ("-j" "jobs" "-j="  :class mype-option :mype-usage (build) )
   ("-r" "rebuild" "--rebuild" :class mype-switch :mype-usage (build))
   ("-v" "verbose" "--verbose" :class mype-switch :mype-usage (build))
   ]
  [
   "Install"
   ("-ii" "--reinstall"  "--reinstall"  :class mype-switch :mype-usage (install) )
   ("-in" "--no-install" "--no-install" :class mype-switch :mype-usage (install))
   ("-ir" "--remove"     "--remove"     :class mype-switch :mype-usage (install))
   ("-if" "--no-free-space-check" "--no-free-space-check" :class mype-switch :mype-usage (install))
   ]
  ]
  ["Targets"
   (mype-build:--app)
   (mype-build:--app-inst)
   ]
  ["Actions"
   ("b" "Build"  mype-build-build)
   ("i" "Install"  mype-build-install)
   ]
  ["Settings"
   ("S" "Save"  
    (lambda () (interactive)
      (transient-save)
      (message "Saved")
      )
    :transient t
    )
   ("R" "Reset"
    (lambda () (interactive)
      (transient-reset)
      (message "Reset")
      )
    :transient t
    )
   ]
  ;;  (5 mype-build:--strategy-option)
  ;;  (5 "-b" "Ignore changes in amount of whitespace" "-Xignore-space-change")
  ;;  (5 "-w" "Ignore whitespace when comparing lines" "-Xignore-all-space")
  ;;  (5 magit-diff:--diff-algorithm :argument "-Xdiff-algorithm=")
  ;;  (5 magit:--gpg-sign)]
  ;; ["Actions"
  ;;  :if-not mype-build-in-progress-p
  ;;  [("m" "Merge"                  mype-build-plain)
  ;;   ("e" "Merge and edit message" mype-build-editmsg)
  ;;   ("n" "Merge but don't commit" mype-build-nocommit)
  ;;   ("a" "Absorb"                 mype-build-absorb)]
  ;;  [("p" "Preview merge"          mype-build-preview)
  ;;   ""
  ;;   ("s" "Squash merge"           mype-build-squash)
  ;;   ("i" "Dissolve"               mype-build-into)]]
  ;; ["Actions"
  ;;  :if mype-build-in-progress-p
  ;;  ("m" "Commit merge" magit-commit-create)
  ;;  ("a" "Abort merge"  mype-build-abort)]
  )

(defun mype-build-build (&optional args)
  (interactive
   (list (transient-args 'mype-build)))
  (transient-save)
  (message "args %s" (transient-args 'mype-build))
  (message "args %s" args)
  (mype-build-it 'build args)
  )

;; (apply 'mype-build-it (cons 'build '()))

(defun mype-build-install (&optional args)
  (interactive
   (list (transient-args 'mype-build)))
  (transient-save)
  (message "args %s" (transient-args 'mype-build))
  (message "args %s" args)
  (mype-build-it 'install args)
  )

(mype-build)
;; (oref (plist-get (symbol-plist 'mype-build) 'transient--prefix) value)
;; (mype-install)
;; (test-function)

;; (setq prefix-object (plist-get (symbol-plist 'mype-build) 'transient--prefix))
;; (oref prefix-object :value)
;; (oref prefix-object :prototype)


;; (mype--args-for-cmd 'build )
;; (mype--args-for-cmd 'install )


;; (my-load-init-config "pe.el")
