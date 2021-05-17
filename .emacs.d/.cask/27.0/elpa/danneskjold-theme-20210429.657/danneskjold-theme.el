;; danneskjold-theme.el --- beautiful high-contrast theme

;; Copyright (c) 2016 Dmitry Akatov

;; Author: Dmitry Akatov <akatovda@yandex.com>
;; URL: https://github.com/rails-to-cosmos/
;; Package-Version: 20160311.458

;;; Commentary:

;;; Code:

(deftheme danneskjold
  "Amazing. Beautiful. Contrast.")

(let (;; (custom--inhibit-theme-enable nil)
      (c '((class color) (min-colors 89)))
      (class '((class color) (min-colors 89)))
      (background     "#000000")
      (fg             "#ffffff")

      ;; doom-molokai-colors
      ;; https://github.com/hlissner/emacs-doom-theme/blob/master/doom-molokai-theme.el
      (black          "#000000")
      (black-c        "#FFFFFF")

      (white          "#FFFFFF")
      (white-c        "#000000")

      (yellow         "#ffcc00") ;; "#E2C770" "#F9BA32"
      (yellow-c       "#281580")

      ;; test
      (turquoise-bright "#1abc9c")
      (turquoise-dark "#16a085")
      (green-bright "#2ecc71")
      (green-dark "#27ae60")
      (blue-bright "#3498db")
      (blue-dark "#2980b9")
      (magenta-bright "#9b59b6")
      (magenta-dark "#8e44ad")
      (grey-blue-bright "#34495e")
      (grey-blue-dark "#2c3e50")
      (yellow-bright "#f1c40f")
      (yellow-dark "#f39c12")
      (orange-bright "#e67e22")
      (orange-dark "#d35400")
      (red-bright "#e74c3c")
      (red-dark "#c0392b")
      (grey-bright2 "#ecf0f1")
      (grey-bright1 "#bdc3c7")
      (grey-dark1 "#95a5a6")
      (grey-dark2 "#7f8c8d")
      (black "#000")
      (white "#fff")

      ;; end

      (grey           "#C0C5CF")
      (grey-.5        "#828284")
      (grey-1         "#525254")
      (grey-2         "#39393D")
      (orange         "#ffa500") ;; "#FD971F"
      (red            "#E74C3C") ;; "#F34A4A"
      (magenta        "#F92672")
      (violet         "#7b68ee")
      (blue           "#4CB5F5") ;; "#268BD2"
      (blue+2         "#727280")
      (cyan           "#66D9EF")
      (green          "#B6E63E") ;; "#B3DE81"
      (green-3        "#86B20E")
      (dark-cyan      "#8FA1B3")

      ;; danneskjold-colors
      (frost        "#D0E1F9")
      (invisible    "#2b4b6e")
      (comment      "#A4C2EB")

      (sbt-midnight   "#282c34")
      (ada-midnight   "#21252b")
      (summer-flower  "#013220")
      (diredcl        "#749AF7")
      (dvi            "DarkViolet")
      (waddles        "#FF87BA")
      (krayola        "#E38B75")
      (red-forest     "#8b0000"))

  (let* ((search-bg      green)
         (search-fg      black)
         (search-rest-bg violet)
         (search-rest-fg black)
         (highlight      orange)
         (current-line   "#1F1F1F")
         (selection      "#535556")
         (builtin        orange)
         (comments       grey-1)
         (constants      green)
         (delimiters     "#c0c5ce")
         (functions      cyan)
         (keywords       magenta)
         (methods        dark-cyan)
         (operators      violet)
         (type           cyan)
         (strings        green)
         (variables      orange)

         (error-highlight red)

         (active-minibuffer "#404046")

         (vc-modified    grey-2)
         (vc-added       green-3)
         (vc-deleted     red))

    (custom-theme-set-faces
     'danneskjold
     `(default ((,c (:foreground ,white :background ,black))))
     `(fringe ((,c (:foreground ,invisible))))
     `(region ((,c (:background "#373d4f"))))
     `(button ((,c (:foreground ,frost :underline t :weight normal))))
     `(link ((,c (:foreground ,frost :underline t))))
     `(menu ((,c (:foreground ,white :background ,ada-midnight))))
     `(shadow ((,c (:foreground ,comment))))

     `(secondary-selection ((,c ())))

     `(show-paren-match ((,c (:background ,blue :foreground ,white))))

     `(highlight ((,c (:background ,invisible :foreground ,black))))

     `(font-lock-string-face ((,c (:foreground ,green))))
     `(font-lock-doc-face ((,c (:foreground ,green))))
     `(font-lock-builtin-face ((,c (:foreground ,blue))))
     `(font-lock-variable-name-face ((,c (:foreground ,white))))
     `(font-lock-keyword-face ((,c (:foreground ,frost))))
     `(font-lock-comment-face ((,c (:foreground ,comment))))
     `(font-lock-comment-delimiter-face ((,c (:foreground ,invisible))))
     `(font-lock-function-name-face ((,c (:foreground ,yellow))))
     `(font-lock-type-face ((,c (:foreground ,orange))))
     `(font-lock-constant-face ((,c (:foreground ,yellow))))
     `(font-lock-warning-face ((,c (:foreground ,yellow))))

     `(mmm-default-submode-face ((,c (:background ,ada-midnight))))

     `(header-line ((,c (:background ,black
                         :foreground ,comment
                         :underline ,comment
                         :weight normal))))

     ;; Mode-line
     `(mode-line ((,c (:background ,black :foreground ,comment))))
     `(mode-line-inactive ((,c (:background ,black :foreground ,invisible))))
     `(mode-line-buffer-id ((,c (:foreground ,white))))
     `(org-mode-line-clock ((,c (:foreground ,yellow))))
     `(org-mode-line-clock-overrun ((,c (:foreground ,red))))

     `(compilation-error ((,c (:foreground ,red))))
     `(compilation-line-number ((,c (:foreground ,green))))
     `(compilation-column-number ((,c (:foreground ,blue))))
     `(compilation-warning ((,c :foreground ,yellow)))
     `(compilation-info ((,c (:foreground ,diredcl))))

     ;; Linum
     `(line-number ((,c (:foreground ,invisible))))
     `(line-number-current-line ((,c (:foreground ,white))))

     `(linum ((,c (:foreground ,invisible))))
     `(linum-highlight-face ((,c (:foreground ,white))))

     `(widget-field ((,c (:foreground ,white :background ,sbt-midnight))))
     `(widget-button ((,c (:foreground ,yellow))))

     ;; Highlight quoted mode-line
     `(highlight-quoted-symbol ((,c (:foreground ,waddles))))
     `(highlight-symbol-face ((,c (:foreground ,black :background ,diredcl))))

     ;; Hl-line
     `(hl-line ((,c (:background "keyboardFocusIndicatorColor"))))

     ;; search
     `(isearch ((,c (:foreground ,black :background ,invisible))))
     `(lazy-highlight ((,c (:foreground ,black :background ,yellow))))

     ;; diff
     `(diff-added ((,class (:foreground ,green-dark))))
     `(diff-changed ((,class (:foreground ,magenta-bright))))
     `(diff-removed ((,class (:foreground ,yellow-dark))))
     `(diff-header ((,class (:foreground ,magenta-dark :background nil))))
     `(diff-file-header ((,class (:foreground ,blue-dark :background nil))))
     `(diff-hunk-header ((,class (:foreground ,magenta-bright))))
     `(diff-refine-removed ((,class (:inherit magit-diff-removed-highlight :foreground ,red-bright))))
     `(diff-refine-added ((,class (:inherit magit-diff-added-highlight :foreground ,blue-bright))))

     ;; diff-hl
     `(diff-hl-change ((,class (:foreground ,blue-dark :background ,blue-dark))))
     `(diff-hl-delete ((,class (:foreground ,orange-bright :background ,orange-dark))))
     `(diff-hl-insert ((,class (:foreground ,green-dark :background ,green-dark))))

     ;; ediff
     `(ediff-even-diff-A ((,class (:foreground nil :background nil :inverse-video t))))
     `(ediff-even-diff-B ((,class (:foreground nil :background nil :inverse-video t))))
     `(ediff-odd-diff-A  ((,class (:foreground ,grey-dark1 :background nil :inverse-video t))))
     `(ediff-odd-diff-B  ((,class (:foreground ,grey-dark1 :background nil :inverse-video t))))

     ;; dired+
     `(diredp-compressed-file-suffix ((,class (:foreground ,yellow-dark))))
     `(diredp-date-time ((,class (:foreground ,yellow-bright))))
     `(diredp-deletion ((,class (:foreground ,red-bright :weight bold :slant italic))))
     `(diredp-deletion-file-name ((,class (:foreground ,red-bright :underline t))))
     `(diredp-dir-heading ((,class (:foreground ,red-bright))))
     `(diredp-dir-priv ((,class (:foreground ,magenta-bright :background nil))))
     `(diredp-exec-priv ((,class (:foreground ,green-bright :background nil))))
     `(diredp-executable-tag ((,class (:foreground ,green-bright :background nil))))
     `(diredp-file-name ((,class (:foreground ,white))))
     `(diredp-file-suffix ((,class (:foreground "coral"))))
     `(diredp-flag-mark ((,class (:foreground ,red-bright :weight bold))))
     `(diredp-flag-mark-line ((,class (:inherit highlight))))
     `(diredp-ignored-file-name ((,class (:foreground ,grey-dark1))))
     `(diredp-link-priv ((,class (:background nil :foreground ,orange-bright))))
     `(diredp-mode-line-flagged ((,class (:foreground ,yellow-dark))))
     `(diredp-mode-line-marked ((,class (:foreground ,magenta-bright))))
     `(diredp-no-priv ((,class (:foreground ,grey-dark1 :background nil))))
     `(diredp-number ((,class (:foreground ,yellow-dark))))
     `(diredp-other-priv ((,class (:background nil :foreground ,yellow-dark))))
     `(diredp-rare-priv ((,class (:foreground ,red-dark :background nil))))
     `(diredp-read-priv ((,class (:foreground ,blue-dark :background nil))))
     `(diredp-symlink ((,class (:foreground ,orange-bright))))
     `(diredp-write-priv ((,class (:foreground ,magenta-bright :background nil))))
     `(diredp-date-time ((,c (:foreground ,diredcl))))
     `(diredp-dir-name ((,c (:foreground "DeepSkyBlue1"))))
     `(diredp-ignored-file-name ((,c ())))
     `(diredp-compressed-file-suffix ((,c (:foreground ,orange))))
     `(diredp-rainbow-media-face ((,c (:foreground ,yellow))))
     `(diredp-symlink ((,c (:foreground ,yellow))))
     `(diredp-number ((,c (:foreground ,yellow))))

     ;; Magit
     ;; `(git-commit-summary ((,c (:foreground ,white))))
     ;; `(git-commit-comment-file ((,c (:foreground ,green))))
     ;; `(git-commit-comment-heading ((,c (:foreground ,frost))))

     ;; `(magit-diff-added ((,c (:foreground ,green))))
     ;; `(magit-diff-added-highlight ((,c (:foreground ,green))))
     ;; `(magit-diff-removed ((,c (:foreground ,red))))
     ;; `(magit-diff-removed-highlight ((,c (:foreground ,red))))
     ;; `(magit-diff-context ((,c (:background ,black :foreground ,frost))))
     ;; `(magit-diff-context-highlight ((,c (:background ,black :foreground ,frost))))
     ;; `(magit-section-highlight ((,c (:background ,black))))
     ;; `(magit-section-heading ((,c (:foreground ,yellow))))
     ;; `(magit-diff-hunk-heading ((,c (:foreground ,blue :background ,sbt-midnight))))
     ;; `(magit-diff-hunk-heading-highlight ((,c (:foreground ,blue :background ,sbt-midnight))))
     ;; `(magit-diff-lines-heading ((,c (:foreground ,frost :background ,sbt-midnight))))
     ;; `(magit-blame-heading ((,c (:foreground ,blue :background ,sbt-midnight))))
     ;; `(magit-diff-lines-heading ((,c (:foreground ,orange :background ,sbt-midnight))))
     ;; `(magit-diff-lines-boundary ((,c (:foreground ,white :background ,sbt-midnight))))
     ;; `(magit-diff-hunk-heading-highlight ((,c (:foreground ,white :background ,sbt-midnight))))

     ;; ein
     `(ein:cell-input-area ((,class (:background ,ada-midnight))))
     `(ein:cell-output-area ((,class (:background ,black))))
     `(ein:cell-input-prompt ((,class (:foreground ,yellow))))
     `(ein:cell-output-prompt ((,class (:foreground ,orange))))

     ;; lsp
     `(lsp-face-highlight-read ((,class (:underline ,blue))))

     ;; magit
     `(magit-branch ((,class (:foreground ,green-dark))))
     `(magit-header ((,class (:inherit nil :weight bold))))
     `(magit-item-highlight ((,class (:inherit highlight :background nil))))
     `(magit-log-graph ((,class (:foreground ,grey-dark2))))
     `(magit-log-sha1 ((,class (:foreground ,yellow-bright))))
     `(magit-log-head-label-bisect-bad ((,class (:foreground ,red-dark))))
     `(magit-log-head-label-bisect-good ((,class (:foreground ,green-dark))))
     `(magit-log-head-label-default ((,class (:foreground ,yellow-bright :box nil :weight bold))))
     `(magit-log-head-label-local ((,class (:foreground ,magenta-bright :box nil :weight bold))))
     `(magit-log-head-label-remote ((,class (:foreground ,magenta-bright :box nil :weight bold))))
     `(magit-log-head-label-tags ((,class (:foreground ,magenta-dark :box nil :weight bold))))
     `(magit-section-title ((,class (:foreground ,blue-dark :weight bold))))

     ;; magit `next'
     `(magit-section ((,class (:inherit nil))))
     `(magit-section-highlight ((,class (:background "#0e1824"))))
     `(magit-section-heading ((,class (:foreground ,blue-bright))))
     `(magit-branch-local ((,class (:foreground ,turquoise-bright))))
     `(magit-branch-remote ((,class (:foreground ,yellow-bright))))
     `(magit-hash ((,class (:foreground ,grey-bright2))))
     `(magit-diff-file-heading ((,class (:foreground ,yellow))))
     `(magit-diff-file-heading-highlight ((,class (:foreground ,yellow-bright :background "#0e1824"))))
     `(magit-diff-hunk-heading ((,class (:foreground ,magenta-bright))))
     `(magit-diff-hunk-heading-highlight ((,class (:inherit magit-diff-hunk-heading :weight bold))))
     `(magit-diff-context ((,class (:foreground ,grey-bright1))))
     `(magit-diff-context-highlight ((,class (:foreground ,grey-bright2 :background "#0e1824"))))
     `(magit-diff-added ((,class (:foreground ,green-dark))))
     `(magit-diff-added-highlight ((,class (:foreground ,green-bright :background "#0e1824"))))
     `(magit-diff-removed ((,class (:foreground ,red-dark))))
     `(magit-diff-removed-highlight ((,class (:foreground ,red-bright :background "#0e1824"))))

     ;; ledger
     `(ledger-font-xact-highlight-face ((,class (:background "#0e1824"))))

     ;; Monky
     `(monky-diff-add ((,c (:foreground ,green))))
     `(monky-diff-del ((,c (:foreground ,red))))

     ;; Org-mode
     `(org-tag                      ((,c (:foreground ,frost :slant italic))))
     `(org-ellipsis                 ((,c (:inherit hs-face :underline nil))))
     `(org-link                     ((,c (:foreground ,frost :underline ,invisible))))
     `(org-hide                     ((,c (:foreground ,black))))
     `(org-table                    ((,c (:foreground ,yellow))))
     `(org-quote                    ((,c (:slant italic :foreground ,white))))
     `(org-document-info            ((,c (:foreground ,white))))
     `(org-document-info-keyword    ((,c (:foreground ,frost :bold t))))
     `(org-meta-line                ((,c (:foreground ,frost))))
     `(org-block                    ((,c (:background "#0e1824"))))
     `(org-block-begin-line         ((,c (:foreground "selectedControlColor" :slant italic))))
     `(org-block-end-line           ((,c (:inherit org-block-begin-line))))
     `(org-archived                 ((,c (:foreground ,invisible))))
     `(org-document-title           ((,c (:foreground ,white :bold t))))
     `(org-level-1                  ((,c (:foreground ,white))))
     `(org-level-2                  ((,c (:foreground ,white))))
     `(org-level-3                  ((,c (:foreground ,white))))
     `(org-level-4                  ((,c (:foreground ,white))))
     `(org-level-5                  ((,c (:foreground ,white))))
     `(org-level-6                  ((,c (:foreground ,white))))
     `(org-level-7                  ((,c (:foreground ,white))))
     `(org-level-8                  ((,c (:foreground ,white))))
     `(org-code                     ((,c (:foreground ,orange))))
     `(org-column                   ((,c (:background ,black))))
     `(org-column-title             ((,c (:background ,black :foreground ,comment))))
     `(org-formula                  ((,c (:foreground ,orange))))
     `(org-latex-and-related        ((,c (:foreground "#FAF9FF"))))
     `(org-list-dt                  ((,c (:foreground ,yellow))))
     `(org-footnote                 ((,c (:foreground ,orange))))
     `(org-priority                 ((,c (:foreground ,white))))
     `(org-drawer                   ((,c (:foreground ,orange))))

     `(org-date                     ((,c (:foreground "LightSteelBlue2" :underline "LightSteelBlue4"))))
     `(org-todo                     ((,c (:foreground ,yellow))))
     `(org-done                     ((,c (:foreground ,green))))
     `(org-special-keyword          ((,c (:foreground "#ffcc00"))))
     `(org-property-value          ((,c (:foreground ,white))))
     `(org-checkbox-statistics-todo ((,c (:inherit org-todo))))
     `(org-checkbox-statistics-done ((,c (:inherit org-done))))

     `(org-headline-done ((,c (:foreground ,comment))))

     ;; jupyter
     `(jupyter-repl-traceback ((,c (:foreground ,orange))))

     ;; packages
     `(package-name                 ((,c (:inherit org-link))))

     ;; cider
     `(cider-stacktrace-error-class-face ((,c (:foreground ,yellow))))
     `(cider-stacktrace-error-message-face ((,c (:foreground ,green))))

     ;; minimap
     `(minimap-active-region-background ((,c (:background ,sbt-midnight))))

     ;; vc
     `(vc-annotate-face-3F3FFF ((,c (:foreground ,blue))))
     `(vc-annotate-face-FF3F3F ((,c (:foreground ,red))))
     `(vc-annotate-face-FFF33F ((,c (:foreground ,yellow))))
     `(vc-annotate-face-56FF3F ((,c (:foreground ,green))))
     `(vc-annotate-face-3FF3FF ((,c (:foreground ,frost))))
     `(vc-annotate-face-3FFF56 ((,c (:foreground ,violet))))

     ;; comint
     `(comint-highlight-input ((,c (:foreground ,white :bold t))))
     `(comint-highlight-prompt ((,c (:foreground ,cyan))))

     `(org-habit-clear-face ((,c (:background ,black :foreground ,frost :underline t))))
     `(org-habit-clear-future-face ((,c (:background ,black :underline t :foreground ,frost))))
     `(org-habit-ready-face ((,c (:background ,black :foreground ,green :underline t))))
     `(org-habit-ready-future-face ((,c (:background ,black :underline t :foreground ,green))))
     `(org-habit-alert-face ((,c (:background ,black :underline t :foreground ,yellow))))
     `(org-habit-alert-future-face ((,c (:background ,black :underline t :foreground ,yellow))))
     `(org-habit-overdue-face ((,c (:background ,black :underline t :foreground ,red))))
     `(org-habit-overdue-future-face ((,c (:background ,black :underline t :foreground ,red))))

     `(org-scheduled ((,c (:foreground ,white))))
     `(org-warning ((,c (:foreground "#FFCA00"))))
     `(org-scheduled-today ((,c (:foreground ,white))))
     `(org-scheduled-previously ((,c (:foreground ,violet :slant italic))))
     `(org-time-grid ((,c (:foreground ,invisible))))

     `(org-agenda-clocking ((,c (:foreground ,diredcl :background ,ada-midnight))))

     `(org-agenda-date ((,c (:foreground ,blue))))
     `(org-agenda-date-today ((,c (:foreground ,white))))
     `(org-agenda-date-weekend ((,c (:foreground ,white :bold t))))

     `(org-agenda-structure ((,c (:foreground ,white))))
     `(org-agenda-calendar-event ((,c (:foreground ,yellow :slant italic))))

     `(org-agenda-done ((,c (:foreground ,green))))
     `(org-agenda-diary ((,c (:foreground ,orange :slant italic))))
     `(org-agenda-dimmed-todo-face ((,c (:foreground ,comment))))
     `(org-agenda-current-time ((,c (:foreground ,frost))))
     `(org-upcoming-deadline ((,c (:foreground ,orange))))
     `(org-upcoming-distant-deadline ((,c (:foreground ,comment))))

     ;; Hydra
     `(hydra-face-red ((,c (:foreground ,red))))
     `(hydra-face-blue ((,c (:foreground ,blue))))

     ;; Hi
     `(hi-green-b ((,c (:foreground ,green))))
     `(hi-yellow-b ((,c (:foreground ,yellow))))
     `(hi-yellow ((,c (:foreground ,black :background ,yellow))))
     `(hi-red-b ((,c (:foreground ,red))))

     ;; Bookmarks
     `(bmkp-remote-file ((,c (:foreground ,green))))
     `(bmkp-url ((,c (:foreground ,white))))
     `(bmkp-local-directory ((,c (:foreground ,blue))))
     `(bmkp-no-local ((,c (:foreground ,yellow :slant italic))))
     `(bmkp-D-mark ((,c (:foreground ,red))))

     ;; Wgrep
     `(wgrep-face                  ((,c (:foreground ,yellow))))
     `(wgrep-done-face                  ((,c (:foreground ,green))))
     `(wgrep-file-face                  ((,c (:background ,yellow-c :foreground ,yellow))))
     `(wgrep-reject-face                  ((,c (:foreground ,red))))

     ;; Perspeen
     `(perspeen-selected-face ((,c (:foreground ,frost))))

     ;; Whitespace mode
     `(whitespace-space-after-tab ((,c (:foreground ,ada-midnight))))
     `(whitespace-space ((,c (:foreground ,ada-midnight))))
     `(whitespace-hspace ((,c (:foreground ,ada-midnight))))
     `(whitespace-newline ((,c (:foreground ,ada-midnight))))
     `(whitespace-line ((,c ())))
     `(whitespace-empty ((,c (:foreground ,ada-midnight))))
     `(whitespace-tab ((,c (:foreground ,ada-midnight))))
     `(whitespace-indentation ((,c (:foreground ,ada-midnight))))

     ;; Popup
     `(popup-face ((,c (:foreground ,white :background ,ada-midnight))))
     `(popup-tip-face ((,c (:foreground ,black :background ,yellow))))
     `(popup-menu-mouse-face ((,c (:foreground ,white :background ,sbt-midnight))))
     `(popup-menu-selection-face ((,c (:foreground ,white :background ,sbt-midnight))))
     `(flx-highlight-face ((,c (:underline ,red :background ,sbt-midnight :foreground ,white))))

     ;; Powerline
     `(powerline-active1 ((,c (:foreground ,yellow))))
     `(powerline-active2 ((,c (:foreground ,comment))))
     `(powerline-inactive1 ((,c (:foreground ,comment))))
     `(powerline-inactive2 ((,c (:foreground ,comment))))

     ;; Prodigy
     `(prodigy-red-face ((,c (:foreground ,red))))
     `(prodigy-green-face ((,c (:foreground ,green))))
     `(prodigy-yellow-face ((,c (:foreground ,yellow))))

     ;; Jabber
     `(jabber-title-large ((,c (:foreground ,yellow))))
     `(jabber-title-medium ((,c (:foreground ,yellow))))
     `(jabber-title-small ((,c (:foreground ,yellow))))
     `(jabber-chat-prompt-local ((,c (:foreground ,frost))))
     `(jabber-chat-prompt-foreign ((,c(:foreground ,yellow))))
     `(jabber-roster-user-xa ((,c (:foreground ,yellow))))
     `(jabber-roster-user-online ((,c (:foreground ,green))))
     `(jabber-roster-user-offline ((,c (:foreground ,comment))))
     `(jabber-roster-user-away ((,c (:foreground ,frost))))
     `(jabber-rare-time-face ((,c (:foreground ,sbt-midnight))))

     ;; SQL*Plus
     `(sqlplus-table-head-face ((,c (:foreground ,yellow))))
     `(sqlplus-table-even-rows-face ((,c (:foreground ,white :background ,ada-midnight))))
     `(sqlplus-table-odd-rows-face ((,c (:foreground ,white))))

     ;; Rainbow-delimiters
     `(rainbow-delimiters-depth-1-face ((,c (:foreground ,green))))
     `(rainbow-delimiters-depth-2-face ((,c (:foreground ,red))))
     `(rainbow-delimiters-depth-3-face ((,c (:foreground ,frost))))
     `(rainbow-delimiters-depth-4-face ((,c (:foreground ,yellow))))
     `(rainbow-delimiters-depth-5-face ((,c (:foreground ,waddles))))
     `(rainbow-delimiters-depth-6-face ((,c (:foreground ,frost))))
     `(rainbow-delimiters-depth-7-face ((,c (:foreground ,green))))
     `(rainbow-delimiters-depth-8-face ((,c (:foreground ,red))))
     `(rainbow-delimiters-depth-9-face ((,c (:foreground ,frost))))
     `(rainbow-delimiters-depth-10-face ((,c (:foreground ,yellow))))

     ;; Company-mode
     `(company-tooltip ((,c (:foreground ,white :background ,ada-midnight))))
     `(company-tooltip-selection ((,c (:foreground ,white :background ,sbt-midnight))))
     `(company-scrollbar-fg ((,c (:background ,ada-midnight))))
     `(company-scrollbar-bg ((,c (:background ,sbt-midnight))))
     `(company-tooltip-common ((,c (:foreground ,yellow))))
     `(company-preview ((,c (:background ,sbt-midnight))))
     `(company-preview-common ((,c (:background ,sbt-midnight :foreground ,red))))
     `(company-mouse ((,c (:background ,ada-midnight))))

     ;; Elfeed
     `(elfeed-search-feed-face ((,c (:foreground ,comment))))
     `(elfeed-search-tag-face ((,c (:foreground ,green))))
     `(elfeed-search-unread-title-face ((,c (:foreground ,white))))
     `(elfeed-search-date-face ((,c (:foreground ,diredcl))))

     ;; Flycheck
     `(flycheck-warning ((,c (:underline (:color "orange" :style wave)))))
     `(flymake-error ((,c (:underline (:color "red" :style wave)))))

     ;; js2-mode
     `(js2-function-param ((,c (:foreground ,yellow))))

     ;; message
     `(message-header-name ((,c (:foreground ,comment))))
     `(message-header-subject ((,c (:foreground ,white))))
     `(message-header-to ((,c (:foreground ,white))))
     `(message-header-other ((,c (:foreground ,white))))
     `(shr-link ((,c (:foreground ,frost :underline t))))

     ;; erc
     `(erc-timestamp-face ((,c (:foreground ,red))))
     `(erc-prompt-face ((,c (:foreground ,green))))
     `(erc-nick-default-face ((,c (:foreground ,frost))))
     `(erc-notice-face ((,c (:foreground ,waddles))))
     `(erc-button ((,c (:foreground ,frost))))
     `(erc-current-nick-face ((,c (:foreground ,red))))

     ;; eshell
     `(eshell-prompt ((,c (:foreground ,red))))
     `(eshell-ls-executable ((,c (:foreground ,green))))
     `(eshell-ls-directory ((,c (:foreground ,blue))))
     `(eshell-ls-symlink ((,c (:foreground ,waddles))))
     `(eshell-ls-readonly ((,c (:foreground ,invisible))))
     `(eshell-ls-missing ((,c (:foreground ,red))))
     `(eshell-ls-product ((,c (:foreground ,comment))))
     `(eshell-ls-special ((,c (:foreground ,comment :underline t))))

     `(epe-remote-face ((,c (:foreground ,comment))))
     `(epe-dir-face ((,c (:foreground ,blue))))
     `(epe-symbol-face ((,c (:foreground ,yellow))))

     ;; dired
     `(dired-directory ((,c (:foreground ,blue))))
     `(dired-git-face ((,c (:foreground ,red))))
     `(dired-ignored ((,c (:foreground ,invisible))))
     `(dired-filetype-omit ((,c (:foreground ,invisible))))
     `(dired-filetype-common ((,c (:foreground ,yellow))))
     `(dired-filetype-execute ((,c (:foreground ,green))))
     `(dired-filetype-source ((,c (:foreground ,orange))))
     `(dired-filetype-plain ((,c (:foreground ,comment))))
     `(dired-filetype-link ((,c (:foreground ,blue :underline t))))
     `(dired-flagged ((,c (:foreground ,red :underline t))))
     `(dired-marked ((,c (:foreground ,yellow :underline t))))
     `(dired-subtree-depth-1-face ((,c (:background ,black))))
     `(dired-subtree-depth-2-face ((,c (:background ,black))))
     `(dired-subtree-depth-3-face ((,c (:background ,black))))
     `(dired-subtree-depth-4-face ((,c (:background ,black))))
     `(dired-subtree-depth-5-face ((,c (:background ,black))))
     `(dired-subtree-depth-6-face ((,c (:background ,black))))
     `(dired-subtree-depth-7-face ((,c (:background ,black))))
     `(dired-subtree-depth-8-face ((,c (:background ,black))))
     `(dired-subtree-depth-9-face ((,c (:background ,black))))

     ;; custom hacks
     `(dired-collapsed-dirs ((,c (:background ,black :foreground ,frost))))

     ;; dired-rainbow
     `(dired-rainbow-executable-unix-face ((,c (:foreground ,green))))

     `(diredp-dir-priv ((,c (:foreground ,blue))))
     `(diredp-read-priv ((,c (:foreground ,red))))
     `(diredp-write-priv ((,c (:foreground ,yellow))))
     `(diredp-exec-priv ((,c (:foreground ,green))))
     `(diredp-no-priv ((,c (:foreground ,white))))
     `(diredp-rare-priv ((,c (:foreground ,waddles))))
     `(diredp-flag-mark ((,c (:foreground ,black))))
     `(diredp-flag-mark-line ((,c (:foreground ,black :background ,yellow))))
     `(diredp-mode-line-marked ((,c (:foreground ,yellow))))
     `(diredp-deletion ((,c (:foreground ,black :background ,red))))
     `(diredp-deletion-file-name ((,c (:foreground ,black :background ,red))))
     `(diredp-mode-line-flagged ((,c (:foreground ,red))))

     ;; ido
     `(minibuffer-prompt ((,c (:foreground ,diredcl))))
     `(ido-first-match ((,c (:bold t :foreground ,white))))
     `(ido-only-match ((,c (:bold t :foreground ,white))))
     `(ido-subdir ((,c (:foreground ,frost))))
     `(ido-virtual ((,c (:foreground ,comment))))
     `(ido-vertical-match-face ((,c (:underline ,diredcl))))

     ;; ivy
     `(ivy-current-match ((,c (:foreground "#FFCA00"))))
     `(ivy-prompt-match ((,c (:bold t :foreground ,white))))
     `(ivy-confirm-face ((,c (:underline ,diredcl))))

     `(ivy-virtual ((,c (:foreground ,comment))))
     `(ivy-remote ((,c (:foreground ,white :slant italic))))
     `(ivy-cursor ((,c (:foreground ,comment))))
     `(ivy-action ((,c (:foreground ,yellow))))
     `(ivy-highlight-face ((,c (:foreground ,orange))))
     `(ivy-minibuffer-match-face-1 ((,c (:foreground ,white))))
     `(ivy-minibuffer-match-face-2 ((,c (:underline ,red))))
     `(ivy-minibuffer-match-face-3 ((,c (:underline ,orange))))
     `(ivy-minibuffer-match-face-4 ((,c (:underline ,yellow))))
     `(swiper-match-face-1 ((,c (:foreground ,white))))
     `(swiper-match-face-2 ((,c (:underline ,red))))
     `(swiper-match-face-3 ((,c (:underline ,orange))))
     `(swiper-match-face-4 ((,c (:underline ,yellow))))

     ;; vertical-border
     `(vertical-border ((,c (:foreground "#223959"))))

     ;; yas
     `(yas-field-highlight-face ((,c (:background ,ada-midnight))))

     ;; epresent
     `(epresent-title-face ((,c (:inherit 'default :height 2.0))))
     `(epresent-heading-face ((,c ())))
     `(epresent-subheading-face ((,c ())))
     `(epresent-author-face ((,c (:inherit 'default))))
     `(epresent-bullet-face ((,c (:inherit 'default))))

     ;; hackernews
     `(hackernews-score-face ((,c (:foreground ,white))))
     `(hackernews-link-face ((,c (:foreground ,green))))
     `(hackernews-comment-count-face ((,c (:foreground ,red)))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
	       (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'danneskjold)
;;; danneskjold-theme.el ends here
