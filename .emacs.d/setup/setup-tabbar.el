;;; setup-tabbar.el ---                         -*- lexical-binding: t; -*-

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

;; Tabbar ruler pre-requisites
(use-package mode-icons
  :if (version< emacs-version "27.3")
  :demand t
  :config (defadvice mode-icons-set-mode-icon (around bar activate)
            (ignore-errors add-do-it)))

;; Tabbar
(use-package tabbar
  :if (version< emacs-version "27.3")
  :hook (after-init . tabbar-mode)
  :preface (push "~/.emacs.d/etc/images/" image-load-path)
  :custom ((tabbar-auto-scroll-flag  t)
           (tabbar-use-images        t)
           (table-time-before-update 0.1))
  :config (progn
            ;; Sort tabbar buffers by name
            (defun tabbar-add-tab (tabset object &optional append_ignored)
              "Add to TABSET a tab with value OBJECT if there isn't one there yet.
 If the tab is added, it is added at the beginning of the tab list,
 unless the optional argument APPEND is non-nil, in which case it is
 added at the end."
              (let ((tabs (tabbar-tabs tabset)))
                (if (tabbar-get-tab object tabset)
                    tabs
                  (let ((tab (tabbar-make-tab object tabset)))
                    (tabbar-set-template tabset nil)
                    (set tabset (sort (cons tab tabs)
                                      (lambda (a b) (string< (buffer-name (car a)) (buffer-name (car b))))))))))

            ;; Reduce tabbar width to enable as many buffers as possible
            (defun tabbar-buffer-tab-label (tab)
              "Return a label for TAB.
That is, a string used to represent it on the tab bar."
              (let ((label  (if tabbar--buffer-show-groups
                                (format "[%s] " (tabbar-tab-tabset tab))
                              (format "%s" (tabbar-tab-value tab)))))
                ;; Unless the tab bar auto scrolls to keep the selected tab
                ;; visible, shorten the tab label to keep as many tabs as possible
                ;; in the visible area of the tab bar.
                (if nil ;; tabbar-auto-scroll-flag
                    label
                  (tabbar-shorten
                   label (max 1 (/ (window-width)
                                   (length (tabbar-view
                                            (tabbar-current-tabset)))))))))

            ;; Tweaking the tabbar
            (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
              (setq ad-return-value
                    (if (and (buffer-modified-p (tabbar-tab-value tab))
                             (buffer-file-name (tabbar-tab-value tab)))
                        (concat "+" (concat ad-return-value ""))
                      (concat "" (concat ad-return-value "")))))

            ;; called each time the modification state of the buffer changed
            (defun my/modification-state-change ()
              (tabbar-set-template tabbar-current-tabset nil)
              (tabbar-display-update))

            ;; first-change-hook is called BEFORE the change is made
            (defun my/on-buffer-modification ()
              (set-buffer-modified-p t)
              (my/modification-state-change))

            ;; Assure switching tabs uses switch-to-buffer
            (defun switch-tabbar (num)
              (let* ((tabs (tabbar-tabs
                            (tabbar-current-tabset)))
                     (tab (nth
                           (if (> num 0) (- num 1) (+ (length tabs) num))
                           tabs)))
                (if tab (switch-to-buffer (car tab)))))))

