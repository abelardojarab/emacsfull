;;; setup-themes.el ---                              -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Abelardo Jara-Berrocal

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

;; assorted emacs color themes
(add-to-list 'load-path (expand-file-name "emacs-color-themes/themes/" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "emacs-color-themes/themes/" user-emacs-directory))

;; Add themes
(dolist (my/theme
         (list
          "darktooth"
          "gruber-darker"
          "moe"
          "flatui"
          "borland-blue"
          "professional"
          "intellij"
          "darcula"
          "faff"
          "plan9"
          "creamsody"
          "ample"
          "monokai"
          "atom-one-dark"
          "zenburn"
          "material"
          "leuven"
          "zerodark"
          "eink"
          "danneskjold"
          "minimal"
          "goose"
          "tao"
          "white-sand"
          "monotropic"
          "spike"
          "dracula"
          "grandshell"
          "monochrome"
          "spacemacs"
          "apropospriate"))
  (progn
    (add-to-list 'load-path (expand-file-name
                             (concat "themes/"
                                     my/theme
                                     "-theme/")
                             user-emacs-directory))
    (add-to-list 'custom-theme-load-path (expand-file-name
                                          (concat "themes/"
                                                  my/theme
                                                  "-theme/")
                                          user-emacs-directory))))

;; Tomorrow theme
(add-to-list 'load-path (expand-file-name "themes/sanityinc-tomorrow-theme/" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes/sanityinc-tomorrow-theme/" user-emacs-directory))
(require 'color-theme-sanityinc-tomorrow)

;; Solarized theme
(add-to-list 'load-path (expand-file-name "themes/solarized-theme/" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes/solarized-theme" user-emacs-directory))
(require 'solarized)
(setq solarized-scale-org-headlines nil)

(provide 'setup-themes)
;;; setup-themes.el ends here
