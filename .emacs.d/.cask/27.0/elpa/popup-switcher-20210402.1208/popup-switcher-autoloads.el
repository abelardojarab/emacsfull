;;; popup-switcher-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "popup-switcher" "popup-switcher.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from popup-switcher.el

(autoload 'psw-switch-buffer "popup-switcher" "\
Show buffers list menu to switch buffer.
If ARG show only buffers with files and without * in the beginning and end of
the buffer name.

\(fn &optional ARG)" t nil)

(autoload 'psw-switch-recentf "popup-switcher" nil t nil)

(autoload 'psw-switch-projectile-files "popup-switcher" nil t nil)

(autoload 'psw-switch-projectile-projects "popup-switcher" nil t nil)

(autoload 'psw-navigate-files "popup-switcher" "\


\(fn &optional START-PATH)" t nil)

(autoload 'psw-switch-function "popup-switcher" nil t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "popup-switcher" '("psw-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; popup-switcher-autoloads.el ends here
