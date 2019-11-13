;;; setup-post.el ---                                -*- lexical-binding: t; -*-

;; Copyright (C) 2014-2019  Abelardo Jara-Berrocal

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

;; Add all diminished modes here

;; Disable theme before setting a new one
(defun disable-themes (&optional themes)
  (mapc #'disable-theme (or themes custom-enabled-themes)))

;; So, fringe is nice actually, but the background for it kind of sucks in leuven
;; so I set it to the same color as the background
(defun my/set-face-fringe ()
  "Set the fringe background to the same color as the regular background."
  (interactive)
  (setq my/fringe-background-color
        (face-background 'default))
  (custom-set-faces
   `(fringe ((t (:background ,my/fringe-background-color))))))

;; Default ECB theme-ing
(defun my/set-face-ecb ()
  "Set the ecb background to the same color as the regular background."
  (interactive)
  (setq my/ecb-background-color
        (face-background 'default))
  (custom-set-faces
   `(ecb-default-general-face ((t (:background ,my/ecb-background-color :inherit fixed-pitch))))
   `(ecb-default-highlight-face ((t (:inherit helm-selection-line))))))

;; Default tabbar theme-ing
(defun my/set-face-tabbar ()
  "Set the tabbar background to the same color as the regular background."
  (interactive)
  (setq tabbar-separator '(0.25))
  ;; Colors
  (set-face-attribute 'tabbar-default nil
                      :background "gray20" :foreground
                      "gray60" :distant-foreground "gray50"
                      :family "Helvetica Neue" :box nil)
  (set-face-attribute 'tabbar-unselected nil
                      :background "gray80" :foreground "black" :box nil)
  (set-face-attribute 'tabbar-modified nil
                      :foreground "red4" :box nil
                      :inherit 'tabbar-unselected)
  (set-face-attribute 'tabbar-selected nil
                      :background "#4090c0" :foreground "white" :box nil)
  (set-face-attribute 'tabbar-selected-modified nil
                      :inherit 'tabbar-selected :foreground "GoldenRod2" :box nil)
  (set-face-attribute 'tabbar-button nil
                      :box nil))

(add-hook 'after-init-hook #'my/set-face-fringe)
(add-hook 'after-init-hook #'my/set-face-tabbar)
(add-hook 'after-init-hook #'my/set-face-ecb)

(defun set-selected-frame-dark ()
  (interactive)
  (let ((frame-name (cdr (assq 'name (frame-parameters (selected-frame))))))
    (call-process-shell-command
     (format
      "xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT 'dark' -name '%s'"
      frame-name))))

;; Advice the load theme function
(defadvice load-theme (around load-theme-around)
  (let ()
    (disable-themes)
    ad-do-it

    (when (display-graphic-p)
      (set-icon-fonts
       '(("fontawesome"
          ;;                         
          #xf07c #xf0c9 #xf0c4 #xf0cb #xf017 #xf101)

         ("all-the-icons"
          ;;    
          #xe907 #xe928)

         ("github-octicons"
          ;;                        
          #xf091 #xf059 #xf076 #xf075 #xf016 #xf00a)

         ("Symbola"
          ;; 𝕊    ⨂      ∅      ⟻    ⟼     ⊙      𝕋       𝔽
          #x1d54a #x2a02 #x2205 #x27fb #x27fc #x2299 #x1d54b #x1d53d
          ;; 𝔹    𝔇       𝔗
          #x1d539 #x1d507 #x1d517))))

    ;; Add required faces
    (ignore-errors
      (if (executable-find "xprop")
          (set-selected-frame-dark)))
    (my/set-face-fringe)
    (my/set-face-tabbar)
    (my/set-face-ecb)
    (doom-modeline-mode t)

    ;; remove modeline boxes
    (set-face-attribute 'mode-line nil :box nil)
    (set-face-attribute 'mode-line-inactive nil :box nil)))
(ad-activate 'load-theme)

(if (file-exists-p custom-file-x)
    (add-hook 'after-init-hook (lambda ()
                                 (load custom-file-x :noerror :nomessage)

                                 ;; Add required faces
                                 (my/set-face-fringe)
                                 (my/set-face-tabbar)
                                 (my/set-face-ecb)

                                 ;; Set the modeline
                                 (doom-modeline-mode t)
                                 ;; (my/ecb-activate)
                                 )))

(provide 'setup-post)
;;; setup-post.el ends here
