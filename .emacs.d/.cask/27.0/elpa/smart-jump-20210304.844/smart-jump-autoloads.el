;;; smart-jump-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "smart-jump" "smart-jump.el" (0 0 0 0))
;;; Generated autoloads from smart-jump.el

(autoload 'smart-jump-setup-default-registers "smart-jump" "\
Register a default set of modes for `smart-jump'." t nil)

(autoload 'smart-jump-diag "smart-jump" "\
Pop a buffer with information about `smart-jump'." t nil)

(autoload 'smart-jump-go "smart-jump" "\
Go to the function/variable declartion for thing at point.

SMART-LIST will be set (or nil) if this is a continuation of a previous jump.

CONTINUE will be non nil if this is a continuation of a previous jump.

\(fn &optional SMART-LIST CONTINUE)" t nil)

(autoload 'smart-jump-back "smart-jump" "\
Jump back to where the last jump was done." t nil)

(autoload 'smart-jump-references "smart-jump" "\
Find references with fallback.
Optional argument SMART-LIST This will be non-nil of continuation of previous
call to `smart-jump-references'.

CONTINUE will be set if this is a continuation of a previous call to
`smart-jump-references'.

\(fn &optional SMART-LIST CONTINUE)" t nil)

(autoload 'smart-jump-register "smart-jump" "\
Register mode for use with `smart-jump'.

MODES: Can be a mode '(c-mode), a list of modes '(c-mode c++-mode), a
cons pair where the car of the pair is a mode and the cdr of the pair is
a hook '(c-mode . c-mode-hook) or a list containing modes or pairs.
'(c-mode
  (java-mode . java-mode-hook))

If MODES contains a pair, the hook will be used to bootstrap `smart-jump' for
that mode. If MODES contain just the mode, the hook will be derived from the
mode's name.

JUMP-FN: The function to call interactively to trigger go to definition.

POP-FN: The reverse of jump-function.

REFS-FN: Function used for finding references.

BEFORE-JUMP-FN: Function called before JUMP-FN is called.

SHOULD-JUMP: Either t, nil or a function that determines if jump-fn
should be triggered.

HEURISTIC: Either a recognized symbol or a custom function that will be
ran after jump-function is triggered.

REFS-HEURISTIC: Like HEURISTIC, but for use with REFS-FN.

ASYNC: Whether or not to run the heuristic function after a certain time.
If this is a number, run the heuristic function after that many ms.

ORDER: The weight applied to each JUMP-FN. This is used to determine which
fallback strategy is used first. Lower numbers give more precedence.

\(fn &key MODES (JUMP-FN \\='xref-find-definitions) (POP-FN \\='xref-pop-marker-stack) (REFS-FN \\='xref-find-references) (BEFORE-JUMP-FN nil) (SHOULD-JUMP t) (HEURISTIC \\='error) (REFS-HEURISTIC heuristic) (ASYNC nil) (ORDER smart-jump-default-order-weight))" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump" '("smart-jump-")))

;;;***

;;;### (autoloads nil "smart-jump-cc-mode" "smart-jump-cc-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-cc-mode.el

(autoload 'smart-jump-cc-mode-register "smart-jump-cc-mode" "\
Register `cc-mode' for `smart-jump'." nil nil)

;;;***

;;;### (autoloads nil "smart-jump-clojure-mode" "smart-jump-clojure-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-clojure-mode.el

(autoload 'smart-jump-clojure-mode-register "smart-jump-clojure-mode" "\
Register `clojure-mode' for `smart-jump'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-clojure-mode" '("smart-jump-clojure-cider-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-csharp-mode" "smart-jump-csharp-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-csharp-mode.el

(autoload 'smart-jump-csharp-mode-register "smart-jump-csharp-mode" "\
Register `smart-jump' for `csharp-mode'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-csharp-mode" '("smart-jump-csharp-omnisharp-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-elisp-mode" "smart-jump-elisp-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-elisp-mode.el

(autoload 'smart-jump-elisp-mode-register "smart-jump-elisp-mode" "\
Register `smart-jump' for `elisp-mode'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-elisp-mode" '("smart-jump-elisp-slime-nav-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-elixir-mode" "smart-jump-elixir-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-elixir-mode.el

(autoload 'smart-jump-elixir-mode-register "smart-jump-elixir-mode" "\
Register `smart-jump' for `elixir-mode'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-elixir-mode" '("smart-jump-elixir-alchemist-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-go-mode" "smart-jump-go-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-go-mode.el

(autoload 'smart-jump-go-mode-register "smart-jump-go-mode" "\
Register `go-mode' for `smart-jump'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-go-mode" '("smart-jump-go-mode-go-guru-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-lisp-mode" "smart-jump-lisp-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-lisp-mode.el

(autoload 'smart-jump-lisp-mode-register "smart-jump-lisp-mode" "\
Register `smart-jump' for `lisp-mode'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-lisp-mode" '("smart-jump-lisp-sl")))

;;;***

;;;### (autoloads nil "smart-jump-lispy" "smart-jump-lispy.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from smart-jump-lispy.el

(autoload 'smart-jump-lispy-register "smart-jump-lispy" "\
Register `smart-jump' for `lispy'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-lispy" '("smart-jump-lispy-order")))

;;;***

;;;### (autoloads nil "smart-jump-python" "smart-jump-python.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-python.el

(autoload 'smart-jump-python-register "smart-jump-python" "\
Register `smart-jump' for `python'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-python" '("smart-jump-python-")))

;;;***

;;;### (autoloads nil "smart-jump-ruby-mode" "smart-jump-ruby-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-ruby-mode.el

(autoload 'smart-jump-ruby-mode-register "smart-jump-ruby-mode" "\
Register `smart-jump' for `ruby-mode'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-ruby-mode" '("smart-jump-ruby-robe-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-rust-mode" "smart-jump-rust-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-rust-mode.el

(autoload 'smart-jump-rust-mode-register "smart-jump-rust-mode" "\
Register `smart-jump' for `rust-mode'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-rust-mode" '("smart-jump-rust-mode-racer-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-scheme" "smart-jump-scheme.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-scheme.el

(autoload 'smart-jump-scheme-register "smart-jump-scheme" "\
Register `smart-jump' for `scheme'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-scheme" '("smart-jump-scheme-geiser-available-p")))

;;;***

;;;### (autoloads nil "smart-jump-typescript-mode" "smart-jump-typescript-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from smart-jump-typescript-mode.el

(autoload 'smart-jump-typescript-mode-register "smart-jump-typescript-mode" "\
Register `smart-jump' for `typescript-mode'.

\(fn &optional MODE)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "smart-jump-typescript-mode" '("smart-jump-typescript-")))

;;;***

;;;### (autoloads nil nil ("smart-jump-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; smart-jump-autoloads.el ends here
