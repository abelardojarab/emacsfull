;;; setup-dabbrev.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2016, 2017, 2018  Abelardo Jara-Berrocal

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

;; Abbrevs
(use-package abbrev
  :demand t
  :diminish abbrev-mode
  :init (progn
          (setq abbrev-file-name (concat (file-name-as-directory
                                          my/emacs-cache-dir)
                                         "abbrev_defs"))
          (if (file-exists-p abbrev-file-name)
              (quietly-read-abbrev-file))
          (add-hook 'kill-emacs-hook
                    'write-abbrev-file))
  :config (progn
            ;; Activate template autocompletion
            (abbrev-mode t)
            (setq save-abbrevs 'silently)
            (setq-default abbrev-mode t)
            (dolist (mode my/abbrev-modes)
              (add-hook mode (lambda () (abbrev-mode 1))))))

(provide 'setup-dabbrev)
;;; setup-dabbrev.el ends here
