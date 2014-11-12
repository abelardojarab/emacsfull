;;; setup-python.el ---

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

;; Python tweaks

(defun python-reset-imenu ()
  (interactive)
  (if (fboundp 'setq-mode-local)
      (setq-mode-local python-mode
                       imenu-create-index-function 'python-imenu-create-index))
  (setq imenu-create-index-function 'python-imenu-create-index))
(when (featurep 'python) (unload-feature 'python t))

(add-to-list 'load-path "~/.emacs.d/python-mode")
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook 'autopair-mode)
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'semantic-default-python-setup)

;; Python Hook
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))
(setq-default python-indent 2)
(setq-default python-guess-indent nil)

;; Jedi settings
(add-to-list 'load-path "~/.emacs.d/ctable")
(add-to-list 'load-path "~/.emacs.d/deferred")
(add-to-list 'load-path "~/.emacs.d/epc")
(add-to-list 'load-path "~/.emacs.d/jedi")
(add-to-list 'load-path "~/.emacs.d/python-environment")
(require 'python-environment)
(require 'epc)
(require 'jedi)
(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)
            (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)

(defun jedi:ac-direct-matches ()
  (mapcar
   (lambda (x)
     (destructuring-bind (&key word doc description symbol)
         x
       (popup-make-item word
                        :symbol symbol
                        :document (unless (equal doc "") doc))))
   jedi:complete-reply))

(eval-after-load 'jedi
  '(progn
     (custom-set-faces
      '(jedi:highlight-function-argument ((t (:inherit eldoc-highlight-function-argument)))))

     (setq jedi:tooltip-method nil)
     (defun jedi-eldoc-documentation-function ()
       (deferred:nextc
         (jedi:call-deferred 'get_in_function_call)
         #'jedi-eldoc-show)
       nil)

     (defun jedi-eldoc-show (args)
       (when args
         (let ((eldoc-documentation-function
                (lambda ()
                  (apply #'jedi:get-in-function-call--construct-call-signature args))))
           (eldoc-print-current-symbol-info))))))

;; Jedi Eldoc
(require 'jedi-eldoc)
(set-face-attribute 'jedi-eldoc:highlight-function-argument nil
                    :foreground "green")
(add-hook 'python-mode-hook 'jedi-eldoc-mode)

;; Restore semantic
(add-hook 'python-mode-hook 'wisent-python-default-setup)

(provide 'setup-python)
;;; setup-python.el ends here
