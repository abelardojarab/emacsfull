;;; setup-windows.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2014, 2015, 2016  abelardo.jara-berrocal

;; Author: Abelardo Jara-Berrocal <abelardojara@Abelardos-MacBook-Pro.local>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

;; Manage popup windows
(use-package popwin
  :defer t
  :commands popwin-mode
  :load-path (lambda () (expand-file-name "popwin/" user-emacs-directory))
  :config (progn
            (defvar popwin:special-display-config-backup popwin:special-display-config)
            (setq display-buffer-function 'popwin:display-buffer)

            ;; basic
            (push '("*Help*" :stick t :noselect t) popwin:special-display-config)
            (push '("*Cedet Global*" :stick t :noselect t) popwin:special-display-config)

            ;; magit
            (push '("*magit-process*" :stick t) popwin:special-display-config)

            ;; dictionaly
            (push '("*dict*" :stick t) popwin:special-display-config)
            (push '("*sdic*" :stick t) popwin:special-display-config)

            ;; Elisp
            (push '("*ielm*" :stick t) popwin:special-display-config)
            (push '("*eshell pop*" :stick t) popwin:special-display-config)

            ;; python
            (push '("*Python*"   :stick t) popwin:special-display-config)
            (push '("*Python Help*" :stick t :height 20) popwin:special-display-config)
            (push '("*jedi:doc*" :stick t :noselect t) popwin:special-display-config)

            ;; ecb
            (push '("*ECB History*" :position left :width 0.3 :stick t)
                  popwin:special-display-config)
            (push '("*ECB Methods*" :position left :width 0.3 :stick t)
                  popwin:special-display-config)
            (push '("*ECB Directories*" :position right :width 0.3 :stick t)
                  popwin:special-display-config)

            ;; sgit
            (push '("*sgit*" :position right :width 0.5 :stick t)
                  popwin:special-display-config)

            ;; git-gutter
            (push '("*git-gutter:diff*" :width 0.5 :stick t)
                  popwin:special-display-config)

            ;; es-results-mode
            (push '(es-result-mode :stick t :width 0.5)
                  popwin:special-display-config)

            ;; direx
            (push '(direx:direx-mode :position left :width 40 :dedicated t)
                  popwin:special-display-config)

            (push '("*Occur*" :stick t) popwin:special-display-config)

            ;; compilation
            (push '("*compilation*" :stick t :height 30)
                  popwin:special-display-config)

            ;; org-mode
            (push '("*Org tags*" :stick t :height 30)
                  popwin:special-display-config)

            ;; Completions
            (push '("*Completions*" :stick t :noselect t) popwin:special-display-config)

            ;; ggtags
            (push '("*ggtags-global*" :stick t :noselect t :height 30) popwin:special-display-config)

            ;; async shell commands
            (push '("*Async Shell Command*" :stick t) popwin:special-display-config)

            ;; helm
            (push '("^\*helm .+\*$" :regexp t) popwin:special-display-config)
            (push '("^\*helm-.+\*$" :regexp t) popwin:special-display-config)

            ;; popwin conflicts with ecb
            (popwin-mode -1)))

;; Window purpose
(use-package window-purpose
  :load-path (lambda () (expand-file-name "window-purpose/" user-emacs-directory))
  :after helm
  :init (progn
          ;; Prefer helm
          (setq purpose-preferred-prompt 'helm)

          ;; overriding `purpose-mode-map' with empty keymap, so it doesn't conflict
          ;; with original `C-x C-f', `C-x b', etc. and `semantic' key bindings. must
          ;; be done before `window-purpose' is loaded
          (setq purpose-mode-map (make-sparse-keymap)))
  :config (progn
            (setq purpose-user-name-purposes
                  '(("*ag*"               . search)))

            (setq purpose-user-regexp-purposes
                  '(("^\\*elfeed"                  . admin)
                    ("^\\*Python Completions"      . minibuf)
                    ))

            (setq purpose-user-mode-purposes
                  '((eshell-mode          . terminal)

                    (python-mode          . py)
                    (inferior-python-mode . py-repl)

                    (circe-chat-mode      . comm)
                    (circe-query-mode     . comm)
                    (circe-lagmon-mode    . comm)
                    (circe-server-mode    . comm)

                    (ess-mode             . edit)
                    (gitconfig-mode       . edit)
                    (inferior-ess-mode    . interactive)

                    (mu4e-main-mode       . admin)
                    (mu4e-view-mode       . admin)
                    (mu4e-about-mode      . admin)
                    (mu4e-headers-mode    . admin)
                    (mu4e-compose-mode    . edit)

                    (pdf-view-mode        . view)
                    (doc-view-mode        . view)))

            ;; Extra configuration
            (require 'window-purpose-x)

            ;; Single window magit
            (purpose-x-magit-single-on)

            ;; Enable purpose compatibility
            ;; (purpose-x-popwin-setup)

            ;; when killing a purpose-dedicated buffer that is displayed in a window,
            ;; ensure that the buffer is replaced by a buffer with the same purpose
            ;; (or the window deleted, if no such buffer)
            (purpose-x-kill-setup)

            ;; Prefer helm
            (setq purpose-preferred-prompt 'helm)

            ;; Load user preferences
            (purpose-compile-user-configuration)
            (purpose-mode)))

;; Helm interface to purpose
(use-package helm-purpose
  :after (helm window-purpose)
  :commands (helm-purpose-switch-buffer-with-purpose helm-purpose-switch-buffer-with-some-purpose)
  :load-path (lambda () (expand-file-name "helm-purpose/" user-emacs-directory)))

;; Resize windows
(use-package resize-window
  :defer t
  :commands resize-window
  :load-path (lambda () (expand-file-name "resize-window/" user-emacs-directory)))

;; Perspective
(use-package perspective
  :defer t
  :commands persp-mode
  :load-path (lambda () (expand-file-name "perspective/" user-emacs-directory))
  :config (persp-mode))

;; Switch window
(use-package switch-window
  :defer t
  :if (display-graphic-p)
  :commands switch-window
  :load-path (lambda () (expand-file-name "switch-window/" user-emacs-directory)))

;; ace-window for switching windows, but we only call it as a subroutine from a hydra
(use-package ace-window
  :bind (:map ctl-x-map
              ("o" . ace-window))
  :load-path (lambda () (expand-file-name "ace-window/" user-emacs-directory))
  :config (progn
            ;; Customize font on ace-window leading char
            ;; http://oremacs.com/2015/02/27/ace-window-leading-char/
            (if (display-graphic-p)
                (custom-set-faces
                 '(aw-leading-char-face
                   ((t (:inherit ace-jump-face-foreground :height 3.0))))))

            (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l)
                  aw-dispatch-always nil
                  aw-dispatch-alist
                  '((?x aw-delete-window     "Ace - Delete Window")
                    (?c aw-swap-window       "Ace - Swap Window")
                    (?n aw-flip-window)
                    (?v aw-split-window-vert "Ace - Split Vert Window")
                    (?h aw-split-window-horz "Ace - Split Horz Window")
                    (?g delete-other-windows "Ace - Maximize Window")
                    (?b balance-windows)
                    (?u winner-undo)
                    (?r winner-redo)))))

(provide 'setup-windows)
;;; setup-windows.el ends here
