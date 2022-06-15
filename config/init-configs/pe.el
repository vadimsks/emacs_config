(require 'transient)

(defun test-function (&optional args)
  (interactive
   (list (transient-args 'test-transient)))
  (message "args %s" args))

(define-infix-argument test-transient:--message ()
  :description "Message"
  :class 'transient-option
  :shortarg "-m"
  :argument "--message=")

(define-infix-argument kubernetes-transient:--tail ()
  :description "Tail"
  :class 'transient-option
  :shortarg "-t"
  :argument "--tail=")

(defun kubernetes-get-logs (&optional args)
  (interactive
   (list (transient-args 'test-transient)))
  (let ((process "*kubectl*")
        (buffer "*kubectl-logs*")
        (pod "test"))
    (if (member "-f" args)
        (apply #'start-process process buffer "ls" "logs" pod args)
      (apply #'call-process "ls" nil buffer nil "logs" pod args))
    ;; (message "args %s" args)
    (switch-to-buffer buffer)
    ))

(define-transient-command test-transient ()
  "Test Transient Title"
  ["Arguments"
   ("-s" "Switch" "--switch")
   ("-a" "Another switch" "--another")
   (kubernetes-transient:--tail)
   (test-transient:--message)]
  ["Actions"
   ("d" "Action d" test-function)
   ("l" "Log" kubernetes-get-logs)
   ])

(transient-define-argument mype-build:--config ()
  :description "config"
  :class 'transient-option
  ;; key for merge and rebase: "-s"
  ;; key for cherry-pick and revert: "=s"
  ;; shortarg for merge and rebase: "-s"
  ;; shortarg for cherry-pick and revert: none
  :key "-c"
  :argument "--config="
  :choices '("Debug" "Release" "Testing"))

(transient-define-prefix mype-build ()
  "Merge branches."
  :man-page "git-merge"
  ;; :incompatible '(("--ff-only" "--no-ff"))
  ["Arguments"
   ;; ("-f" "Fast-forward only" "--ff-only")
   ;; ("-n" "No fast-forward"   "--no-ff")
   (mype-build:--config)
   ]
  ["Actions"
   ("b" "Build"  mype-build-build)] 
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
  (message "args %s" args))

(mype-build)

;; (test-function)
