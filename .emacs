;; -*-mode: Emacs-Lisp; -*-
;; Copyright (C) 1996-2016 Abelardo Jara-Berrocal
;; URL: http://pintucoperu.wordpress.com
;; This file is free software licensed under the terms of the
;; GNU General Public License, version 3 or later.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq debug-on-quit t)
(setq debug-on-error t)
(defconst debian-emacs-flavor 'emacs24
  "A symbol representing the particular debian flavor of emacs running.
 Something like 'emacs20, 'xemacs20, etc.")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/dadams")
(add-to-list 'load-path "~/.emacs.d/setup")
(add-to-list 'load-path "~/.emacs.d/use-package")

;; Setup package
(require 'setup-package)

;; Setup functions
(require 'setup-functions)

;; CEDET
(add-to-list 'load-path "~/.emacs.d/cedet")
(add-to-list 'load-path "~/.emacs/cedet/contrib")
(require 'cedet-remove-builtin)
(setq byte-compile-warnings nil)
(load-file "~/.emacs.d/cedet/cedet-devel-load.el")
(load-file "~/.emacs.d/cedet/contrib/cedet-contrib-load.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e"
     "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa"
     "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e"
     "96ec5305ec9f275f61c25341363081df286d616a27a69904a35c9309cfa0fe1b"
     "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f"
     "fb4bf07618eab33c89d72ddc238d3c30918a501cf7f086f2edf8f4edba9bd59f"
     default)))
 '(ecb-options-version "2.40")
 '(ede-locate-setup-options (quote (ede-locate-global ede-locate-locate)))
 '(ede-project-directories (quote ("~/workspace"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(jedi:highlight-function-argument ((t (:inherit eldoc-highlight-function-argument)))))

;; Setup environment
(require 'setup-environment)

;; Setup general
(require 'setup-general)

;; Setup tramp
(require 'setup-tramp)

;; Setup appearance
(require 'setup-appearance)

;; Setup fonts
(require 'setup-fonts)

;; Setup cursor
(require 'setup-cursor)

;; Setup themes
(require 'setup-themes)

;; Setup Ido (optional, disabled GUI for open file, caused crash too?)
(require 'setup-ido)

;; Setup CEDET
(require 'setup-cedet)

;; Setup Org
(require 'setup-org)

;; Setup tabbar (optional)
(require 'setup-tabbar)

;; Setup smex
(require 'setup-smex)

;; Setup Org (babel support)
(require 'setup-org-babel)

;; Setup Org (image supporg)
(require 'setup-org-image)

;; Setup Org (latex support)
(require 'setup-org-latex)

;; Setup Org (html support)
(require 'setup-org-html)

;; Setup pandoc
(require 'setup-pandoc)

;; Setup web support
(require 'setup-web)

;; Setup tags (optional)
(require 'setup-tags)

;; Setup spelling (optional)
(require 'setup-spell)

;; Setup Flycheck
(require 'setup-flycheck)

;; Setup compile
(require 'setup-compile)

;; Setup Autopair
(require 'setup-autopair)

;; Setup Yasnippet
(require 'setup-yasnippet)

;; Setup Auto-Insert
(require 'setup-auto-insert)

;; Setup Auto-Complete
(require 'setup-auto-complete)

;; Setup bookmarks
(require 'setup-bookmarks)

;; Setup recentf (causes crash?)
(require 'setup-recentf)

;; Setup dash
(require 'setup-dash)

;; Setup versioning (optional)
(require 'setup-versioning)

;; Setup Lisp mode (cause crash)
(require 'setup-lisp)

;; Setup Python
(require 'setup-python)

;; Setup Python plugins (e.g. Jedi)
(require 'setup-python-plugins)

;; Setup markdown and Yaml
(require 'setup-markdown)

;; Setup Javascript
(require 'setup-js2)

;; Setup VHDL/Verilog mode
(require 'setup-vhdl)

;; Setup VHDL/Verilog mode
(require 'setup-spice)

;; Setup bison/yacc/lex
(require 'setup-bison)

;; Setup R/ess
(require 'setup-ess)

;; Setup polymode
(require 'setup-polymode)

;; Setup shell
(require 'setup-eshell)

;; Setup hideshow
(require 'setup-hideshow)

;; Setup imenu
(require 'setup-imenu)

;; Setup helm
(require 'setup-helm)

;; Setup helm plugin
(require 'setup-helm-plugins)

;; Setup post
(require 'setup-post)

;; Setup ECB
(require 'setup-ecb)

;; Setup keys
(require 'setup-keys)

;; Setup server
(require 'setup-server)

(setq debug-on-quit nil)
(setq debug-on-error nil)
