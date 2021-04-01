;;; vimish-fold-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "vimish-fold" "vimish-fold.el" (0 0 0 0))
;;; Generated autoloads from vimish-fold.el

(autoload 'vimish-fold "vimish-fold" "\
Fold active region staring at BEG, ending at END.

\(fn BEG END)" t nil)

(autoload 'vimish-fold-unfold "vimish-fold" "\
Delete all `vimish-fold--folded' overlays at point." t nil)

(autoload 'vimish-fold-refold "vimish-fold" "\
Refold unfolded fold at point." t nil)

(autoload 'vimish-fold-delete "vimish-fold" "\
Delete fold at point." t nil)

(autoload 'vimish-fold-unfold-all "vimish-fold" "\
Unfold all folds in current buffer." t nil)

(autoload 'vimish-fold-refold-all "vimish-fold" "\
Refold all closed folds in current buffer." t nil)

(autoload 'vimish-fold-delete-all "vimish-fold" "\
Delete all folds in current buffer." t nil)

(autoload 'vimish-fold-toggle "vimish-fold" "\
Toggle fold at point." t nil)

(autoload 'vimish-fold-toggle-all "vimish-fold" "\
Toggle all folds in current buffer." t nil)

(autoload 'vimish-fold-avy "vimish-fold" "\
Fold region of text between point and line selected with avy.

This feature needs `avy' package." t nil)

(autoload 'vimish-fold-next-fold "vimish-fold" "\
Jump to next folded region in current buffer." t nil)

(autoload 'vimish-fold-previous-fold "vimish-fold" "\
Jump to previous folded region in current buffer." t nil)

(autoload 'vimish-fold-from-marks "vimish-fold" "\
Create folds from folding symbols.

Mark strings are controlled by `vimish-fold-marks' customize variable." t nil)

(autoload 'vimish-fold-mode "vimish-fold" "\
Toggle `vimish-fold-mode' minor mode.

With a prefix argument ARG, enable `vimish-fold-mode' mode if ARG
is positive, and disable it otherwise.  If called from Lisp,
enable the mode if ARG is omitted or NIL, and toggle it if ARG is
`toggle'.

This minor mode sets hooks so when you `find-file' it calls
`vimish-fold--restore-folds' and when you kill a file it calls
`vimish-fold--save-folds'.

For globalized version of this mode see `vimish-fold-global-mode'.

\(fn &optional ARG)" t nil)

(put 'vimish-fold-global-mode 'globalized-minor-mode t)

(defvar vimish-fold-global-mode nil "\
Non-nil if Vimish-Fold-Global mode is enabled.
See the `vimish-fold-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `vimish-fold-global-mode'.")

(custom-autoload 'vimish-fold-global-mode "vimish-fold" nil)

(autoload 'vimish-fold-global-mode "vimish-fold" "\
Toggle Vimish-Fold mode in all buffers.
With prefix ARG, enable Vimish-Fold-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Vimish-Fold mode is enabled in all buffers where
`vimish-fold-mode' would do it.
See `vimish-fold-mode' for more information on Vimish-Fold mode.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "vimish-fold" '("vimish-fold-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vimish-fold-autoloads.el ends here
