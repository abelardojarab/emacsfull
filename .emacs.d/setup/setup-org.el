;;; setup-org.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Abelardo Jara-Berrocal

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

;; Org mode
(use-package org
  :defer t
  :mode (("\\.org$" . org-mode))
  :load-path (lambda () (expand-file-name "org/lisp" user-emacs-directory))
  :bind (("C-c C"        . org-capture)
         ("C-c L"        . org-store-link)
         ("C-c I"        . org-insert-link-global)
         ("C-c O"        . org-open-at-point-global)
         :map org-mode-map
         ("C-t"          . org-time-stamp)
         ("<return>"     . org-return)
         ([enter]        . org-return)
         ([kp-enter]     . org-meta-return)
         ([C-M-return]   . org-insert-todo-heading)
         ([S-return]     . org-insert-subheading)
         ("RET"          . org-retun)
         ("C-TAB"        . org-cycle)
         ("C-c c"        . org-html-copy)
         ("C-c k"        . org-cut-subtree)
         ("C-c t"        . org-show-todo-tree)
         ("C-c r"        . org-refile)
         ("C-c v"        . org-reveal))
  :commands (org-mode
             org-capture
             org-store-link
             org-insert-link-global
             org-open-at-point-global
             orgtbl-mode
             orgstruct-mode
             orgstruct++-mode
             org-agenda)
  :init (progn
          (setq load-path (cons (expand-file-name "org/contrib/lisp" user-emacs-directory) load-path))
          (defvar org-list-allow-alphabetical t)
          (defun org-element-bold-successor           (arg))
          (defun org-element-code-successor           (arg))
          (defun org-element-entity-successor         (arg))
          (defun org-element-italic-successor         (arg))
          (defun org-element-latex-fragment-successor (arg))
          (defun org-element-strike-through-successor (arg))
          (defun org-element-subscript-successor      (arg))
          (defun org-element-superscript-successor    (arg))
          (defun org-element-underline-successor      (arg))
          (defun org-element-verbatim-successor       (arg)))
  :config (progn

            ;; Basic packages
            (use-package org-list)
            (use-package ox-org)
            (use-package ox-extra)

            ;; Avoid error when inserting '_'
            (defadvice org-backward-paragraph (around bar activate)
              (ignore-errors add-do-it))

            ;; Tweaks
            (add-hook 'org-mode-hook
                      (lambda ()
                        (progn
                          (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
                          (linum-mode         -1)
                          (org-indent-mode    -1)
                          (cua-mode           t)
                          (flyspell-mode      t)
                          (writegood-mode     t)
                          (yas-minor-mode     t)
                          (undo-tree-mode     t))))

            ;; Hide properties drawer in org mode
            (defalias 'org-cycle-hide-drawers 'my/block-org-cycle-hide-drawers)

            (defun my/block-org-cycle-hide-drawers (state)
              "Re-hide all drawers, footnotes or html blocks after a visibility state change."
              (when
                  (and
                   (derived-mode-p 'org-mode)
                   (not (memq state '(overview folded contents))))
                (save-excursion
                  (let* (
                         (globalp (memq state '(contents all)))
                         (beg (if globalp (point-min) (point)))
                         (end
                          (cond
                           (globalp
                            (point-max))
                           ((eq state 'children)
                            (save-excursion (outline-next-heading) (point)))
                           (t (org-end-of-subtree t)) )))
                    (goto-char beg)
                    (while
                        (re-search-forward
                         ".*\\[fn\\|^\\#\\+BEGIN_SRC.*$\\|^[ \t]*:PROPERTIES:[ \t]*$" end t)
                      (my/org-flag t))))))

            (defalias 'org-cycle-internal-local 'my/block-org-cycle-internal-local)

            (defun my/block-org-cycle-internal-local ()
              "Do the local cycling action."
              (let ((goal-column 0) eoh eol eos has-children children-skipped struct)
                (save-excursion
                  (if (org-at-item-p)
                      (progn
                        (beginning-of-line)
                        (setq struct (org-list-struct))
                        (setq eoh (point-at-eol))
                        (setq eos (org-list-get-item-end-before-blank (point) struct))
                        (setq has-children (org-list-has-child-p (point) struct)))
                    (org-back-to-heading)
                    (setq eoh (save-excursion (outline-end-of-heading) (point)))
                    (setq eos (save-excursion (1- (org-end-of-subtree t t))))
                    (setq has-children
                          (or
                           (save-excursion
                             (let ((level (funcall outline-level)))
                               (outline-next-heading)
                               (and
                                (org-at-heading-p t)
                                (> (funcall outline-level) level))))
                           (save-excursion
                             (org-list-search-forward (org-item-beginning-re) eos t)))))
                  (beginning-of-line 2)
                  (if (featurep 'xemacs)
                      (while
                          (and
                           (not (eobp))
                           (get-char-property (1- (point)) 'invisible))
                        (beginning-of-line 2))
                    (while
                        (and
                         (not (eobp))
                         (get-char-property (1- (point)) 'invisible))
                      (goto-char (next-single-char-property-change (point) 'invisible))
                      (and
                       (eolp)
                       (beginning-of-line 2))))
                  (setq eol (point)))
                (cond
                 ((= eos eoh)
                  (unless (org-before-first-heading-p)
                    (run-hook-with-args 'org-pre-cycle-hook 'empty))
                  (org-unlogged-message "EMPTY ENTRY")
                  (setq org-cycle-subtree-status nil)
                  (save-excursion
                    (goto-char eos)
                    (outline-next-heading)
                    (if (outline-invisible-p)
                        (org-flag-heading nil))))
                 ((and
                   (or
                    (>= eol eos)
                    (not (string-match "\\S-" (buffer-substring eol eos))))
                   (or
                    has-children
                    (not (setq children-skipped
                               org-cycle-skip-children-state-if-no-children))))
                  (unless (org-before-first-heading-p)
                    (run-hook-with-args 'org-pre-cycle-hook 'children))
                  (if (org-at-item-p)
                      ;; then
                      (org-list-set-item-visibility (point-at-bol) struct 'children)
                    ;; else
                    (org-show-entry)
                    (org-with-limited-levels (show-children))
                    (when (eq org-cycle-include-plain-lists 'integrate)
                      (save-excursion
                        (org-back-to-heading)
                        (while (org-list-search-forward (org-item-beginning-re) eos t)
                          (beginning-of-line 1)
                          (let* (
                                 (struct (org-list-struct))
                                 (prevs (org-list-prevs-alist struct))
                                 (end (org-list-get-bottom-point struct)))
                            (mapc (lambda (e) (org-list-set-item-visibility e struct 'folded))
                                  (org-list-get-all-items (point) struct prevs))
                            (goto-char (if (< end eos) end eos)))))))
                  (org-unlogged-message "CHILDREN")
                  (save-excursion
                    (goto-char eos)
                    (outline-next-heading)
                    (if (outline-invisible-p)
                        (org-flag-heading nil)))
                  (setq org-cycle-subtree-status 'children)
                  (unless (org-before-first-heading-p)
                    (run-hook-with-args 'org-cycle-hook 'children)))
                 ((or
                   children-skipped
                   (and
                    (eq last-command this-command)
                    (eq org-cycle-subtree-status 'children)))
                  (unless (org-before-first-heading-p)
                    (run-hook-with-args 'org-pre-cycle-hook 'subtree))
                  (outline-flag-region eoh eos nil)
                  (org-unlogged-message
                   (if children-skipped
                       "SUBTREE (NO CHILDREN)"
                     "SUBTREE"))
                  (setq org-cycle-subtree-status 'subtree)
                  (unless (org-before-first-heading-p)
                    (run-hook-with-args 'org-cycle-hook 'subtree)))
                 ((eq org-cycle-subtree-status 'subtree)
                  (org-show-subtree)
                  (message "ALL")
                  (setq org-cycle-subtree-status 'all))
                 (t
                  (run-hook-with-args 'org-pre-cycle-hook 'folded)
                  (outline-flag-region eoh eos t)
                  (org-unlogged-message "FOLDED")
                  (setq org-cycle-subtree-status 'folded)
                  (unless (org-before-first-heading-p)
                    (run-hook-with-args 'org-cycle-hook 'folded))))))

            (defun my/org-flag (flag)
              "When FLAG is non-nil, hide any of the following:  html code block;
footnote; or, the properties drawer.  Otherwise make it visible."
              (save-excursion
                (beginning-of-line 1)
                (cond
                 ((looking-at ".*\\[fn")
                  (let* (
                         (begin (match-end 0))
                         end-footnote)
                    (if (re-search-forward "\\]"
                                           (save-excursion (outline-next-heading) (point)) t)
                        (progn
                          (setq end-footnote (point))
                          (outline-flag-region begin end-footnote flag))
                      (user-error "Error beginning at point %s." begin))))
                 ((looking-at "^\\#\\+BEGIN_SRC.*$\\|^[ \t]*:PROPERTIES:[ \t]*$")
                  (let* ((begin (match-end 0)))
                    (if (re-search-forward "^\\#\\+END_SRC.*$\\|^[ \t]*:END:"
                                           (save-excursion (outline-next-heading) (point)) t)
                        (outline-flag-region begin (point-at-eol) flag)
                      (user-error "Error beginning at point %s." begin)))))))

            (defun my/toggle-block-visibility ()
              "For this function to work, the cursor must be on the same line as the regexp."
              (interactive)
              (if
                  (save-excursion
                    (beginning-of-line 1)
                    (looking-at
                     ".*\\[fn\\|^\\#\\+BEGIN_SRC.*$\\|^[ \t]*:PROPERTIES:[ \t]*$"))
                  (my/org-flag (not (get-char-property (match-end 0) 'invisible)))
                (message "Sorry, you are not on a line containing the beginning regexp.")))

            ;; Only use bimodal org-cycle when a heading has a :BIMODAL-CYCLING: property value.
            (advice-add 'org-cycle :around #'my/org-cycle)
            (defun my/toggle-bimodal-cycling (&optional pos)
              "Enable/disable bimodal cycling behavior for the current heading."
              (interactive)
              (let* ((enabled (org-entry-get pos "BIMODAL-CYCLING")))
                (if enabled
                    (org-entry-delete pos "BIMODAL-CYCLING")
                  (org-entry-put pos "BIMODAL-CYCLING" "yes"))))

            (defun my/org-cycle (fn &optional arg)
              "Make org outline cycling bimodal (FOLDED and SUBTREE) rather than trimodal (FOLDED, CHILDREN, and SUBTREE) when a heading has a :BIMODAL-CYCLING: property value."
              (interactive)
              (if (and (org-at-heading-p)
                       (org-entry-get nil "BIMODAL-CYCLING"))
                  (my/toggle-subtree)
                (funcall fn arg)))

            (defun my/toggle-subtree ()
              "Show or hide the current subtree depending on its current state."
              (interactive)
              (save-excursion
                (outline-back-to-heading)
                (if (not (outline-invisible-p (line-end-position)))
                    (outline-hide-subtree)
                  (outline-show-subtree))))

            ;; Ignore tex commands during flyspell
            (add-hook 'org-mode-hook (lambda () (setq ispell-parser 'tex)))
            (defun flyspell-ignore-tex ()
              (interactive)
              (set (make-variable-buffer-local 'ispell-parser) 'tex))
            (add-hook 'org-mode-hook #'flyspell-ignore-tex)

            ;; source http://endlessparentheses.com/ispell-and-org-mode.html
            (defun my/org-ispell ()
              "Configure `ispell-skip-region-alist' for `org-mode'."
              (make-local-variable 'ispell-skip-region-alist)
              (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
              (add-to-list 'ispell-skip-region-alist '("~" "~"))
              (add-to-list 'ispell-skip-region-alist '("=" "="))
              (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "^#\\+END_SRC"))
              (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))
              (add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_QUOTE" . "#\\+END_QUOTE")))
            (add-hook 'org-mode-hook #'my/org-ispell)

            ;; Bind org-table-* command when the point is in an org table (source).
            (bind-keys
             :map org-mode-map
             :filter (org-at-table-p)
             ("C-c ?"   . org-table-field-info)
             ("C-c SPC" . org-table-blank-field)
             ("C-c +"   . org-table-sum)
             ("C-c ="   . org-table-eval-formula)
             ("C-c `"   . org-table-edit-field)
             ("C-#"     . org-table-rotate-recalc-marks)
             ("C-c }"   . org-table-toggle-coordinate-overlays)
             ("C-c {"   . org-table-toggle-formula-debugger))

            ;; Miscellanenous settings
            (setq org-startup-folded              'showall
                  org-startup-indented            t
                  org-cycle-separator-lines       1
                  org-cycle-include-plain-lists   'integrate
                  org-startup-with-inline-images  nil
                  org-startup-truncated           t
                  org-use-speed-commands          t
                  org-completion-use-ido          t
                  org-hide-leading-stars          nil
                  org-highlight-latex-and-related '(latex)
                  org-ellipsis                    " ••• "

                  ;; Avoid editting hidden regions
                  org-catch-invisible-edits      'smart

                  ;; this causes problem in other modes
                  org-indent-mode                 nil

                  ;; Enable sub and super script only when enclosed by {}
                  ;; Also improves readability when exponent/subscript is composed of multiple words
                  org-use-sub-superscripts        nil

                  ;; Hide the /italics/ and *bold* markers
                  org-hide-emphasis-markers      t

                  ;; org-entities displays \alpha etc. as Unicode characters.
                  org-pretty-entities            t

                  ;; Allow a) b) c) lists
                  org-list-allow-alphabetical    t

                  ;; Right-align tags to an indent from the right margin
                  org-tags-column                120)

            ;; Allow multiple line Org emphasis markup
            (setcar (nthcdr 4 org-emphasis-regexp-components) 20) ;; Up to 20 lines, default is just 1

            ;; Below is needed to apply the modified `org-emphasis-regexp-components'
            ;; settings from above.
            (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

            ;; Allow quotes to be verbatim
            (add-hook 'org-mode-hook
                      (lambda ()
                        (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n,'")
                        (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
                        (org-element--set-regexps)
                        (custom-set-variables `(org-emphasis-alist ',org-emphasis-alist))))

            ;; Enable mouse in Org
            (use-package org-mouse)

            ;; Fonts
            (add-hook 'org-mode-hook (lambda () (variable-pitch-mode t)))
            (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
            (set-face-attribute 'org-code  nil :inherit 'fixed-pitch)
            (set-face-attribute 'org-block nil :inherit 'fixed-pitch)

            (defface org-block-begin-line
              '((t (:inherit org-meta-line
                             :overline "light grey" :foreground "#008ED1")))
              "Face used for the line delimiting the begin of source blocks.")

            (defface org-block-end-line
              '((t (:inherit org-meta-line
                             :underline "light grey" :foreground "#008ED1")))
              "Face used for the line delimiting the end of source blocks.")

            ;; Org Templates
            (setq org-structure-template-alist
                  '(("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>")
                    ("e" "#+begin_example\n?\n#+end_example" "<example>\n?\n</example>")
                    ("q" "#+begin_quote\n?\n#+end_quote" "<quote>\n?\n</quote>")
                    ("v" "#+BEGIN_VERSE\n?\n#+END_VERSE" "<verse>\n?\n</verse>")
                    ("c" "#+BEGIN_COMMENT\n?\n#+END_COMMENT")
                    ("p" "#+BEGIN_PRACTICE\n?\n#+END_PRACTICE")
                    ("l" "#+begin_src emacs-lisp\n?\n#+end_src" "<src lang=\"emacs-lisp\">\n?\n</src>")
                    ("L" "#+latex: " "<literal style=\"latex\">?</literal>")
                    ("h" "#+begin_html\n?\n#+end_html" "<literal style=\"html\">\n?\n</literal>")
                    ("H" "#+html: " "<literal style=\"html\">?</literal>")
                    ("E" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC\n")
                    ("S" "#+BEGIN_SRC shell-script\n?\n#+END_SRC\n")
                    ("L" "#+BEGIN_SRC latex\n\\begin{align*}\n?\\end{align*}\n#+END_SRC")
                    ("a" "#+begin_ascii\n?\n#+end_ascii")
                    ("A" "#+ascii: ")
                    ("i" "#+index: ?" "#+index: ?")
                    ("I" "#+include %file ?" "<include file=%file markup=\"?\">")))

            ;; Fix shift problem in Org mode
            (setq org-CUA-compatible t)
            (setq org-support-shift-select 'always)
            (eval-after-load "org"
              '(progn
                 (eval-after-load "cua-base"
                   '(progn
                      (defadvice org-call-for-shift-select (before org-call-for-shift-select-cua activate)
                        (if (and cua-mode
                                 org-support-shift-select
                                 (not (use-region-p)))
                            (cua-set-mark)))))))

            ;; Make org do not open other frames
            (setq org-link-frame-setup (quote ((vm      . vm-visit-folder-other-frame)
                                               (vm-imap . vm-visit-imap-folder-other-frame)
                                               (gnus    . org-gnus-no-new-news)
                                               (file    . find-file)
                                               (wl      . wl-other-frame))))

            ;; Repair export blocks to match new format
            ;; #+BEGIN_EXPORT backend
            ;; ...
            ;; #+END_EXPORT
            (defun org-repair-export-blocks ()
              "Repair export blocks and INCLUDE keywords in current buffer."
              (interactive)
              (when (eq major-mode 'org-mode)
                (let ((case-fold-search t)
                      (back-end-re (regexp-opt
                                    '("HTML" "ASCII" "LATEX" "ODT" "MARKDOWN" "MD" "ORG"
                                      "MAN" "BEAMER" "TEXINFO" "GROFF" "KOMA-LETTER")
                                    t)))
                  (org-with-wide-buffer
                   (goto-char (point-min))
                   (let ((block-re (concat "^[ \t]*#\\+BEGIN_" back-end-re)))
                     (save-excursion
                       (while (re-search-forward block-re nil t)
                         (let ((element (save-match-data (org-element-at-point))))
                           (when (eq (org-element-type element) 'special-block)
                             (save-excursion
                               (goto-char (org-element-property :end element))
                               (save-match-data (search-backward "_"))
                               (forward-char)
                               (insert "EXPORT")
                               (delete-region (point) (line-end-position)))
                             (replace-match "EXPORT \\1" nil nil nil 1))))))
                   (let ((include-re
                          (format "^[ \t]*#\\+INCLUDE: .*?%s[ \t]*$" back-end-re)))
                     (while (re-search-forward include-re nil t)
                       (let ((element (save-match-data (org-element-at-point))))
                         (when (and (eq (org-element-type element) 'keyword)
                                    (string= (org-element-property :key element) "INCLUDE"))
                           (replace-match "EXPORT \\1" nil nil nil 1)))))))))

            ;; Add missing function
            (defun org-reverse-string (string)
              (apply 'string (reverse (string-to-list string))))

            ;; Use Org bold, italics, code styles
            (defun org-text-wrapper (txt &optional endtxt)
              "Wraps the region with the text passed in as an argument."
              (if (use-region-p)
                  (save-restriction
                    (narrow-to-region (region-beginning) (region-end))
                    (goto-char (point-min))
                    (insert txt)
                    (goto-char (point-max))
                    (if endtxt
                        (insert endtxt)
                      (insert txt)))
                (if (looking-at "[A-z]")
                    (save-excursion
                      (if (not (looking-back "[     ]"))
                          (backward-word))
                      (progn
                        (mark-word)
                        (org-text-wrapper txt endtxt)))
                  (progn
                    (insert txt)
                    (let ((spot (point)))
                      (insert txt)
                      (goto-char spot))))))

            (defun org-text-bold () "Wraps the region with asterisks."
                   (interactive)
                   (org-text-wrapper "*"))

            (defun org-text-italics () "Wraps the region with slashes."
                   (interactive)
                   (org-text-wrapper "/"))

            (defun org-text-code () "Wraps the region with equal signs."
                   (interactive)
                   (org-text-wrapper "="))

            ;; Org formatted copy and paste
            (if (equal system-type 'darwin)
                (progn
                  (defun org-html-paste ()
                    "Convert clipboard contents from HTML to Org and then paste (yank)."
                    (interactive)
                    (kill-new (shell-command-to-string "osascript -e 'the clipboard as \"HTML\"' | perl -ne 'print chr foreach unpack(\"C*\",pack(\"H*\",substr($_,11,-3)))' | pandoc -f html -t json | pandoc -f json -t org"))
                    (yank))

                  (defun org-html-copy ()
                    "Export region to HTML, and copy it to the clipboard."
                    (interactive)
                    (save-window-excursion
                      (let* ((buf (org-export-to-buffer 'html "*Formatted Copy*" nil nil t t))
                             (html (with-current-buffer buf (buffer-string))))
                        (with-current-buffer buf
                          (shell-command-on-region
                           (point-min)
                           (point-max)
                           "textutil -stdin -format html -convert rtf -stdout | pbcopy"))
                        (kill-buffer buf)))))
              (progn
                (defun org-html-paste ()
                  "Convert clipboard contents from HTML to Org and then paste (yank)."
                  (interactive)
                  (kill-new (shell-command-to-string
                             "xclip -o -t TARGETS | grep -q text/html && (xclip -o -t text/html | pandoc -f html -t json | pandoc -f json -t org) || xclip -o"))
                  (yank))

                (defun org-html-copy ()
                  "Export region to HTML, and copy it to the clipboard."
                  (interactive)
                  (org-export-to-file 'html "/tmp/org.html")
                  (apply
                   'start-process "xclip" "*xclip*"
                   (split-string
                    "xclip -verbose -i /tmp/org.html -t text/html -selection clipboard" " ")))))

            ;; convert csv to org-table considering "12,12"
            (defun org-convert-csv-table (beg end)
              (interactive (list (point) (mark)))
              (replace-regexp "\\(^\\)\\|\\(\".*?\"\\)\\|," (quote (replace-eval-replacement
                                                                    replace-quote (cond ((equal "^" (match-string 1)) "|")
                                                                                        ((equal "," (match-string 0)) "|")
                                                                                        ((match-string 2))) ))  nil  beg end))

            ;; Footnote definitions
            (setq org-footnote-definition-re (org-re "^\\[\\(fn:[-_[:word:]]+\\)\\]")
                  org-footnote-re (concat "\\[\\(?:"
                                          ;; Match inline footnotes.
                                          (org-re "fn:\\([-_[:word:]]+\\)?:\\|")
                                          (org-re "\\(fn:[-_[:word:]]+\\)")
                                          "\\)"))

            ;; .txt files aren't in the list initially, but in case that changes
            ;; in a future version of org, use if to avoid errors
            (if (assoc "\\.txt\\'" org-file-apps)
                (setcdr (assoc "\\.txt\\'" org-file-apps) "gedit %s")
              (add-to-list 'org-file-apps '("\\.txt\\'" . "gedit %s") t))

            ;; Change .pdf association directly within the alist
            (setcdr (assoc "\\.pdf\\'" org-file-apps) "acroread %s")

            ;; Org Export
            (use-package ox
              :config (progn

                        ;; Export options
                        (setq org-export-coding-system         'utf-8
                              org-export-time-stamp-file       nil
                              org-export-headline-levels       4

                              ;; Require wrapping braces to interpret _ and ^ as sub/super-script
                              org-export-with-sub-superscripts '{}      ;;  ;also #+options: ^:{}

                              org-export-allow-bind-keywords   t
                              org-export-async-debug           t

                              ;; Turn ' and " into ‘posh’ “quotes”
                              org-export-with-smart-quotes     t) ;; also #+options: ':t

                        ;; Org Export Customization
                        ;; Delete selected columns from Org tables before exporting
                        (defun my/org-export-delete-commented-cols (back-end)
                          "Delete columns $2 to $> marked as `<#>' on a row with `/' in $1.
If you want a non-empty column $1 to be deleted make it $2 by
inserting an empty column before and adding `/' in $1."
                          (while (re-search-forward
                                  "^[ \t]*| +/ +|\\(.*|\\)? +\\(<#>\\) *|" nil :noerror)
                            (goto-char (match-beginning 2))
                            (org-table-delete-column)
                            (beginning-of-line)))
                        (add-hook 'org-export-before-processing-hook
                                  #'my/org-export-delete-commented-cols)

                        ;; http://lists.gnu.org/archive/html/emacs-orgmode/2016-09/msg00168.html
                        (defun my/filter-begin-only (type)
                          "Remove BEGIN_ONLY %s blocks whose %s doesn't equal TYPE.
For those that match, only remove the delimiters.
On the flip side, for BEGIN_EXCEPT %s blocks, remove those if %s equals TYPE. "
                          (goto-char (point-min))
                          (while (re-search-forward " *#\\+BEGIN_\\(ONLY\\|EXCEPT\\) +\\([a-z]+\\)\n"
                                                    nil :noerror)
                            (let ((only-or-export (match-string-no-properties 1))
                                  (block-type (match-string-no-properties 2))
                                  (begin-from (match-beginning 0))
                                  (begin-to (match-end 0)))
                              (re-search-forward (format " *#\\+END_%s +%s\n"
                                                         only-or-export block-type))
                              (let ((end-from (match-beginning 0))
                                    (end-to (match-end 0)))
                                (if (or (and (string= "ONLY" only-or-export)
                                             (string= type block-type))
                                        (and (string= "EXCEPT" only-or-export)
                                             (not (string= type block-type))))
                                    (progn              ;Keep the block,
                                        ;delete just the comment markers
                                      (delete-region end-from end-to)
                                      (delete-region begin-from begin-to))
                                  ;; Delete the block
                                  (message "Removing %s block" block-type)
                                  (delete-region begin-from end-to))))))
                        (add-hook 'org-export-before-processing-hook #'my/filter-begin-only)))

            ;; Beamer/ODT/Markdown exporters
            (use-package ox-beamer)
            (use-package ox-odt)
            (use-package ox-md)

            ;; HTML5 slide exporter
            (use-package ox-html5slide)))

;; Setup Org Agenda
(use-package setup-org-agenda)

;; Setup Org (babel support)
(use-package setup-org-babel)

;; Setup Org plugins
(use-package setup-org-plugins)

;; Setup Org (latex support)
(use-package setup-org-latex)

;; Setup Org (html support)
(use-package setup-org-html)

;; Use footnotes as eldoc source
(use-package org-eldoc
  :defer t
  :init (progn
          (add-hook 'org-mode-hook #'org-eldoc-load)
          (add-hook 'org-mode-hook #'eldoc-mode))
  :commands org-eldoc-load
  :config (progn
            (defun my/org-eldoc-get-footnote ()
              (save-excursion
                (let ((fn (org-between-regexps-p "\\[fn:" "\\]")))
                  (when fn
                    (save-match-data
                      (nth 3 (org-footnote-get-definition (buffer-substring (+ 1 (car fn)) (- (cdr fn) 1)))))))))
            (advice-add 'org-eldoc-documentation-function
                        :before-until #'my/org-eldoc-get-footnote)))

;; Use UTF8 symbols for Org Todo priorities
(use-package org-fancy-priorities
  :defer t
  :init (add-hook 'org-mode-hook 'org-fancy-priorities-mode)
  :commands org-fancy-priorities-mode
  :config (setq org-fancy-priorities-list '((?A . "❗")
                                            (?B . "⬆")
                                            (?C . "⬇")
                                            (?D . "☕")
                                            (?1 . "⚡")
                                            (?2 . "⮬")
                                            (?3 . "⮮")
                                            (?4 . "☕")
                                            (?I . "Important"))))

(provide 'setup-org)
;;; setup-org.el ends here
