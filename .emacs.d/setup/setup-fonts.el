;;; setup-fonts.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2020  Abelardo Jara-Berrocal

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

(use-package faces
  :demand t
  :custom (inhibit-compacting-font-caches t)
  :commands fontify-frame
  :hook ((org-mode markdown-mode TeX-mode message-mode mu4e-view-mode) . variable-pitch-mode)
  :init (unless (fboundp 'set-default-font)
          (defun set-default-font (font frame)
            (interactive "Font Name-Size: ")
            (set-face-attribute 'default nil :font font)))
  :config (progn
            ;; Prefer user choices
            (if (find-font (font-spec :name my/main-programming-font))
                (if (not (find-font (font-spec :name my/main-writing-font)))
                    (setq my/main-writing-font my/main-programming-font)))

            ;; Dynamic font adjusting based on monitor resolution, using Android fonts
            (defun fontify-frame (&optional frame)
              (interactive)
              (let ()
                (when (and (find-font (font-spec :name my/main-programming-font))
                           (find-font (font-spec :name my/main-writing-font)))

                  ;; Adjust text size based on resolution
                  (case system-type
                    ('windows-nt
                     (if (> (x-display-pixel-width) 2000)
                         (progn ;; HD monitor in Windows
                           (setq my/main-programming-font-size "12")
                           (setq my/main-writing-font-size "12"))
                       (progn
                         (setq my/main-programming-font-size "11")
                         (setq my/main-writing-font-size "11"))))
                    ('darwin
                     (if (> (x-display-pixel-width) 1800)
                         (if (> (x-display-pixel-width) 2000)
                             (progn ;; Ultra-HD monitor in OSX
                               (setq my/main-programming-font-size "19")
                               (setq my/main-writing-font-size "20"))
                           (progn ;; HD monitor in OSX
                             (setq my/main-programming-font-size "16")
                             (setq my/main-writing-font-size "17")))
                       (progn
                         (setq my/main-programming-font-size "16")
                         (setq my/main-writing-font-size "16"))))
                    (t ;; Linux
                     ;; ultra high-resolution 2560x1440-pixel
                     (if (and (> (car (screen-size)) 2200)
                              (> (cadr (screen-size)) 1300)
                              (> 3000 (car (screen-size))))
                         (progn ;; Ultra-HD monitor in Linux
                           (setq my/main-programming-font-size "13")
                           (setq my/main-writing-font-size "14"))
                       ;; high-resolution 2048x1152 and 1920x1028-pixel
                       (if (and (> (car (screen-size)) 1900)
                                (> (cadr (screen-size)) 1000)
                                (> 3000 (car (screen-size))))
                           (progn ;; HD monitor in Linux
                             (setq my/main-programming-font-size "13")
                             (setq my/main-writing-font-size "13"))
                         (progn
                           (setq my/main-programming-font-size "12")
                           (setq my/main-writing-font-size "13"))))))

                  ;; Apply fonts
                  (add-to-list 'default-frame-alist (cons 'font
                                                          (concat
                                                           my/main-programming-font
                                                           "-"
                                                           my/main-programming-font-size)))
                  (set-frame-font (concat my/main-programming-font
                                          "-"
                                          my/main-programming-font-size) t)
                  (set-face-attribute 'default nil
                                      :font (concat my/main-programming-font
                                                    "-"
                                                    my/main-programming-font-size)
                                      :weight 'regular
                                      :width  'semi-condensed)
                  (set-face-attribute 'fixed-pitch nil
                                      :font (concat my/main-programming-font
                                                    "-"
                                                    my/main-programming-font-size)
                                      :weight 'regular
                                      :width  'semi-condensed)
                  (set-face-attribute 'variable-pitch nil
                                      :font (concat my/main-writing-font
                                                    "-"
                                                    my/main-writing-font-size)
                                      :weight 'normal))

                ;; Use mathematical symbols
                (when (and (display-graphic-p)
                           (find-font (font-spec :name "Fira Code")))
                  (let ((utf8-font "Fira Code"))
                    (set-fontset-font "fontset-startup" '(#x000000 . #x3FFFFF) utf8-font)
                    (set-fontset-font "fontset-default" '(#x000000 . #x3FFFFF) utf8-font)
                    (set-fontset-font "fontset-standard" '(#x000000 . #x3FFFFF) utf8-font)))

                ;; Specify fonts for all unicode characters
                (when (and (member "Fira Code" (font-family-list))
                           (display-graphic-p))
                  (set-fontset-font t 'unicode "Fira Code" nil 'prepend))))

            ;; Fontify frame only for graphical mode
            (when (display-graphic-p)
              ;; Fontify current frame
              (fontify-frame nil)
              (let (frame (selected-frame))
                (fontify-frame frame))

              ;; Fontify any future frames for emacsclient
              (add-hook 'after-make-frame-functions #'fontify-frame)

              ;; hook for setting up UI when not running in daemon mode
              (add-hook 'emacs-startup-hook (lambda () (fontify-frame (selected-frame)))))))

;; Fixed pitch for HTML
(defun fixed-pitch-mode ()
  (buffer-face-mode -1))
(add-hook 'html-mode-hook #'fixed-pitch-mode)
(add-hook 'nxml-mode-hook #'fixed-pitch-mode)

;; Pretty mode
(use-package pretty-mode
  :defer t
  :commands pretty-mode)

;; Prettier symbols
(use-package prettiy-symbols-mode
  :defer t
  :if (and (fboundp 'global-prettify-symbols-mode)
           (display-graphic-p))
  :commands (prettify-symbols-mode
             global-prettify-symbols-mode)
  :hook (org-mode . prettify-symbols-mode)
  :custom (prettify-symbols-unprettify-at-point 'right-edge)
  :config (progn
            (setq-default prettify-symbols-alist '(("#+BEGIN_SRC" . "✎")
                                                   ("#+END_SRC" . "□")
                                                   ("#+begin_src" . "✎")
                                                   ("#+end_src" . "□")
                                                   (">=" . "≥")
                                                   ("=>" . "⇨")
                                                   ("[ ]" .  "☐")
                                                   ("[X]" . "☑")
                                                   ("[-]" . "?⛞" )
                                                   ("#+TITLE" . "🕮")
                                                   ("#+DATE" . "📆")
                                                   ("#+AUTHOR" . "👤")
                                                   ("#+COLUMNS" . "▓")
                                                   ("#+EMAIL" . "🖂")
                                                   ("#+OPTIONS" . ?⚙)
                                                   ("#+TYP_TODO" . "☑")
                                                   ("#+TAGS" . ?🏷)
                                                   ("#+EXPORT_SELECT_TAGS" . ?🏷)
                                                   ("#+EXPORT_EXCLUDE_TAGS" . ?🏷)
                                                   ("#+DESCRIPTION" . ?🗎)))))

(defun set-icon-fonts (CODE-FONT-ALIST)
  "Utility to associate many unicode points with specified fonts."
  (--each CODE-FONT-ALIST
    (-let (((font . codes) it))
      (--each codes
        (set-fontset-font t `(,it . ,it) font)))))

(provide 'setup-fonts)
;;; setup-fonts.el ends here
