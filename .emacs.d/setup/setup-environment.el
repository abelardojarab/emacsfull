;;; setup-environment.el ---

;; Copyright (C) 2014, 2015, 2016  abelardo.jara-berrocal

;; Author: abelardo.jara-berrocal <ajaraber@plxc25288.pdx.intel.com>
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
 gc-cons-threshold (* 20 1204 1204)
 gc-cons-percentage 0.5)

;; Improve Emacs performance
(if (boundp 'max-specpdl-size)
    (setq max-specpdl-size (* max-specpdl-size 15)
          max-lisp-eval-depth (* max-lisp-eval-depth 30)))

;; ignore byte-compile warnings
(setq byte-compile-warnings nil)

;; Assure .emacs.cache directory exists
(if (not (file-exists-p "~/.emacs.cache"))
    (make-directory "~/.emacs.cache") t)

;; Inhibit startup window, very annoying
(setq inhibit-startup-message t)

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
  (push "/usr/local/texlive/2014/bin/x86_64-darwin" exec-path)

  (defun mac-open-file ()
    (interactive)
    (let ((file (do-applescript "try
 POSIX path of (choose file)
 end try")))
      (if (> (length file) 3)
          (setq file
                (substring file 1 (- (length file) 1))
                ))
      (if (and (not (equal file ""))(file-readable-p file))
          (find-file file)
        (beep))))

  (defun mac-save-file-as ()
    (interactive)
    (let ((file (do-applescript "try
 POSIX path of (choose file name with prompt \"Save As...\")
 end try")))
      (if (> (length file) 3)
          (setq file
                (substring file 1 (- (length file) 1))
                ))
      (if (not (equal file ""))
          (write-file file)
        (beep))))

  ;; Point Org to LibreOffice executable
  (when (file-exists-p "/Applications/LibreOffice.app/Contents/MacOS/soffice")
    (setq org-export-odt-convert-processes '(("LibreOffice" "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i")))))

 ;; Windows
 ((equal system-type 'windows-nt)

  ;; Custom $PATH
  (when (file-directory-p "c:/cygwin/bin")
    (setenv "PATH" (concat "c:/cygwin/bin:" (getenv "PATH")))
    (add-to-list 'exec-path "c:/cygwin/bin")
    (setq explicit-shell-file-name "C:/cygwin/bin/bash.exe")
    (setq shell-file-name explicit-shell-file-name))
  (when (file-directory-p "c:/cygwin64/bin")
    (setenv "PATH" (concat "c:/cygwin64/bin:" (getenv "PATH")))
    (add-to-list 'exec-path "c:/cygwin64/bin")
    (setq explicit-shell-file-name "C:/cygwin64/bin/bash.exe")
    (setq shell-file-name explicit-shell-file-name))

  (setenv "SHELL" shell-file-name)
  (require 'w32browser-dlgopen)
  (setq dlgopen-executable-path (expand-file-name "elisp/getfile.exe" user-emacs-directory))))

;; Emacs is a text editor, make sure your text files end in a newline
(setq require-final-newline 'query)

;; Automatically kill all spawned processes on exit
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

;; Always split horizontally
(setq split-width-threshold 78)
(setq split-height-threshold nil)

;; Helper function for horizontal splitting
(defun split-horizontally-for-temp-buffers ()
  "Split the window horizontally for temp buffers."
  (when (and (one-window-p t)
             (not (active-minibuffer-window)))
    (split-window-horizontally)))
(add-hook 'temp-buffer-setup-hook 'split-horizontally-for-temp-buffers)

;; horizontal splitting - when opening files or buffers with C-x4b or C-x4f
(defun split-window-prefer-horizonally (window)
  "If there's only one window (excluding any possibly active
         minibuffer), then split the current window horizontally."
  (if (and (one-window-p t)
           (not (active-minibuffer-window)))
      (let ((split-height-threshold nil))
        (split-window-sensibly window))
    (split-window-sensibly window)))
(setq split-window-preferred-function 'split-window-prefer-horizonally)

;; Enable tooltips
(tooltip-mode t)
(setq tooltip-use-echo-area t)

;; Bell instead of annoying beep
(setq visible-bell t)

;; Turn off the bell http://www.emacswiki.org/cgi-bin/wiki?AlarmBell
(setq ring-bell-function 'ignore)

;; Do not add empty lines at the end of our file if we press down key
(setq next-line-add-newlines nil)

;; Keep height of the echo area equal to only 1 line
(setq message-truncate-lines t)

;; Makes final line always be a return
(setq require-final-newline t)

;; Set indent to 4 instead of 2
(setq standard-indent 4)

;; My personal configurations, has to use setq-default
(setq-default indent-tabs-mode nil
              default-tab-width 4
              tab-width 4
              c-basic-offset 4)

;; auto-indent pasted code
(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode java-mode js2-mode))
      (indent-region (region-beginning) (region-end) nil)))

(defadvice yank-pop (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode java-mode js2-mode))
      (indent-region (region-beginning) (region-end) nil)))

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Edition of EMACS edition modes
(setq major-mode 'text-mode)
(add-hook 'text-mode-hook 'text-mode-hook-identify)
(add-hook 'text-mode-hook (function
                           (lambda () (ispell-minor-mode))))

;; Pretty diff mode
(autoload 'ediff-buffers "ediff" "Intelligent Emacs interface to diff" t)
(autoload 'ediff-files "ediff" "Intelligent Emacs interface to diff" t)
(autoload 'ediff-files-remote "ediff" "Intelligent Emacs interface to diff" t)

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
