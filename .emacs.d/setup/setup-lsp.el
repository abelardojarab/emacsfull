;;; setup-lsp.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2018  Abelardo Jara-Berrocal

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

;; lsp-mode:  Emacs client/library for the Language Server Protocol
(use-package lsp-mode
  :demand t
  :commands lsp)

(use-package lsp-clients
  :demmand t
  :after lsp
  :commands lsp-define-stdio-client)

;; make sure we have lsp-imenu everywhere we have LSP
(use-package lsp-imenu
  :hook (lsp-after-open . lsp-enable-imenu))

;; lsp-ui: This contains all the higher level UI modules of lsp-mode, like flycheck support and code lenses.
(use-package lsp-ui
  :custom ((lsp-ui-sideline-enable           nil)
       (lsp-ui-doc-enable                nil)
       (lsp-ui-flycheck-enable           t)
       (lsp-ui-imenu-enable              t)
       (lsp-ui-sideline-ignore-duplicate t))
  :hook (lsp-mode . lsp-ui-mode)
  :config (progn
        (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
        (define-key lsp-ui-mode-map [remap xref-find-references]  #'lsp-ui-peek-find-references)))

(provide 'setup-lsp)
;;; setup-lsp.el ends here
