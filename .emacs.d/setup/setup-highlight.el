;;; setup-highlight.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Abelardo Jara

;; Author: Abelardo Jara <abelardojara@Abelardos-MacBook-Pro.local>
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

;; higlight changes in documents
(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil)
(diminish 'highlight-changes-mode)

;; Fix highlight bug of marking a file as modified
(defadvice highlight-changes-rotate-faces (around around-rotate-faces)
  (let ((was-modified (buffer-modified-p))
        (buffer-undo-list t))
    ad-do-it
    (unless was-modified
      (set-buffer-modified-p nil))))
(ad-activate 'highlight-changes-rotate-faces)

;; Highlight the line
(use-package hl-line
  :config (progn
            (global-hl-line-mode t)
            (defun local-hl-line-mode-off ()
              (interactive)
              (make-local-variable 'global-hl-line-mode)
              (setq global-hl-line-mode nil))

            ;; hl-line overrides the background of hi-lock’ed text, this will provide a fix
            (defadvice hi-lock-set-pattern (around use-overlays activate)
              (let ((font-lock-fontified nil))
                ad-do-it))
            (add-hook 'org-mode-hook 'local-hl-line-mode-off)))

;; Highlight the latest changes in the buffer (like text inserted from: yank, undo, etc.) until the next command is run
(use-package volatile-highlights
  :load-path (lambda () (expand-file-name "volatile-highlights/" user-emacs-directory))
  :diminish volatile-highlights-mode
  :config (progn
            (volatile-highlights-mode t)))

;; Highlight blocks
(use-package highlight-blocks
  :load-path (lambda () (expand-file-name "highlight-blocks/" user-emacs-directory))
  :diminish highlight-blocks-mode)

;; Highlight symbol
(use-package highlight-symbol
  :load-path (lambda () (expand-file-name "highlight-symbol/" user-emacs-directory))
  :config (progn (mapc (lambda (mode)
                         (add-hook mode 'highlight-symbol-mode))
                       '(prog-mode-hook))
                 (setq highlight-symbol-on-navigation-p t))
  :diminish highlight-symbol-mode)

;; Highlight s-exp
(use-package highlight-sexp
  :load-path (lambda () (expand-file-name "highlight-sexp/" user-emacs-directory))
  :diminish highlight-sexp-mode
  :config (progn (mapc (lambda (mode)
                         (add-hook mode 'highlight-sexp-mode))
                       '(prog-mode-hook))))

(provide 'setup-highlight)
;;; setup-highlight.el ends here
