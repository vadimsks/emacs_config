
;; Remap 'help' key to 'insert'
;;(define-key key-translation-map [f13] [insert])
;; Remap 'clear' key to 'num-lock'
;;(define-key key-translation-map [clear] [num-lock])

;; [Insert] key generates <help> event on macos.
;; To fix this, [Insert] is remapped to F13 in Wootility.

(add-hook 'term-mode-hook
          (lambda ()
            (define-key term-mode-map (kbd "S-<f13>") 'term-paste)
            (define-key term-raw-map (kbd "S-<f13>") 'term-paste)
            )
          )

