;;; setup-parenthesis.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2016, 2017, 2018  Abelardo Jara-Berrocal

;; Author: Abelardo Jara <abelardojarab@gmail.com>
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

;; Show-paren-mode: subtle blinking of matching paren (defaults are ugly)
(use-package paren
  :defer t
  :init (show-paren-mode t)
  :commands show-paren-mode
  :config (progn
            ;; Show paren-mode when off-screen
            (defadvice show-paren-function (after show-matching-paren-offscreen activate)
              "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
              (interactive)
              (ignore-errors
                (let* ((cb (char-before (point)))
                       (matching-text (and cb
                                           (char-equal (char-syntax cb) ?\) )
                                           (blink-matching-open))))
                  (when matching-text (message matching-text)))))

            ;; Enable mode
            (show-paren-mode 1)))

;; Smartparens
(use-package smartparens
  :defer t
  :diminish smartparens-mode
  :load-path (lambda () (expand-file-name "smartparens/" user-emacs-directory))
  :init (progn (use-package smartparens-config)
               (smartparens-global-mode t))
  :commands (smartparens-global-mode smartparens-mode)
  :config (progn
            ;; subtle blinking of matching paren (defaults are ugly)
            (show-smartparens-global-mode 1)

            ;; disable pairing of ' in minibuffer
            (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)

            ;; use smartparens to automatically indent correctly when opening new block
            (dolist (mode '(c-mode c++-mode java-mode))
              (sp-local-pair mode "{" nil :post-handlers '((apm-c-mode-common-open-block "RET"))))))

;; Autopair
(use-package autopair
  :defer t
  :load-path (lambda () (expand-file-name "autopair/" user-emacs-directory))
  :commands (autopair-mode autopair-global-mode)
  :diminish autopair-mode
  :config (progn
            (autopair-global-mode) ;; enable autopair in all buffers
            (setq autopair-autowrap t)
            (put 'autopair-insert-opening         'delete-selection t)
            (put 'autopair-skip-close-maybe       'delete-selection t)
            (put 'autopair-insert-or-skip-quote   'delete-selection t)
            (put 'autopair-extra-insert-opening   'delete-selection t)
            (put 'autopair-extra-skip-close-maybe 'delete-selection t)
            (put 'autopair-backspace              'delete-selection 'supersede)
            (put 'autopair-newline                'delete-selection t)

            ;; only needed if you use autopair
            (add-hook 'text-mode-hook
                      (lambda () (setq autopair-dont-activate t)))
            (add-hook 'org-mode-hook
                      (lambda () (setq autopair-dont-activate t)))))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :defer t
  :load-path (lambda () (expand-file-name "rainbow-delimiters/" user-emacs-directory))
  :commands rainbow-delimiters-mode
  :init (progn
          (add-hook 'lisp-mode-hook #'rainbow-delimiters-mode)
          (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)))

;; Legacy minor mode
(use-package paredit
  :defer t
  :commands paredit-mode
  :load-path (lambda () (expand-file-name "paredit/" user-emacs-directory)))

(provide 'setup-parenthesis)
;;; setup-autopair.el ends here
