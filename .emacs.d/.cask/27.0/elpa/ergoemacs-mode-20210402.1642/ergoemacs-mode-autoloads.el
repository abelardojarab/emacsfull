;;; ergoemacs-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ergoemacs-advice" "ergoemacs-advice.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from ergoemacs-advice.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-advice" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-command-loop" "ergoemacs-command-loop.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-command-loop.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-command-loop" '("ergoemacs-" "erogemacs-command--echo-timer")))

;;;***

;;;### (autoloads nil "ergoemacs-component" "ergoemacs-component.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-component.el

(autoload 'ergoemacs-ignore-prev-global "ergoemacs-component" "\
Ignore previously defined global keys." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-component" '("describe-ergoemacs-component" "ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-debug" "ergoemacs-debug.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from ergoemacs-debug.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-debug" '("ergoemacs-debug")))

;;;***

;;;### (autoloads nil "ergoemacs-functions" "ergoemacs-functions.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-functions.el

(autoload 'ergoemacs-paste-cycle "ergoemacs-functions" "\
Run `yank-pop' or`yank'.
This is `yank-pop' if `ergoemacs-smart-paste' is nil.
This is `yank' if `ergoemacs-smart-paste' is t.

If `browse-kill-ring' is enabled and the last command is not a
paste, this will start `browse-kill-ring'.

When in `browse-kill-ring-mode', cycle backward through the key ring.
" t nil)

(autoload 'ergoemacs-paste "ergoemacs-functions" "\
Run `yank' or `yank-pop' if this command is repeated.
This is `yank' if `ergoemacs-smart-paste' is nil.
This is `yank-pop' if `ergoemacs-smart-paste' is t and last command is a yank.
This is `browse-kill-ring' if `ergoemacs-smart-paste' equals 'browse-kill-ring and last command is a yank.

When in `browse-kill-ring-mode', cycle forward through the key ring.

This does the same thing in `iseach-mode' using `isearch-yank-pop' and  `isearch-yank-kill'
" t nil)

(autoload 'ergoemacs-unaccent-word "ergoemacs-functions" "\
Move curseur forward NUM (prefix arg) words, removing accents.
Guillemet -> quote, degree -> @, s-zed -> ss, upside-down ?! -> ?!.

\(fn NUM)" t nil)

(autoload 'ergoemacs-unaccent-region "ergoemacs-functions" "\
Replace accented chars between START and END by unaccented chars.
Guillemet -> quote, degree -> @, s-zed -> ss, upside-down ?! -> ?!.
When called from a program, third arg DISPLAY-MSGS non-nil means to
display in-progress messages.

\(fn START END DISPLAY-MSGS)" t nil)

(autoload 'ergoemacs-unaccent-char "ergoemacs-functions" "\
Replace accented char at curser by corresponding unaccented char(s).
Guillemet -> quote, degree -> @, s-zed -> ss, upside-down ?! -> ?!." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-functions" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-key-description" "ergoemacs-key-description.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-key-description.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-key-description" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-layouts" "ergoemacs-layouts.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-layouts.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-layouts" '("describe-ergoemacs-layout" "ergoemacs-layout")))

;;;***

;;;### (autoloads nil "ergoemacs-lib" "ergoemacs-lib.el" (0 0 0 0))
;;; Generated autoloads from ergoemacs-lib.el

(autoload 'ergoemacs-set "ergoemacs-lib" "\
Sets VARIABLE to VALUE without disturbing customize or setq.

If the user changed the value with either `setq' or `customize',
then respect the varaible.

If FORCE is true, set it even if it changed.

Whe changed return t, otherwise return nil.

\(fn VARIABLE VALUE &optional DEFER FORCE)" nil nil)

(autoload 'ergoemacs-save "ergoemacs-lib" "\
Set VARIABLE to VALUE and tell customize it needs to be saved.

\(fn VARIABLE VALUE)" nil nil)

(autoload 'ergoemacs-menu--filter "ergoemacs-lib" "\
Put `ergoemacs-mode' key bindings on menus.

\(fn MENU &optional FN KEYMAP)" nil nil)

(autoload 'ergoemacs-set-layout "ergoemacs-lib" "\
Set `ergoemacs-keyboard-layout' to LAYOUT and reset `ergoemacs-mode'.
The reset is done with `ergoemacs-mode-reset'.

\(fn LAYOUT)" nil nil)

(autoload 'ergoemacs-gen-ahk "ergoemacs-lib" "\
Generates autohotkey for all layouts and themes

\(fn &optional ALL)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-lib" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-macros" "ergoemacs-macros.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from ergoemacs-macros.el

(autoload 'ergoemacs-keymapp "ergoemacs-macros" "\
Error free check of keymap by `keymapp'

\(fn KEYMAP)" nil t)

(autoload 'ergoemacs-sv "ergoemacs-macros" "\
Error free `symbol-value'.
If SYMBOL is void, return nil

\(fn SYMBOL &optional DEFAULT)" nil t)

(autoload 'ergoemacs-theme-component--parse-remaining "ergoemacs-macros" "\
Parse the REMAINING list, and convert:

- `define-key' is converted to
  `ergoemacs-component-struct--define-key' and keymaps are quoted.

- `global-set-key' is converted to
  `ergoemacs-component-struct--define-key' with keymap equal to
  `global-map'.

- `bind-key' is converted to
  `ergoemacs-component-struct--define-key'.

- `global-unset-key' is converted to
  `ergoemacs-component-struct--define-key' with keymap equal to
  `global-map' and function definition is nil.

- `global-reset-key' is converted
  `ergoemacs-component-struct--define-key'

- `setq' and `set' is converted to
  `ergoemacs-component-struct--set'

- `add-hook' and `remove-hook' is converted to
  `ergoemacs-component-struct--set'

- Mode initialization like (delete-selection-mode 1)
  or (delete-selection) is converted to
  `ergoemacs-component-struct--set'

- Allows :version statement expansion to
  `ergoemacs-component-struct--new-version'

- Adds with-hook syntax or (when -hook) or (when -mode) using
  `ergoemacs-component-struct--with-hook'

Since `ergoemacs-mode' tries to distinguish return, escape, and
tab from their ASCII equivalents In the GUI, the following Emacs
keyboard codes are converted to keys that `ergoemacs-mode' can
distinguish from the ASCII equivalents:

- C-i (TAB) is changed to <C-i>

- C-m (RET) is changed to <C-m>

- C-[ (ESC)  is changed to <C-]>

\(fn REMAINING)" nil nil)

(autoload 'ergoemacs-component "ergoemacs-macros" "\
A component of an ergoemacs-theme.

This places BODY-AND-PLIST in the `ergoemacs-theme-component'
macro.

\(fn &rest BODY-AND-PLIST)" nil t)

(function-put 'ergoemacs-component 'doc-string-elt '2)

(function-put 'ergoemacs-component 'lisp-indent-function '2)

(autoload 'ergoemacs-theme-component "ergoemacs-macros" "\
A component of an ergoemacs-theme.

This macro parses BODY-AND-PLIST to Emacs code to generate an
`erogemacs-mode' theme component.

This accepts the following keywords:

:bind -- What keys to bind.  This is compatible with use-package
    definitions.  That is it can take a command like:

    :bind (\"C-.\" . ace-jump-mode)

    or list of commands

    :bind ((\"M-o l\" . highlight-lines-matching-regexp)
           (\"M-o r\" . highlight-regexp)
           (\"M-o w\" . highlight-phrase))

    This list of commands can just be a list without the extra
    parentheses for each command:

    :bind (\"M-o l\" . highlight-lines-matching-regexp
           \"M-o r\" . highlight-regexp
           \"M-o w\" . highlight-phrase)


    Note that these keys may change based on keyboard layouts,
    and also these keys can accept special ergoemacs-commands and
    keymaps (unlike use-package).

    When package-name is non-nil, create autoloads for undefined commands.

    Default: nil

:bind-keymap -- A keymap to bind.  Similar to :bind but used for
    keymaps.  This is processed before :bind keywords.  While
    this is necessary for use-package, it is not necessary for
    `ergoemacs-mode'.  However, this keyword is provided for convenience. 

    Default: nil

:bind* -- Keys to bind above minor modes (in
  `ergoemacs-override-keymap').

   Default: nil

:bind-keymap* -- Keymap to bind above minor modes (in
   `ergoemacs-override-keymap').

    Default: nil

:commands -- List of commands to create autoloads for.  This can
    take a command like:

    :commands ace-jump-mode

    Or

    :commands (isearch-moccur isearch-all)

    When :package-name is non-nil, this will create autoloads for
    the commands.

:defer -- Should this package's loading be deferred?
    When using :commands :bind :bind* :bind-keymap :bind-keymap*
   :mode or :interperter, defer is implied.  When :package-name
   is nil, this dosen't do anything.

:demand -- Prevent deferred loading in all cases

:diminish -- Diminish this mode.  It can be of the following forms:

    :diminish t -- Assumes that :package-name is diminshed
    :diminish package-name -- Diminshes package-name
    :diminish (package-name \" New Description\")
    :diminish (package-name \" unicode\" \" str\")

    For more information, see `ergoemacs-component--diminish-on'.

    By default this is nil.

:mode -- Modes to be added to `auto-mode-alist'. This can be a string such as:

\(ergoemacs-package ruby-mode
    :mode \"\\\\.rb\\\\'\")

or a list 

\(ergoemacs-package ruby-mode
    :mode (\"\\\\.rb\\\\'\" . ruby-mode))

or a list of modes:

\(ergoemacs-package ess-site
    :ensure ess
    :mode ((\"\\\\.R\\\\'\" . R.mode)
           (\"\\\\.[Ss][Aa][Ss]\\\\'\" . SAS-mode)))

Borrowed from `use-package'.

:ensure -- If the package should be installed by `package' if not present.

This can be t to install the :package-name symbol.  Otherwise
it can be a list of symbols or single symbol.

:package-name -- Name of package to load.  When non-nil any key
defition to a single command will create an autoload for that
command.

Default: nil

:no-load / :no-require -- Don't load/require the package-name.

:ergoemacs-require -- when non-nil, this ergoemacs-component is
required with `ergoemacs-require'. By default this is disabled

:just-first-keys -- Keys where a fixed amount of the key is based
on variable keyboard placement, then the rest of the key is
based on letter.  For example with the apps component, the
just first keys are defined to be [apps ?h], which means the
\[apps h] will be defined based on finger placement, but the
keys afterward would be based on letter.

By default this is defined as nil, meaning no special keys
like this occur.

:just-first-keys (list [apps ?h] [menu ?h])
Defaults to nil

:variable-modifiers -- Modifiers that are considierd variable.
These modifiers have keys change among various keyboard
layouts.  That is keys are bound based on finger placement
among various keyboard layouts.

Defaults to '(meta)

:variable-prefixes -- Keyboard prefixes that are considiered
variable.  After these keys are pressed, the keyboard layout
dictates the keys.  That is, keys are bound based on finger
placement among various keyboard layouts.

Defaults to '([apps] [menu] [27])

:layout -- Layout that the key bindings are based on.

Defaults to us (QWERTY)

Please do not use the following tags, since they are parsed based
on the definition:

:name -- Component Name

:description -- Component Description

:file -- File where the component was defined.

\(fn &rest BODY-AND-PLIST)" nil t)

(function-put 'ergoemacs-theme-component 'doc-string-elt '2)

(function-put 'ergoemacs-theme-component 'lisp-indent-function '2)

(autoload 'ergoemacs-test-layout "ergoemacs-macros" "\


\(fn &rest KEYS-AND-BODY)" nil t)

(autoload 'ergoemacs-theme "ergoemacs-macros" "\
Define an ergoemacs-theme.

This macro parses BODY-AND-PLIST into an `ergoemacs-mode' theme.

- :components -- list of components that this theme uses.  These
  can't be seen or toggled.

- :optional-on -- list of components that are optional and are on
  by default

- :optional-off -- list of components that are optional and off
  by default

- :options-menu -- Menu options list

- :silent -- If this theme is \"silent\", i.e. doesn't show up in
  the Themes menu.

- :based-on -- what `ergoemacs-mode' theme this is based on.

The rest of the body is an `ergoemacs-theme-component' named
 THEME-NAME-theme.

\(fn &rest BODY-AND-PLIST)" nil t)

(function-put 'ergoemacs-theme 'doc-string-elt '2)

(function-put 'ergoemacs-theme 'lisp-indent-function '2)

(autoload 'ergoemacs-deftheme "ergoemacs-macros" "\
Create theme layout for `ergoemacs-mode' key-bindings.

This is compatibility layer.

- NAME is the theme name.

- DESC is the theme description

- BASED-ON is the base name theme that the new theme is based on.

- DIFFERENCES are the differences from the layout based on the
  functions.  These are based on the following functions:

- `ergoemacs-key' = defines/replaces variable key with function
  by (ergoemacs-key QWERTY-KEY FUNCTION DESCRIPTION ONLY-FIRST)

- `ergoemacs-fixed-key' = defines/replace fixed key with function
   by (ergoemacs-fixed-key KEY FUNCTION DESCRIPTION).

\(fn NAME DESC BASED-ON &rest DIFFERENCES)" nil t)

(function-put 'ergoemacs-deftheme 'lisp-indent-function '1)

(autoload 'ergoemacs-save-buffer-state "ergoemacs-macros" "\
Eval BODY,
then restore the buffer state under the assumption that no significant
modification has been made in BODY.  A change is considered
significant if it affects the buffer text in any way that isn't
completely restored again.  Changes in text properties like `face' or
`syntax-table' are considered insignificant.  This macro allows text
properties to be changed, even in a read-only buffer.

This macro should be placed around all calculations which set
\"insignificant\" text properties in a buffer, even when the buffer is
known to be writeable.  That way, these text properties remain set
even if the user undoes the command which set them.

This macro should ALWAYS be placed around \"temporary\" internal buffer
changes (like adding a newline to calculate a text-property then
deleting it again), so that the user never sees them on his
`buffer-undo-list'.  

However, any user-visible changes to the buffer (like auto-newlines)
must not be within a `ergoemacs-save-buffer-state', since the user then
wouldn't be able to undo them.

The return value is the value of the last form in BODY.

This was stole/modified from `c-save-buffer-state'

\(fn &rest BODY)" nil t)

(autoload 'ergoemacs "ergoemacs-macros" "\
Get/Set keymaps and `ergoemacs-mode' properties

When arg1 can be a property.  The following properties are supported:
- :layout - returns the current (or specified by PROPERTY) keyboard layout.
- :remap - Use `ergoemacs-mode' to remap to an appropriate function.
- :md5 -- returns an md5 of the currently enabled `ergoemacs-mode' options.
- :map-list,  :composed-p, :composed-list, :key-hash :empty-p calls ergoemacs-map-properties-- equivalent functions.

\(fn &rest ARGS)" nil t)

(autoload 'ergoemacs-translation "ergoemacs-macros" "\
Defines an `ergoemacs-mode' translation.

:text -- Text to display while completing this translation
:keymap -- Local Keymap for translation
:keymap-modal -- Modal keymap for overrides.
:modal-always -- If the modal state is always on, regardless of
                 the values of  `ergoemacs-modal-ignored-buffers',
                `ergoemacs-modal-emacs-state-modes' `minibufferp'
The following arguments allow the keyboard presses to be translated:
 - :meta
 - :control
 - :shift
 - :meta-control
 - :meta-shift
 - :control-shift
 - :meta-control-shift
 - :unchorded (no modifiers)

This also creates functions:
- ergoemacs-translate--NAME-universal-argument
- ergoemacs-translate--NAME-digit-argument
- ergoemacs-translate--NAME-negative-argument
- ergoemacs-translate--NAME-modal

\(fn &rest BODY-AND-PLIST)" nil t)

(function-put 'ergoemacs-translation 'doc-string-elt '2)

(function-put 'ergoemacs-translation 'lisp-indent-function '2)

(autoload 'ergoemacs-advice "ergoemacs-macros" "\
Defines an `ergoemacs-mode' advice.

The structure is (ergoemacs-advice function args tags body-and-plist)

When the tag :type equals :replace, the advice replaces the function.

When :type is :replace that replaces a function (like `define-key')

\(fn FUNCTION ARGS &rest BODY-AND-PLIST)" nil t)

(function-put 'ergoemacs-advice 'doc-string-elt '2)

(function-put 'ergoemacs-advice 'lisp-indent-function '2)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-macros" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-map" "ergoemacs-map.el" (0 0 0 0))
;;; Generated autoloads from ergoemacs-map.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-map" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-map-properties" "ergoemacs-map-properties.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-map-properties.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-map-properties" '("ergoemacs-map-properties--")))

;;;***

;;;### (autoloads nil "ergoemacs-mapkeymap" "ergoemacs-mapkeymap.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-mapkeymap.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-mapkeymap" '("ergoemacs-map-")))

;;;***

;;;### (autoloads nil "ergoemacs-mode" "ergoemacs-mode.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from ergoemacs-mode.el

(defvar ergoemacs-mode nil "\
Non-nil if Ergoemacs mode is enabled.
See the `ergoemacs-mode' command
for a description of this minor mode.")

(custom-autoload 'ergoemacs-mode "ergoemacs-mode" nil)

(autoload 'ergoemacs-mode "ergoemacs-mode" "\
Toggle ergoemacs keybinding minor mode.
This minor mode changes your emacs keybinding.

If called interactively, enable Ergoemacs mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

Without argument, toggles the minor mode.
If optional argument is 1, turn it on.
If optional argument is 0, turn it off.

Home page URL `http://ergoemacs.github.io/'

The `execute-extended-command' is now \\[execute-extended-command].

\(fn &optional ARG)" t nil)

(autoload 'ergoemacs-mode-reset "ergoemacs-mode" "\
Reset `ergoemacs-mode' without toggling unnecessary variables." nil nil)

(autoload 'ergoemacs-set-default "ergoemacs-mode" "\
`ergoemacs-mode' equivalent to `set-default'.

Will reload `ergoemacs-mode' after setting the values.

SYMBOL is the symbol to set, NEW-VALUE is it's value.

\(fn SYMBOL NEW-VALUE)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-mode" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-score" "ergoemacs-score.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from ergoemacs-score.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-score" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-test" "ergoemacs-test.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from ergoemacs-test.el

(autoload 'ergoemacs-test "ergoemacs-test" "\
Test ergoemacs issues." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-test" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-theme-engine" "ergoemacs-theme-engine.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-theme-engine.el

(autoload 'ergoemacs-theme-set-version "ergoemacs-theme-engine" "\
Sets the current themes default VERSION.

\(fn VERSION)" nil nil)

(autoload 'ergoemacs-theme-option-off "ergoemacs-theme-engine" "\
Turns OPTION off.
Uses `ergoemacs-theme-option-on'.

\(fn OPTION &optional NO-CUSTOM)" nil nil)

(autoload 'ergoemacs-theme-option-on "ergoemacs-theme-engine" "\
Turns OPTION on.
When OPTION is a list turn on all the options in the list
If OFF is non-nil, turn off the options instead.

\(fn OPTION &optional NO-CUSTOM OFF)" nil nil)

(autoload 'ergoemacs-theme-toggle-option "ergoemacs-theme-engine" "\
Toggle theme OPTION.

\(fn OPTION)" nil nil)

(autoload 'ergoemacs-theme-create-bash "ergoemacs-theme-engine" "\
Create bash ~/.inputrc for use with bash." t nil)

(defalias 'ergoemacs-bash 'ergoemacs-theme-create-bash)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-theme-engine" '("ergoemacs-")))

;;;***

;;;### (autoloads nil "ergoemacs-translate" "ergoemacs-translate.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ergoemacs-translate.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ergoemacs-translate" '("ergoemacs-translate")))

;;;***

;;;### (autoloads nil nil ("ergoemacs-mode-pkg.el" "ergoemacs-themes.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ergoemacs-mode-autoloads.el ends here
