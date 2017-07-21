;;; setup-ivy.el ---                              -*- lexical-binding: t; -*-

;; Copyright (C) 2016, 2017  Abelardo Jara-Berrocal

;; Author: Abelardo Jara-Berrocal <abelardojara@Abelardos-MacBook-Pro.local>
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

(use-package swiper
  :defer t
  :commands (swiper
             swiper-all
             ivy-mode
             ivy-read
             ivy-completing-read
             ivy-resume
             ivy-switch-buffer
             ivy-switch-buffer-other-window)
  :load-path (lambda () (expand-file-name "swiper/" user-emacs-directory))
  :bind (("C-c C-r" . ivy-resume)
         :map ctl-x-map
         ("s" . swiper))
  :config (progn
            (set-variable 'ivy-on-del-error-function '(lambda()))
            (setq ivy-display-style 'fancy
                  ivy-format-function 'ivy-format-function-arrow
                  ivy-use-virtual-buffers t
                  ivy-height 20
                  completion-in-region-function 'ivy-completion-in-region)

            (ivy-set-actions
             'ivy-switch-buffer
             '(("k"
                (lambda (x)
                  (kill-buffer x)
                  (ivy--reset-state ivy-last))
                "kill")
               ("j"
                ivy--switch-buffer-other-window-action
                "other window")))

            ;; advise swiper to recenter on exit
            (defun my/swiper-recenter (&rest args)
              "recenter display after swiper"
              (recenter))
            (advice-add 'swiper :after #'my/swiper-recenter)))

(use-package counsel
  :load-path (lambda () (expand-file-name "swiper/" user-emacs-directory))
  :bind (("M-x"                     . counsel-M-x)
         ("M-y"                     . counsel-yank-pop)
         ("C-o"                     . counsel-find-file)
         ("C-c v"                   . counsel-yank-pop)
         ([remap bookmark-jump]     . counsel-bookmark) ;; Jump to book or set it if it doesn't exist, C-x r b
         ([remap bookmark-set]      . counsel-bookmark)  ;; C-x r m
         ([remap find-file]         . counsel-find-file)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap describe-function] . counsel-describe-function)
         :map ctl-x-map
         ("x"                       . counsel-M-x)
         :map ivy-minibuffer-map
         ("M-y"                     . ivy-next-line))
  :config (define-key read-expression-map (kbd "C-r") #'counsel-expression-history))

(use-package swiper-helm
  :defer t
  :after (swiper helm)
  :commands swiper-helm
  :load-path (lambda () (expand-file-name "swiper-helm/" user-emacs-directory)))

(use-package ivy-rich
  :after swiper
  :commands ivy-switch-buffer
  :load-path (lambda () (expand-file-name "ivy-rich/" user-emacs-directory))
  :config (progn
            (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer)

            ;; Do not align the virtual buffers, breaks ivy-rich
            (setq ivy-rich-switch-buffer-align-virtual-buffer nil)))

(use-package all-the-icons-ivy
  :if (display-grayscale-p)
  :after swiper
  :load-path (lambda () (expand-file-name "all-the-icons-ivy/" user-emacs-directory))
  :config (all-the-icons-ivy-setup))

(provide 'setup-ivy)
;;; setup-swiper.el ends here
