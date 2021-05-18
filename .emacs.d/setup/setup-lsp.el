;;; setup-lsp.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2021  Abelardo Jara-Berrocal

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

(defconst lsp--completion-item-kind
  [nil
   "Text"
   "Method"
   "Function"
   "Constructor"
   "Field"
   "Variable"
   "Class"
   "Interface"
   "Module"
   "Property"
   "Unit"
   "Value"
   "Enum"
   "Keyword"
   "Snippet"
   "Color"
   "File"
   "Reference"
   "Folder"
   "EnumMember"
   "Constant"
   "Struct"
   "Event"
   "Operator"
   "TypeParameter"])

;; lsp-mode:  Emacs client/library for the Language Server Protocol
(use-package lsp-mode
  :demand t
  :commands (lsp
             lsp-deferred
             lsp-enable-which-key-integration)
  :hook (((c-mode c++-mode)    . lsp)
         (python-mode          . lsp)
         (js2-mode             . lsp)
         (lsp-mode             . lsp-lens-mode))
  :custom ((lsp-completion-show-detail       t)
           (lsp-completion-show-kind         t)
           (lsp-semantic-highlightning       t)
           (lsp-prefer-flymake               nil)
           (lsp-pyls-plugins-pylint-enabled  nil)
           (lsp-auto-guess-root              nil)
           (lsp-auto-configure               t)
           (lsp-enable-completion-at-point   t)
           (lsp-enable-xref                  t)
           (lsp-eldoc-enable-hover           t)
           (lsp-eldoc-render-all             nil)
           (lsp-enable-snippet               t)
           (lsp-file-watch-threshold         (* 1024 1024)))
  :init (defun lsp--resolve-completion (item)
          "Resolve completion ITEM."
          (cl-assert item nil "Completion item must not be nil")
          (or (-first 'identity
                      (condition-case _err
                          (lsp-foreach-workspace
                           (when (lsp:completion-options-resolve-provider?
                                  (lsp--capability :completionProvider))
                             (lsp-request "completionItem/resolve" item)))
                        (error)))
              item))
  :config (progn
            (add-hook 'lsp-mode-hook
                      (lambda ()
                        (setq-local company-format-margin-function
                                    #'company-vscode-dark-icons-margin)))

            (setq read-process-output-max (* 1024 1024 10))
            (setq lsp-completion-provider :capf)

            ;; ignored directories
            (dolist (dir '(
                           "[/\\\\]\\.venv$"
                           "[/\\\\]\\.mypy_cache$"
                           "[/\\\\]__pycache__$"
                           "[/\\\\]\\.vscode$"
                           ))
              (push dir lsp-file-watch-ignored))

            ;; Prefer pyright if available
            (if (executable-find "pyright")
                (setq lsp-pyls-configuration-sources ["pyright"]))

            ;; `-background-index' requires clangd v8+!
            (setq lsp-clients-clangd-args '("-j=5" "-background-index" "-log=error"))))

;; Fix bug on dash/lsp
(load (expand-file-name "no-autoloads/dash.el" user-emacs-directory))
(load (expand-file-name "no-autoloads/lsp-mode.el" user-emacs-directory))
(load (expand-file-name "no-autoloads/helm-xref.el" user-emacs-directory))

;; Breadcrumbs (conflicts with tabbar)
(use-package lsp-headerline
  :defer t
  :commands lsp-headerline-breadcrumb-mode
  :custom ((lsp-headerline-breadcrumb-enable nil)
           (lsp-headerline-breadcrumb-icons-enable t))
  :config (setq lsp-headerline-breadcrumb-segments '(project file symbols)))

;; Enable lsp-clients
(use-package lsp-clients
  :demand t
  :after lsp-mode
  :commands lsp-define-stdio-client)

;; make sure we have lsp-imenu everywhere we have LSP
(use-package lsp-imenu
  :hook (lsp-after-open . lsp-enable-imenu))

;; flycheck integration & higher level UI modules
(use-package lsp-ui
  :diminish t
  :custom ((lsp-ui-sideline-enable               nil)
           (lsp-ui-doc-enable                    nil)
           (lsp-ui-doc-header                    t)
           (lsp-ui-doc-include-signature         t)
           (lsp-ui-doc-position                  'bottom)
           (lsp-ui-flycheck-enable               t)
           (lsp-ui-imenu-enable                  t)
           (lsp-ui-sideline-ignore-duplicate     t)
           (lsp-ui-sideline-show-symbol          nil)
           (lsp-ui-sideline-show-diagnostics     t)
           (lsp-ui-sideline-show-code-actions    t)
           (lsp-ui-peek-enable                   t)
           (lsp-ui-peek-always-show              t)
           (lsp-ui-doc-delay                     0.7 "higher than eldoc delay"))
  :hook (lsp-after-open . lsp-ui-mode)
  :bind (:map lsp-ui-mode-map
              ("M-;"                         . company-lsp)
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references]  . lsp-ui-peek-find-references)
              ("M-."                         . lsp-ui-peek-find-definitions)
              ("M-?"                         . lsp-ui-peek-find-references)
              ("M-/"                         . lsp-ui-imenu))
  :config (progn
            (if (display-graphic-p)
                (progn
                  (setq lsp-ui-sideline-code-actions-prefix "ℹ ")
                  (when (require 'xwidget nil 'noerror)
                    (setq lsp-ui-doc-use-webkit t))))

            ;; Information on right fringe
            (add-to-list 'lsp-ui-doc-frame-parameters '(right-fringe . 8))

            ;; `C-g'to close doc
            (advice-add #'keyboard-quit :before #'lsp-ui-doc-hide)

            ;; Reset `lsp-ui-doc-background' after loading theme
            (add-hook 'after-load-theme-hook
                      (lambda ()
                        (setq lsp-ui-doc-border (face-foreground 'default))
                        (set-face-background 'lsp-ui-doc-background
                                             (face-background 'tooltip))))

            ;; WORKAROUND Hide mode-line of the lsp-ui-imenu buffer
            ;; @see https://github.com/emacs-lsp/lsp-ui/issues/243
            (defadvice lsp-ui-imenu (after hide-lsp-ui-imenu-mode-line activate)
              (setq mode-line-format nil)))
  :hydra (hydra-lsp (:exit t :hint nil)
                    "
 Buffer^^               Server^^                   Symbol
-------------------------------------------------------------------------------------
 [_f_] format           [_M-r_] restart            [_d_] declaration  [_i_] implementation  [_o_] documentation
 [_m_] imenu            [_S_]   shutdown           [_D_] definition   [_t_] type            [_r_] rename
 [_x_] execute action   [_M-s_] describe session   [_R_] references   [_s_] signature"
                    ("d" lsp-find-declaration)
                    ("D" lsp-ui-peek-find-definitions)
                    ("R" lsp-ui-peek-find-references)
                    ("i" lsp-ui-peek-find-implementation)
                    ("t" lsp-find-type-definition)
                    ("s" lsp-signature-help)
                    ("o" lsp-describe-thing-at-point)
                    ("r" lsp-rename)

                    ("f" lsp-format-buffer)
                    ("m" lsp-ui-imenu)
                    ("x" lsp-execute-code-action)

                    ("M-s" lsp-describe-session)
                    ("M-r" lsp-restart-workspace)
                    ("S" lsp-shutdown-workspace)))

(use-package lsp-metals-treeview
  :disabled t
  :custom (lsp-metals-treeview-show-when-views-received t)
  :config (lsp-metals-treeview-enable t))

(use-package lsp-modeline
  :defer t
  :commands (lsp-modeline-diagnostics-mode
             lsp-modeline-workspace-status-mode))

(provide 'setup-lsp)
;;; setup-lsp.el ends here
