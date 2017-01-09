;;; setup-font-lock.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2016, 2017  Abelardo Jara-Berrocal

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

;; Syntax coloring
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size (* 512 512))
(setq font-lock-multiline t)
(defun global-font-lock-mode-check-buffers () nil)

;; Do not fontify large files
(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 512 512))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)))
(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

;; In programming modes, make sure things like FIXME and TODO are highlighted so they stand out:
(defun my/add-watchwords ()
  "Highlight FIXME, TODO, and NOCOMMIT in code TODO"
  (font-lock-add-keywords
   nil '(("\\<\\(FIXME:?\\|TODO:?\\|NOCOMMIT:?\\)\\>"
          1 '((:foreground "#d7a3ad") (:weight bold)) t))))
(add-hook 'prog-mode-hook #'my/add-watchwords)

;; Displaying image tooltips in Emacs
;; http://kitchingroup.cheme.cmu.edu/blog/2016/03/21/Displaying-image-overlays-on-image-filenames-in-Emacs/
(defvar image-tooltip-re (concat  "\\(?3:'\\|\"\\)\\(?1:.*\\."
                                  (regexp-opt '("png" "PNG" "JPG" "jpeg"
                                                "jpg" "JPEG" "eps" "EPS"
                                                "pdf" "PDF" "ps" "PS"))
                                  "\\)\\(?:\\3\\)")
  "Regexp to match image filenames in quotes")

;; Tooltip creation
(defun image-tooltip (window object position)
  (save-excursion
    (goto-char position)
    (let (beg end imgfile img s)
      (while (not (looking-at image-tooltip-re))
        (forward-char -1))
      (setq imgfile (match-string-no-properties 1))
      (when (file-exists-p imgfile)
        (setq img (create-image (expand-file-name imgfile)
                                'imagemagick nil :width 200))
        (propertize "Look in the minibuffer"
                    'display img)))))

;; Enable tooltip in graphical mode
(if (display-graphic-p)
    (font-lock-add-keywords
     nil
     `((,image-tooltip-re
        0 '(face font-lock-keyword-face
                 help-echo image-tooltip)))))

;; Colorize color strings
(use-package rainbow-mode
  :defer t
  :commands rainbow-mode
  :load-path (lambda () (expand-file-name "rainbow-mode/" user-emacs-directory))
  :diminish rainbow-mode
  :config (progn (mapc (lambda (mode)
                         (add-hook mode 'rainbow-mode))
                       '(prog-mode-hook text-mode-hook markdown-mode-hook org-mode-hook))))

(provide 'setup-font-lock)
;;; setup-font-lock.el ends here
