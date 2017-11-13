;;; setup-org-plugins.el ---                         -*- lexical-binding: t; -*-

;; Copyright (C) 2016, 2017  Abelardo Jara-Berrocal

;; Author: Abelardo Jara-Berrocal <abelardojara@ubuntu-MacBookPro>
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

;; Org Table of Contents
(use-package toc-org
  :load-path (lambda () (expand-file-name "toc-org/" user-emacs-directory))
  :config(add-hook 'org-mode-hook 'toc-org-enable))

;; Nice bulleted lists
(use-package org-bullets
  :if (display-graphic-p)
  :load-path (lambda () (expand-file-name "org-bullets/" user-emacs-directory))
  :config (progn
            (setq org-bullets-bullet-list '("●" "►" "•" "•"))
            (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))))

;; Seek headlines or content inside org buffers
(use-package org-seek
  :defer t
  :load-path (lambda () (expand-file-name "org-seek/" user-emacs-directory))
  :commands (org-seek-string org-seek-regexp org-seek-headlines))

;; Automated bulleting
(use-package org-autolist
  :load-path (lambda () (expand-file-name "org-autolist/" user-emacs-directory))
  :config (add-hook 'org-mode-hook (lambda () (org-autolist-mode 1))))

;; ASCII doc exporter
(use-package ox-asciidoc
  :load-path (lambda () (expand-file-name "ox-asciidoc/" user-emacs-directory)))

;; Export org-mode to Google I/O HTML5 slides
(use-package ox-ioslide
  :load-path (lambda () (expand-file-name "ox-ioslide/" user-emacs-directory))
  :config (use-package ox-ioslide-helper))

(provide 'setup-org-plugins)
;;; setup-org-plugins.el ends here
