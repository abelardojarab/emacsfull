;;; setup-dired-plugins.el ---                       -*- lexical-binding: t; -*-

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

(use-package async
  :load-path (lambda () (expand-file-name "async/" user-emacs-directory))
  :config (progn
            (require 'dired-async)
            (dired-async-mode 1)))

(use-package direx
  :load-path (lambda () (expand-file-name "direx/" user-emacs-directory))
  :config (progn
            (setq direx:closed-icon "+ ")
            (setq direx:leaf-icon "| ")
            (setq direx:open-icon "> ")
            (define-key direx:direx-mode-map [mouse-1] 'direx:mouse-2)
            (define-key direx:direx-mode-map [mouse-3] 'direx:mouse-1)))

(use-package direx-project
  :load-path (lambda () (expand-file-name "direx/" user-emacs-directory)))

;; highlight dired buffer with K-shell coloring
(use-package dired-k
  :load-path (lambda () (expand-file-name "dired-k/" user-emacs-directory))
  :bind (:map dired-mode-map
              ("K" . dired-k))
  :config (progn
            (add-hook 'dired-initial-position-hook 'dired-k)
            (add-hook 'dired-after-readin-hook #'dired-k-no-revert)))

;; Facility to see images inside dired
(use-package image-dired
  :defer t
  :config (progn
            (setq image-dired-cmd-create-thumbnail-options
                  (replace-regexp-in-string "-strip" "-auto-orient -strip" image-dired-cmd-create-thumbnail-options)
                  image-dired-cmd-create-temp-image-options
                  (replace-regexp-in-string "-strip" "-auto-orient -strip" image-dired-cmd-create-temp-image-options))))

;;preview files in dired
(use-package peep-dired
  :load-path (lambda () (expand-file-name "peep-dired/" user-emacs-directory))
  :defer t ;; don't access `dired-mode-map' until `peep-dired' is loaded
  :bind (:map dired-mode-map
              ("P" . peep-dired)))

(provide 'setup-dired-plugins)
;;; setup-dired-plugins.el ends here
