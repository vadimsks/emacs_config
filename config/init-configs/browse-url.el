(require 'browse-url)

;; use google chrome web browser
(setq browse-url-browser-function (quote browse-url-generic))
(setq browse-url-generic-program "/usr/bin/google-chrome")

;; use conkeror as a default web browser
;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "/usr/bin/conkeror")


