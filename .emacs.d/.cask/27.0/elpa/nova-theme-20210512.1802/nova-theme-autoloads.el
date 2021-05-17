;;; nova-theme-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "nova-theme" "nova-theme.el" (0 0 0 0))
;;; Generated autoloads from nova-theme.el

(autoload 'nova--build-face "nova-theme" "\
Internal helper to turn FACE into proper face spec.

\(fn FACE)" nil nil)

(autoload 'nova-darken "nova-theme" "\
Darken given rgb string COLOR by ALPHA (0-1).

\(fn COLOR ALPHA)" nil nil)

(autoload 'nova-with-colors "nova-theme" "\
Macro to make color variables available to BODY.

\(fn &rest BODY)" nil t)

(function-put 'nova-with-colors 'lisp-indent-function 'defun)

(autoload 'nova-blend "nova-theme" "\
Combine A C1 with (1-a) C2.

\(fn C1 C2 A)" nil nil)

(autoload 'nova-lighten "nova-theme" "\
Lighten given rgb string COLOR by ALPHA (0-1).

\(fn COLOR ALPHA)" nil nil)

(when (and load-file-name (boundp 'custom-theme-load-path)) (add-to-list 'custom-theme-load-path (file-name-directory load-file-name)))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "nova-theme" '("nova")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; nova-theme-autoloads.el ends here
