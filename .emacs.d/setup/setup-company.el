;;; setup-company.el ---                             -*- lexical-binding: t; -*-

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
(use-package company
  :defer t
  :diminish company-mode
  :defines (company-dabbrev-ignore-case
            company-dabbrev-downcase)
  :commands (global-company-mode
             company-mode
             add-pcomplete-to-capf
             company-text-setup
             company-c-setup)
  ;; Nicer looking faces
  :custom-face
  (company-tooltip-common
   ((t (:inherit company-tooltip :weight bold :underline nil))))
  (company-tooltip-common-selection
   ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
  :custom ((company-begin-commands           '(self-insert-command
                                               org-self-insert-command
                                               c-electric-lt-gt
                                               c-electric-colon
                                               completion-separator-self-insert-command
                                               outshine-self-insert-command))
           (company-transformers              '(company-sort-by-backend-importance))
           (company-frontends                 '(company-pseudo-tooltip-unless-just-one-frontend
                                                company-preview-frontend
                                                company-echo-metadata-frontend))
           (company-selection-wrap-around     t)
           (company-minimum-prefix-length     2)
           (company-show-numbers              t)
           (company-tooltip-align-annotations t)
           (company-tooltip-limit             10)
           (company-dabbrev-downcase          nil)
           (company-dabbrev-ignore-case       t)
           (company-dabbrev-code-everywhere   t)
           (company-semantic-insert-arguments nil)
           (company-gtags-insert-arguments    t)
           (company-lighter-base              ""))
  :bind (("C-;"                              . company-complete-common)
         ("C-c h"                            . company-complete)
         :map outline-minor-mode-map
         ("TAB"                              . company-indent-for-tab-command)
         ("<tab>"                            . company-indent-for-tab-command)
         :map company-mode-map
         ([remap completion-at-point]        . company-complete-common-or-cycle)
         ([remap complete-symbol]            . company-complete-common)
         ([remap indent-for-tab-command]     . company-indent-for-tab-command)
         :map company-active-map
         ("C-n"                              . company-select-next)
         ("C-p"                              . company-select-previous)
         ("C-d"                              . company-show-doc-buffer)
         ("TAB"                              . company-complete-selection)
         ("<tab>"                            . company-complete-selection)
         ("RET"                              . company-complete-selection))
  :init (global-company-mode t)
  :hook ((org-mode          . add-pcomplete-to-capf)
         ((c-mode c++-mode) . company-c-setup)
         (text-mode         . company-text-setup))
  :config (progn
            (add-to-list 'completion-styles 'initials t)

            ;; Enable company in Org mode
            (defun add-pcomplete-to-capf ()
              (add-hook 'completion-at-point-functions #'pcomplete-completions-at-point nil t))

            (defvar completion-at-point-functions-saved nil)
            (defun company-indent-for-tab-command (&optional arg)
              (interactive "P")
              (let ((completion-at-point-functions-saved completion-at-point-functions)
                    (completion-at-point-functions '(company-complete-common-wrapper)))
                (indent-for-tab-command arg)))
            (defun company-complete-common-wrapper ()
              (let ((completion-at-point-functions completion-at-point-functions-saved))
                (company-complete-common)))

            ;; company-lsp: Company completion backend for lsp-mode.
            (use-package company-lsp
              :demand t
              :init (progn
                      (defun lsp--sort-completions (completions)
                        "Sort COMPLETIONS."
                        (sort
                         completions
                         (-lambda ((&CompletionItem :sort-text? sort-text-left :label label-left)
                                   (&CompletionItem :sort-text? sort-text-right :label label-right))
                           (if (equal sort-text-left sort-text-right)
                               (string-lessp label-left label-right)
                             (string-lessp sort-text-left sort-text-right)))))
                      (defun lsp--annotate (item)
                        "Annotate ITEM detail."
                        (-let (((&CompletionItem :detail? :kind?) (plist-get (text-properties-at 0 item)
                                                                             'lsp-completion-item)))
                          (concat (when (and lsp-completion-show-detail detail?)
                                    (concat " " (s-replace "\r" "" detail?)))
                                  (when lsp-completion-show-kind
                                    (when-let (kind-name (and kind? (aref lsp--completion-item-kind kind?)))
                                      (format " (%s)" kind-name)))))))
              :custom ((company-lsp-async               t)
                       (company-lsp-cache-candidates    t)
                       (company-lsp-enable-recompletion t)
                       (company-lsp-enable-snippet      t)))

            ;; Default company backends
            (setq company-backends
                  '((company-lsp
                     company-keywords
                     company-dabbrev-code
                     :with company-yasnippet
                     :with company-capf)))

            ;; Ignore errors
            (defadvice company-capf (around bar activate)
              (ignore-errors add-do-it))

            ;; Disable check buffers breaks init
            (add-hook 'company-mode-hook
                      (global-company-mode-check-buffers nil))

            ;; Add company-ispell as backend for text-mode's only
            (defun company-text-setup ()
              ;; OPTIONAL, if `company-ispell-dictionary' is nil, `ispell-complete-word-dict' is used
              ;;  but I prefer hard code the dictionary path. That's more portable.
              (setq company-ispell-dictionary (expand-file-name "dictionaries/words.txt" user-emacs-directory))

              ;; make `company-backends' local is critical
              ;; or else, you will have completion in every major mode, that's very annoying!
              (set (make-local-variable 'company-backends) '((company-keywords
                                                              :with company-yasnippet
                                                              :with company-capf))))

            ;; Integration of company with TabNine
            (use-package company-tabnine
              :if (executable-find "TabNine")
              :custom (company-tabnine-max-num-results 9)
              :hook ((lsp-after-open . (lambda ()
                                         (setq company-tabnine-max-num-results 3)
                                         (add-to-list 'company-transformers 'company/sort-by-tabnine t)))
                     (kill-emacs . company-tabnine-kill-process))
              :init (defun company/sort-by-tabnine (candidates)
                      (if (or (functionp company-backend)
                              (not (and (listp company-backend) (memq 'company-tabnine company-backend))))
                          candidates
                        (let ((candidates-table (make-hash-table :test #'equal))
                              candidates-lsp
                              candidates-tabnine)
                          (dolist (candidate candidates)
                            (if (eq (get-text-property 0 'company-backend candidate)
                                    'company-tabnine)
                                (unless (gethash candidate candidates-table)
                                  (push candidate candidates-tabnine))
                              (push candidate candidates-lsp)
                              (puthash candidate t candidates-table)))
                          (setq candidates-lsp (nreverse candidates-lsp))
                          (setq candidates-tabnine (nreverse candidates-tabnine))
                          (nconc (seq-take candidates-tabnine 3)
                                 (seq-take candidates-lsp 6)))))
              :config (progn
                        ;; Need to use a custom path for TabNine
                        (defun company-tabnine--executable-path ()
                          "TabNine")

                        ;; Enable tabnine on default
                        (add-to-list 'company-backends #'company-tabnine)))

            ;; Company integration with irony
            (use-package company-irony
              :if (and (executable-find "irony-server")
                       (not (executable-find "clangd"))))

            ;; Company integration with rtags
            (use-package company-rtags
              :if (and (executable-find "rdm")
                       (not (executable-find "clangd")))
              :load-path (lambda () (expand-file-name "rtags/src/" user-emacs-directory))
              :custom (rtags-completions-enabled t))

            ;; C-mode setup
            (defun company-c-setup ()
              ;; make `company-backends' local is critical
              ;; or else, you will have completion in every major mode, that's very annoying!
              (make-local-variable 'company-backends)
              (setq company-backends (copy-tree company-backends)))

            ;; Documentation popups for company
            (use-package company-box
              :diminish t
              ;; Disabled on emacs newer than 27.0
              :if (version< emacs-version "27.0")
              :functions (my/company-box--make-line
                          my/company-box-icons--elisp
                          company-box--get-color
                          company-box--resolve-colors
                          company-box--add-icon
                          company-box--apply-color
                          company-box--make-line
                          company-box-icons--elisp)
              :defines company-box-icons-all-the-icons
              :hook (company-mode . company-box-mode)
              :init (setq company-box-icons-alist 'company-box-icons-all-the-icons)
              :custom ((company-box-backends-colors       nil)
                       (company-box-show-single-candidate t)
                       (company-box-max-candidates        50)
                       (company-box-doc-delay             0.3))
              :config (defadvice company-box-show (around bar activate)
                        (ignore-errors add-do-it)))

            ;; Documentation popups for company
            (use-package company-quickhelp
              :disabled t
              :defines company-quickhelp-delay
              :bind (:map company-active-map
                          ([remap company-show-doc-buffer] . company-quickhelp-manual-begin))
              :custom ((company-quickhelp-delay                0.2)
                       (company-quickhelp-use-propertized-text t))
              :commands company-quickhelp-mode
              :hook (global-company-mode . company-quickhelp-mode)
              :config (setq company-frontends (delq 'company-echo-metadata-frontend company-frontends)))

            ;; Company bibtex integration
            (use-package company-bibtex
              :if (or (executable-find "bibtex")
                      (executable-find "biber"))
              :custom (company-bibtex-bibliography '("~/workspace/Documents/Bibliography/biblio.bib")))

            ;; Company math
            (use-package company-math
              :after math-symbol-lists)

            ;; Company auctex
            (use-package company-auctex
              :defer t
              :after (auctex company-math)
              :commands (company-auctex-init
                         my/latex-mode-init)
              :hook ((TeX-mode   . my/latex-mode-init)
                     (LaTeX-mode . company-auctex-init))
              :init (progn
                      (defun company-auctex-labels (command &optional arg &rest ignored)
                        "company-auctex-labels backend"
                        (interactive (list 'interactive))
                        (case command
                          (interactive (company-begin-backend 'company-auctex-labels))
                          (prefix (company-auctex-prefix "\\\\.*ref{\\([^}]*\\)\\="))
                          (candidates (company-auctex-label-candidates arg))))

                      ;; local configuration for TeX modes
                      (defun my/latex-mode-init ()
                        (setq-local company-backends
                                    (append '(company-auctex-macros
                                              company-auctex-environments
                                              company-math-symbols-unicode
                                              company-math-symbols-latex
                                              company-auctex-labels
                                              company-auctex-bibs
                                              company-bibtex)
                                            company-backends)))))))

;; company-tng (Tab and Go) allows you to perform completion using just TAB.
(use-package company-tng-mode
  :disabled t
  :commands company-tng-mode
  :hook (company-mode . company-tng-mode))

(provide 'setup-company)
;;; setup-company.el ends here
