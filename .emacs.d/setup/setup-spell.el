;;; setup-spell.el ---

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

;; We need tell emacs to use aspell, and where your custom dictionary is.
(require 'ispell)
(setq ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))
(if (eq system-type 'darwin)
    (if (file-executable-p "/usr/local/bin/aspell")
        (progn
          (setq ispell-program-name "/usr/local/bin/aspell")
          (setq ispell-extra-args '("-d" "/Library/Application Support/cocoAspell/aspell6-en-6.0-0/en.multi")))))

;; change dictionary: "C-c e" = engelska, "C-c s"=spanish, "C-c w"=turn off flyspell
(add-hook 'text-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c s 2")
                            (lambda () (interactive)
                              (ispell-change-dictionary "american")
                              (flyspell-mode 1)
                              (flyspell-buffer)))
             (local-set-key (kbd "C-c s 1")
                            (lambda () (interactive)
                              (ispell-change-dictionary "spanish")
                              (flyspell-mode 1)
                              (flyspell-buffer)))
             (local-set-key (kbd "C-c s 0")
                            (lambda () (interactive)
                              (flyspell-mode -1)))))

;; flyspell
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

(provide 'setup-spell)
;;; setup-spell.el ends here
