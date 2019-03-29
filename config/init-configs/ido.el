; ido
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)

;;M-x mode
;; (global-set-key
;;  "\M-x"
;;  (lambda ()
;;    (interactive)
;;    (call-interactively
;;     (intern
;;      (ido-completing-read
;;       "M-x "
;;       (all-completions "" obarray 'commandp))))))


;If you use IDO and want to have Sunrise instead of plain Dired used, then append the following snippet to your .emacs file:
(defun ido-sunrise ()
  "Call `sunrise' the ido way.
    The directory is selected interactively by typing a substring.
    For details on keybindings, see `ido-find-file'."
  (interactive)
  (let ((ido-report-no-match nil)
        (ido-auto-merge-work-directories-length -1))
    (ido-file-internal 'sr-dired 'sr-dired nil "Sunrise: " 'dir)))

(define-key (cdr (assoc 'ido-mode minor-mode-map-alist)) [remap dired] 'ido-sunrise)
;(setq sr-listing-switches " --group-directories-first -al")
;(setq sr-listing-switches " -al ")
