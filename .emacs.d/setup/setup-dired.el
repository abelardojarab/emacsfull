;;; setup-dired.el ---                               -*- lexical-binding: t; -*-

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

(use-package dired
  :bind (("C-x C-j" . dired-jump)
         :map dired-mode-map
         (("." . dired-up-directory)
          ("Y" . my/dired-rsync)
          ("RET" . dired-find-alternate-file)
          ("C-c d" . dired-filter-by-directory)
          ("C-c f" . dired-filter-by-file)))
  :config (progn
            (defun my/dired-mode-hook ()
              (setq-local truncate-lines t))
            (require 'dired-x)
            (add-hook 'dired-mode-hook 'projectile-mode)
            (setq-default dired-omit-mode t)
            (put 'dired-find-alternate-file 'disabled nil)
            (add-to-list 'dired-omit-extensions ".DS_Store")
            (setq ls-lisp-dirs-first t
                  dired-listing-switches "-alhF --group-directories-first"
                  dired-recursive-copies 'top
                  dired-recursive-deletes 'top
                  dired-dwim-target t
                  ;; -F marks links with @
                  dired-ls-F-marks-symlinks t
                  ;; Auto refresh dired
                  dired-auto-revert-buffer t
                  global-auto-revert-non-file-buffers t)

            ;; rsync helper
            (defun my/dired-rsync (dest)
              (interactive
               (list
                (expand-file-name
                 (read-file-name
                  "Rsync to:"
                  (dired-dwim-target-directory)))))
              ;; store all selected files into "files" list
              (let ((files (dired-get-marked-files
                            nil current-prefix-arg))
                    ;; the rsync command
                    (tmtxt/rsync-command
                     "rsync -arvz --progress "))
                ;; add all selected file names as arguments
                ;; to the rsync command
                (dolist (file files)
                  (setq tmtxt/rsync-command
                        (concat tmtxt/rsync-command
                                (shell-quote-argument file)
                                " ")))
                ;; append the destination
                (setq tmtxt/rsync-command
                      (concat tmtxt/rsync-command
                              (shell-quote-argument dest)))
                ;; run the async shell command
                (async-shell-command tmtxt/rsync-command "*rsync*")
                ;; finally, switch to that window
                (other-window 1)))

            ;; extra hooks
            (add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))
            (add-hook 'dired-mode-hook #'hl-line-mode)
            (add-hook 'dired-mode-hook #'my/dired-mode-hook)))

(provide 'setup-dired)
;;; setup-dired.el ends here
