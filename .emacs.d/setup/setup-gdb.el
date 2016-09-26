;;; setup-gdb.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Lab

;; Author: Lab <lab@cpt-swdev1.jf.intel.com>
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

(use-package gdb-mi
  :config (progn

            ;; gdb should use multi-windowed like all the other debuggers out there.
            (setq gdb-many-windows t
                  gdb-show-main t
                  gdb-max-frames 120)

            ;; This module sets up the same function keys as Eclipse, F5 to F8 (run slow to fast):
            ;;
            ;; -------------- -------------------------------------------------------
            ;; Key            Definition
            ;; -------------- -------------------------------------------------------
            ;; F5             Step into (s)
            ;; F6             Next (n)
            ;; F7             Run to the end of the function
            ;; F8             Run
            ;;
            ;; Functions:
            ;;
            ;; - M-x `gdb-few-windows': split the current frame into 3 windows stacked up
            ;;   on top of each other: gdb command line, source code, program IO.
            ;;   This function completes the native `gdb-many-windows' which displays 6
            ;;   windows (stack, breakpoints, local variables or registers).

            ;; Highlight the current line in the source window.
            (defconst gdb-highlight-face 'highlight
              "face to use for highlighting the current line")

            (defvar gud-overlay
              (let ((ov (make-overlay (point-min) (point-min))))
                (overlay-put ov 'face gdb-highlight-face)
                ov)
              "Overlay variable for GUD highlighting.")

            (defadvice gud-display-line (after my-gud-highlight act)
              "Highlight the current line."
              (let ((ov gud-overlay)
                    (bf (gud-find-file true-file)))
                ;; TODO: should use with-current-buffer?
                (save-excursion
                  (set-buffer bf)
                  (move-overlay ov (line-beginning-position) (line-end-position)
                                (current-buffer)))))

            (defun gud-kill-buffer ()
              (if (eq major-mode 'gud-mode)
                  (delete-overlay gud-overlay)))

            (add-hook 'kill-buffer-hook 'gud-kill-buffer)

            ;; Keep the current line in sync with the point and in the center of the
            ;; buffer. Otherwise the current line may disappear from the buffer as you step
            ;; into the code. I don't know why this is not the default.
            (defadvice gud-display-line (after gud-display-line-centered activate)
              "Center the current line in the source code window"
              (when (and gud-overlay-arrow-position gdb-source-window)
                (with-selected-window gdb-source-window
                                        ; (marker-buffer gud-overlay-arrow-position)
                  (save-restriction
                    ;; Compiler-happy equivalent to (goto-line (ad-get-arg 1))
                    (goto-char (point-min))
                    (forward-line (1- (ad-get-arg 1)))
                    (recenter)))))

            (defun gdb-few-windows ()
              "Slit the current frame into 3 windows: gdb command line,
source code, and program IO."
              (interactive)
              (switch-to-buffer gud-comint-buffer)
              (delete-other-windows)
              (let ((win0 (selected-window))
                    (win1 (split-window nil ( / ( * (window-height) 3) 4)))
                    (win2 (split-window nil ( / (window-height) 3))))
                ;; IO
                (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io) nil win1)
                ;; Source code or current buffer if not found.
                (set-window-buffer
                 win2
                 (if gud-last-last-frame
                     (gud-find-file (car gud-last-last-frame))
                   (if gdb-main-file
                       (gud-find-file gdb-main-file)
                     ;; Put the buffer list in window if we cannot find a source file...
                     (list-buffers-noselect))))
                (setq gdb-source-window (selected-window))
                ;; Give focus to the comint window.
                (set-window-dedicated-p win0 t)
                (select-window win0)))

            ;; Keys
            (define-key gud-minor-mode-map [(f5)] #'gud-step)
            (define-key gud-minor-mode-map [(f6)] #'gud-next)
            (define-key gud-minor-mode-map [(f7)] #'gud-finish)
            (define-key gud-minor-mode-map [(f8)] #'gud-cont)))

(provide 'setup-gdb)
;;; setup-gdb.el ends here
