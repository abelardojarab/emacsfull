;;; flycheck-posframe-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "flycheck-posframe" "flycheck-posframe.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flycheck-posframe.el

(autoload 'flycheck-posframe-configure-pretty-defaults "flycheck-posframe" "\
Configure some nicer settings for prettier display." nil nil)

(autoload 'flycheck-posframe-mode "flycheck-posframe" "\
A minor mode to show Flycheck error messages in a posframe.

If called interactively, enable Flycheck-Posframe mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "flycheck-posframe" '("flycheck-posframe-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flycheck-posframe-autoloads.el ends here
