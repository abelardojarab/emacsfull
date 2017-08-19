;;; setup-eshell.el ---                       -*- lexical-binding: t; -*-

;; Copyright (C) 2014, 2015, 2016, 2017  Abelardo Jara-Berrocal

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

(use-package ielm
  :bind (("C-'"  . ielm-repl)
         ("C-0"  . ielm-repl)
         :map ctl-x-map
         (("C-t" . ielm-repl)
          ("z"   . ielm-repl))
         :map ielm-map
         (("C-t" . quit-window)))
  :config (progn
            (defun ielm-repl ()
              (interactive)
              (pop-to-buffer (get-buffer-create "*ielm*"))
              (ielm))

            ;; When using auto-complete
            (when (featurep 'auto-complete)
              (defun ielm-auto-complete ()
                "Enables `auto-complete' support in \\[ielm]."
                (setq ac-sources '(ac-source-functions
                                   ac-source-variables
                                   ac-source-features
                                   ac-source-symbols
                                   ac-source-words-in-same-mode-buffers))
                (add-to-list 'ac-modes 'inferior-emacs-lisp-mode)
                (auto-complete-mode 1))
              (add-hook 'ielm-mode-hook 'ielm-auto-complete))))

(use-package eshell
  :commands (eshell eshell-vertical eshell-horizontal)
  :bind (("C-t"                     . eshell)
         ("C-c C-t"                 . eshell)
         :map ctl-x-map
         ("t"                       . eshell)
         :map eshell-mode-map
         (("C-t"                    . quit-window)
          ("C-c C-t"                . quit-window)
          ([remap eshell-pcomplete] . helm-esh-pcomplete)
          ("M-p"                    . helm-eshell-history)))
  :after helm
  :init  (progn
           ;; Fix lack of eshell-mode-map
           (if (not (boundp 'eshell-mode-map))
               (defvar eshell-mode-map (make-sparse-keymap)))

           ;; First, Emacs doesn't handle less well, so use cat instead for the shell pager:
           (setenv "PAGER" "cat")
           (setq-default eshell-directory-name "~/.emacs.cache/eshell")
           (setq eshell-glob-case-insensitive t
                 eshell-scroll-to-bottom-on-input 'this
                 eshell-buffer-shorthand t
                 eshell-history-size 1024
                 eshell-buffer-shorthand t
                 eshell-cmpl-ignore-case t
                 eshell-cmpl-cycle-completions nil
                 eshell-aliases-file (concat user-emacs-directory ".eshell-aliases")
                 eshell-last-dir-ring-size 512))
  :config (progn
            (add-hook 'eshell-mode-hook '(lambda () (eshell/export "NODE_NO_READLINE=1")))

            ;; Vertical split eshell
            (defun eshell-vertical ()
              "opens up a new shell in the directory associated with the current buffer's file."
              (interactive)
              (let* ((parent (if (buffer-file-name)
                                 (file-name-directory (buffer-file-name))
                               default-directory))
                     (name (car (last (split-string parent "/" t)))))
                (split-window-right)
                (other-window 1)
                (eshell "new")
                (rename-buffer (concat "*eshell: " name "*"))
                (eshell-send-input)))

            ;; Horizontal split eshell
            (defun eshell-horizontal ()
              "opens up a new shell in the directory associated with the current buffer's file."
              (interactive)
              (let* ((parent (if (buffer-file-name)
                                 (file-name-directory (buffer-file-name))
                               default-directory))
                     (name (car (last (split-string parent "/" t)))))
                (split-window-below)
                (other-window 1)
                (eshell "new")
                (rename-buffer (concat "*eshell: " name "*"))
                (eshell-send-input)))))

;; Show fringe status for eshell
(use-package eshell-fringe-status
  :if (display-graphic-p)
  :load-path (lambda () (expand-file-name "eshell-fringe-status/" user-emacs-directory))
  :after eshell
  :config (add-hook 'eshell-mode-hook 'eshell-fringe-status-mode))

;; Show git branches on the prompt
(use-package eshell-prompt-extras
  :load-path (lambda () (expand-file-name "eshell-prompt-extras/" user-emacs-directory))
  :after eshell
  :config (setq eshell-prompt-function 'epe-theme-lambda))

;; Shell mode
(use-package sh-script
  :commands sh-mode
  :mode (("\\.sh$" . sh-mode))
  :config (progn
            ;; create keymap
            (setq sh-mode-map (make-sparse-keymap))

            ;; Configuration choices
            (add-hook 'sh-mode-hook
                      (lambda ()
                        (setq sh-indentation 2)
                        (setq sh-basic-offset 2)
                        (show-paren-mode -1)
                        (flycheck-mode -1)
                        (setq blink-matching-paren nil)))

            ;; When compiling from shell, display error result as in compilation
            ;; buffer, with links to errors.
            (add-hook 'sh-mode-hook 'compilation-shell-minor-mode)
            (add-hook 'sh-mode-hook 'ansi-color-for-comint-mode-on)))

;; CShell mode
(use-package csh-mode
  :after sh-script
  :config (progn
            (dolist (elt interpreter-mode-alist)
              (when (member (car elt) (list "csh" "tcsh"))
                (setcdr elt 'csh-mode)))

            ;; Fix issues in csh indentation
            (add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))
            (add-to-list 'auto-mode-alist '("\\.csh\\'" . sh-mode))
            (add-to-list 'auto-mode-alist '("\\.cshrc\\'" . sh-mode))
            (defun my/tcsh-set-indent-functions ()
              (when (or (string-match ".*\\.alias" (buffer-file-name))
                        (string-match "\\(.*\\)\\.csh$" (file-name-nondirectory (buffer-file-name))))
                (setq-local indent-line-function   #'csh-indent-line)
                (setq-local indent-region-function #'csh-indent-region)))
            (add-hook 'sh-mode-hook #'my/tcsh-set-indent-functions)
            (add-hook 'sh-set-shell-hook #'my/tcsh-set-indent-functions)
            (add-hook 'sh-mode-hook (lambda () (electric-indent-mode -1)))))

;; Send expressions to a REPL line-by-line by hitting C-RET
(use-package eval-in-repl
  :load-path (lambda () (expand-file-name "eval-in-repl/" user-emacs-directory))
  :config (progn
            (setq eir-jump-after-eval nil)
            (setq eir-always-split-script-window t)
            (setq eir-delete-other-windows t)
            (setq eir-repl-placement 'right)))

;; ielm support (for emacs lisp)
(use-package eval-in-repl-ielm
  :load-path (lambda () (expand-file-name "eval-in-repl/" user-emacs-directory))
  :commands eir-eval-in-ielm)

;; Shell support
(use-package eval-in-repl-shell
  :load-path (lambda () (expand-file-name "eval-in-repl/" user-emacs-directory))
  :commands eir-eval-in-shell)

;; Python support
(use-package eval-in-repl-python
  :load-path (lambda () (expand-file-name "eval-in-repl/" user-emacs-directory))
  :commands eir-eval-in-python)

;; Javascript support
(use-package eval-in-repl-javascript
  :load-path (lambda () (expand-file-name "eval-in-repl/" user-emacs-directory))
  :commands eir-eval-in-javascript)

;; Emacs interaction with tmux
(use-package emamux
  :load-path (lambda () (expand-file-name "emamux/" user-emacs-directory))
  :commands (emamux:send-command
             emamux:run-command
             emamux:run-last-command
             emamux:zoom-runner
             emamux:inspect-runner
             emamux:close-runner-pane
             emamux:close-panes
             emamux:clear-runner-history
             emamux:interrupt-runner
             emamux:copy-kill-ring
             emamux:yank-from-list-buffers))

(use-package multi-term
  :commands (multi-term
             my/multi-term-vertical
             my/multi-term-horizontal)
  :config (progn
            ;; Vertical split multi-term
            (defun my/multi-term-vertical ()
              "opens up a new terminal in the directory associated with the current buffer's file."
              (interactive)
              (split-window-right)
              (other-window 1)
              (multi-term))

            ;; Horizontal split multi-term
            (defun my/multi-term-horizontal ()
              "opens up a new terminal in the directory associated with the current buffer's file."
              (interactive)
              (split-window-below)
              (other-window 1)
              (multi-term))))

(provide 'setup-eshell)
;;; setup-eshell.el ends here
