;;; setup-cedet.el ---

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

;; Make a #define be left-aligned
(setq c-electric-pound-behavior (quote (alignleft)))

;; Enable Semantic
(require 'semantic/ia)
(semantic-mode 1)
(global-semantic-idle-completions-mode)
(set-default 'semantic-case-fold t)
(global-set-key [?\C- ] 'semantic-ia-complete-symbol-menu)
(semantic-load-enable-code-helpers) ;; Enable prototype help and smart completion
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode t)

;; Mouse-3
(global-cedet-m3-minor-mode 1)
(define-key cedet-m3-mode-map "\C-c " 'cedet-m3-menu-kbd)

;; Enable plugins
(global-semanticdb-minor-mode t)
(global-semantic-idle-summary-mode t)
(global-semantic-idle-completions-mode t)
(global-semantic-highlight-func-mode t)
(global-semantic-decoration-mode t)
(global-semantic-idle-local-symbol-highlight-mode t)

;; Enable code folding
(global-semantic-tag-folding-mode)

;; Don't reparse really big buffers.
(setq semantic-idle-scheduler-max-buffer-size 100000)

;; Small workloads
(setq semantic-idle-scheduler-idle-time 5)

;; Big workloads
(setq semantic-idle-scheduler-work-idle-time 60)

;; Default directory
(setq semanticdb-default-save-directory
      (expand-file-name "~/.emacs.cache/semanticdb"))
(setq ede-project-placeholder-cache-file "~/.emacs.cache/ede-projects.el")

;; what to cache
(setq semanticdb-persistent-path '(never))

;; ctags
(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)
(when (cedet-ectag-version-check t)
  (semantic-load-enable-primary-ectags-support))

(require 'semantic/analyze/refs)
(defun ac-complete-semantic-self-insert (arg)
  (interactive "p")
  (self-insert-command arg)
  (ac-complete-semantic))

(defun cc-mode-ac-key-bindings ()
  (local-set-key "." 'ac-complete-semantic-self-insert)
  (local-set-key ">" 'ac-complete-semantic-self-insert)
  (local-set-key ":" 'ac-complete-semantic-self-insert))

(add-hook 'c-mode-common-hook 'cc-mode-ac-key-bindings)
(global-set-key (kbd "M-n") 'ac-complete-semantic-self-insert)

;; smart completions
(require 'semantic/ia)
(setq-mode-local emacs-lisp-mode semanticdb-find-default-throttle
                 '(unloaded system))
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(unloaded system))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(unloaded system))
(setq-mode-local lisp-mode semanticdb-find-default-throttle
                 '(unloaded system))
(setq-mode-local python-mode semanticdb-find-default-throttle
                 '(unloaded system))
(setq-mode-local js2-mode semanticdb-find-default-throttle
                 '(unloaded system))

;; Include settings
(require 'semantic/bovine/c)
(require 'semantic/bovine/gcc)
(require 'semantic/bovine/clang)
(require 'semantic/bovine/scm-by)

(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public" "."
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(setq cedet-sys-include-dirs (list
                              "/usr/include"
                              "/usr/include/c++"))
(let ((include-dirs cedet-user-include-dirs))
  (setq include-dirs (append include-dirs cedet-sys-include-dirs))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
(setq semantic-c-dependency-system-include-path "/usr/include/")

;; Fast jump
(defun semantic-jump-hook ()
  (define-key c-mode-base-map [f1] 'semantic-ia-fast-jump)
  (define-key c-mode-base-map [S-f1]
    (lambda ()
      (interactive)
      (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
          (error "Semantic bookmark ring is currently empty"))
      (let* ((ring (oref semantic-mru-bookmark-ring ring))
             (alist (semantic-mrub-ring-to-assoc-list ring))
             (first (cdr (car alist))))
        (if (semantic-equivalent-tag-p (oref first tag)
                                       (semantic-current-tag))
            (setq first (cdr (car (cdr alist)))))
        (semantic-mrub-switch-tags first)))))
(add-hook 'c-mode-common-hook 'semantic-jump-hook)
(add-hook 'lisp-mode-hook 'semantic-jump-hook)
(add-hook 'python-mode-hook 'semantic-jump-hook)
(add-hook 'js2-mode-hook 'semantic-jump-hook)

;; Fast switch between header and implementation for C/C++
(defun dts-switch-between-header-and-source ()
  "Switch between a c/c++ header (.h) and its corresponding source (.c/.cpp)."
  (interactive)
  (setq bse (file-name-sans-extension buffer-file-name))
  (setq ext (downcase (file-name-extension buffer-file-name)))
  (cond
   ((or (equal ext "h") (equal ext "hpp"))
    ;; first, look for bse.c
    (setq nfn (concat bse ".c"))
    (if (file-exists-p nfn)
        (find-file nfn)
      (progn
        (setq nfn (concat bse ".cpp"))
        (find-file nfn))))
   ;; second condition - the extension is "cpp"
   ((equal ext "cpp")
    (setq nfn (concat bse ".h"))
    (if (file-exists-p nfn)
        (find-file nfn)
      (progn
        (setq nfn (concat bse ".hpp"))
        (find-file nfn))))

   ((equal ext "c")
    (setq nfn (concat bse ".h"))
    (find-file nfn))

   ((equal ext "hxx")
    (setq nfn (concat bse ".cxx"))
    (find-file nfn))

   ((equal ext "cxx")
    (setq nfn (concat bse ".hxx"))
    (find-file nfn))

   ((equal ext "hx")
    (setq nfn (concat bse ".cx"))
    (find-file nfn))

   ((equal ext "cx")
    (setq nfn (concat bse ".hx"))
    (find-file nfn))

   ) ;; cond
  ) ;; defun

(require 'eassist nil 'noerror)
(define-key c-mode-base-map [f12] 'eassist-switch-h-cpp)
(define-key c-mode-base-map [C-f12] 'dts-switch-between-header-and-source)

;; Eassist header switches
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))

;; when skipping to errors, show a few lines above
(setq compilation-context-lines 1)

;; scroll compilation buffer
(setq compilation-scroll-output t)

;; make sure ant's output is in a format emacs likes
(setenv "ANT_ARGS" "-emacs")

;; gdb should use many windows, to make it look like an IDE
(setq gdb-many-windows t
      gdb-max-frames 120)

;; Tags table
(setq tag-table-alist
      '(("\\.il$" . "~/workspace/frametools/TAGS")
        ("\\.ils$" . "~/workspace/frametools/TAGS")))
(setq tags-always-build-completion-table t)

;; working with tags
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(semanticdb-enable-gnu-global-databases 'lisp-mode)
(semanticdb-enable-gnu-global-databases 'python-mode)
(semanticdb-enable-gnu-global-databases 'js2-mode)

;; Function arguments
(add-to-list 'load-path "~/.emacs.d/functions-args")
(require 'function-args)
(fa-config-default)

(provide 'setup-cedet)
;;; setup-cedet.el ends here
