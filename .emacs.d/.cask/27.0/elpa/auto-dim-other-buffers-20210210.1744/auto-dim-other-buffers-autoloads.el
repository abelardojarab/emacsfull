;;; auto-dim-other-buffers-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "auto-dim-other-buffers" "auto-dim-other-buffers.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from auto-dim-other-buffers.el

(defvar auto-dim-other-buffers-mode nil "\
Non-nil if Auto-Dim-Other-Buffers mode is enabled.
See the `auto-dim-other-buffers-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `auto-dim-other-buffers-mode'.")

(custom-autoload 'auto-dim-other-buffers-mode "auto-dim-other-buffers" nil)

(autoload 'auto-dim-other-buffers-mode "auto-dim-other-buffers" "\
Visually makes windows without focus less prominent.

If called interactively, enable Auto-Dim-Other-Buffers mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

Windows without input focus are made to look less prominent by
applying ‘auto-dim-other-buffers-face’ to them.  With many
windows in a frame, the idea is that this mode helps recognise
which is the selected window by providing a non-intrusive but
still noticeable visual indicator.

Note that despite it’s name, since Emacs 27 this mode operates
on *windows* rather than buffers.  In older versions of Emacs, if
a buffer was displayed in multiple windows, none of them would be
dimmed even though at most one could have focus.  This historic
behaviour is where the mode gets its name from.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "auto-dim-other-buffers" '("adob--" "auto-dim-other-buffers-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; auto-dim-other-buffers-autoloads.el ends here
