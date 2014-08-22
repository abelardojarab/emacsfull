;;; setup-tabbar.el ---

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

;; Tabbar mode
(add-to-list 'load-path "~/.emacs.d/tabbar")
(require 'tabbar)
(tabbar-mode)
(global-set-key [s-left] 'tabbar-backward)
(global-set-key [s-right] 'tabbar-forward)
(global-set-key [s-up] 'tabbar-forward-group)
(global-set-key [s-down] 'tabbar-backward-group)
(global-set-key "\C-c+" 'tabbar-forward)
(global-set-key "\C-c-" 'tabbar-backward)
(global-set-key "\C-c-" 'tabbar-backward)
(global-set-key "\C-c*" 'other-window)
(global-set-key [C-prior] 'tabbar-backward)
(global-set-key [C-next] 'tabbar-forward)
(global-set-key [M-prior] 'tabbar-backward-group)
(global-set-key [M-next] 'tabbar-forward-group)
(global-set-key [(control meta prior)] 'tabbar-forward-group)
(global-set-key [(control meta next)] 'tabbar-backward-group)

;; Tweaking the tabbar
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
        (if (and (buffer-modified-p (tabbar-tab-value tab))
                 (buffer-file-name (tabbar-tab-value tab)))
            (concat "+" (concat ad-return-value ""))
          (concat "" (concat ad-return-value "")))))

;; called each time the modification state of the buffer changed
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))

;; first-change-hook is called BEFORE the change is made
(defun ztl-on-buffer-modification ()
  (set-buffer-modified-p t)
  (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)

;; more tweaking to tabbar
(add-to-list 'load-path "~/.emacs.d/tabbar-ruler")
(setq tabbar-ruler-global-tabbar 't) ; If you want tabbar
(require 'tabbar-ruler)
(setq tabbar-separator '(0.5))

;; Define tabbar groups
(setq tabbar-buffer-groups-function
      (lambda ()
        (list (cond
               ((string-equal "*" (substring (buffer-name) 0 1)) "Emacs")
               ((eq major-mode 'dired-mode) "Dired")
               ((eq major-mode 'compilation-mode) "Compilation")
               (t "User")))))

;; necessary support function for buffer burial
(defun crs-delete-these (delete-these from-this-list)
  "Delete DELETE-THESE FROM-THIS-LIST."
  (cond
   ((car delete-these)
    (if (member (car delete-these) from-this-list)
        (crs-delete-these (cdr delete-these) (delete (car delete-these)
                                                     from-this-list))
      (crs-delete-these (cdr delete-these) from-this-list)))
   (t from-this-list)))

;; this is the list of avoided buffers
(defvar crs-hated-buffers
  '("KILL" "*Compile-Log*"))
(add-to-list 'crs-hated-buffers "*Messages*")
(add-to-list 'crs-hated-buffers "*Completions*")
(add-to-list 'crs-hated-buffers "*scratch*")
(add-to-list 'crs-hated-buffers "*etags tmp*")
(add-to-list 'crs-hated-buffers "*Python*")
(add-to-list 'crs-hated-buffers "vc")

;; might as well use this for both
(setq iswitchb-buffer-ignore (append '("^ " "*Buffer") crs-hated-buffers))
(defun crs-hated-buffers ()
  "List of buffers I never want to see, converted from names to buffers."
  (delete nil
          (append
           (mapcar 'get-buffer crs-hated-buffers)
           (mapcar (lambda (this-buffer)
                     (if (string-match "^ " (buffer-name this-buffer))
                         this-buffer))
                   (buffer-list)))))

;; bury buffer function
(defun crs-bury-buffer (&optional n)
  (interactive)
  (unless n
    (setq n 1))
  (let ((my-buffer-list (crs-delete-these (crs-hated-buffers)
                                          (buffer-list (selected-frame)))))
    (switch-to-buffer
     (if (< n 0)
         (nth (+ (length my-buffer-list) n)
              my-buffer-list)
       (bury-buffer)
       (nth n my-buffer-list)))))
(global-set-key  [C-next] 'crs-bury-buffer)
(global-set-key  [C-prior] (lambda ()
                             (interactive)
                             (crs-bury-buffer -1)))

(provide 'setup-tabbar)
;;; setup-tabbar.el ends here
