;;; setup-bookmarks.el ---                      -*- lexical-binding: t; -*-

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

;; Bookmark Plus
(use-package bookmark+
  :demand t
  :load-path (lambda () (expand-file-name "bookmark+/" user-emacs-directory))
  :config (progn
            (setq bookmark-save-flag 1)
            (setq-default bookmark-default-file (concat (file-name-as-directory my/emacs-cache-dir)
                                                        "bookmarks"))))

;; Visible bookmarks
(use-package bm
  :defer t
  :load-path (lambda () (expand-file-name "bm/" user-emacs-directory))
  :commands (bm-repository-load bm-buffer-restore bm-buffer-save bm-buffer-save-all bm-repository-save bm-toggle)
  :bind (;; bind left mouse clicks and scrolls in left margin/fringe
         ("<left-fringe> <mouse-5>" . bm-next-mouse)
         ("<left-margin> <mouse-5>" . bm-next-mouse)
         ("<left-fringe> <mouse-4>" . bm-previous-mouse)
         ("<left-margin> <mouse-4>" . bm-previous-mouse)
         ("<left-fringe> <mouse-1>" . bm-toggle-mouse)
         ("<left-margin> <mouse-1>" . bm-toggle-mouse))
  :init (progn

          ;; bm-repository
          (setq bm-repository-file (concat (file-name-as-directory
                                            my/emacs-cache-dir) "bm-repository"))

          ;; Loading the repository from file when on start up.
          (add-hook 'after-init-hook #'bm-repository-load)

          ;; Restoring bookmarks when on file find.
          (add-hook 'find-file-hook #'bm-buffer-restore)

          ;; Saving bookmark data on killing a buffer
          (add-hook 'kill-buffer-hook #'bm-buffer-save)

          ;; Saving the repository to file when on exit.
          (add-hook 'kill-emacs-hook (lambda ()
                                       (progn (bm-buffer-save-all)
                                              (bm-repository-save)))))
  :config (progn
            ;; Add fringe only if display is graphic (GUI)
            (when (display-graphic-p)
               (define-fringe-bitmap 'bm-marker-left [#xF8    ; ▮ ▮ ▮ ▮ ▮ 0 0 0
                                                      #xFC    ; ▮ ▮ ▮ ▮ ▮ ▮ 0 0
                                                      #xFE    ; ▮ ▮ ▮ ▮ ▮ ▮ ▮ 0
                                                      #x0F    ; 0 0 0 0 ▮ ▮ ▮ ▮
                                                      #x0F    ; 0 0 0 0 ▮ ▮ ▮ ▮
                                                      #xFE    ; ▮ ▮ ▮ ▮ ▮ ▮ ▮ 0
                                                      #xFC    ; ▮ ▮ ▮ ▮ ▮ ▮ 0 0
                                                      #xF8])) ; ▮ ▮ ▮ ▮ ▮ 0 0 0

            (setq bm-highlight-style 'bm-highlight-line-and-fringe)
            (setq bm-restore-repository-on-load t)

            ;; make bookmarks persistent as default
            (setq-default bm-buffer-persistence t)

            ;; search all open buffers for bookmarks
            (setq bm-cycle-all-buffers t)))

(provide 'setup-bookmarks)
;;; setup-bookmarks.el ends here
