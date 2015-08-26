;;; setup-modeline.el ---

;; Copyright (C) 2014, 2015  abelardo.jara-berrocal

;; Author: abelardo.jara-berrocal <ajaraber@plxc25288.pdx.intel.com>
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

;; Nyan cat
(add-to-list 'load-path "~/.emacs.d/nyan-mode")
(require 'nyan-mode)
(nyan-mode t)

(add-to-list 'load-path "~/.emacs.d/powerline")
(require 'powerline)
(powerline-center-theme)
(set-face-attribute 'mode-line nil
                    :foreground "black"
                    :background "grey40"
                    :box nil)

;; Better Alt-x
(if (and (= emacs-major-version 24) (= emacs-minor-version 2))
    ;; Use smex3
    (add-to-list 'load-path "~/.emacs.d/smex2")
  ;; Use smex2
  (add-to-list 'load-path "~/.emacs.d/smex")
  ) ;; if
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(provide 'setup-modeline)
;;; setup-modeline.el ends here
