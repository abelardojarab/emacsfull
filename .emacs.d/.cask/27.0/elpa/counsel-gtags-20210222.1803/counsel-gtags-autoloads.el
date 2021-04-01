;;; counsel-gtags-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "counsel-gtags" "counsel-gtags.el" (0 0 0 0))
;;; Generated autoloads from counsel-gtags.el

(autoload 'counsel-gtags-find-definition "counsel-gtags" "\
Search for TAGNAME definition in tag database.
Prompt for TAGNAME if not given.

\(fn TAGNAME)" t nil)

(autoload 'counsel-gtags-find-reference "counsel-gtags" "\
Search for TAGNAME reference in tag database.
Prompt for TAGNAME if not given.

\(fn TAGNAME)" t nil)

(autoload 'counsel-gtags-find-symbol "counsel-gtags" "\
Search for TAGNAME symbol in tag database.
Prompt for TAGNAME if not given.

\(fn TAGNAME)" t nil)

(autoload 'counsel-gtags-find-reference-other-window "counsel-gtags" "\
Search for TAGNAME reference in tag database in other window.
Prompt for TAGNAME if not given.

\(fn TAGNAME)" t nil)

(autoload 'counsel-gtags-find-symbol-other-window "counsel-gtags" "\
Search for TAGNAME symbol in tag database in other window.
Prompt for TAGNAME if not given.

\(fn TAGNAME)" t nil)

(autoload 'counsel-gtags-find-file "counsel-gtags" "\
Search/narrow for FILENAME among tagged files.

\(fn &optional FILENAME)" t nil)

(autoload 'counsel-gtags-go-backward "counsel-gtags" "\
Go to previous position in context stack." t nil)

(autoload 'counsel-gtags-go-forward "counsel-gtags" "\
Go to next position in context stack." t nil)

(autoload 'counsel-gtags-create-tags "counsel-gtags" "\
Create tag database in ROOTDIR.
LABEL is passed as the value for the environment variable GTAGSLABEL.
Prompt for ROOTDIR and LABEL if not given.  This command is asynchronous.

\(fn ROOTDIR LABEL)" t nil)

(autoload 'counsel-gtags-update-tags "counsel-gtags" "\
Update tag database for current file.
Changes in other files are ignored.  With a prefix argument, update
tags for all files.  With two prefix arguments, generate new tag
database in prompted directory." t nil)

(autoload 'counsel-gtags-mode "counsel-gtags" "\
Minor mode of counsel-gtags.
  If `counsel-gtags-update-tags' is non-nil, the tag files are updated
  after saving buffer.

If called interactively, enable Counsel-Gtags mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "counsel-gtags" '("counsel-gtags-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; counsel-gtags-autoloads.el ends here
