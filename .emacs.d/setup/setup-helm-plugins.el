;;; setup-helm-plugins.el ---                        -*- lexical-binding: t; -*-

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

;; Helm flycheck
(use-package helm-flycheck
  :load-path "~/.emacs.d/helm-flycheck"
  :config (progn
            (bind-keys :map ctl-x-map
                       ("k" . helm-flycheck))))

;; Helm ls git
(use-package helm-ls-git
  :load-path "~/.emacs.d/helm-ls-git"
  :config (progn
            (bind-keys :map ctl-x-map
                       ("g" . helm-ls-git-ls))))

;; Helm bm support
(use-package helm-bm
  :load-path "~/.emacs.d/helm-bm"
  :config (progn
            (bind-keys :map ctl-x-map
                       ("b" . helm-bookmarks))))

;; Helm themes
(use-package helm-themes
  :load-path "~/.emacs.d/helm-themes")

;; Helm flyspell
(use-package helm-flyspell
  :load-path "~/.emacs.d/helm-flyspell")

;; Helm etags plus
(use-package helm-etags+
  :load-path "~/.emacs.d/helm-etags-plus")

;; Helm swoop
(use-package helm-swoop
  :load-path "~/.emacs.d/helm-etags+"
  :config (progn

            ;; From helm-swoop to helm-multi-swoop-all
            (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

            ;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
            (define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

            ;; Move up and down like isearch
            (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
            (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
            (define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
            (define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

            ;; Save buffer when helm-multi-swoop-edit complete
            (setq helm-multi-swoop-edit-save t)

            ;; If this value is t, split window inside the current window
            (setq helm-swoop-split-with-multiple-windows nil)

            ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
            (setq helm-swoop-split-direction 'split-window-vertically)

            ;; If nil, you can slightly boost invoke speed in exchange for text color
            (setq helm-swoop-speed-or-color nil)

            ;; ;; Go to the opposite side of line from the end or beginning of line
            (setq helm-swoop-move-to-line-cycle t)))

;; Helm dash
(use-package helm-dash
  :load-path "~/.emacs.d/helm-dash"
  :config (progn
            (setq helm-dash-min-length 2)
            (setq helm-dash-docsets-path (expand-file-name "~/.emacs.d/docsets"))
            (setq helm-dash-common-docsets '(
                                             "Markdown"
                                             "LaTeX"
                                             "Python_2"
                                             "Perl"
                                             "C++"
                                             "JavaScript"
                                             "Bash"
                                             "Tcl"
                                             "R"
                                             "Emacs_Lisp"))

            (defun c-doc-hook ()
              (interactive)
              (setq-local helm-dash-docsets '("C" "C++" "Qt")))
            (add-hook 'c-mode-common-hook 'c-doc-hook)

            (defun python-doc-hook ()
              (interactive)
              (setq-local helm-dash-docsets '("Python_2" "NumPy" "SciPy")))
            (add-hook 'python-mode-hook 'python-doc-hook)

            (defun js2-doc-hook ()
              (interactive)
              (setq-local helm-dash-docsets '("JavaScript" "NodeJS" "HTML")))
            (add-hook 'js2-mode-hook 'js2-doc-hook)

            (defun java-doc-hook ()
              (interactive)
              (setq-local helm-dash-docsets '("Java")))
            (add-hook 'java-mode-hook 'java-doc-hook)))

;; Helm bibtex
(use-package helm-bibtex
  :load-path "~/.emacs.d/helm-bibtex"
  :config (progn
            (defun helm-bibtex-cite ()
              "Helm command to cite bibliography."
              (interactive)
              (helm-other-buffer
               '(helm-c-source-bibtex)
               "*helm bibtex:"))))

(provide 'setup-helm-plugins)
;;; setup-helm-plugins.el ends here