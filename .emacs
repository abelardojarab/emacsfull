;; -*-mode: Emacs-Lisp; -*-
;; Copyright (C) 1996-2015 Abelardo Jara-Berrocal
;; URL: http://pintucoperu.wordpress.com
;; This file is free software licensed under the terms of the
;; GNU General Public License, version 3 or later.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq debug-on-error t)

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/setup")
(add-to-list 'load-path "~/.emacs.d/elp")
(add-to-list 'load-path "~/.emacs.d/pkg-info")
(add-to-list 'load-path "~/.emacs.d/use-package")
(add-to-list 'load-path "~/.emacs.d/s")
(add-to-list 'load-path "~/.emacs.d/f")
(add-to-list 'load-path "~/.emacs.d/dash")
(add-to-list 'load-path "~/.emacs.d/fringe-helper")
(add-to-list 'load-path "~/.emacs.d/tabbar")

;; CEDET
(add-to-list 'load-path "~/.emacs.d/cedet")
(add-to-list 'load-path "~/projects/cedet/contrib")
(require 'cedet-remove-builtin)
(setq byte-compile-warnings nil)
(load-file "~/.emacs.d/cedet/cedet-devel-load.el")
(load-file "~/.emacs.d/cedet/contrib/cedet-contrib-load.el")
(global-ede-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "96ec5305ec9f275f61c25341363081df286d616a27a69904a35c9309cfa0fe1b" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "fb4bf07618eab33c89d72ddc238d3c30918a501cf7f086f2edf8f4edba9bd59f" default)))
 '(ecb-display-image-icons-for-semantic-tags t)
 '(ecb-grep-find-function (quote if))
 '(ecb-grep-recursive-function (quote rgrep))
 '(ecb-highlight-tag-with-point (quote highlight-scroll))
 '(ecb-kill-buffer-clears-history (quote auto))
 '(ecb-layout-name "leftright-sa-m")
 '(ecb-methods-menu-sorter (lambda (entries) (let ((sorted (copy-list entries))) (sort sorted (quote string-lessp)))))
 '(ecb-options-version "2.40")
 '(ecb-prescan-directories-for-emptyness t)
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-process-non-semantic-files t)
 '(ecb-redraw-layout-quickly t)
 '(ecb-source-path (quote (("/" "/"))))
 '(ecb-sources-perform-read-only-check t)
 '(ecb-sources-sort-method (quote extension))
 '(ecb-tree-buffer-style (quote image))
 '(ecb-use-speedbar-instead-native-tree-buffer nil)
 '(ecb-vc-enable-support t)
 '(ede-locate-setup-options (quote (ede-locate-global ede-locate-locate)))
 '(initial-scratch-message ";; scratch buffer created -- start typing...")
 '(safe-local-variable-values (quote ((encoding . utf-8-unix))))
 '(semantic-self-insert-show-completion-function (lambda nil (semantic-ia-complete-symbol-menu (point)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(jedi:highlight-function-argument ((t (:inherit eldoc-highlight-function-argument))))
 '(org-done ((t (:foreground "PaleGreen" :weight normal :strike-through t))))
 '(org-headline-done ((((class color) (min-colors 16) (background dark)) (:foreground "LightSalmon" :strike-through t)))))

;; Setup general
(require 'setup-general)

;; Setup appearance
(require 'setup-appearance)

;; Setup Cedet
(require 'setup-cedet)

;; cl-lib
(require 'cl-lib)
(defun cl--set-getf (plist tag val)
  (let ((p plist))
    (while (and p (not (eq (car p) tag))) (setq p (cdr (cdr p))))
    (if p (progn (setcar (cdr p) val) plist) (list* tag val plist))))

;; Setup Org and LaTeX
(require 'setup-org)

;; Setup regular expressions
(require 'setup-regexp)

;; Setup Etags and GTAGS
(require 'setup-tags)

;; Setup Spelling
(require 'setup-spell)

;; Setup Flycheck
(require 'setup-flycheck)

;; Setup compile
(require 'setup-compile)

;; Setup Ido and Flex
(require 'setup-ido)

;; Setup Autopair
(require 'setup-autopair)

;; Setup Eldoc
(require 'setup-eldoc)

;; Setup Yasnippet
(require 'setup-yasnippet)

;; Setup Auto-Complete
(require 'setup-auto-complete)

;; Setup Hideshow
(require 'setup-hideshow)

;; Setup markdown and Yaml
(require 'setup-markdown)

;; Setup Python
(require 'setup-python)

;; Setup Javascript mode
(require 'setup-js2-mode)

;; Setup C# mode
(require 'setup-csharp)

;; Setup Lisp mode
(require 'setup-lisp)

;; Setup VHDL/Verilog mode
(require 'setup-vhdl)

;; Setup bison/yacc/lex
(require 'setup-bison)

;; Setup bookmarks
(require 'setup-bookmarks)

;; Setup versioning control
(require 'setup-versioning)

;; Setup modeline and Smex
(require 'setup-modeline)

;; Setup recent
(require 'setup-recentf)

;; Setup project support
(require 'setup-project)

;; Setup tabbar
(require 'setup-tabbar)

;; Setup utilities
(require 'setup-utilities)

;; Setup elnode
(require 'setup-elnode)

;; Setup eshell
(require 'setup-eshell)

;; Setup ECB
(require 'setup-ecb)

;; Setup keys
(require 'setup-keys)

;; Setup gnus and Newsticker - requires Internet
(require 'setup-gnus)

;; Setup server
(unless (string-equal system-type "windows-nt")
  (require 'setup-server))

(setq debug-on-error nil)
