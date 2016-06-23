;;; setup-projectile.el ---                          -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Abelardo Jara

;; Author: Abelardo Jara <abelardojara@Abelardos-MacBook-Pro.local>
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

(use-package projectile
  :diminish projectile-mode
  :commands (projectile-global-mode projectile-ignored-projects projectile-compile-project)
  :init (projectile-global-mode)
  :load-path (lambda () (expand-file-name "projectile/" user-emacs-directory))
  :config (progn
            (setq projectile-known-projects-file "~/.emacs.cache/projectile-bookmarks.eld")
            (setq projectile-cache-file "~/.emacs.cache/projectile.cache")
            (setq projectile-enable-caching t)
            (setq projectile-sort-order 'recently-active)
            (setq projectile-indexing-method 'alien)
            (setq projectile-globally-ignored-files (quote ("TAGS" "*.log" "*DS_Store" "node-modules")))))

(use-package helm-projectile
  :load-path (lambda () (expand-file-name "helm-projectile/" user-emacs-directory))
  :config (progn
            (helm-projectile-on)
            (setq projectile-switch-project-action 'helm-projectile)
            (setq projectile-completion-system 'helm)))

(provide 'setup-projectile)
;;; setup-projectile.el ends here
