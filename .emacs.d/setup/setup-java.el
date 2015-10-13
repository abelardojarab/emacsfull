;;; setup-java.el ---                                -*- lexical-binding: t; -*-

;; Copyright (C) 2015  abelardo.jara-berrocal

;; Author: abelardo.jara-berrocal <ajaraber@plxc26391.pdx.intel.com>
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

(add-to-list 'load-path "~/.emacs.d/ajc-java-complete/")
(require 'ajc-java-complete-config)
(add-hook 'java-mode-hook 'ajc-java-complete-mode)
(setq ajc-tag-file-list (list (expand-file-name "~/.emacs.d/ajc-java-complete/java_base.tag")))

(provide 'setup-java)
;;; setup-java.el ends here