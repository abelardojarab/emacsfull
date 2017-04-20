;;; setup-environment.el ---                 -*- lexical-binding: t; -*-

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

;; garbage collection
(setq-default ;; alloc.c
 gc-cons-threshold most-positive-fixnum
 gc-cons-percentage 0.5)

;; Reset garbage collector after initialization is finished and garbage-collect on focus out
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 20 1204 1204))))
(add-hook 'focus-out-hook 'garbage-collect)

;; Improve Emacs performance
(if (boundp 'max-specpdl-size)
    (setq max-specpdl-size (* max-specpdl-size 40)
          max-lisp-eval-depth (* max-lisp-eval-depth 30)))

;; ignore byte-compile warnings
(setq byte-compile-warnings nil)

;; prefer newer non-byte compiled sources to older byte compiled ones
(setq load-prefer-newer t)

;; Assure .emacs.cache directory exists
(if (not (file-exists-p "~/.emacs.cache"))
    (make-directory "~/.emacs.cache") t)

;; Inhibit startup window, very annoying
(setq inhibit-startup-message t)

;; Features
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; Printing
(setq ps-paper-type 'a4
      ps-font-size 7.0
      ps-print-header nil
      ps-print-color-p t
      ps-landscape-mode nil    ;; for two pages per page: t
      ps-number-of-columns 1)  ;; for two pages per page: 2

;; Define preferred shell
(cond
 ((executable-find "bash")
  (setq shell-file-name "bash"))
 ((executable-find "csh")
  (setq shell-file-name "csh"))
 ((executable-find "cmdproxy")
  (setq shell-file-name "cmdproxy"))
 (t
  (setq shell-file-name "bash")))
(setq explicit-shell-file-name shell-file-name)

;; Exec path from shell in Mac OSX
(use-package exec-path-from-shell
  :if (equal system-type 'darwin)
  :load-path (lambda () (expand-file-name "exec-path-from-shell/" user-emacs-directory))
  :config (progn
            (setq exec-path-from-shell-check-startup-files nil)
            (exec-path-from-shell-initialize)))

(cond

 ;; Linux
 ((equal system-type 'gnu/linux)

  ;; Prefer /bin/bash
  (if (executable-find "/bin/bash")
      (setenv "SHELL" "/bin/bash"))

  ;; Get back font antialiasing
  (push '(font-backend xft x) default-frame-alist)

  ;; Inspired by the windows version. Also used call-process here because
  ;; shell-command-to-string gave me 100% CPU usage by lisp.run until
  ;; kdialog returned.
  (defun kde-open-file ()
    (interactive)
    (let ((file-name
           (replace-regexp-in-string "kbuildsycoca running..." ""
                                     (replace-regexp-in-string
                                      "[\n]+" ""
                                      (shell-command-to-string "kdialog --getopenurl ~ 2> /dev/null")))))
      (cond
       ((string-match "^file://" file-name)
        ;; Work arround a bug in kioexec, which causes it to delete local
        ;; files. (See bugs.kde.org, Bug 127894.) Because of this we open the
        ;; file with `find-file' instead of emacsclient.
        (let ((local-file-name (substring file-name 7)))
          (message "Opening local file '%s'" local-file-name)
          (find-file local-file-name)))
       ((string-match "^[:space:]*$" file-name)
        (message "Empty file name given, doing nothing..."))
       (t
        (message "Opening remote file '%s'" file-name)
        (save-window-excursion
          (shell-command (concat "kioexec emacsclient " file-name "&"))))))))

 ;; Mac OSX
 ((equal system-type 'darwin)
  (setq delete-by-moving-to-trash t
        trash-directory "~/.Trash/")
  ;; Keep the Option key as Meta
  (setq mac-option-modifier 'meta
        mac-command-modifier 'meta)
  ;; BSD ls does not support --dired. Use GNU core-utils: brew install coreutils
  (when (executable-find "gls")
    (setq insert-directory-program "gls"))
  ;; Derive PATH by running a shell so that GUI Emacs sessions have access to it
  (exec-path-from-shell-initialize)
  ;; Correctly parse exec-path when PATH delimiter is a space
  (when (equal (file-name-nondirectory (getenv "SHELL")) "fish")
    (setq exec-path (split-string (car exec-path) " "))
    (setenv "PATH" (mapconcat 'identity exec-path ":"))
    (setq eshell-path-env (getenv "PATH")))
  (setenv "PATH" (concat "/usr/local/texlive/2014/bin/x86_64-darwin:/usr/texbin:/opt/local/bin:/usr/local/bin:" (getenv "PATH")))
  (push "/usr/local/bin" exec-path)
  (push "/opt/local/bin" exec-path)
  (push "/usr/texbin" exec-path)

  (defun my/mac-open-file ()
    (interactive)
    (let ((file (do-applescript "try
 POSIX path of (choose file)
 end try")))
      (if (> (length file) 3)
          (setq file
                (substring file 1 (- (length file) 1))))
      (if (and (not (equal file ""))
               (file-readable-p file))
          (find-file file)
        (beep))))

  (defun my/mac-save-file-as ()
    (interactive)
    (let ((file (do-applescript "try
 POSIX path of (choose file name with prompt \"Save As...\")
 end try")))
      (if (> (length file) 3)
          (setq file
                (substring file 1 (- (length file) 1))))
      (if (not (equal file ""))
          (write-file file)
        (beep))))

  ;; Point Org to LibreOffice executable
  (when (file-exists-p "/Applications/LibreOffice.app/Contents/MacOS/soffice")
    (setq org-export-odt-convert-processes '(("LibreOffice" "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i")))))

 ;; Windows
 ((equal system-type 'windows-nt)
  (if (or (file-directory-p "c:/cygwin64/bin")
          (file-directory-p "c:/cygwin64/bin"))
      (require 'setup-cygwin))

  ;; Custom $PATH
  (when (file-directory-p "c:/cygwin/bin")
    (setenv "PATH" (concat "c:/cygwin/bin:" (getenv "PATH")))
    (add-to-list 'exec-path "c:/cygwin/bin")
    (setq explicit-shell-file-name "c:/cygwin/bin/bash.exe")
    (setq shell-file-name explicit-shell-file-name))
  (when (file-directory-p "c:/cygwin64/bin")
    (setenv "PATH" (concat "c:/cygwin64/bin:c:/cygwin64/usr/local/bin" (getenv "PATH")))
    (add-to-list 'exec-path "c:/cygwin64/bin")
    (add-to-list 'exec-path "c:/cygwin64/usr/local/bin")
    (setq explicit-shell-file-name "c:/cygwin64/bin/bash.exe")
    (setq shell-file-name explicit-shell-file-name))

  (setenv "SHELL" shell-file-name)
  (require 'w32browser-dlgopen)
  (setq dlgopen-executable-path (expand-file-name "elisp/getfile.exe" user-emacs-directory))))

;; Make directory on-the-fly if non-existent
;; http://mbork.pl/2016-07-25_Making_directories_on_the_fly
(defun make-parent-directory ()
  "Make sure the directory of `buffer-file-name' exists."
  (make-directory (file-name-directory buffer-file-name) t))

(add-hook 'find-file-not-found-functions #'make-parent-directory)

;; Emacs is a text editor, make sure your text files end in a newline
(setq require-final-newline 'query)

;; Automatically kill all spawned processes on exit
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (ignore-errors
    (flet ((process-list ())) ad-do-it)))

;; Enable tooltips
(if (display-graphic-p)
    (tooltip-mode t))

;; http://emacs.stackexchange.com/questions/21330/query-replace-read-to-command-attempted-to-use-minibuffer-while-in-minibuffer
(setq enable-recursive-minibuffers t)

;; Bell instead of annoying beep
(setq visible-bell t)

;; Turn off the bell http://www.emacswiki.org/cgi-bin/wiki?AlarmBell
(setq ring-bell-function 'ignore)

;; Save whatever’s in the current (system) clipboard before
;; replacing it with the Emacs’ text.
;; https://github.com/dakrone/eos/blob/master/eos.org
(setq save-interprogram-paste-before-kill t)

;; The default goes to the middle first. I prefer that the default goes to the top first. Let’s change this.
(setq recenter-positions '(top middle bottom))

;; Disable word wrapping
(setq-default word-wrap nil)

;; It's much easier to move around lines based on how they are displayed,
;; rather than the actual line. This helps a ton with long log file lines
;; that may be wrapped:
(setq line-move-visual t)

;; Do not add empty lines at the end of our file if we press down key
(setq next-line-add-newlines nil)

;; Dont keep height of the echo area equal to only 1 line
(setq message-truncate-lines nil)

;; Makes final line always be a return
(setq require-final-newline t)

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Edition of EMACS edition modes
(setq major-mode 'text-mode)
(add-hook 'text-mode-hook 'text-mode-hook-identify)
(add-hook 'text-mode-hook (function
                           (lambda () (ispell-minor-mode))))

;; Change type files
(setq auto-mode-alist
      (append '(("\\.cpp$" . c++-mode)
                ("\\.h$" . c++-mode)
                ("\\.hpp$" . c++-mode)
                ("\\.lsp$" . lisp-mode)
                ("\\.il$" . lisp-mode)
                ("\\.ils$" . lisp-mode)
                ("\\.scm$" . scheme-mode)
                ("\\.pl$" . perl-mode)
                ) auto-mode-alist))

;; Measure Emacs startup time
(defun show-startup-time ()
  "Show Emacs's startup time in the minibuffer"
  (message "Startup time: %s seconds."
           (emacs-uptime "%s")))
(add-hook 'emacs-startup-hook 'show-startup-time 'append)

(provide 'setup-environment)
