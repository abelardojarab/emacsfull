;;; setup-python.el ---

;; Copyright (C) 2014, 2015  abelardo.jara-berrocal

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

;; Assure correct Python
(add-to-list 'load-path "~/.emacs.d/python-mode")
(autoload 'python-mode "python-mode" "Python Mode." t)

;; Python configuration
(add-hook 'python-mode-hook 'autopair-mode)
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'hideshowvis-enable)

;; Extra
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(setq interpreter-mode-alist
      (cons '("python" . python-mode)
            interpreter-mode-alist)
      python-mode-hook
      '(lambda () (progn
               (set-variable 'python-indent-offset 4)
               (set-variable 'py-indent-offset 4)
               (set-variable 'indent-tabs-mode nil))))

;; Update imenu
(defun python-reset-imenu ()
  (interactive)
  (if (fboundp 'setq-mode-local)
      (setq-mode-local python-mode
                       imenu-create-index-function 'python-imenu-create-index))
  (setq imenu-create-index-function 'python-imenu-create-index))

;; Setup Python path
(setenv "PYTHONPATH" (concat (concat (getenv "HOME") "/workspace/pythonlibs/lib/python2.7/site-packages") ":" (getenv "PYTHONPATH")))

;; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)

;; split horizontally on execution
(setq-default py-split-windows-on-execute-function 'split-window-horizontally)

;; try to automagically figure out indentation
(setq py-smart-indentation t)

;; in cedet semantic-python-get-system-include-path forces starting of the python interpreter
(defun python-shell-internal-send-string (string) "")

;; Add Wisent
(add-hook 'python-mode-hook 'wisent-python-default-setup)

;; Python hook
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            python-indent 4
                            tab-width 4))))

;; Jedi settings
(add-to-list 'load-path "~/.emacs.d/ctable")
(add-to-list 'load-path "~/.emacs.d/deferred")
(add-to-list 'load-path "~/.emacs.d/python-environment")
(add-to-list 'load-path "~/.emacs.d/epc")
(add-to-list 'load-path "~/.emacs.d/jedi")
(require 'python-environment)
(require 'epc)
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys nil)
(setq jedi:complete-on-dot t)
(setq jedi:tooltip-method nil)
(add-hook 'python-mode-hook 'jedi-mode)

(defun jedi:ac-direct-matches ()
  (mapcar
   (lambda (x)
     (destructuring-bind (&key word doc description symbol)
         x
       (popup-make-item word
                        :symbol symbol
                        :document (unless (equal doc "") doc))))
   jedi:complete-reply))

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
      (eldoc-print-current-symbol-info))))

;; Jedi Eldoc
(require 'jedi-eldoc)
(set-face-attribute 'jedi-eldoc:highlight-function-argument nil
                    :foreground "green")
(add-hook 'python-mode-hook 'jedi-eldoc-mode)

(provide 'setup-python)
;;; setup-python.el ends here
