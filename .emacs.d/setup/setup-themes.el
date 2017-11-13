;;; setup-themes.el ---                              -*- lexical-binding: t; -*-

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

;; Override zenburn colors
(use-package zenburn-theme
  :init  (defvar zenburn-override-colors-alist
           '(("zenburn-bg-2"  . "#000000")
             ("zenburn-bg-1"  . "#101010")
             ("zenburn-bg-05" . "#282828")
             ("zenburn-bg"    . "#2F2F2F")
             ("zenburn-bg+05" . "#383838")
             ("zenburn-bg+1"  . "#3F3F3F")
             ("zenburn-bg+2"  . "#4F4F4F")
             ("zenburn-bg+3"  . "#5F5F5F"))))

;; Font-core library
(use-package font-core)

;; Solarized theme
(use-package solarized
  :config (setq solarized-scale-org-headlines nil))

;; Choose different themes depending if we are using GUI or not
;; Console colors are enabled if "export TERM=xterm-256color" is added into .bashrc
(load-theme my/emacs-theme)

;; Remember last theme
(use-package remember-last-theme
  :if (display-graphic-p)
  :load-path (lambda () (expand-file-name "remember-last-theme/" user-emacs-directory))
  :config (remember-last-theme-enable))

(provide 'setup-themes)
;;; setup-themes.el ends here
