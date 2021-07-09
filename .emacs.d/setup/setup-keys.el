;;; setup-keys.el ---                               -*- lexical-binding: t; -*-

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

;; Show freen keybindings for minor modes
(use-package free-keys
  :defer t
  :commands free-keys)

;; As in Windows, replace after typing a letter
(use-package delsel
  :hook (after-init . delete-selection-mode))

;; Windows-like mouse/arrow movement & selection
(use-package cua-base
  :demand t
  :init (defun cua-mode-disable () (cua-mode -1))
  :hook (((prog-mode text-mode c-mode-common) . cua-mode-disable)
         (after-init                          . transient-mark-mode))
  :bind (([remap scroll-up]    . cua-scroll-up)
         ([remap scroll-down]  . cua-scroll-down)))

;; popup-based buffer switcher
(use-package popup-switcher
  :defer t
  :commands (psw-switch-recentf
             psw-switch-buffer
             psw-switch-function
             psw-switch-projectile-files
             psw-navigate-files)
  :bind (:map ctl-x-map
              ("/" . psw-switch-function)))

;; Native file opening
(cond
 ;; Windows
 ((equal system-type 'windows-nt)
  (global-set-key "\C-x\C-f" 'dlgopen-open-files)
  (define-key menu-bar-file-menu [open-file] '("Open File..." . dlgopen-open-files))) ;; if

 ;; Linux
 ((and (equal system-type 'gnu/linux)
       (executable-find "kdialog"))
  (define-key menu-bar-file-menu [open-file] '("Open File..." . kde-open-file))) ;; if

 (t
  nil)) ;; cond

;; don't want ESC as a modifier
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Treat 'y' or <CR> as yes, 'n' as no.
(fset 'yes-or-no-p 'y-or-n-p)
(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m]  'act)

;; Commands to make my programming environment nice
(global-set-key (kbd "RET")      'newline-and-indent)
(global-set-key (kbd "")         'other-window)
(global-set-key [kp-prior]       'cua-scroll-down)
(global-set-key [prior]          'cua-scroll-down)
(global-set-key [kp-next]        'cua-scroll-up)
(global-set-key [next]           'cua-scroll-up)
(global-set-key [home]           'beginning-of-line)
(global-set-key [end]            'end-of-line)
(global-set-key [delete]         'delete-char)
(global-set-key [kp-delete]      'delete-char)
(global-set-key [(control l)]    'goto-line)
(global-set-key [(control s)]    'save-buffer)
(global-set-key [(control o)]    'counsel-find-file)
(global-set-key [(meta    s)]    'write-file)
(global-set-key [(control q)]    'save-buffers-kill-emacs)
(global-set-key [(meta    q)]    'kill-this-buffer)
(global-set-key [(control r)]    'replace-string)
(global-set-key [(control a)]    'mark-whole-buffer)
(global-set-key [(control v)]    'yank)
(global-set-key [(control tab)]  'comment-or-uncomment-region)
(global-set-key (kbd "C-c C-v")  'counsel-yank-pop)
(global-set-key (kbd "C-c C-b")  'beautify-buffer)

;; Text scale
(global-set-key [(control +)]    'text-scale-increase)
(global-set-key [(control -)]    'text-scale-decrease)

;; Buffer navigation
(global-set-key [(control n)]    'cua-scroll-down)
(global-set-key [(control p)]    'cua-scroll-up)

;; List buffers
(global-set-key (kbd "<f4>")    'ivy-switch-buffer)

;; Compile
(global-set-key (kbd "<f5>")     'recompile)

;; Flyspell
(global-set-key (kbd "<f6>")     'flyspell-check-next-highlighted-word)
(global-set-key (kbd "C-<f6>")   'helm-flyspell-correct)

;; Flycheck
(global-set-key (kbd "<f7>")     'flycheck-next-error)
(global-set-key (kbd "C-<f7>")   'helm-flycheck)

;; Neotree toggle
(global-set-key (kbd "<f8>")     'neotree-project-dir)
(global-set-key (kbd "C-<f8>")   'neotree-toggle)

;; Refresh file
(global-set-key (kbd "<f9>")     'refresh-file)

;; Menu bar
(global-set-key (kbd "<f10>")    'menu-bar-open)

;; Toggle frame maximized
(global-set-key (kbd "<f11>")    'toggle-frame-maximized)

;; Helm semantic (switch function)
(global-set-key (kbd "<f12>")     'helm-semantic-or-imenu)

;; Tabbar
(global-set-key [C-prior]             'tabbar-backward-tab)
(global-set-key [C-next]              'tabbar-forward-tab)
(global-set-key [C-home]              'tabbar-backward-group)
(global-set-key [C-end]               'tabbar-forward-group)

;; Tabbar, now using ctl-x-map
(global-set-key (kbd "C-x <prior>")   'tabbar-backward-tab)
(global-set-key (kbd "C-x <next>")    'tabbar-forward-tab)
(global-set-key (kbd "C-x <home>")    'tabbar-backward-group)
(global-set-key (kbd "C-x <end>")     'tabbar-forward-group)

;; Escape key in minibuffer
(bind-keys :map minibuffer-local-map
           ([escape] . abort-recursive-edit)
           :map minibuffer-local-ns-map
           ([escape] . abort-recursive-edit)
           :map minibuffer-local-completion-map
           ([escape] . abort-recursive-edit)
           :map minibuffer-local-isearch-map
           ([escape] . abort-recursive-edit))

;; Splitting windows
(bind-keys :map ctl-x-map
           ((kbd "|")         . split-window-right)
           ((kbd "-")         . split-window-below))

;; Jump between windows
(bind-keys :map ctl-x-map
           ((kbd "<up>")      . windmove-up)
           ((kbd "<down>")    . windmove-down)
           ((kbd "<left>")    . windmove-left)
           ((kbd "<right>")   . windmove-right))

;; Tabbar Ctrl-x mappings
(define-key ctl-x-map (kbd "<prior>") 'tabbar-backward-tab)
(define-key ctl-x-map (kbd "<next>")  'tabbar-forward-tab)
(define-key ctl-x-map (kbd "<home>")  'tabbar-backward-group)
(define-key ctl-x-map (kbd "<end>")   'tabbar-forward-group)

;; Extra Ctrl-x mappings
(bind-keys :map ctl-x-map
           ((kbd "SPC")       . my/disable-rbm-deactivate-mark)
           ((kbd ">")         . increase-left-margin)
           ((kbd "<")         . decrease-left-margin)
           ((kbd "F")         . toggle-frame-fullscreen)
           ((kbd "T")         . toggle-truncate-lines))


;; Cua mode helpers
(bind-keys :map ctl-x-map
           ((kbd "C-s")       . save-buffer)
           ((kbd "C-a")       . mark-whole-buffer)
           ((kbd "C-v")       . clipboard-yank)
           ((kbd "C-z")       . undo))

;; Overwrite other modes
(defvar my/keys-minor-mode-map (make-keymap) "my/keys-minor-mode keymap.")
(bind-keys :map my/keys-minor-mode-map
           ((kbd "<mouse-3>")                       .   mouse3-popup-menu)
           ((kbd "<C-tab>")                         .   comment-or-uncomment-region)
           ((kbd "C-/")                             .   comment-or-uncomment-region)
           ((kbd "C-?")                             .   xref-find-references)
           ((kbd "C-.")                             .   xref-find-definitions)
           ((kbd "<f12>")                           .   helm-semantic-or-imenu)
           ((kbd "C-`")                             .   helm-semantic-or-imenu)
           ((kbd "<f4>")                            .   ivy-switch-buffer)
           ((kbd "<f5>")                            .   recompile)
           ((kbd "C-o")                             .   counsel-find-file)
           ((kbd "C-b")                             .   ivy-switch-buffer))

;; Define custom key mode
(define-minor-mode my/keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t "" 'my/keys-minor-mode-map)
(diminish 'my/keys-minor-mode)
(my/keys-minor-mode 1)
(defun my/keys-disable-setup-hook ()
  (my/keys-minor-mode 0))

;; Disable overwrite for some modes
(add-hook 'org-mode-hook #'my/keys-disable-setup-hook)

;; Advice to set proper order for keymaps
;;(defadvice load (after give-my/keybindings-priority)
;;  "Try to ensure that my keybindings always have priority."
;;  (if (not (eq (car (car minor-mode-map-alist)) 'my/keys-minor-mode))
;;      (let ((mykeys (assq 'my/keys-minor-mode minor-mode-map-alist)))
;;        (assq-delete-all 'my/keys-minor-mode minor-mode-map-alist)
;;        (add-to-list 'minor-mode-map-alist mykeys))))
;;(ad-activate 'load)

;; Enable console keys
(use-package console-keys
  :if (not (display-graphic-p))
  :load-path (lambda () (expand-file-name "console-keys/" user-emacs-directory)))

;; For treemacs
(defun my/add-current-project-to-treemacs ()
  ""
  (interactive)
  (let ((project-path (projectile-project-root)))
    (treemacs-add-project-at project-path
                             (file-name-base (directory-file-name project-path)))))

(defun my/select-treemacs-or-toggle ()
  ""
  (interactive)
  (if (eq major-mode 'treemacs-mode)
      (select-window my/treemacs-prior-window)
    (setq my/treemacs-prior-window (selected-window))
    (treemacs-select-window)))

(global-set-key (kbd "<f1>") 'my/select-treemacs-or-toggle)
(define-key dired-mode-map (kbd "<f1>") 'my/select-treemacs-or-toggle)

;; Window resizing keys
;; Ctrl + Shift + <left|right|up|down>
(global-set-key (kbd "C-S-<left>")
                (lambda () (interactive)
                  (enlarge-window-horizontally 1)))
(global-set-key (kbd "C-S-<right>")
                (lambda () (interactive)
                  (shrink-window-horizontally 1)))
(global-set-key (kbd "C-S-<up>")
                (lambda () (interactive)
                  (shrink-window 1)))
(global-set-key (kbd "C-S-<down>")
                (lambda () (interactive)
                  (enlarge-window 1)))
(provide 'setup-keys)
;;; setup-keys.el ends here
