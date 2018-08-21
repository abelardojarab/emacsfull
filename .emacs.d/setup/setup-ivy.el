;;; setup-ivy.el ---                              -*- lexical-binding: t; -*-

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
  :diminish ivy-mode
  :hook (after-init . ivy-mode)
  :defines (projectile-completion-system
        magit-completing-read-function)
  :bind (("C-c C-r" . ivy-resume)
         :map ctl-x-map
         ("s"       . swiper)
         ("b"       . ivy-switch-buffer)
         :map ivy-minibuffer-map
         ("C-v"     . ivy-yank-word))
  :chords (("BB"    . ivy-switch-buffer))
  :config (progn

            (setq ivy-do-completion-in-region      nil
                  ivy-wrap                         t
                  ivy-fixed-height-minibuffer      t
                  ivy-height                       20
                  ivy-virtual-abbreviate           'full
                  ivy-initial-inputs-alist         nil
                  ivy-count-format                 "[%d/%d]"
                  ivy-display-style                'fancy
                  ivy-format-function              'ivy-format-function-arrow
                  ivy-use-virtual-buffers          t
                  ;; disable magic slash on non-match
                  ivy-magic-slash-non-match-action nil)

            (push #'+ivy-yas-prompt yas-prompt-functions)
            (setq completion-in-region-function #'ivy-completion-in-region)

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
  :defer t
  :commands counsel-mode
  :diminish counsel-mode
  :hook (ivy-mode . counsel-mode)
  :chords (("VV" . counsel-yank-pop))
  :bind (("M-x"                     . counsel-M-x)
         ("C-o"                     . counsel-find-file)
         ("C-c C-v"                 . counsel-yank-pop)
         ("C-c C-a"                 . counsel-git-grep)
         ("C-c C-g"                 . counsel-git-checkout)
         ([remap bookmark-jump]     . counsel-bookmark)
         ([remap bookmark-set]      . counsel-bookmark)
         ([remap find-file]         . counsel-find-file)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap describe-function] . counsel-describe-function)
         :map org-mode-map
         ("C-c C-j"                 . counsel-org-goto)
         ("C-c C-t"                 . counsel-org-tag)
         :map ctl-x-map
         ("x"                       . counsel-M-x)
         ("C-r"                     . counsel-recentf)
         :map ivy-minibuffer-map
         ("M-y"                     . ivy-next-line)
         :map read-expression-map
         ("C-r"                     . counsel-expression-history))
  :config (setq counsel-yank-pop-separator
                (concat "\n\n"
                        (concat (apply 'concat (make-list 50 "---")) "\n"))))

;; Use helm for swiper
(use-package swiper-helm
  :defer t
  :after (swiper helm)
  :commands swiper-helm)

;; Select from xref candidates with Ivy
(use-package ivy-xref
  :if (and (executable-find "global")
           (boundp 'xref-backend-functions))
  :custom (xref-show-xrefs-function 'ivy-xref-show-xrefs))

;; Improve ivy-switch-buffer
(use-package ivy-rich
  :defer t
  :after swiper
  :commands ivy-switch-buffer
  :custom (ivy-rich-switch-buffer-align-virtual-buffer nil)
  :config (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer))

;; Icons for ivy
(use-package all-the-icons-ivy
  :defer t
  :if (display-grayscale-p)
  :commands all-the-icons-ivy-setup
  :after swiper
  :hook (counsel-mode . all-the-icons-ivy-setup))

;; Ivy integration with yasnippet
(use-package ivy-yasnippet
  :defer t
  :commands ivy-yasnippet)

;; Ivy source for 'pass' tool
(use-package ivy-pass
  :custom (password-store-password-length 30)
  :bind ("C-c p" . ivy-pass))

;; counsel-org-clock provides commands for displaying org clock entries
(use-package counsel-org-clock
  :defer t
  :commands (counsel-org-clock-context
             counsel-org-clock-history))

;; Ivy integration for Projectile
(use-package counsel-projectile
  :defer t
  :commands counsel-projectile-mode
  :hook (after-init . counsel-projectile-mode))

;; Tramp ivy interface
(use-package counsel-tramp
  :defer t
  :commands counsel-tramp)

(provide 'setup-ivy)
;;; setup-swiper.el ends here
