;;; setup-general.el ---

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

;; Popup, used by auto-complete and other tools
(use-package popup
  ;; We don't ensure this package, because we definitely don't want to have this
  ;; mess, but unfortunately it's a dependency of Ensime :(
  :load-path "~/.emacs.d/popup"
  :pin manual
  :config (progn
            (setq popup-use-optimized-column-computation t)))

;; Fix indent guide issue
;; (defvar sanityinc/indent-guide-mode-suppressed nil)
;; (defadvice popup-create (before indent-guide-mode activate)
;;   "Suspend indent-guide-mode while popups are visible"
;;   (let ((indent-guide-enabled (and (boundp 'indent-guide-mode) indent-guide-mode)))
;;     (set (make-local-variable 'sanityinc/indent-guide-mode-suppressed) indent-guide-mode)
;;     (when indent-guide-enabled
;;       (indent-guide-mode nil))))
;; (defadvice popup-delete (after indent-guide-mode activate)
;;   "Restore indent-guide-mode when all popups have closed"
;;   (let ((indent-guide-enabled (and (boundp 'indent-guide-mode) indent-guide-mode)))
;;     (when (and (not popup-instances) sanityinc/indent-guide-mode-suppressed)
;;       (setq sanityinc/indent-guide-mode-suppressed nil)
;;       (indent-guide-mode 1))))

;; Manage popup windows
(use-package popwin
  :load-path "~/.emacs.d/popwin"
  :pin manual
  :config (popwin-mode 1))

;; Automatically save and restore sessions
(use-package desktop
  :init (progn
          ;; Save desktops a minute after Emacs was idle.
          (setq-default desktop-missing-file-warning nil)
          (setq desktop-dirname             "~/.emacs.cache/"
                desktop-base-file-name      "emacs.desktop"
                desktop-base-lock-name      "lock"
                desktop-path                (list desktop-dirname)
                desktop-save                t
                desktop-files-not-to-save   "^$" ;; reload tramp paths
                desktop-load-locked-desktop t
                desktop-save 'ask-if-new
                desktop-file-name-format 'absolute
                desktop-restore-frames nil
                desktop-restore-in-current-display t
                desktop-restore-forces-onscreen nil
                desktop-auto-save-timeout 60
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
                  tags-file-name
                  register-alist)
                desktop-locals-to-save
                (nconc '(word-wrap line-move-visual) desktop-locals-to-save))
          (setq desktop-files-not-to-save
                "\\(^/[^/:]*:\\|(ftp)$\\)\\|\\(^/tmp/\\)\\|\\(.gpg$\\)")
          (setq desktop-buffers-not-to-save
                (concat "\\(" "^nn\\.a[0-9]+\\|\\ECB\\|\\.log\\|(ftp)"
                        "\\)$")))
  :config (progn
            ;; Don't save Magit and Git related buffers
            (dolist (mode '(magit-mode magit-log-mode dired-mode Info-mode fundamental-mode DocView-mode))
              (add-to-list 'desktop-modes-not-to-save mode))
            (add-to-list 'desktop-files-not-to-save (rx bos "COMMIT_EDITMSG"))

            ;; buffer-display-time is changed when desktop is loaded
            (add-to-list 'desktop-locals-to-save 'buffer-display-time-1)
            (make-variable-buffer-local 'buffer-display-time-1)
            (defun save-buffer-display-time ()
              (mapc (lambda (buf)
                      (with-current-buffer buf
                        (setq buffer-display-time-1
                              (or buffer-display-time (current-time)))))
                    (buffer-list)))
            (add-hook 'desktop-save-hook 'save-buffer-display-time)

            (defun set-buffer-display-time ()
              (mapc (lambda (buf)
                      (with-current-buffer buf
                        (setq buffer-display-time buffer-display-time-1)))
                    (buffer-list)))
            (add-hook 'desktop-after-read-hook 'set-buffer-display-time)
            (desktop-save-mode)))

;; Show-paren-mode: subtle blinking of matching paren (defaults are ugly)
(use-package paren
  :config (progn
            ;; Show paren-mode when off-screen
            (defadvice show-paren-function
                (after show-matching-paren-offscreen activate)
              "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
              (interactive)
              (let* ((cb (char-before (point)))
                     (matching-text (and cb
                                         (char-equal (char-syntax cb) ?\) )
                                         (blink-matching-open))))
                (when matching-text (message matching-text))))

            ;; Opening bracket to be highlighted when the point is on the closing bracket
            (defadvice show-paren-function
                (around show-paren-closing-before
                        activate compile)
              (if (eq (syntax-class (syntax-after (point))) 5)
                  (save-excursion
                    (forward-char)
                    ad-do-it)
                ad-do-it))

            (show-paren-mode 1)))

;; Smartparens
(use-package smartparens
  :load-path "~/.emacs.d/smartparens"
  :pin manual
  :init (progn
          (require 'smartparens-config))
  :config (progn
            (show-smartparens-global-mode 1)))

;; Auto-indent mode
(use-package auto-indent-mode
  :pin manual
  :load-path "~/.emacs.d/auto-indent-mode"
  :init (progn
          (setq auto-indent-indent-style 'conservative)
          (setq auto-indent-on-visit-file nil) ;; do not indent when a file is visit
          (setq auto-indent-blank-lines-on-move nil)
          (setq auto-indent-next-pair-timer-geo-mean (quote ((default 0.0005 0))))
          (setq auto-indent-disabled-modes-list (list (quote vhdl-mode))))
  :config (progn
            (auto-indent-global-mode)))

;; Remember the position where we closed a file
(use-package saveplace
  :init (progn
          (setq save-place-file "~/.emacs.cache/emacs.saveplace")
          (setq-default save-place t)))

;; Better search, similar to vim
(use-package isearch+
  :init (progn
          (require 'isearch-prop))
  :config (progn
            (defun my-isearch-word-at-point ()
              (interactive)
              (call-interactively 'isearch-forward-regexp))

            (defun my-isearch-yank-word-hook ()
              (when (equal this-command 'my-isearch-word-at-point)
                (let ((string (concat "\\<"
                                      (buffer-substring-no-properties
                                       (progn (skip-syntax-backward "w_") (point))
                                       (progn (skip-syntax-forward "w_") (point)))
                                      "\\>")))
                  (if (and isearch-case-fold-search
                           (eq 'not-yanks search-upper-case))
                      (setq string (downcase string)))
                  (setq isearch-string string
                        isearch-message
                        (concat isearch-message
                                (mapconcat 'isearch-text-char-description
                                           string ""))
                        isearch-yank-flag t)
                  (isearch-search-and-update))))
            (add-hook 'isearch-mode-hook 'my-isearch-yank-word-hook)

            ;; Keep the search results in the center in incremental search
            (defadvice isearch-repeat-forward (after isearch-repeat-forward-recenter activate)
              (recenter))
            (defadvice isearch-repeat-backward (after isearch-repeat-backward-recenter activate)
              (recenter))
            (ad-activate 'isearch-repeat-forward)
            (ad-activate 'isearch-repeat-backward)))

;; Search at point
(use-package thingatpt
  :defer 1
  :bind (("M-s ." . my-isearch-forward-symbol-at-point)
         ("M-s ," . my-isearch-forward-word-at-point))
  :config
  (progn
    (defun my-isearch-forward-word-at-point ()
      "Search for word at point."
      (interactive)
      (let ((word (thing-at-point 'word t))
            (bounds (bounds-of-thing-at-point 'word)))
        (if word
            (progn
              (isearch-mode t nil nil nil t)
              (when (< (car bounds) (point))
                (goto-char (car bounds)))
              (isearch-yank-string word))
          (user-error "No word at point"))))

    (defun my-isearch-forward-symbol-at-point ()
      "Search for symbol at point."
      (interactive)
      (let ((symbol (thing-at-point 'symbol t))
            (bounds (bounds-of-thing-at-point 'symbol)))
        (if symbol
            (progn
              (isearch-mode t nil nil nil 'isearch-symbol-regexp)
              (when (< (car bounds) (point))
                (goto-char (car bounds)))
              (isearch-yank-string symbol))
          (user-error "No symbol at point"))))))

;; Turn on subword-mode for non-lispy languages
(use-package subword
  :config (progn (global-subword-mode)
                 (mapc (lambda (mode)
                         (add-hook mode 'subword-mode))
                       '(c-common-mode-hook
                         python-mode-hook
                         js2-mode-hook
                         java-mode-hook)))
  :diminish subword-mode)

;; Uniquify-buffers
(use-package uniquify
  :config (progn
            (setq
             uniquify-buffer-name-style 'post-forward
             uniquify-separator ":"
             ;; rename after killing uniquified
             uniquify-after-kill-buffer-p t
             ;; don't muck with special buffers
             uniquify-ignore-buffers-re "^\\*")))

;; imenu list
(add-to-list 'load-path "~/.emacs.d/imenu-list")
(use-package imenu-list
  :pin manual
  :load-path "~/.emacs.d/imenu-list"
  :config (progn
            (setq imenu-list-size 0.2)
            (setq imenu-list-focus-after-activation t)
            (setq imenu-list-auto-resize t)
            (setq imenu-list-position 'right)))

;; Browse kill ring
(use-package browse-kill-ring
  :pin manual
  :load-path "~/.emacs.d/browse-kill-ring")

;; Line numbers
(use-package linum
  :config (progn
            (defadvice linum-update-window (around linum-dynamic activate)
              (let* ((w (length (number-to-string
                                 (count-lines (point-min) (point-max)))))
                     (linum-format (concat " %" (number-to-string w) "d ")))
                ad-do-it))))

;; Multiple cursors
(use-package multiple-cursors
  :pin manual
  :load-path "~/.emacs.d/multiple-cursors")

(provide 'setup-general)
;;; setup-general.el ends here
