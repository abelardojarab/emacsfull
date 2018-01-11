;;; setup-cedet.el ---

;; Copyright (C) 2014, 2015, 2016, 2017, 2018  Abelardo Jara-Berrocal

;; Author: Abelardo Jara-Berrocal <abelardojarab@gmail.com>
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

(use-package semantic
  :demand t
  :config (progn

            (setq format-args t)

            ;; To use additional features for names completion, and displaying of information for tags & classes,
            ;; you also need to load the semantic-ia package. Unfortunately, semantic makes Emacs slow
            (use-package semantic/ia)

            ;; Enable support for parsing additional languages
            (use-package semantic/wisent)

            ;; The Semantic Database (SemanticDB) caches the results of parsing source code files.
            (use-package semantic/db)

            ;; Find system header files, if using gcc
            (if (executable-find "gcc")
                (use-package semantic/bovine/gcc))

            ;; Enabled features
            (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                              global-semanticdb-minor-mode
                                              global-semantic-idle-summary-mode
                                              global-semantic-mru-bookmark-mode
                                              global-semantic-load-enable-code-helpers
                                              global-semantic-load-enable-excessive-code-helpers
                                              global-semantic-idle-completions-mode))

            ;; Assure .emacs.cache/semanticdb directory exists
            (if (not (file-exists-p "~/.emacs.cache/semanticdb"))
                (make-directory "~/.emacs.cache/semanticdb") t)

            ;; Enable case-insensitive searching
            (set-default 'semantic-case-fold t)

            ;; Faster parsing
            (setq semantic-idle-work-parse-neighboring-files-flag nil
                  semantic-idle-work-update-headers-flag          nil
                  semantic-idle-scheduler-idle-time               432000
                  semantic-idle-scheduler-work-idle-time          1800 ;; default is 60
                  semantic-idle-scheduler-max-buffer-size         1)

            ;; Disable Semantics for large files
            (add-hook 'semantic--before-fetch-tags-hook
                      (lambda () (if (and (> (point-max) 500)
                                     (not (semantic-parse-tree-needs-rebuild-p)))
                                nil
                              t)))

            ;; Don't use information from system include files, by removing system
            (setq-mode-local c-mode semanticdb-find-default-throttle
                             '(project unloaded system recursive))
            (setq-mode-local c++-mode semanticdb-find-default-throttle
                             '(project unloaded system recursive))

            ;; Enable decoration mode
            (global-semantic-decoration-mode t)

            ;; for semantic-ia-fast-jump
            (use-package semantic/analyze/refs)

            ;; Fixing a bug in semantic, see #22287
            (defun semanticdb-save-all-db-idle ()
              "Save all semantic tag databases from idle time.
Exit the save between databases if there is user input."

              ;; save-mark-and-excursion is defined in Emacs 25.1-forward
              (if (fboundp 'save-mark-and-excursion)
                  (semantic-safe "Auto-DB Save: %S"
                    ;; FIXME: Use `while-no-input'?
                    (save-mark-and-excursion ;; <-- added line
                      (semantic-exit-on-input 'semanticdb-idle-save
                        (mapc (lambda (db)
                                (semantic-throw-on-input 'semanticdb-idle-save)
                                (semanticdb-save-db db t))
                              semanticdb-database-list))))
                (if (fboundp 'save-excursion)
                    (save-excursion ;; <-- added line
                      (semantic-exit-on-input 'semanticdb-idle-save
                        (mapc (lambda (db)
                                (semantic-throw-on-input 'semanticdb-idle-save)
                                (semanticdb-save-db db t))
                              semanticdb-database-list))))))

            ;; Disable semanticdb, slows down Emacs
            (global-semanticdb-minor-mode nil)
            (setq semanticdb-search-system-databases t)
            (add-hook 'c-mode-common-hook
                      (lambda ()
                        (setq semanticdb-project-system-databases
                              (list (semanticdb-create-database
                                     semanticdb-new-database-class
                                     "/usr/include")))))

            ;; Set project roots to start from /
            (setq semanticdb-project-roots
                  (list
                   (expand-file-name "/")))

            ;; This prevents Emacs to become uresponsive
            (defun semanticdb-kill-hook ()
              nil)
            (defun semanticdb-create-table-for-file-not-in-buffer (arg)
              nil)

            ;; Ignore errors in semantic completions
            (defadvice semantic-analyze-possible-completions (around bar activate)
              (ignore-errors add-do-it))

            (defadvice semantic-analyze-possible-completions-default (around bar activate)
              (ignore-errors add-do-it))

            ;; Default semanticdb directory
            (setq-default semanticdb-default-save-directory "~/.emacs.cache/semanticdb")

            ;; semanticdb support for global/gtags
            (when (executable-find "global")
              (semanticdb-enable-gnu-global-databases 'c-mode t)
              (semanticdb-enable-gnu-global-databases 'c++-mode t))))

;; Load contrib library
(use-package eassist)

;; EDE project managment, slows down Emacs
(use-package ede
  :disabled t
  :config (progn
            (global-ede-mode 1)
            (ede-enable-generic-projects)
            (setq ede-project-directories t)

            ;; Default EDE directory
            (setq-default ede-project-placeholder-cache-file "~/.emacs.cache/ede-projects.el")

            ;; Advice ede add projects to avoid errors
            (defadvice ede-add-project-to-global-list (around bar activate)
              (ignore-errors add-do-it))))

;; Show function in mode-line
(use-package which-func
  :defer t
  :commands which-function-mode
  :config (progn
            ;; Enable which-function-mode for selected major modes
            (setq which-func-unknown "⊥"
                  which-func-maxout 1024
                  which-func-modes '(latex-mode
                                     markdown-mode
                                     c-mode
                                     emacs-lisp-mode
                                     org-mode
                                     c++-mode)
                  which-func-format
                  `(" "
                    (:propertize which-func-current local-map
                                 (keymap
                                  (mode-line keymap
                                             (mouse-3 . end-of-defun)
                                             (mouse-2 . narrow-to-defun)
                                             (mouse-1 . beginning-of-defun)))
                                 face which-func
                                 mouse-face mode-line-highlight
                                 help-echo "mouse-1: go to beginning\n\
mouse-2: toggle rest visibility\n\
mouse-3: go to end")
                    " "))))

(provide 'setup-cedet)
;;; setup-cedet.el ends here
