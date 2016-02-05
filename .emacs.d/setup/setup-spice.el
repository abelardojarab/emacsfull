;;; setup-post.el ---                                -*- lexical-binding: t; -*-

;; Copyright (C) 2015, 2016  abelardo.jara-berrocal

;; Author: abelardo.jara-berrocal <ajaraber@plxc20122.pdx.intel.com>
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

;; Spice mode
(add-to-list 'load-path "~/.emacs.d/spice-mode")
(require 'spice-mode)
(add-to-list 'auto-mode-alist '("\\.sp\\'" . spice-mode))
(add-to-list 'auto-mode-alist '("\\.scs\\'" . spice-mode))

(provide 'setup-spice)
;;; setup-post.el ends here