;;; setup-appearance.el ---                           -*- lexical-binding: t; -*-

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

;; Disable tool-bar and scroll-bar
(when (display-graphic-p)
  (tool-bar-mode -1)
  (set-scroll-bar-mode 'right)
  (scroll-bar-mode -1)
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode 0)))

;; Dont pause screen refresh
(setq redisplay-dont-pause t)

;; Optimization
(setq-default bidi-display-reordering nil)

;; Do not redraw entire frame after suspending.
(setq no-redraw-on-reenter t)

;; Modify toggle truncate lines to avoid messages
(defun toggle-truncate-lines (&optional arg)
  "Toggle truncating of long lines for the current buffer.
When truncating is off, long lines are folded.
With prefix argument ARG, truncate long lines if ARG is positive,
otherwise fold them.  Note that in side-by-side windows, this
command has no effect if `truncate-partial-width-windows' is
non-nil."
  (interactive "P")
  (setq truncate-lines
        (if (null arg)
            (not truncate-lines)
          (> (prefix-numeric-value arg) 0)))
  (force-mode-line-update)
  (unless truncate-lines
    (let ((buffer (current-buffer)))
      (walk-windows (lambda (window)
                      (if (eq buffer (window-buffer window))
                          (set-window-hscroll window 0)))
                    nil t)))
  t)

;; Marker if the line goes beyond the end of the screen (arrows)
(global-visual-line-mode 1)
(diminish 'visual-line-mode)
(add-hook 'text-mode-hook #'turn-on-visual-line-mode)
(setq visual-line-fringe-indicators '(nil right-curly-arrow))
(add-hook 'prog-mode-hook
          (lambda ()
            (visual-line-mode -1)
            (toggle-truncate-lines t)
            (setq truncate-lines t)))
(add-hook 'text-mode-hook
          (lambda ()
            (visual-line-mode -1)
            (toggle-truncate-lines t)
            (setq truncate-lines t)))

;; Get centered text when visual-line-mode is on
(use-package visual-fill-column
  :defer t
  :commands visual-fill-column-mode
  :load-path (lambda () (expand-file-name "visual-fill-column/" user-emacs-directory))
  :config (setq-default visual-fill-column-center-text             t
                        visual-fill-column-fringes-outside-margins nil
                        visual-fill-column-width
                        ;; take Emacs 26 line numbers into account
                        (+ (if (boundp 'display-line-numbers) 6 0)
                           fill-column)))

;; Just like the previous package, this one is also subtle.
;; It highlights characters that exceed a particular column margin. Very useful while coding.
(use-package column-enforce-mode
  :defer t
  :commands column-enforce-mode
  :diminish column-enforce-mode
  :init (setq column-enforce-column 99)
  :load-path (lambda () (expand-file-name "column-enforce-mode/" user-emacs-directory))
  :config (add-hook 'prog-mode-hook #'column-enforce-mode))

;; Faster line numbers
(use-package linum-ex
  :demand t
  :commands linum-mode
  :unless (boundp 'display-line-numbers) ;; Emacs 26 includes native line numbering
  :init (dolist (hook my/linum-modes)
          (add-hook hook (lambda ()
                           ;; turn off `linum-mode' when there are more than 5000 lines
                           (if (and (> (buffer-size)
                                       (* 5000 80)))
                               (linum-mode -1)
                             (linum-mode 1)))))
  :config (progn
            (defadvice linum-update-window (around linum-dynamic activate)
              (let* ((w (length (number-to-string
                                 (count-lines (point-min) (point-max)))))
                     (linum-format (concat " %" (number-to-string w) "d ")))
                ad-do-it))))

;; Highlight line number
(use-package hlinum
  :defer t
  :after linum-ex
  :load-path (lambda () (expand-file-name "hlinum/" user-emacs-directory))
  :commands hlinum-activate)

;; Adaptive scrollbar
(use-package lawlist-scroll-mode
  :defer t
  :if (display-graphic-p)
  :commands lawlist-scroll-bar-mode
  :diminish (lawlist-scroll-bar-mode)
  :init (dolist (hook my/linum-modes)
          (add-hook hook (lambda ()
                           (unless (and (> (buffer-size)
                                           (* 5000 80)))
                             (lawlist-scroll-bar-mode 1))))))

;; All the icons
(use-package all-the-icons
  :defer t
  :if (display-graphic-p)
  :commands all-the-icons-insert
  :load-path (lambda () (expand-file-name "all-the-icons/" user-emacs-directory)))

;; Better characters
(unless standard-display-table
  (setq standard-display-table (make-display-table)))
(set-display-table-slot standard-display-table
                        'selective-display (string-to-vector " ⮷ "))

(provide 'setup-appearance)
;;; setup-appearance.el ends here
