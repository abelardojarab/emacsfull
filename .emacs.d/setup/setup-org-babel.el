;;; setup-org-babel.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Abelardo Jara

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

;; Rendering ditaa
(setq org-ditaa-jar-path (expand-file-name "~/.emacs.d/jar/ditaa.jar"))

;; Rendering plantuml
(setq org-plantuml-jar-path (expand-file-name "~/.emacs.d/jar/plantuml.jar"))
(defun plantuml-render-buffer ()
  (interactive)
  (message "PLANTUML Start rendering")
  (shell-command (concat "java -jar "
                         (expand-file-name "~/.emacs.d/jar/plantuml.jar")
                         " "
                         buffer-file-name))
  (message (concat "PLANTUML Rendered:  " (buffer-name))))



;; for Gnuplot
(add-to-list 'load-path "~/.emacs.d/gnuplot")
(require 'gnuplot)

;; Automatically refresh inline images that are generated from Babel blocks
(add-hook 'org-babel-after-execute-hook (lambda ()
                                          (condition-case nil
                                              (org-display-inline-images)
                                            (error nil)))
          'append)

;; Enable multiple languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (plantuml . t)
   (ditaa . t)
   (dot . t)
   (gnuplot . t)
   (sh . t)
   (R . t)
   (perl . t)
   (ruby . t)
   (python . t)
   (js . t)
   (C . t)
   (haskell . t)))

;; Don't ask for confirmation on every =C-c C-c= code-block compile.
(setq org-confirm-babel-evaluate nil)

;; The next block makes org-babel aware that a lower-case 'r' in a =src= block header should be processed as R.
(add-to-list 'org-src-lang-modes
             '("r" . ess-mode))

;; Abbrev
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))
(define-skeleton skel-org-block-elisp
  "Insert an emacs-lisp block"
  ""
  "#+begin_src emacs-lisp\n"
  _ - \n
  "#+end_src\n")
(define-abbrev org-mode-abbrev-table "elsrc" "" 'skel-org-block-elisp)

(define-skeleton skel-org-block-js
  "Insert a JavaScript block"
  ""
  "#+begin_src js\n"
  _ - \n
  "#+end_src\n")
(define-abbrev org-mode-abbrev-table "jssrc" "" 'skel-org-block-js)

(define-skeleton skel-header-block
  "Creates my default header"
  ""
  "#+TITLE: " str "\n"
  "#+AUTHOR:\n"
  "#+EMAIL:\n"
  "#+LANGUAGE: en\n"
  "#+OPTIONS:  toc:nil num:0\n"
  "#+OPTIONS: author:t email:nil  date:t\n"
  "#+OPTIONS: c:nil d:(not LOGBOOK) e:t f:t inline:t p:nil pri:nil stat:t tags:t\n"
  "#+OPTIONS: tasks:t tex:t timestamp:t todo:t\n"
  "#+DESCRIPTION:\n"
  "#+EXCLUDE_TAGS: noexport\n"
  "#+KEYWORDS:\n"
  "#+SELECT_TAGS: export\n"
  "#+STYLE: <link rel=\"stylesheet\" type=\"text/css\" href=\"http://thomasf.github.io/solarized-css/solarized-light.min.css\" />\n")
(define-abbrev org-mode-abbrev-table "sheader" "" 'skel-header-block)

;; Tell auto-insert what to use for .org files
(define-auto-insert "\\.org" 'skel-header-block)

(provide 'setup-org-babel)
;;; setup-org-babel.el ends here