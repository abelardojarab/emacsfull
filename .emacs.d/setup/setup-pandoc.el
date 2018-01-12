;;; setup-pandoc.el ---                              -*- lexical-binding: t; -*-

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

;; Pandoc
(use-package pandoc-mode
  :load-path (lambda () (expand-file-name "pandoc-mode/" user-emacs-directory))
  :config (progn
            (setq pandoc-data-dir "~/.emacs.cache/pandoc/")
            (add-hook 'pandoc-mode-hook   #'pandoc-load-default-settings)
            (add-hook 'markdown-mode-hook #'pandoc-load-default-settings)
            (add-hook 'org-mode-hook      #'pandoc-load-default-settings)
            (add-hook 'pandoc-mode-hook   #'pandoc-load-default-settings)))

;; Org integration with pandoc
(use-package ox-pandoc
  :if (executable-find "pandoc")
  :load-path (lambda () (expand-file-name "ox-pandoc/" user-emacs-directory))
  :config (progn

            ;; Prefer xelatex
            (if (executable-find "xelatex")
                (setq org-pandoc-options '((standalone . t)) ; Default options
                      ;; Special settings for beamer-pdf and latex-pdf exporters
                      org-pandoc-options-for-beamer-pdf
                      '((latex-engine . "xelatex"))
                      org-pandoc-options-for-latex-pdf
                      '((latex-engine . "xelatex"))))

            ;; Use external css for html5
            (let ((stylesheet (concat user-emacs-directory
                                      "/styles/github-pandoc.css")))
              (setq org-pandoc-options-for-html5
                    `((css . ,(concat "file://" stylesheet)))))))

(provide 'setup-pandoc)
;;; setup-pandoc.el ends here
