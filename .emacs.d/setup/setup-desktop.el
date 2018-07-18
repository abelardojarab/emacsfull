;;; setup-desktop.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Abelardo Jara-Berrocal

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

;; Keep .emacs.d clean
(use-package no-littering
  :demand t
  :config (progn
	    (require 'recentf)
	    (add-to-list 'recentf-exclude no-littering-var-directory)
	    (add-to-list 'recentf-exclude no-littering-etc-directory)

	    (setq create-lockfiles    nil
		  delete-old-versions t
		  kept-new-versions   6
		  kept-old-versions   2
		  version-control     t
		  backup-by-copying   t)

	    (setq auto-save-default   nil
		  auto-save-interval  500)

	    ;; Preserve the owner and group of the file you're editing
	    (setq backup-by-copying-when-mismatch t)

	    (setq
	     backup-directory-alist
	     `((".*" . ,(no-littering-expand-var-file-name "backup/")))
	     auto-save-file-name-transforms
	     `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))))

;; Savehist: save some history
(use-package savehist
  :demand t
  :init (setq savehist-additional-variables '(search ring regexp-search-ring)
              savehist-autosave-interval    120
              savehist-file                  (concat (file-name-as-directory
                                                      my/emacs-cache-dir)
                                                     "savehist"))
  :config (savehist-mode t))

;; Filecache
(use-package file-cache
  :disabled t
  :config (progn
            (message "Loading file cache...")
            (file-cache-add-directory "~/")
            (file-cache-add-directory-list '("~/Desktop" "~/Documents" "~/workspace"))))

;; Remember the position where we closed a file
(use-package saveplace
  :demand t
  :init (progn
          (setq save-place-file  (concat (file-name-as-directory
                                          my/emacs-cache-dir)
                                         "emacs.saveplace"))
          (setq-default save-place t)))

;; Automatically save and restore sessions
(use-package desktop
  :defer t
  :commands (desktop-save-mode desktop-read desktop-save)
  :init (progn
          ;; Save desktops a minute after Emacs was idle.
          (setq-default desktop-missing-file-warning nil)
          (setq desktop-dirname                    (file-name-as-directory my/emacs-cache-dir)
                desktop-base-file-name             "emacs.desktop"
                desktop-base-lock-name             "lock"
                desktop-path                       (list desktop-dirname)
                desktop-save                       t
                desktop-load-locked-desktop        t
                desktop-save                       'ask-if-new
                desktop-file-name-format           'absolute
                desktop-restore-frames             nil
                desktop-restore-in-current-display t
                desktop-restore-forces-onscreen    nil
                desktop-restore-eager              0
                desktop-auto-save-timeout          60
                desktop-globals-to-save
                '((extended-command-history . 30)
                  (file-name-history        . 100)
                  (grep-history             . 30)
                  (compile-history          . 30)
                  (minibuffer-history       . 50)
                  (query-replace-history    . 60)
                  (read-expression-history  . 60)
                  (regexp-history           . 60)
                  (regexp-search-ring       . 20)
                  (search-ring              . 20)
                  (shell-command-history    . 50)
                  (ido-buffer-history       . 100)
                  (ido-last-directory-list  . 100)
                  (ido-work-directory-list  . 100)
                  (ido-work-file-list       . 100)
                  (magit-read-rev-history   . 50)
                  tags-file-name
                  register-alist)
                desktop-locals-to-save
                (nconc '(word-wrap line-move-visual) desktop-locals-to-save)))
  :config (progn
            ;; Don't save Magit and Git related buffers
            (dolist (mode my/desktop-modes-disabled)
              (add-to-list 'desktop-modes-not-to-save mode))

            ;; buffer-display-time is changed when desktop is loaded
            (add-to-list 'desktop-locals-to-save 'buffer-display-time-1)
            (make-variable-buffer-local 'buffer-display-time-1)
            (defun save-buffer-display-time ()
              (mapc (lambda (buf)
                      (with-current-buffer buf
                        (setq buffer-display-time-1
                              (or buffer-display-time (current-time)))))
                    (buffer-list)))
            (add-hook 'desktop-save-hook #'save-buffer-display-time)

            (defun set-buffer-display-time ()
              (mapc (lambda (buf)
                      (with-current-buffer buf
                        (setq buffer-display-time buffer-display-time-1)))
                    (buffer-list)))
            (add-hook 'desktop-after-read-hook #'set-buffer-display-time)
            (desktop-save-mode)))

;; Dashboard startup screen
(use-package dashboard
  :demand t
  :load-path (lambda () (expand-file-name "dashboard/" user-emacs-directory))
  :if (display-graphic-p)
  :config (progn
            (add-hook 'dashboard-mode-hook
                      (lambda ()
                        (toggle-truncate-lines t)
                        (setq truncate-lines t)))

            ;; Set the title
            (if (not (equal system-type 'windows-nt))
                (setq dashboard-banner-logo-title (concat "GNU Emacs "
                                                          emacs-version
                                                          " kernel " (car (split-string (shell-command-to-string "uname -r") "-"))
                                                          " x86_64")))

            ;; Set the banner
            (setq dashboard-startup-banner (concat user-emacs-directory
                                                   "/emacs.png"))

            (dashboard-setup-startup-hook)
            (setq dashboard-page-separator "\n\f\f\n")

            (setq dashboard-items '((recents . 10) (projects . 10)))
            (dashboard-setup-startup-hook)))

(provide 'setup-desktop)
;;; setup-desktop.el ends here
