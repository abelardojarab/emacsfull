;;; setup-hydra.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2014, 2015, 2016, 2017, 2018  Abelardo Jara-Berrocal

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

(use-package hydra
  :load-path (lambda () (expand-file-name "hydra/" user-emacs-directory))
  :config (progn

            ;; Do not use lv it messes up windows layout
            (setq-default hydra-lv nil)

            (defhydra hydra-window (:color red :hint nil)
              "
 Split: _v_ert _x_:horz
Delete: _o_nly  _da_ce  _dw_indow  _db_uffer  _df_rame
  Move: _s_wap
Frames: _f_rame new  _df_ delete
  Misc: _m_ark _a_ce  _u_ndo  _r_edo"
              ("h" windmove-left)
              ("j" windmove-down)
              ("k" windmove-up)
              ("l" windmove-right)
              ("H" hydra-move-splitter-left)
              ("J" hydra-move-splitter-down)
              ("K" hydra-move-splitter-up)
              ("L" hydra-move-splitter-right)
              ("|" (lambda ()
                     (interactive)
                     (split-window-right)
                     (windmove-right)))
              ("_" (lambda ()
                     (interactive)
                     (split-window-below)
                     (windmove-down)))
              ("v" split-window-right)
              ("x" split-window-below)
                                        ;("t" transpose-frame "'")
              ;; winner-mode must be enabled
              ("u" winner-undo)
              ("r" winner-redo) ;;Fixme, not working?
              ("o" delete-other-windows :exit t)
              ("a" ace-window :exit t)
              ("f" new-frame :exit t)
              ("s" ace-swap-window)
              ("da" ace-delete-window)
              ("dw" delete-window)
              ("db" kill-this-buffer)
              ("df" delete-frame :exit t)
              ("q" nil)
              ("m" headlong-bookmark-jump))

            (defhydra hydra-multiple-cursors (:hint nil)
              "
     ^Up^            ^Down^        ^Other^
----------------------------------------------
[_p_]   Next    [_n_]   Next    [_l_] Edit lines
[_P_]   Skip    [_N_]   Skip    [_a_] Mark all
[_M-p_] Unmark  [_M-n_] Unmark  [_r_] Mark by regexp
^ ^             ^ ^             [_q_] Quit
"
              ("l" mc/edit-lines :exit t)
              ("a" mc/mark-all-like-this :exit t)
              ("n" mc/mark-next-like-this)
              ("N" mc/skip-to-next-like-this)
              ("M-n" mc/unmark-next-like-this)
              ("p" mc/mark-previous-like-this)
              ("P" mc/skip-to-previous-like-this)
              ("M-p" mc/unmark-previous-like-this)
              ("r" mc/mark-all-in-region-regexp :exit t)
              ("q" nil))

            (defhydra hydra-yasnippet (:color blue :hint nil)
              "
              ^YASnippets^
--------------------------------------------
  Modes:    Load/Visit:    Actions:

 _g_lobal  _d_irectory    _i_nsert
 _m_inor   _f_ile         _t_ryout
 _e_xtra   _l_ist         _n_ew
         _a_ll
"
              ("d" yas-load-directory)
              ("e" yas-activate-extra-mode)
              ("i" yas-insert-snippet)
              ("f" yas-visit-snippet-file :color blue)
              ("n" yas-new-snippet)
              ("t" yas-tryout-snippet)
              ("l" yas-describe-tables)
              ("g" yas/global-mode)
              ("m" yas/minor-mode)
              ("a" yas-reload-all))

            (defhydra hydra-helm (:hint nil :color pink)
              "
                                                                          ╭──────┐
   Navigation   Other  Sources     Mark             Do             Help   │ Helm │
  ╭───────────────────────────────────────────────────────────────────────┴──────╯
        ^_k_^         _K_       _p_   [_m_] mark         [_v_] view         [_H_] helm help
        ^^↑^^         ^↑^       ^↑^   [_t_] toggle all   [_d_] delete       [_s_] source help
    _h_ ←   → _l_     _c_       ^ ^   [_u_] unmark all   [_f_] follow: %(helm-attr 'follow)
        ^^↓^^         ^↓^       ^↓^    ^ ^               [_y_] yank selection
        ^_j_^         _J_       _n_    ^ ^               [_w_] toggle windows
  --------------------------------------------------------------------------------
        "
              ("<tab>" helm-keyboard-quit "back" :exit t)
              ("<escape>" nil "quit")
              ("\\" (insert "\\") "\\" :color blue)
              ("h" helm-beginning-of-buffer)
              ("j" helm-next-line)
              ("k" helm-previous-line)
              ("l" helm-end-of-buffer)
              ("g" helm-beginning-of-buffer)
              ("G" helm-end-of-buffer)
              ("n" helm-next-source)
              ("p" helm-previous-source)
              ("K" helm-scroll-other-window-down)
              ("J" helm-scroll-other-window)
              ("c" helm-recenter-top-bottom-other-window)
              ("m" helm-toggle-visible-mark)
              ("t" helm-toggle-all-marks)
              ("u" helm-unmark-all)
              ("H" helm-help)
              ("s" helm-buffer-help)
              ("v" helm-execute-persistent-action)
              ("d" helm-persistent-delete-marked)
              ("y" helm-yank-selection)
              ("w" helm-toggle-resplit-and-swap-windows)
              ("f" helm-follow-mode))

            (defhydra hydra-toggle-map nil
              "
^Toggle^
^^^^^^^^--------------------
_d_: debug-on-error
_D_: debug-on-quit
_f_: auto-fill-mode
_l_: toggle-truncate-lines
_h_: hl-line-mode
_r_: read-only-mode
_q_: quit
"
              ("d" toggle-debug-on-error :exit t)
              ("D" toggle-debug-on-quit :exit t)
              ("f" auto-fill-mode :exit t)
              ("l" toggle-truncate-lines :exit t)
              ("r" read-only-mode :exit t)
              ("h" hl-line-mode :exit t)
              ("q" nil :exit t))

            (defhydra hydra-flycheck (:color blue)
              "
^
^Flycheck^          ^Errors^            ^Checker^
^────────^──────────^──────^────────────^───────^───────────
[_q_] quit          [_c_] check         [_s_] select
[_v_] verify setup  [_n_] next          [_d_] disable
[_m_] manual        [_p_] previous      [_?_] describe
^^                  ^^                  ^^
"
              ("q" nil)
              ("c" flycheck-buffer)
              ("d" flycheck-disable-checker)
              ("m" flycheck-manual)
              ("n" flycheck-next-error :color red)
              ("p" flycheck-previous-error :color red)
              ("s" flycheck-select-checker)
              ("v" flycheck-verify-setup)
              ("?" flycheck-describe-checker))

            (defhydra hydra-projectile (:color blue)
              "
^
^Projectile^        ^Buffers^           ^Find^              ^Search^
^──────────^────────^───────^───────────^────^──────────────^──────^────────────
[_q_] quit          [_b_] list all      [_d_] directory     [_r_] replace
[_i_] reset cache   [_k_] kill all      [_D_] root          [_s_] ag
^^                  [_S_] save all      [_f_] file          ^^
^^                  ^^                  [_p_] project       ^^
^^                  ^^                  ^^                  ^^
"
              ("q" nil)
              ("b" helm-projectile-switch-to-buffer)
              ("d" helm-projectile-find-dir)
              ("D" projectile-dired)
              ("f" helm-projectile-find-file)
              ("i" projectile-invalidate-cache :color red)
              ("k" projectile-kill-buffers)
              ("p" helm-projectile-switch-project)
              ("r" projectile-replace)
              ("s" helm-projectile-ag)
              ("S" projectile-save-project-buffers :color red))

            (defhydra hydra-org (:color pink)
              "
^
^Org^               ^Links^             ^Outline^
^───^───────────────^─────^─────────────^───────^───────────
[_q_] quit          [_i_] insert        [_a_] show all
^^                  [_n_] next          [_b_] backward
^^                  [_o_] open          [_f_] forward
^^                  [_p_] previous      [_v_] overview
^^                  [_s_] store         ^^
^^                  ^^                  ^^
"
              ("q" nil)
              ("a" show-all)
              ("b" org-backward-element)
              ("f" org-forward-element)
              ("i" org-insert-link)
              ("n" org-next-link)
              ("o" org-open-at-point)
              ("p" org-previous-link)
              ("s" org-store-link)
              ("v" org-overview))

            (defhydra hydra-org-clock (:color blue :timeout 12 :columns 4)
              "Org commands"
              ("i" (lambda () (interactive) (org-clock-in '(4))) "Clock in")
              ("o" org-clock-out "Clock out")
              ("q" org-clock-cancel "Cancel a clock")
              ("<f10>" org-clock-in-last "Clock in the last task")
              ("j" (lambda () (interactive) (org-clock-goto '(4))) "Go to a clock")
              ("m" make-this-message-into-an-org-todo-item "Flag and capture this message"))))

(provide 'setup-hydra)
;;; setup-hydra.el ends here
