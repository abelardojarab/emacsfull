;;; setup-modeline.el ---

;; Copyright (C) 2014, 2015, 2016  abelardo.jara-berrocal

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
(when window-system
  (add-to-list 'load-path "~/.emacs.d/nyan-mode")
  (require 'nyan-mode)
  (nyan-mode t))

;; Powerline
(use-package powerline
  :load-path "~/.emacs.d/powerline"
  :init (setq powerline-default-separator 'wave)
  :config (progn
            (add-hook 'desktop-after-read-hook 'powerline-reset)
            (defface modes-ml-face '((t (:background "#002b36" :inherit mode-line)))
              "Powerline face for modes section of the mode-line"
              :group 'powerline)
            (defface file-ml-face '((t (:background "#586e75" :inherit mode-line)))
              "Powerline face for file and branch section of the mode-line"
              :group 'powerline)
            (defface line-ml-face '((t (:background "#93a1a1" :inherit mode-line)))
              "Powerline face for line number section of the mode-line"
              :group 'powerline)
            (defface pos-ml-face '((t (:background "#586e75" :inherit mode-line)))
              "Powerline face for file position section of the mode-line"
              :group 'powerline)
            (defface ml-fill-face '((t (:background "#93a1a1" :inherit mode-line)))
              "Powerline face used to fill the unused portion of the mode-line"
              :group 'powerline)
            (setq-default mode-line-format
                          '("%e"
                            (:eval
                             (let* ((file-name (buffer-file-name (current-buffer)))
                                    (active (powerline-selected-window-active))
                                    (separator-left (intern (format "powerline-%s-%s"
                                                                    (powerline-current-separator)
                                                                    (car powerline-default-separator-dir))))
                                    (separator-right (intern (format "powerline-%s-%s"
                                                                     (powerline-current-separator)
                                                                     (cdr powerline-default-separator-dir))))
                                    (lhs (list (powerline-major-mode 'modes-ml-face 'l)
                                               (powerline-process 'modes-ml-face 'l)
                                               (powerline-minor-modes 'modes-ml-face 'l)
                                               (powerline-raw " " 'modes-ml-face)
                                               (funcall separator-left 'modes-ml-face 'file-ml-face)

                                               (powerline-raw "[" 'file-ml-face)
                                               (powerline-raw (projectile-project-name) 'file-ml-face)
                                               (powerline-raw "] %b %*" 'file-ml-face)
                                               (powerline-raw (concat " "
                                                                      (when (and file-name vc-mode)
                                                                        (concat "(" (-> file-name
                                                                                        vc-working-revision
                                                                                        (string-utils-truncate-to 40))
                                                                                ")")))
                                                              'file-ml-face 'r)
                                               (funcall separator-left 'file-ml-face 'ml-fill-face)))

                                    (rhs (list (powerline-raw global-mode-string 'ml-fill-face 'r)
                                               (funcall separator-right 'ml-fill-face 'pos-ml-face)
                                               (powerline-raw "%p " 'pos-ml-face 'l)
                                               (funcall separator-right 'pos-ml-face 'line-ml-face)

                                               (powerline-raw " %4l " 'line-ml-face 'r))))

                               (concat (powerline-render lhs)
                                       (powerline-fill 'ml-fill-face (powerline-width rhs))
                                       (powerline-render rhs))))))))

(provide 'setup-modeline)
;;; setup-modeline.el ends here
