;;; setup-project.el ---

;; Copyright (C) 2014  abelardo.jara-berrocal

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

;; Helm
(add-to-list 'load-path "~/.emacs.d/helm")
(require 'helm-config)

;; Helm ls git
(add-to-list 'load-path "~/.emacs.d/helm-ls-git")
(require 'helm-ls-git)
(global-set-key (kbd "C-<f6>") 'helm-ls-git-ls)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)

;; Helm bm support
(add-to-list 'load-path "~/.emacs.d/helm-bm")
(require 'helm-bm) ;; Not necessary if using ELPA package
(global-set-key (kbd "C-c b") 'helm-bm)

;; Helm themes
(add-to-list 'load-path "~/.emacs.d/helm-themes")
(require 'helm-themes)

;; Async
(require 'dired+)
(add-to-list 'load-path "~/.emacs.d/async")
(when (require 'dired-aux)
  (require 'dired-async))

;; iMenu
(set-default 'imenu-auto-rescan t)
(add-hook 'lisp-mode-hook
          (lambda ()
            (setq imenu-create-index-function 'imenu-example--create-lisp-index)
            (setq imenu-generic-expression scheme-imenu-generic-expression)))

(add-hook 'emacs-lisp-mode-hook 'imenu-add-menubar-index)
(add-hook 'lisp-mode-hook 'imenu-add-menubar-index)
(add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'reftex-mode-hook 'imenu-add-menubar-index)
(add-hook 'latex-mode-hook 'imenu-add-menubar-index)
(add-hook 'org-mode-hook 'imenu-add-menubar-index)
(add-hook 'python-mode-hook 'imenu-add-menubar-index)

;; Enable which-function-mode for selected major modes
(setq which-func-modes '(ecmascript-mode python-mode emacs-lisp-mode lisp-mode
                                         c-mode c++-mode makefile-mode sh-mode))
(which-function-mode t)
(add-hook 'js2-mode-hook
          (lambda () (which-function-mode t)))
(add-hook 'python-mode-hook
          (lambda () (which-function-mode t)))
(add-hook 'c-mode-common-hook
          (lambda () (which-function-mode t)))
(add-hook 'lisp-mode-hook
          (lambda () (which-function-mode t)))
(add-hook 'emacs-lisp-mode-hook
          (lambda () (which-function-mode t)))

;; Project management
(add-to-list 'load-path "~/.emacs.d/ack-and-a-half")
(add-to-list 'load-path "~/.emacs.d/projectile")
(add-to-list 'load-path "~/.emacs.d/perspective")
(require 'ack-and-a-half)
;; (require 'perspective)
(require 'projectile)
(setq projectile-cache-file "~/.emacs.cache/projectile.cache")
(setq projectile-known-projects-file "~/.emacs.cache/projectile-bookmarks.eld")
(setq projectile-enable-caching t)
(setq projectile-keymap-prefix (kbd "C-c C-p"))
(setq projectile-remember-window-configs t)
(unless (string-equal system-type "windows-nt")
  (setq projectile-indexing-method 'git)
  ) ;; unless
(projectile-global-mode t)

;; cmake autocomplete/flycheck
(add-to-list 'load-path "~/.emacs.d/cpputils-cmake")
(require 'cpputils-cmake)

;; cmake IDE
(add-to-list 'load-path "~/.emacs.d/cmake-ide")
(require 'cmake-ide)
(cmake-ide-setup)

;; cmake IDE
(add-to-list 'load-path "~/.emacs.d/helm-dash")
(require 'helm-dash)

(defun jwintz/dash-path (docset)
  (if (string= docset "OpenGL_2")
      (concat (concat helm-dash-docsets-path "/") "OpenGL2.docset")
    (if (string= docset "OpenGL_3")
        (concat (concat helm-dash-docsets-path "/") "OpenGL3.docset")
      (if (string= docset "OpenGL_4")
          (concat (concat helm-dash-docsets-path "/") "OpenGL4.docset")
        (if (string= docset "Emacs_Lisp")
            (concat (concat helm-dash-docsets-path "/") "Emacs Lisp.docset")
          (concat
           (concat
            (concat
             (concat helm-dash-docsets-path "/")
             (nth 0 (split-string docset "_")))) ".docset"))))))

(defun jwintz/dash-install (docset)
  (unless (file-exists-p (jwintz/dash-path docset))
    (helm-dash-install-docset docset)))

(defun jwintz/dash-hook ()
  (local-set-key "\C-h\C-df" 'helm-dash)
  (local-set-key "\C-h\C-dg" 'helm-dash-at-point)
  (local-set-key "\C-h\C-dh" 'helm-dash-reset-connections))

(defun jwintz/dash-hook-java ()
  (interactive)
  (setq-local helm-dash-docsets '("Java_SE8")))

(setq helm-dash-docsets-path (format "%s/.emacs.d/docsets" (getenv "HOME")))
(setq helm-dash-common-docsets '("C" "C++"))
(setq helm-dash-min-length 2)

(add-hook 'prog-mode-hook 'jwintz/dash-hook)
(add-hook 'java-mode-hook 'jwintz/dash-hook-java)

(provide 'setup-project)
;;; setup-project.el ends here
