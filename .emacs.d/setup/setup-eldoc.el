;;; setup-eldoc.el ---

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

;; Eldoc
(require 'eldoc)
(require 'eldoc-extension)
(setq eldoc-echo-area-use-multiline-p t)
(setq eldoc-idle-delay 0)
(add-hook 'c-mode-common-hook
          '(lambda ()
             (turn-on-eldoc-mode)))
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)))
(add-hook 'lisp-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)))
(add-hook 'python-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)))
(add-hook 'js2-mode-hook
          '(lambda ()
             (turn-on-eldoc-mode)))

(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)
(set-face-attribute 'eldoc-highlight-function-argument nil :underline "red")

;; Skill-mode
(load "skill-fn-info.el")

;; Figure out what the function name is
(defun skill-get-fnsym ()
  (let ((p (point))
        (ret nil))
    ;; Don't do anything if current word is inside a string.
    (if (= (or (char-after (1- (point))) 0) ?\")
        nil
      (progn
        (backward-up-list)
        (forward-word)
        (setq ret (thing-at-point 'symbol))))
    (goto-char p)
    ret))

(defun lispdoc-get-arg-index ()
  (save-excursion
    (let ((fn (eldoc-fnsym-in-current-sexp))
          (i 0))
      (unless (memq (char-syntax (char-before)) '(32 39))
        (condition-case err
            (backward-sexp) ;; for safety
          (error 1)))
      (condition-case err
          (while (not (equal fn (eldoc-current-symbol)))
            (setq i (1+ i))
            (backward-sexp))
        (error 1))
      (max 0 i))))

(defun lispdoc-highlight-nth-arg (doc n)
  (cond ((null doc) "")
        ((<= n 0) doc)
        (t
         (let ((i 0))
           (mapconcat
            (lambda (arg)
              (if (member arg '("&optional" "&rest" "@optional" "@key" "@rest"))
                  arg
                (prog2
                    (if (= i (1- n))
                        (put-text-property 0 (length arg) 'face '(:bold t :foreground "yellow") arg))
                    arg
                  (setq i (1+ i)))))
            (split-string doc) " ")))))

;; Function that looks up and return the docstring
(defun skill-eldoc-function ()
  "Returns a documentation string appropriate for the current context or nil."
  (condition-case err
      (let* ((current-fnsym  (skill-get-fnsym))
             (doc (skill-fn-info-get current-fnsym))
             (adviced (lispdoc-highlight-nth-arg doc
                                                 (lispdoc-get-arg-index))))
        adviced)
    ;; This is run from post-command-hook or some idle timer thing,
    ;; so we need to be careful that errors aren't ignored.
    (error (message "eldoc error: %s" err))))


(provide 'setup-eldoc)
;;; setup-eldoc.el ends here