;; Tabbar ruler
(use-package tabbar-ruler
  :demand t
  :if (and (display-graphic-p)
           (version< emacs-version "27.3"))
  :custom ((tabbar-cycle-scope             'tabs)
           (tabbar-ruler-global-tabbar     t)
           (tabbar-ruler-fancy-close-image nil))
  :config (progn
            ;; Fix for tabbar under Emacs 24.4
            ;; store tabbar-cache into a real hash,
            ;; rather than in frame parameters
            (defvar tabbar-caches (make-hash-table :test 'equal))

            (defun tabbar-create-or-get-tabbar-cache ()
              "Return a frame-local hash table that acts as a memoization
       cache for tabbar. Create one if the frame doesn't have one yet."
              (or (gethash (selected-frame) tabbar-caches)
                  (let ((frame-cache (make-hash-table :test 'equal)))
                    (puthash (selected-frame) frame-cache tabbar-caches)
                    frame-cache)))))

;; Newer built-in tabbar for Emacs
(use-package tab-line
  :if (not (version< emacs-version "27.9"))
  :preface (push "~/.emacs.d/etc/images/" image-load-path)
  :hook (after-init . global-tab-line-mode)
  :init (tabbar-mode -1)
  :custom ((tab-line-close-button-show t)
           (tab-line-new-button-show   t)
           (tab-line-separator         ""))
  :config (progn
            (defcustom tab-line-tab-min-width 10
              "Minimum width of a tab in characters."
              :type 'integer
              :group 'tab-line)
            (defcustom tab-line-tab-max-width 30
              "Maximum width of a tab in characters."
              :type 'integer
              :group 'tab-line)

            (when (display-graphic-p)
              (setq tab-line-new-button
                    (propertize " + "
                                'display `(image :type xpm
                                                 :file ,(image-search-load-path
                                                         "new@2x.xpm")
                                                 :margin (2 . 0)
                                                 :ascent center
                                                 :scale 0.75)
                                'keymap tab-line-add-map
                                'mouse-face 'tab-line-highlight
                                'help-echo "Click to add tab"))

              (setq tab-line-close-button
                    (propertize " x"
                                'display `(image :type xpm
                                                 :file ,(image-search-load-path
                                                         "close@2x.xpm")
                                                 :margin (2 . 0)
                                                 :ascent center
                                                 :scale 0.75)
                                'keymap tab-line-tab-close-map
                                'mouse-face 'tab-line-close-highlight
                                'help-echo "Click to close tab"))

              (setq tab-line-left-button
                    (propertize " <"
                                'display `(image :type xpm
                                                 :file ,(image-search-load-path
                                                         "left-arrow@2x.xpm")
                                                 :margin (2 . 0)
                                                 :ascent center
                                                 :scale 0.75)
                                'keymap tab-line-left-map
                                'mouse-face 'tab-line-highlight
                                'help-echo "Click to scroll left"))

              (setq tab-line-right-button
                    (propertize "> "
                                'display `(image :type xpm
                                                 :file ,(image-search-load-path
                                                         "right-arrow@2x.xpm")
                                                 :margin (2 . 0)
                                                 :ascent center
                                                 :scale 0.75)
                                'keymap tab-line-right-map
                                'mouse-face 'tab-line-highlight
                                'help-echo "Click to scroll right"))

              (defun my/tab-line-name-buffer (buffer &rest _buffers)
                (tabbar-mode -1)
                (with-current-buffer buffer
                  (let* ((window-width (window-width (get-buffer-window)))
                         (close-button-size (if tab-line-close-button-show
                                                (length (substring-no-properties tab-line-close-button))
                                              0))
                         (tab-amount (length (tab-line-tabs-window-buffers)))
                         (window-max-tab-width (/ window-width tab-amount))
                         (tab-width (- (cond ((>= window-max-tab-width tab-line-tab-max-width)
                                              tab-line-tab-max-width)
                                             ((< window-max-tab-width tab-line-tab-min-width)
                                              tab-line-tab-min-width)
                                             (t window-max-tab-width))
                                       close-button-size))
                         (buffer-name (string-trim (buffer-name)))
                         (name-width (length buffer-name)))
                    (if (>= name-width (- tab-width 3))
                        (concat  " " (truncate-string-to-width buffer-name (- tab-width 3)) "… ")
                      (let* ((padding (make-string (/ (- tab-width name-width) 2) ?\s))
                             (buffer-name (concat padding buffer-name))
                             (name-width (length buffer-name)))
                        (concat buffer-name (make-string (- tab-width name-width) ?\s)))))))

              (setq tab-line-tab-name-function #'my/tab-line-name-buffer))))

(provide 'setup-tabbar)
;;; setup-tabbar.el ends here
