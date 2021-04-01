;;; setup-package.el ---                     -*- lexical-binding: t; -*-

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

(defun -const (c)
  "Return a function that returns C ignoring any additional arguments.

In types: a -> b -> a"
  (lambda (&rest _) c))

;;; Code:

(defvar debian-aspell-only-dictionary-alist nil)
(defvar ivy-completing-read-handlers-alist nil)

(defvar org-directory "~/workspace/Documents/Org")
(if (not (file-exists-p org-directory))
    (make-directory org-directory t))

(setq package-user-dir "~/.emacs.d/site-lisp/package-install")
(require 'package)

;; Disable checking signature from elpa
(setq package-check-signature nil)

;; in ~/.emacs.d/init.el (or ~/.emacs.d/early-init.el in Emacs 27)
(setq package-enable-at-startup nil ; don't auto-initialize!
      ;; don't add that `custom-set-variables' block to my init.el!
      package--init-file-ensured t)

;; use https for both melpa and gelpa
(eval-and-compile
  (setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                           ("melpa" . "https://melpa.org/packages/")
                           ("org"   . "http://orgmode.org/elpa/"))))

;; Since I'm managing packages with `use-package' I don't ever want to
;; save `package-selected-packages'.
(defun pd-package--save-selected-packages (&optional value)
  "Set `package-selected-packages' to VALUE."
  (when value
    (setq package-selected-packages value)))
(fset 'package--save-selected-packages 'pd-package--save-selected-packages)

;; Add all sub-directories inside Cask dir
(defun my/add-subfolders-to-load-path (parent-dir)
  "Add all level PARENT-DIR subdirs to the `load-path'."
  (dolist (f (directory-files parent-dir))
    (let ((name (expand-file-name f parent-dir)))
      (when (and (file-directory-p name)
                 (not (string-prefix-p "." f)))
        (add-to-list 'load-path name)
        (add-to-list 'custom-theme-load-path name)
        (my/add-subfolders-to-load-path name)))))

(setq my/vendor-dir (expand-file-name ".cask/27.0/elpa" user-emacs-directory))
(add-to-list 'load-path my/vendor-dir)
(my/add-subfolders-to-load-path my/vendor-dir)

(defun my/byte-recompile-elpa ()
  "Force byte-compile every `.el' file in `my/vendor-dir'.
The `.el' files are re-compiled even if the corresponding `.elc' files exist,
in all the sub-directories under `my/vendor-dir'.
If the `.elc' file does not exist, this function *does not* compile the
corresponding `.el' file."
  (interactive)
  (byte-recompile-directory my/vendor-dir nil :force))

;; Use Package
(eval-when-compile
  (require 'use-package))

(use-package use-package
  :demand t
  :custom ((use-package-expand-minimally     t)
           (use-package-compute-statistics   t)
           (use-package-verbose              t)
           (use-package-enable-imenu-support t)))

;; Use-package plugins
(use-package use-package-hydra
  :demand t)
;; (use-package use-package-el-get
;;   :demand t)

;; Baseline packages
(use-package cl)
(use-package cl-lib)
(use-package bind-key)
(use-package diminish)
(use-package let-alist)
(use-package color)
(use-package ansi-color)

;; Use Cask to fetch packages
(when (file-exists-p "~/.cask/cask.el")
  (require 'cask "~/.cask/cask.el")
  (cask-initialize)

  (use-package pallet
    :commands pallet-mode
    :config (pallet-mode t)))

;; Asynchronous bytecode compilation
(use-package async
  :defer t
  :init (use-package async-bytecomp
          :commands async-bytecomp-package-mode
          :config (async-bytecomp-package-mode 1))
  :custom (async-bytecomp-allowed-packages '(all)))

;; Essential packages
(use-package buttercup           :defer t)
(use-package ctable              :defer t)
(use-package dash                :defer t)
(use-package dash-functional     :defer t)
(use-package deferred            :defer t)
(use-package dropdown-list       :defer t)
(use-package ebib                :defer t)
(use-package epc                 :defer t)
(use-package epl                 :defer t)
(use-package f                   :defer t)
(use-package fringe-helper       :defer t)
(use-package ht                  :defer t)
(use-package list-utils          :defer t)
(use-package log4e               :defer t)
(use-package loop                :defer t)
(use-package makey               :defer t)
(use-package math-symbol-lists   :defer t)
(use-package memoize             :defer t)
(use-package names               :defer t)
(use-package parsebib            :defer t)
(use-package popup               :defer t)
(use-package popwin              :defer t)
(use-package pos-tip             :defer t)
(use-package s                   :defer t)
(use-package seq                 :defer t)
(use-package xml-rpc             :defer t)
(use-package yaxception          :defer t)

;; Tabbar mode
(use-package tabbar
  :defer t
  :commands tabbar-mode)

;; Just in case
(use-package irony
  :defer t
  :load-path (lambda () (expand-file-name "irony-mode/" user-emacs-directory)))

;; Package information
(use-package pkg-info
  :demand t)

;; Paradox
(use-package paradox
  :defer t
  :bind (("C-x C-u" . paradox-upgrade-packages))
  :custom ((paradox-execute-asynchronously t)
           (paradox-lines-per-entry        1)
           (paradox-automatically-star     t)
           (paradox-github-token           t))
  :config (progn
            ;; The "paradox-token" file is supposed to contain this line:
            ;; (setq paradox-github-token "<YOUR_TOKEN>")
            (load (locate-user-emacs-file "paradox-token") :noerror :nomessage)
            (paradox-enable))
  :commands (paradox-enable
             paradox-upgrade-packages
             paradox-list-packages))

;; Enable chord keys for packages
(use-package use-package-chords
  :defer t
  :commands key-chord-mode
  :config (key-chord-mode 1))

;; Get ensure package support
(use-package use-package-ensure-system-package
  :demand t)

;; Auto-compile .el files on load
(use-package auto-compile
  :demand t
  :custom ((auto-compile-display-buffer               nil)
           (auto-compile-mode-line-counter            t)
           (auto-compile-source-recreate-deletes-dest t)
           (auto-compile-toggle-deletes-nonlib-dest   t)
           (auto-compile-update-autoloads             t))
  :hook (auto-compile-inhibit-compile . auto-compile-inhibit-compile-detached-git-head)
  :config (progn
            (auto-compile-on-load-mode)
            (auto-compile-on-save-mode)))

(provide 'setup-package)
;;; setup-package.el ends here
