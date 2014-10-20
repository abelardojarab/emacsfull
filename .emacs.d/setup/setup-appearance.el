;;; setup-appearance.el ---

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

;; Non-nil means do not display continuation lines.
;; Instead, give each line of text just one screen line.
(set-default 'truncate-lines t)

;; disable line wrap
(setq-default default-truncate-lines t)

;; make side by side buffers function the same as the main window
(setq-default truncate-partial-width-windows nil)

;; Non-nil means no need to redraw entire frame after suspending.
(setq no-redraw-on-reenter nil)

;; Do not improve Emacs display engine
(setq redisplay-dont-pause t)

;; Enables narrow possibility (`narrow-to-page' function).
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Disable bidirectional text support
(setq-default bidi-display-reordering nil)

;; Marker if the line goes beyond the end of the screen (arrows)
(global-visual-line-mode 1)
(setq line-move-visual nil)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(setq visual-line-fringe-indicators '(nil right-curly-arrow))

;; Zenburn theme
(add-to-list 'load-path "~/.emacs.d/zenburn-emacs")
;; (require 'zenburn-theme)
;; (load-theme 'zenburn t)

;; Monokai theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/monokai-emacs-theme")
(load-theme 'monokai t)

;; Extra color tweaks
(set-face-foreground 'variable-pitch "#ffffff")
(set-face-foreground 'font-lock-string-face "#95e454")
(set-face-italic-p 'font-lock-string-face t)
(set-face-foreground 'font-lock-doc-face "orange")

;; Syntax coloring
(require 'font-lock+)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size (* 1024 1024))
(setq font-lock-support-mode 'jit-lock-mode ;; lazy-lock-mode
      fast-lock-cache-directories '("~/.emacs.cache"))
(setq font-lock-support-mode 'jit-lock-mode)
(setq jit-lock-stealth-time 16
      jit-lock-defer-contextually t
      jit-lock-stealth-nice 0.5)
(setq-default font-lock-multiline t)

;; Reduce line spacing
(defun toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height."
  (interactive)
  (if (eq line-spacing nil)
      (setq-default line-spacing 0.5) ;; add 0.5 height between lines
    (setq-default line-spacing nil)   ;; no extra heigh between lines
    ) ;; if
  (redraw-display))
(global-set-key (kbd "<C-f7>") 'toggle-line-spacing)

;; Use 10-pt Consolas as default font
(if (find-font (font-spec :name "Consolas"))
    (set-face-attribute 'default nil :font "Consolas-10"))

(if (find-font (font-spec :name "Cambria"))
    (set-face-attribute 'variable-pitch nil :font "Cambria-14" :weight 'normal))
(add-hook 'text-mode-hook 'variable-pitch-mode)

(if (find-font (font-spec :name "Consolas"))
    (set-face-attribute 'fixed-pitch nil :font "Consolas-10:antialias=subpixel"))

;; Fallback for Unicode symbols
(if (find-font (font-spec :name "Symbola"))
    (set-fontset-font "fontset-default" nil
                      (font-spec :size 18 :name "Symbola")))

;; Line numbers, vim style
(require 'linum)
(global-linum-mode 1)
(set-face-attribute 'linum nil :height 125)
(setq linum-delay t)

;; Format the line number
(require 'hl-line)
(defface my-linum-hl
  `((t :inherit linum :foreground "yellow" :background ,(face-background 'hl-line nil t)))
  "Face for the current line number."
  :group 'linum)

(defvar my-linum-format-string "%3d")
(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

(defun my-linum-get-format-string ()
  (let* ((width (1+ (length (number-to-string
                             (count-lines (point-min) (point-max))))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-format)

(defun my-linum-format (line-number)
  (propertize (format my-linum-format-string line-number) 'face
              (if (eq line-number my-linum-current-line-number)
                  'my-linum-hl
                'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

;; Dynamic font adjusting based on monitor resolution
(when (find-font (font-spec :name "Consolas"))
  (let ()

    ;; Finally, set the fonts as desired
    (defun set-default-font (main-programming-font frame)
      (interactive)
      (set-face-attribute 'default nil :font main-programming-font)
      (set-face-attribute 'fixed-pitch nil :font main-programming-font)
      (set-frame-parameter frame 'font main-programming-font))

    (defun fontify-frame (frame)
      (interactive)
      (let (main-writing-font main-programming-font)
        (setq main-writing-font "Consolas")
        (setq main-programming-font "Consolas-10")
        (if (find-font (font-spec :name "Cambria"))
            (setq main-writing-font "Cambria"))
        (if (find-font (font-spec :name "EB Garamond 12"))
            (setq main-writing-font "EB Garamond 12"))

        (if window-system
            (progn
              (if (> (x-display-pixel-width) 1800)
                  (if (equal system-type 'windows-nt)
                      (progn ;; HD monitor in Windows
                        (setq main-programming-font "Consolas-12:antialias=subpixel")
                        (set-default-font main-programming-font frame)
                        (setq main-writing-font (concat main-writing-font "-15"))
                        (set-face-attribute 'variable-pitch nil :font main-writing-font :weight 'normal)
                        (set-face-attribute 'linum nil :height 130))
                    (if (> (x-display-pixel-width) 2000)
                        (progn ;; Cinema display
                          (setq main-programming-font "Consolas-15:antialias=subpixel")
                          (set-default-font main-programming-font frame)
                          (setq main-writing-font (concat main-writing-font "-18"))
                          (set-face-attribute 'variable-pitch nil :font main-writing-font :weight 'normal)
                          (set-face-attribute 'linum nil :height 160))
                      (progn ;; HD monitor in Windows and Mac
                        (setq main-programming-font "Consolas-13:antialias=subpixel")
                        (set-default-font main-programming-font frame)
                        (setq main-writing-font (concat main-writing-font "-16"))
                        (set-face-attribute 'variable-pitch nil :font main-writing-font :weight 'normal)
                        (set-face-attribute 'linum nil :height 140))))
                (progn ;; Small display
                  (setq main-programming-font "Consolas-10:antialias=subpixel")
                  (set-default-font main-programming-font frame)
                  (setq main-writing-font (concat main-writing-font "-14"))
                  (set-face-attribute 'variable-pitch nil :font main-writing-font :weight 'normal)
                  (set-face-attribute 'linum nil :height 120)))))))

    ;; Fontify current frame
    (fontify-frame nil)

    ;; Fontify any future frames for emacsclient
    (push 'fontify-frame after-make-frame-functions)

    ;; hook for setting up UI when not running in daemon mode
    (add-hook 'emacs-startup-hook '(lambda () (fontify-frame nil)))))

;; Pretty lambdas
(defun pretty-lambdas ()
  (font-lock-add-keywords
   nil `(("\\<lambda\\>"
          (0 (progn (compose-region (match-beginning 0) (match-end 0)
                                    ,(make-char 'greek-iso8859-7 107))
                    nil))))))
(add-hook 'emacs-lisp-mode-hook 'pretty-lambdas)
(add-hook 'lisp-mode-hook 'pretty-lambdas)
(add-to-list 'load-path "~/.emacs.d/pretty-symbols")
(require 'pretty-symbols)
(add-hook 'lisp-mode-hook 'pretty-symbols-mode)
(add-to-list 'load-path "~/.emacs.d/pretty-mode")
(require 'pretty-mode)
(global-pretty-mode t)

;; Change form/shape of emacs cursor
(setq djcb-read-only-color "gray")
(setq djcb-read-only-cursor-type 'hbar)
(setq djcb-overwrite-color "red")
(setq djcb-overwrite-cursor-type 'box)
(setq djcb-normal-color "gray")
(setq djcb-normal-cursor-type 'bar)
(defun djcb-set-cursor-according-to-mode ()
  "change cursor color and type according to some minor modes."
  (cond
   (buffer-read-only
    (set-cursor-color djcb-read-only-color)
    (setq cursor-type djcb-read-only-cursor-type))
   (overwrite-mode
    (set-cursor-color djcb-overwrite-color)
    (setq cursor-type djcb-overwrite-cursor-type))
   (t
    (set-cursor-color djcb-normal-color)
    (setq cursor-type djcb-normal-cursor-type))))
(add-hook 'post-command-hook
          (lambda () (interactive)
            (unless (member
                     major-mode '(pdf-docs doc-view-mode))
              (djcb-set-cursor-according-to-mode))))

;; Put a nice title to the window, including filename
(add-hook 'window-configuration-change-hook
          (lambda ()
            (setq frame-title-format
                  (concat
                   invocation-name "@" system-name ": "
                   (replace-regexp-in-string
                    (concat "/home/" user-login-name) "~"
                    (or buffer-file-name "%b"))))))

;; Adjust Emacs size according to resolution
;; Next code work with Emacs 21.4, 22.3, 23.1.
(when window-system
  (add-hook 'window-setup-hook
            (let ((px (display-pixel-width))
                  (py (display-pixel-height))
                  (fx (frame-char-width))
                  (fy (frame-char-height))
                  tx ty)
              ;; Next formulas discovered empiric on Windows host with default font.
              (setq tx (- (/ px fx) 3))
              (setq ty (- (/ py fy) 8))
              (setq initial-frame-alist '((top . 2) (left . 2)))
              (add-to-list 'initial-frame-alist (cons 'width tx))
              (add-to-list 'initial-frame-alist (cons 'height ty))
              t)))

;; Maximize window if function is found
(if (fboundp 'toggle-frame-maximized)
    (add-hook 'emacs-startup-hook 'toggle-frame-maximized))

(defun x11-maximize-frame ()
  "Maximize the current frame (to full screen)"
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))

(defun w32-maximize-frame ()
  "Maximize the current frame (to full screen)"
  (interactive)
  (w32-send-sys-command #xf030))

;; highlight indentation using vertical lines, old version
(load "~/.emacs.d/elisp/00_func.el")
(require 'aux-line)
(add-hook 'c-mode-common-hook 'indent-vline)
(add-hook 'lisp-mode-hook 'indent-vline)
(add-hook 'python-mode-hook 'indent-vline)

;; Higlight indentation
(add-to-list 'load-path "~/.emacs.d/Highlight-Indentation-for-Emacs")
(require 'highlight-indentation)

;; Indent guide
(add-to-list 'load-path "~/.emacs.d/indent-guide")

;; Alternative indent hint, new version
(require 'indent-hint)
(add-hook 'js2-mode-hook 'indent-hint-js)
(require 'indent-guide)
(indent-guide-global-mode)

;; In every buffer, the line which contains the cursor will be fully highlighted
(global-hl-line-mode 1)
(defun local-hl-line-mode-off ()
  (interactive)
  (make-local-variable 'global-hl-line-mode)
  (setq global-hl-line-mode nil))
(add-hook 'org-mode-hook 'local-hl-line-mode-off)

;; Highlight symbol
(add-to-list 'load-path "~/.emacs.d/highlight-symbol")
(require 'highlight-symbol)
(add-hook 'prog-mode-hook (lambda () (highlight-symbol-mode)))
(setq highlight-symbol-on-navigation-p t)
(global-set-key [f3] 'highlight-symbol-at-point)
(global-set-key [(control f3)] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)
(global-set-key [(control shift mouse-1)]
                (lambda (event)
                  (interactive "e")
                  (goto-char (posn-point (event-start event)))
                  (highlight-symbol-at-point)))

;; Scrollbar
(set-scroll-bar-mode 'right)

;; Smart scrollbar
(defvar regexp-always-scroll-bar '("\\.yes" "\\*Scroll-Bar\\*")
  "Regexp matching buffer names that will always have scroll bars.")

(defvar regexp-never-scroll-bar '("\\.off" "\\.not")
  "Regexp matching buffer names that will never have scroll bars.")

(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))

(modify-all-frames-parameters (list (cons 'vertical-scroll-bars nil)))

(defun lawlist-scroll-bar ()
  (when (window-live-p (get-buffer-window (current-buffer)))
    (redisplay t)
    (cond
     ;; not regexp matches | not narrow-to-region
     ((and
       (not (regexp-match-p regexp-always-scroll-bar (buffer-name)))
       (not (regexp-match-p regexp-never-scroll-bar (buffer-name)))
       (equal (- (point-max) (point-min)) (buffer-size)))
      (cond
       ;; Lines of text are less-than or equal-to window height,
       ;; and scroll bars are present (which need to be removed).
       ((and
         (<= (- (point-max) (point-min)) (- (window-end) (window-start)))
         (equal (window-scroll-bars) `(15 2 right nil)))
        (set-window-scroll-bars (selected-window) 0 'right nil))
       ;; Lines of text are greater-than window height, and
       ;; scroll bars are not present and need to be added.
       ((and
         (> (- (point-max) (point-min)) (- (window-end) (window-start)))
         (not (equal (window-scroll-bars) `(15 2 right nil))))
        (set-window-scroll-bars (selected-window) 15 'right nil))))
     ;; Narrow-to-region is active, and scroll bars are present
     ;; (which need to be removed).
     ((and
       (not (equal (- (point-max) (point-min)) (buffer-size)))
       (equal (window-scroll-bars) `(15 2 right nil)))
      (set-window-scroll-bars (selected-window) 0 'right nil))
     ;; not narrow-to-region | regexp always scroll-bars
     ((and
       (equal (- (point-max) (point-min)) (buffer-size))
       (regexp-match-p regexp-always-scroll-bar (buffer-name)))
      (set-window-scroll-bars (selected-window) 15 'right nil))
     ;; not narrow-to-region | regexp never scroll-bars
     ((and
       (equal (- (point-max) (point-min)) (buffer-size))
       (regexp-match-p regexp-never-scroll-bar (buffer-name)))
      (set-window-scroll-bars (selected-window) 0 'right nil)))))

(define-minor-mode lawlist-scroll-bar-mode
  "This is a custom scroll bar mode."
  :lighter " sc"
  (if lawlist-scroll-bar-mode
      (progn
        (add-hook 'post-command-hook 'lawlist-scroll-bar nil t)
        ;; (add-hook 'change-major-mode-hook 'lawlist-scroll-bar nil t)
        ;; (add-hook 'window-configuration-change-hook 'lawlist-scroll-bar nil t)
        )
    (remove-hook 'post-command-hook 'lawlist-scroll-bar t)
    (remove-hook 'change-major-mode-hook 'lawlist-scroll-bar t)
    (remove-hook 'window-configuration-change-hook 'lawlist-scroll-bar t)))

(define-globalized-minor-mode global-lawlist-scroll-bar-mode
  lawlist-scroll-bar-mode lawlist-scroll-bar-on)

(defun lawlist-scroll-bar-on ()
  (unless (minibufferp)
    (lawlist-scroll-bar-mode 1)))

(global-lawlist-scroll-bar-mode)

;; https://github.com/kentaro/auto-save-buffers-enhanced
;; `regexp-match-p` function modified by @sds on stackoverflow
;; http://stackoverflow.com/questions/20343048/distinguishing-files-with-extensions-from-hidden-files-and-no-extensions
(defun regexp-match-p (regexps string)
  (and string
       (catch 'matched
         (let ((inhibit-changing-match-data t)) ; small optimization
           (dolist (regexp regexps)
             (when (string-match regexp string)
               (throw 'matched t)))))))

;; Heartbeat cursor
(require 'cl)
(require 'color)
(defvar heartbeat-fps 16)
(defvar heartbeat-period 5)

(defun heartbeat-range (from to cnt)
  (let ((step (/ (- to from) (float cnt))))
    (loop for i below cnt collect (+ from (* step i)))))

(defun heartbeat-cursor-colors ()
  (let ((cnt (* heartbeat-period heartbeat-fps)))
    (mapcar (lambda (r)
              (color-rgb-to-hex r 1 0))
            (nconc (heartbeat-range .2 1 (/ cnt 2))
                   (heartbeat-range 1 .2 (/ cnt 2))))))

(defvar heartbeat-cursor-timer nil)
(defvar heartbeat-cursor-old-color)

(define-minor-mode heartbeat-cursor-mode
  "Change cursor color with the heartbeat effect."
  nil "" nil
  :global t
  (when heartbeat-cursor-timer
    (cancel-timer heartbeat-cursor-timer)
    (setq heartbeat-cursor-timer nil)
    (set-face-background 'cursor heartbeat-cursor-old-color))
  (when heartbeat-cursor-mode
    (setq heartbeat-cursor-old-color (face-background 'cursor)
          heartbeat-cursor-timer
          (run-with-timer
           0 (/ 1 (float heartbeat-fps))
           (lexical-let ((colors (heartbeat-cursor-colors)) tail)
             (lambda ()
               (setq tail (or (cdr tail) colors))
               (set-face-background 'cursor (car tail))))))))

(add-hook 'prog-mode-hook (heartbeat-cursor-mode t))
(add-hook 'text-mode-hook (heartbeat-cursor-mode t))

(provide 'setup-appearance)
;;; setup-appearance.el ends here
