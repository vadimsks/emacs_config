;; sunrise
(require 'sunrise-commander)

(add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))
(global-set-key [f2] 'sunrise)
(global-set-key [f3] 'sunrise-cd)

(define-key sr-mode-map "\C-ct"       'sr-term-cd)
(define-key sr-mode-map "\C-cT"       'sr-term)


(defun my-sr-bookmark-handler (&optional bookmark)
  "My handler for sunrise bookmarks."
  (or sr-running (sunrise))
  (let* ((dirs (cdr (assq 'sr-directories (cdr bookmark))))
         (dir-1 (car dirs)))
    (if (file-directory-p dir-1)
        (sr-save-aspect (dired dir-1) (sr-bookmark-jump)) ) ))


(defun my-sr-checkpoint-save (&optional _arg)
  "Create a new checkpoint bookmark to save the location of both panes."
  (interactive "P")
  (message "my-sr-checkpoint-save _arg=%s" _arg )
  (if _arg
      (sr-checkpoint-save _arg)
    (progn
      (sr-save-directories)
      (let ((bookmark-make-record-function 'my-sr-make-checkpoint-record))
        (call-interactively 'bookmark-set)))))

(defun my-sr-make-checkpoint-record ()
  "Generate a the bookmark record for a new sr bookmark."
  `(
    (sr-directories . (,sr-this-directory))
    (filename . ,(format "Sunrise - %s"
                         sr-this-directory))
    (handler . my-sr-bookmark-handler)))

;; (defun my-sr-checkpoint-restore (&optional _arg)
;;   "Call `bookmark-jump' interactively."
;;   (interactive "p")
;;   (call-interactively 'bookmark-jump)
;;   (sr-history-push default-directory)
;;   (sr-in-other (sr-history-push default-directory)))

(define-key sr-mode-map [(control >)]         'my-sr-checkpoint-save)
;;(define-key sr-mode-map [(control .)]         'my-sr-checkpoint-restore)


;; TODO - override bookmark-alist in the (defun bookmark-completing-read (prompt &optional default)...)

;; bookmark shortcuts
;; C-x r l - bookmark-list
;; C-x r b - bookmark-jump
