;;; setup-dired-plugins.el ---                       -*- lexical-binding: t; -*-

;; Copyright (C) 2016, 2017, 2018  Abelardo Jara-Berrocal

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

(use-package dired-sidebar
  :defer t
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :after (dired all-the-icons-dired)
  :commands (dired-sidebar-toggle-sidebar)
  :config  (progn
             (if (display-graphic-p)
                 (setq dired-sidebar-theme 'icons)
               (setq dired-sidebar-theme 'nerd))
             (setq dired-sidebar-use-term-integration t
                   dired-sidebar-use-all-the-icons    t
                   dired-sidebar-use-custom-font      t)))

;; neotree side bar
(use-package neotree
  :defer t
  :commands (neotree-toggle)
  :bind (:map neotree-mode-map
              (("<C-return>" . neotree-change-root)
               ("C"          . neotree-change-root)
               ("c"          . neotree-create-node)
               ("+"          . neotree-create-node)
               ("d"          . neotree-delete-node)
               ("r"          . neotree-rename-node)))
  :load-path (lambda () (expand-file-name "neotree/" user-emacs-directory))
  :config (progn
            ;; every time when the neotree window is
            ;; opened, it will try to find current
            ;; file and jump to node.
            (setq-default neo-smart-open    t)
            ;; Don't allow neotree to be the only open window
            (setq-default neo-dont-be-alone t)))

(provide 'setup-dired-plugins)
;;; setup-dired-plugins.el ends here
