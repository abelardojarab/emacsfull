;;; setup-folding.el ---                       -*- lexical-binding: t; -*-

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

(use-package folding
  :bind (:map folding-mode-prefix-map
              ("<SPC>" . folding-context-next-action))
  :config (progn
            (defun my/folding-check-folded ()
              "Function to determine if this file is in folded form."
              (let ((folding-re1 "^.?.?.?{{{")
                    (folding-re2 "[\r\n].*}}}"))
                (save-excursion
                  (goto-char (point-min))
                  ;;  If we found both, we assume file is folded
                  (and (assq major-mode folding-mode-marks-alist)
                       (< (point-max) 10000)
                       (re-search-forward folding-re1 nil t)
                       ;; if file is folded, there are \r's
                       (re-search-forward "[\r\n]" nil t)
                       (re-search-forward folding-re2 nil t)))))
            (setq folding-check-folded-file-function 'my/folding-check-folded)
            (folding-mode-add-find-file-hook)

            ;; add keywords to current buffer directly, overwrite the original function in folding.el
            (defun folding-font-lock-support ()
              "Add font lock support."
              (ignore-errors
                (font-lock-add-keywords nil (folding-font-lock-keywords major-mode))))))

;; fold this - folds selected region
(use-package fold-this
  :defer t
  :after region-bindings-mode
  :init (setq fold-this-persistent-folds-file  (concat (file-name-as-directory
                                                        my/emacs-cache-dir)
                                                       "folds-saved"))
  :bind (:map fold-this-keymap
              ;; left-click on ellipsis to unfold
              ("<mouse-1>" . fold-this-unfold-at-point)
              :map region-bindings-mode-map
              ("&"         . fold-this))
  :commands (fold-this fold-this-unfold-at-point)
  :config (progn
            (setq fold-this-persistent-folds t)

            (defface my/fold-face
              '((t (:foreground "deep sky blue" :slant italic)))
              "Face used for fold ellipsis.")

            (defvar my/fold-this--last-overlay nil
              "Store the last overlay created by `fold-this'.")

            ;; Patch the original `fold-this' command to save the overlay to the var
            ;; `my/fold-this--last-overlay' and tweak the 'display property of the
            ;; overlay
            (defun fold-this (beg end)
              (interactive "r")
              (let ((o (make-overlay beg end nil t nil)))
                (overlay-put o 'type 'fold-this)
                (overlay-put o 'invisible t)
                (overlay-put o 'keymap fold-this-keymap)
                (overlay-put o 'face 'my/fold-face)
                (overlay-put o 'modification-hooks '(fold-this--unfold-overlay))
                (overlay-put o 'display (propertize " « » " 'face 'my/fold-face))
                (overlay-put o 'evaporate t)
                (setq my/fold-this--last-overlay o))
              (deactivate-mark))))

;; Cycle code visibility
(use-package hideshow
  :defer t
  :diminish hs-minor-mode
  :hook (prog-mode  . hs-minor-mode)
  :commands (hs-toggle-hiding
             toggle-fold
             toggle-fold-all
             toggle-hide-all)
  :config (progn

            ;; default 'code, options: 'comment, t, nil
            (setq hs-isearch-open 'code)

            (defvar hs-special-modes-alist
              (mapcar 'purecopy
                      '((c-mode "{" "}" "/[*/]" nil nil)
                        (c++-mode "{" "}" "/[*/]" nil nil)
                        (bibtex-mode ("@\\S(*\\(\\s(\\)" 1))
                        (java-mode "{" "}" "/[*/]" nil nil)
                        (js-mode "{" "}" "/[*/]" nil)
                        (javascript-mode  "{" "}" "/[*/]" nil))")"))

            ;; Support to toggle/untoggle all
            (defvar hs-hide-all nil "Current state of hideshow for toggling all.")
            (make-local-variable 'hs-hide-all)

            (defun toggle-hide-all ()
              "Toggle hideshow all."
              (interactive)
              (setq hs-hide-all (not hs-hide-all))
              (if hs-hide-all
                  (hs-hide-all)
                (hs-show-all)))

            (defvar fold-all-fun nil "Function to fold all.")
            (make-variable-buffer-local 'fold-all-fun)
            (defvar fold-fun nil "Function to fold.")
            (make-variable-buffer-local 'fold-fun)

            (defun toggle-fold-all ()
              "Toggle fold all."
              (interactive)
              (if fold-all-fun
                  (call-interactively fold-all-fun)
                (toggle-hide-all)))

            (defun toggle-fold ()
              "Toggle fold."
              (interactive)
              (if fold-fun
                  (call-interactively fold-fun)
                (hs-toggle-hiding)))))

;; Cycle outline
(use-package outline
  :diminish outline-minor-mode
  :hook ((prog-mode message-mode markdown-mode) . outline-minor-mode))

;; Bring org cycle extensions to outline-minor-mode
(use-package outshine
  :defer t
  :bind (:map outline-minor-mode-map
              ("C-c TAB" . outshine-cycle-buffer))
  :custom ((outshine-use-speed-commands                t)
           (outshine-org-style-global-cycling-at-bob-p t))
  :config (progn
    (defvar-local my/outshine-allow-space-before-heading nil
      "When non-nil, allow outshine heading to begin with whitespace.
For example, when non-nil, do not require the \"// *\" style
comments used by `outshine' to start at column 0 in `verilog-mode.'")

    (defun my/outshine-calc-outline-regexp (orig-ret)
      "Prefix the outline regexp with whitespace regexp, may be.
Do this if `my/outshine-allow-space-before-heading' is non-nil."
      (let ((ret orig-ret))
        (when my/outshine-allow-space-before-heading
          (setq ret (concat "[[:blank:]]*" orig-ret)))
        ret))
    (advice-add 'outshine-calc-outline-regexp :filter-return #'my/outshine-calc-outline-regexp)))

;; Fast Emacs navigation and control
(use-package navi-mode
  :after outshine
  :bind ("M-s s" . navi-search-and-switch)
  :config (setf (cdr (assoc :ALL (cdr (assoc "emacs-lisp" navi-keywords))))
        "^[[:space:]]*(\\(use-package\\|\\(cl-\\)\\{0,1\\}def[a-z]+\\)\\*? "))

;; Outline navigation, similar to outshine-navi
(use-package helm-navi
  :after (helm navi-mode)
  :commands helm-navi)

;; Cycle visibility on outline-minor-mode
(use-package bicycle
  :after outline
  :bind (:map outline-minor-mode-map
              ([C-tab] . bicycle-cycle))
  :commands (bicycle-cycle
             bicycle-cycle-global))

;; org-style folding/unfolding in hideshow
(use-package hideshow-org
  :defer t
  :init (progn
          (setq hs-org/trigger-keys-block (list (kbd "C-c +")))
          (setq hs-org/trigger-keys-all (list (kbd "C-c &"))))
  :commands hs-org/minor-mode)

;; Yet Another Folding - folding code blocks based on indentation
(use-package yafolding
  :defer t
  :commands (yafolding-toggle-element
             yafolding-toggle-all
             yafolding-show-element
             yafolding-show-all
             yafolding-hide-element
             yafolding-hide-all)
  :custom (yafolding-ellipsis-content " ... ")
  :config (set-face-attribute 'yafolding-ellipsis-face nil :inherit 'my/fold-face))

;; Enable fold dwim (do what i mean)
(use-package fold-dwim
  :defer t
  :after hideshow
  :bind ("C-c C-f" . my/fold-dwim)
  :config (progn
            (defun folding-marker-p (&optional pos)
              (eq (get-char-property (or pos (point)) 'face) 'fringe))

            (defadvice fold-dwim-toggle (around toggle-folding-on-folding-marker activate)
              (if (folding-marker-p)
                  (folding-toggle-show-hide)
                ad-do-it))

            (defadvice fold-dwim-hide-all (around folding-open-first activate)
              (if (and (boundp 'folding-mode) folding-mode)
                  (progn
                    (folding-uninstall)
                    (let ((hs-hide-comments-when-hiding-all nil))
                      ad-do-it)
                    (folding-mode))
                ad-do-it))

            ;; DWIM
            (defvar my/fold-dwim--last-fn nil
              "Store the symbol of the last function called using `my/fold-dwim'.")

            (defun my/fold-dwim (&optional beg end)
              "If region is selected use `fold-this', else use `yafolding-toggle-element'.
If prefix argument is used, `set-selective-display' to the current column."
              (interactive "r")
              (let ((message-log-max nil))
                (if (region-active-p)
                    (progn
                      (fold-this beg end)
                      (setq my/fold-dwim--last-fn #'fold-this)
                      (message "Folded the selected region using %s."
                               (propertize
                                (symbol-name my/fold-dwim--last-fn)
                                'face 'font-lock-function-name-face)))
                  (if current-prefix-arg
                      (progn
                        (set-selective-display (current-column))
                        (setq my/fold-dwim--last-fn #'set-selective-display)
                        (message "Folded using %s at column %d."
                                 (propertize
                                  (symbol-name my/fold-dwim--last-fn)
                                  'face 'font-lock-function-name-face)
                                 (current-column)))
                    (progn
                      (yafolding-toggle-element)
                      (setq my/fold-dwim--last-fn #'yafolding-toggle-element)
                      (message "Folded at current indent level using %s."
                               (propertize
                                (symbol-name my/fold-dwim--last-fn)
                                'face 'font-lock-function-name-face)))))))))

;; Visual hideshow mode
(use-package hideshowvis
  :defer t
  :if (display-graphic-p)
  :after hideshow
  :commands (hideshowvis-minor-mode
             hideshowvis-enable)
  :config (progn
            ;; Add the following to your .emacs and uncomment it in order to get a right arrow symbol
            (define-fringe-bitmap 'hs-marker [0 32 48 56 60 56 48 32])

            ;; Change -/+ to ▼/▶
            (define-fringe-bitmap 'hideshowvis-hideable-marker [0 0 254 124 56 16 0 0])
            (define-fringe-bitmap 'hs-marker [0 32 48 56 60 56 48 32])

            (defface my/hs-fringe-face
              '((t (:foreground "#888"
                                :box (:line-width 2 :color "grey75" :style released-button))))
              "Face used to highlight the fringe on folded regions"
              :group 'hideshow)

            ;; Redefine display functions
            (defun display-code-line-counts (ov)
              (when (eq 'code (overlay-get ov 'hs))
                (let* ((marker-string "*fringe-dummy*")
                       (marker-length (length marker-string))
                       (display-string (format " ... %s <%d> ... "
                                               (replace-regexp-in-string
                                                "\n" ""
                                                (replace-regexp-in-string
                                                 "^[ \t]*" ""
                                                 (replace-regexp-in-string
                                                  "[ \t]*$" ""
                                                  (buffer-substring (overlay-start ov)
                                                                    (+ (overlay-start ov) 40)))))
                                               (count-lines (overlay-start ov)
                                                            (overlay-end ov)))))
                  (overlay-put ov 'help-echo "Hidden text... ")
                  (put-text-property 0 marker-length 'display (list 'left-fringe 'hs-expand-bitmap 'my/hs-fringe-face) marker-string)
                  (overlay-put ov 'before-string marker-string)
                  (put-text-property 1 (length display-string) 'face 'my/fold-face display-string)
                  (overlay-put ov 'display display-string))))
            (setq hs-set-up-overlay 'display-code-line-counts)

            (defadvice folding-subst-regions (around toggle-fringe (list find replace) activate)
              ad-do-it
              (save-excursion
                (while list
                  (let* ((begin (car list))
                         (end (cadr list))
                         bol eol
                         (marker-string "*fringe-dummy*")
                         (marker-length (length marker-string)))
                    (dolist (ov (overlays-in begin end))
                      (when (overlay-get ov 'fringe-folding-p)
                        (delete-overlay ov)))
                    (when (and (eq find ?\n) (eq replace ?\r))
                      ;; \\n -> \\r add fringe
                      (goto-char begin)
                      (search-forward "\r")
                      (forward-char -1)
                      (let* ((ov (make-overlay (point) end))
                             (display-string (format " ... %s <%d> ... "
                                                     (replace-regexp-in-string
                                                      "\n" ""
                                                      (replace-regexp-in-string
                                                       "^[ \t]*" ""
                                                       (replace-regexp-in-string
                                                        "[ \t]*$" ""
                                                        (buffer-substring (overlay-start ov)
                                                                          (+ (overlay-start ov) 40)))))
                                                     (count-lines (overlay-start ov)
                                                                  (overlay-end ov)))))
                        (put-text-property 0 marker-length 'display (list 'left-fringe 'hs-marker 'my/hs-fringe-face) marker-string)
                        (overlay-put ov 'before-string marker-string)
                        (put-text-property 1 (length display-string) 'face 'my/fold-face display-string)
                        (overlay-put ov 'display display-string)
                        (overlay-put ov 'priority 9999)
                        (overlay-put ov 'fringe-folding-p t))))
                  (setq list (cdr (cdr list))))))))

;; vim-like fold
(use-package vimish-fold
  :defer t
  :commands (vimish-fold-mode vimish-fold-global-mode)
  :bind (:map vimish-fold-folded-keymap
              ("<tab>" . vimish-fold-unfold)
              :map vimish-fold-unfolded-keymap
              ("<tab>" . vimish-fold-refold))
  :config (progn
            (setq-default
             vimish-fold-dir  (file-name-as-directory
                               (concat (file-name-as-directory
                                        my/emacs-cache-dir)
                                       "vimish-fold"))
             vimish-fold-header-width 79)))

(use-package origami
  :defer t
  :custom (origami-show-fold-header t)
  :commands (hydra-origami/body
             global-origami-mode
             origami-undo
             origami-redo
             origami-toggle-node
             origami-toggle-all-nodes
             origami-recursively-toggle-node)
  :chords (("TT" . origami-toggle-node))
  :init (global-origami-mode)
  :custom-face
  (origami-fold-replacement-face ((t (:inherit magit-diff-context-highlight))))
  (origami-fold-fringe-face ((t (:inherit magit-diff-context-highlight))))
  :config (progn (face-spec-reset-face 'origami-fold-header-face)
                 (defhydra hydra-origami (:color blue :hint none)
                   "
      _:_: recursively toggle node       _a_: toggle all nodes    _t_: toggle node
      _o_: show only current node        _u_: undo                _r_: redo
      _R_: reset
      "
                   (":" origami-recursively-toggle-node)
                   ("a" origami-toggle-all-nodes)
                   ("t" origami-toggle-node)
                   ("o" origami-show-only-node)
                   ("u" origami-undo)
                   ("r" origami-redo)
                   ("R" origami-reset)
                   )))

(provide 'setup-folding)
;;; setup-hideshow.el ends here
