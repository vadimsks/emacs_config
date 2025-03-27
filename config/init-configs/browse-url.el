(require 'browse-url)

;; use google chrome web browser
(setq browse-url-browser-function (quote browse-url-generic))


;; Windows
(setq browse-url-generic-program
      (cond
       ((eq system-type 'windows-nt) "c:/Program Files/Google/Chrome/Application/chrome.exe")
       ((eq system-type 'darwin) "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
       (t "/usr/bin/google-chrome")
       )
      )

;; use conkeror as a default web browser
;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "/usr/bin/conkeror")


