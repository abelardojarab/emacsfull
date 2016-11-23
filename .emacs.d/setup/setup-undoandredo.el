;;; setup-undoandredo.el ---                         -*- lexical-binding: t; -*-

;; Copyright (C) 2016  abelardo.jara-berrocal

;; Author: abelardo.jara-berrocal <ajaraber@plxcj9063.pdx.intel.com>
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

;; Redo
(use-package redo+
  :bind ("C-y" . redo))

;; Better undo
(use-package undo-tree
  :bind (("C-S-z" . undo-tree-redo)
         ("C-z" . undo-tree-undo))
  :config (progn
            (setq undo-no-redo t)
            (setq undo-tree-visualizer-diff t)
            (setq undo-tree-visualizer-timestamps t)
            (setq undo-tree-auto-save t)
            (setq undo-tree-history-directory-alist
                  '((".*" . "~/.emacs.cache/undo-tree")))
            (global-undo-tree-mode)
            (diminish 'undo-tree-mode)))

(provide 'setup-undoandredo)
;;; setup-undoandredo.el ends here
