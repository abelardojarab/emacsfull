;;; setup-swiper.el ---                              -*- lexical-binding: t; -*-

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

(use-package swiper
  :defer t
  :commands (swiper swiper-all ivy-read ivy-mode)
  :load-path (lambda () (expand-file-name "swiper/" user-emacs-directory))
  :config (progn
            (set-variable 'ivy-on-del-error-function '(lambda()))
            (setq ivy-use-virtual-buffers t)
            (setq ivy-height 5)))

(use-package swiper-helm
  :defer t
  :after swiper
  :bind (:map ctl-x-map
              ("s" . swiper-helm))
  :commands swiper-helm
  :load-path (lambda () (expand-file-name "swiper-helm/" user-emacs-directory)))
(provide 'setup-swiper)
;;; setup-swiper.el ends here
