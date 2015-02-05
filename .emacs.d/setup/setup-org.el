;;; setup-org.el ---

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

;; write good mode
(add-to-list 'load-path "~/.emacs.d/writegood-mode")
(require 'writegood-mode nil 'noerror)

;; Org mode
(setq load-path (cons "~/.emacs.d/org-mode/lisp" load-path))
(add-to-list 'load-path "~/.emacs.d/org-mode/contrib/lisp")

(defvar org-list-allow-alphabetical t)
(defun org-element-bold-successor           (arg))
(defun org-element-code-successor           (arg))
(defun org-element-entity-successor         (arg))
(defun org-element-italic-successor         (arg))
(defun org-element-latex-fragment-successor (arg))
(defun org-element-strike-through-successor (arg))
(defun org-element-subscript-successor      (arg))
(defun org-element-superscript-successor    (arg))
(defun org-element-underline-successor      (arg))
(defun org-element-verbatim-successor       (arg))
(require 'org)
(require 'org-list)
(require 'ox-org)

(let ((todo "~/workspace/Documents/Org/agenda.org"))
  (when (file-readable-p todo)
    (setq org-agenda-files '("~/workspace/Documents/Org/agenda.org"))))
(let ((todo "~/workspace/Documents/Org/notes.org"))
  (when (file-readable-p todo)
    (setq org-default-notes-file "~/workspace/Documents/Org/notes.org")))

(add-hook 'org-mode-hook
          (lambda ()
            (flyspell-mode)))
(add-hook 'org-mode-hook
          (lambda ()
            (writegood-mode)))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-startup-folded 'nofold)
(setq org-startup-indented t)
(setq org-startup-with-inline-images t)
(setq org-startup-truncated t)
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-use-speed-commands t)
(setq org-completion-use-ido t)
(setq org-indent-mode nil) ;; this causes problem in other modes
(setq org-blank-before-new-entry ;; Insert blank line before new
      '((heading . t)            ;; headings/list items.
        (plain-list-item . t)))
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-ndays 7)

;; Org Capture
(defun org-capture-todo (note)
  (let* ((org-file org-default-notes-file)
         (type 'entry)
         (headline nil)
         (template (concat "** " note
                           "\n   SCHEDULED: %t\n")))
    (org-capture-entry org-file headline template)))

(defun org-capture-note (note)
  (let* ((org-file org-default-notes-file)
         (type 'entry)
         (headline nil)
         (template (concat "** %U " note "\n")))
    (org-capture-entry org-file headline template)))

(defun org-capture-entry (org-file headline template)
  (let* ((type 'entry)
         (org-capture-entry
          (if (headline)
              `(entry
                (file+headline ,org-file ,headline)
                ,template :clock-keep t :immediate-finish t)
            `(entry
              (file ,org-file)
              ,template :clock-keep t :immediate-finish t))))
    (require 'org-capture)
    (org-capture-noninteractively)))

;; See http://stackoverflow.com/questions/22411626/generate-org-mode-objects-programmatically
(defun org-capture-noninteractively ()
  (let* ((orig-buf (current-buffer))
         (annotation (if (and (boundp 'org-capture-link-is-already-stored)
                              org-capture-link-is-already-stored)
                         (plist-get org-store-link-plist :annotation)
                       (ignore-errors (org-store-link nil))))
         (entry org-capture-entry)
         initial)
    (setq initial (or org-capture-initial
                      (and (org-region-active-p)
                           (buffer-substring (point) (mark)))))
    (when (stringp initial)
      (remove-text-properties 0 (length initial) '(read-only t) initial))
    (when (stringp annotation)
      (remove-text-properties 0 (length annotation)
                              '(read-only t) annotation))
    (setq org-capture-plist (copy-sequence (nthcdr 3 entry)))
    (org-capture-put :target (nth 1 entry))
    (let ((txt (nth 2 entry)) (type (or (nth 0 entry) 'entry)))
      (when (or (not txt) (and (stringp txt) (not (string-match "\\S-" txt))))
        (cond
         ((eq type 'item) (setq txt "- %?"))
         ((eq type 'checkitem) (setq txt "- [ ] %?"))
         ((eq type 'table-line) (setq txt "| %? |"))
         ((member type '(nil entry)) (setq txt "* %?\n  %a"))))
      (org-capture-put :template txt :type type))
    (org-capture-get-template)
    (org-capture-put :original-buffer orig-buf
                     :original-file (or (buffer-file-name orig-buf)
                                        (and (featurep 'dired)
                                             (car (rassq orig-buf
                                                         dired-buffers))))
                     :original-file-nondirectory
                     (and (buffer-file-name orig-buf)
                          (file-name-nondirectory
                           (buffer-file-name orig-buf)))
                     :annotation annotation
                     :initial initial
                     :return-to-wconf (current-window-configuration)
                     :default-time
                     (or org-overriding-default-time
                         (org-current-time)))
    (org-capture-set-target-location)
    (condition-case error
        (org-capture-put :template (org-capture-fill-template))
      ((error quit)
       (if (get-buffer "*Capture*") (kill-buffer "*Capture*"))
       (error "Capture abort: %s" error)))
    (setq org-capture-clock-keep (org-capture-get :clock-keep))
    (condition-case error
        (org-capture-place-template
         (equal (car (org-capture-get :target)) 'function))
      ((error quit)
       (if (and (buffer-base-buffer (current-buffer))
                (string-match "\\`CAPTURE-" (buffer-name)))
           (kill-buffer (current-buffer)))
       (set-window-configuration (org-capture-get :return-to-wconf))
       (error "Error.")))
    (if (and (derived-mode-p 'org-mode)
             (org-capture-get :clock-in))
        (condition-case nil
            (progn
              (if (org-clock-is-active)
                  (org-capture-put :interrupted-clock
                                   (copy-marker org-clock-marker)))
              (org-clock-in)
              (org-set-local 'org-capture-clock-was-started t))
          (error
           "Could not start the clock in this capture buffer")))
    (if (org-capture-get :immediate-finish)
        (org-capture-finalize))))

;; Mouse in Org
(require 'org-mouse)

;; Fonts
(add-hook 'org-mode-hook (lambda () (variable-pitch-mode t)))
(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit 'fixed-pitch)
(set-face-attribute 'org-block nil :inherit 'fixed-pitch)

(defface org-block-begin-line
  '((t (:inherit org-meta-line
                 :overline "light grey" :foreground "#008ED1")))
  "Face used for the line delimiting the begin of source blocks.")

(defface org-block-end-line
  '((t (:inherit org-meta-line
                 :underline "light grey" :foreground "#008ED1")))
  "Face used for the line delimiting the end of source blocks.")

;; Beamer/ODT/Markdown support
(require 'ox-beamer)
(require 'ox-odt)
(require 'ox-md)

;; ASCII doc
(add-to-list 'load-path "~/.emacs.d/org-asciidoc")
(require 'ox-asciidoc)

;; Table ASCII plot
(add-to-list 'load-path "~/.emacs.d/orgtblasciiplot")
(require 'orgtbl-ascii-plot)

;; Org Templates
(add-to-list 'org-structure-template-alist '("E" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC\n"))
(add-to-list 'org-structure-template-alist '("S" "#+BEGIN_SRC shell-script\n?\n#+END_SRC\n"))

;; Fix shift problem in Org mode
(setq org-CUA-compatible t)
(setq org-support-shift-select 'always)
(eval-after-load "org"
  '(progn
     (eval-after-load "cua-base"
       '(progn
          (defadvice org-call-for-shift-select (before org-call-for-shift-select-cua activate)
            (if (and cua-mode
                     org-support-shift-select
                     (not (use-region-p)))
                (cua-set-mark)))))))

;; Fix on the keys
(add-hook 'org-mode-hook
          (lambda ()
            (define-key org-mode-map [kp-enter] 'org-return)
            (define-key org-mode-map [enter] 'org-return)
            (define-key org-mode-map (kbd "RET") 'org-return)))

;; define todo states: set time stamps one waiting, delegated and done
(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "IN PROGRESS(p!)"
         "HOLD(h!)"
         "WAITING(w)"
         "|"
         "DONE(d!)"
         "CANCELLED(c)")))
(setq org-todo-keyword-faces
      '(("IN PROGRESS" . 'warning)
        ("HOLD" . 'font-lock-keyword-face)
        ("WAITING" . 'font-lock-builtin-face)
        ("CANCELLED" . 'font-lock-doc-face)))

;; Abbrev mode
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))
(define-skeleton skel-org-block-elisp
  "Insert an emacs-lisp block"
  ""
  "#+begin_src emacs-lisp\n"
  _ - \n
  "#+end_src\n")
(define-abbrev org-mode-abbrev-table "elsrc" "" 'skel-org-block-elisp)

(define-skeleton skel-org-block-js
  "Insert a JavaScript block"
  ""
  "#+begin_src js\n"
  _ - \n
  "#+end_src\n")
(define-abbrev org-mode-abbrev-table "jssrc" "" 'skel-org-block-js)

;; PlantUML
(require 'iimage)
(autoload 'iimage-mode "iimage" "Support Inline image minor mode." t)
(autoload 'turn-on-iimage-mode "iimage" "Turn on Inline image minor mode." t)
(add-to-list 'iimage-mode-image-regex-alist '("@startuml\s+\\(.+\\)" . 1))
(add-to-list 'iimage-mode-image-regex-alist (cons (concat "\[\[file:\(~?" iimage-mode-image-filename-regex "\)\]") 1))
(setq org-image-actual-width '(400))

;; Rendering ditaa
(setq org-ditaa-jar-path (expand-file-name "~/.emacs.d/jar/ditaa.jar"))

;; Rendering plantuml
(setq org-plantuml-jar-path (expand-file-name "~/.emacs.d/jar/plantuml.jar"))
(defun plantuml-render-buffer ()
  (interactive)
  (message "PLANTUML Start rendering")
  (shell-command (concat "java -jar "
                         (expand-file-name "~/.emacs.d/jar/plantuml.jar")
                         " "
                         buffer-file-name))
  (message (concat "PLANTUML Rendered:  " (buffer-name))))

;; Image reloading
(defun org-reload-image-at-point ()
  (interactive)
  (message "reloading image at point in the current buffer...")
  (image-refresh (get-text-property (point) 'display)))

;; Image resizing and reloading
(defun org-resize-image-at-point ()
  (interactive)
  (message "resizing image at point in the current buffer...")
  (let* ((image-spec (get-text-property (point) 'display))
         (file (cadr (member :file image-spec))))
    (message (concat "resizing image..." file))
    (shell-command (format "convert -resize %d %s %s "
                           (* (window-width (selected-window)) (frame-char-width))
                           file file))
    (org-reload-image-at-point)))

;; Function to setup images for display on load
(defun org-turn-on-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (turn-on-iimage-mode)
  (set-face-underline-p 'org-link t)) ;; start with hidden images
(add-hook 'org-mode-hook '(lambda () (org-turn-on-iimage-in-org)))

;; Function to toggle images in a org buffer
(defun org-toggle-iimage-in-org ()
  "display images in your org file"
  (interactive)
  (if (face-underline-p 'org-link)
      (set-face-underline-p 'org-link nil)
    (set-face-underline-p 'org-link t))
  (call-interactively 'iimage-mode))

;; Preview LaTeX equations in buffers by showing images (C-c C-x C-l)
(setq org-latex-create-formula-image-program 'imagemagick)

;; Equations in Org
;; Use C-c C-x C-l to regenerate the images
(defvar text-scale-mode-hook nil
  "Hook run at end of command `text-scale-mode'.")

(defadvice text-scale-mode (after text-scale-mode-hooks nil activate)
  "Run `text-scale-mode-hook' at end of command `text-scale-mode'."
  (if (functionp text-scale-mode-hook)
      (funcall text-scale-mode-hook)
    (loop for hook in text-scale-mode-hook do
          (if (eq hook 't)
              (run-hooks (default-value text-scale-mode-hook))
            (run-hooks hook)))))

(defun org-text-scale-eye ()
  "Scale equation images according to text-scale-mode-amount."
  (when (boundp 'text-scale-mode-amount)
    (let ((relwidth (* (expt text-scale-mode-step text-scale-mode-amount))))
      (loop for ol in (overlays-in (point-min) (point-max)) do
            (when (eq (overlay-get ol 'org-overlay-type) 'org-latex-overlay)
              (unless (overlay-get ol 'org-image-original-width)
                (overlay-put ol 'org-image-original-width (car (image-size (overlay-get ol 'display) t))))
              (let ((ol-disp-plist (cdr (overlay-get ol 'display))))
                (setq ol-disp-plist (plist-put ol-disp-plist :type 'imagemagick))
                (setq ol-disp-plist (plist-put ol-disp-plist :width (round (* relwidth (overlay-get ol 'org-image-original-width)))))
                (overlay-put ol 'display (append '(image) ol-disp-plist))))))
    (force-window-update)))
(add-hook 'org-mode-hook '(lambda () (add-hook 'text-scale-mode-hook 'org-text-scale-eye)))

(defadvice org-format-latex (before set-scale activate)
  "Set :scale in `org-format-latex-options' to the scaling factor resulting from `text-scale-mode' and clear cache."
  (let ((relwidth (expt text-scale-mode-step text-scale-mode-amount)))
    (unless (= (plist-get org-format-latex-options :scale) relwidth)
      (plist-put org-format-latex-options :scale relwidth))))

;; Insert images from files #+BEGIN: image :file "~/Documents/personal/foo.png"
(defun org-dblock-write:image (params)
  (let ((file (plist-get params :file)))
    (clear-image-cache file)
    (insert-image (create-image file))))

;; Insert screenshots into Org mode, very useful
(defun org-insert-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the same
directory as the org-buffer and insert
a link to this file."
  (interactive)
  (let ((case-fold-search nil))
    (setq tilde-buffer-filename
          (replace-regexp-in-string "/" "\\" (buffer-file-name) t t))
    (setq tilde-buffer-filename
          (replace-regexp-in-string ".org" "" tilde-buffer-filename t t))
    (setq filename
          (concat
           (make-temp-name
            (concat tilde-buffer-filename
                    "_"
                    (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
    (setq filename (file-relative-name filename (file-name-directory (buffer-file-name))))
    (setq filename (replace-regexp-in-string "\\\\" "/" filename))
    (if (equal system-type 'windows-nt)
        ;; Windows: Irfanview
        (call-process "C:\\Program Files (x86)\\IrfanView\\i_view32.exe" nil nil nil (concat
                                                                                      "/clippaste /convert=" filename))

      (if (equal system-type 'darwin)
          ;; Mac OSX pngpaste utility: https://github.com/jcsalterego/pngpaste
          (call-process "pngpaste" nil nil nil filename)

        ;; Linux: ImageMagick: (call-process "import" nil nil nil filename)
        (call-process "import" nil nil nil filename))
      ) ;; if
    (insert (concat "[[file:" filename "]]"))
    (org-display-inline-images)))

;; for Tikz image in Org
(setq org-babel-latex-htlatex "htlatex")
(defmacro by-backend (&rest body)
  `(case (if (boundp 'backend) (org-export-backend-name backend) nil) ,@body))

;; for Graphviz image in Org
(add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))

;; for Gnuplot
(add-to-list 'load-path "~/.emacs.d/gnuplot")
(require 'gnuplot)

;; Tweaks for Latex exporting
(require 'ox-latex)
(setq org-latex-listings t)
(setq org-export-latex-quotes
      '(("en" ("\\(\\s-\\|[[(]\\)\"" . "\\enquote{") ("\\(\\S-\\)\"" . "}") ("\\(\\s-\\|(\\)'" . "`"))))

;; Reftex
(require 'reftex-cite)
(require 'dash)
(setq reftex-default-bibliography '("~/workspace/Documents/Bibliography/biblio.bib")) ;; So that RefTeX in Org-mode knows bibliography
(defun org-mode-reftex-setup ()
  (interactive)
  (and (buffer-file-name) (file-exists-p (buffer-file-name))
       (progn
         ;; Reftex should use the org file as master file. See C-h v TeX-master for infos.
         (setq TeX-master t)
         (turn-on-reftex)
         ;; enable auto-revert-mode to update reftex when bibtex file changes on disk
         (global-auto-revert-mode t) ; careful: this can kill the undo
         ;; history when you change the file
         ;; on-disk.
         (reftex-parse-all)
         ;; add a custom reftex cite format to insert links
         ;; This also changes any call to org-citation!
         (reftex-set-cite-format
          '((?c . "\\citet{%l}") ; natbib inline text
            (?i . "\\citep{%l}") ; natbib with parens
            ))))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
  (define-key org-mode-map (kbd "C-c (") 'org-mode-reftex-search))
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; Org-Ref
(add-to-list 'load-path "~/.emacs.d/org-ref")
(require 'org-ref)
(setq org-ref-bibliography-notes "~/workspace/Documents/Bibliography/notes.org"
      org-ref-default-bibliography '("~/workspace/Documents/Bibliography/biblio.bib")
      org-ref-pdf-directory "~/workspace/Documents/Bibliography/bibtex-pdfs")
(setq org-ref-insert-cite-key "C-c )")
(setq org-ref-default-citation-link "autocite")

;; Add defaults packages to include when exporting.
(add-to-list 'org-latex-packages-alist '("" "graphicx"))
(add-to-list 'org-latex-packages-alist '("" "geometry"))
(add-to-list 'org-latex-packages-alist '("" "hyperref"))
(add-to-list 'org-latex-packages-alist '("" "caption"))
(add-to-list 'org-latex-packages-alist '("" "listings"))
(add-to-list 'org-latex-packages-alist '("" "color"))
(add-to-list 'org-latex-packages-alist '("" "mathptmx"))

(add-to-list 'org-latex-classes
             '("xelatex"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{geometry}
\\usepackage{listings}
\\usepackage{hyperref}
\\usepackage{caption}
\\usepackage{color}
\\usepackage{mathptmx}
\\usepackage[section]{placeins}

\\usepackage{tikz}
\\usepackage{csquotes}
\\usepackage[backend=biber,sorting=none]{biblatex}
\\addbibresource[datatype=bibtex]{~/workspace/Documents/Bibliography/biblio.bib}

\\usepackage[]{xkeyval}
\\usepackage{paralist}

\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\renewcommand{\\rmdefault}{ptm}
\\title{}
      [NO-DEFAULT-PACKAGES]
      [NO-PACKAGES]
\\hypersetup{pdfencoding=auto,colorlinks=true}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("pdflatex"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{geometry}
\\usepackage{listings}
\\usepackage{hyperref}
\\usepackage{caption}
\\usepackage{color}
\\usepackage{mathptmx}
\\usepackage[section]{placeins}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\renewcommand{\\rmdefault}{ptm}
\\title{}
      [NO-DEFAULT-PACKAGES]
      [NO-PACKAGES]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Set default document stylesheet
(if (executable-find "xelatex")
    (setq org-latex-default-class "xelatex")
  (setq org-latex-default-class "pdflatex"))

;; Let the exporter use the -shell-escape option to let latex execute external programs.
(if (executable-find "xelatex")
    (setq org-latex-pdf-process
          '("xelatex -interaction nonstopmode -synctex=1 -shell-escape -output-directory %o %f"
            "biber %b"
            "bibtex $(basename %b)"
            "xelatex -interaction nonstopmode -synctex=1 -shell-escape -output-directory %o %f"
            "xelatex -interaction nonstopmode -synctex=1 -shell-escape -output-directory %o %f")) ;; multipass
  (setq org-latex-pdf-process
        '("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
          "bibtex $(basename %b)"
          "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
          "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"))
  ) ;; multipass

;; Tweak the PDF viewer
(eval-after-load "org"
  '(progn
     ;; .txt files aren't in the list initially, but in case that changes
     ;; in a future version of org, use if to avoid errors
     (if (assoc "\\.txt\\'" org-file-apps)
         (setcdr (assoc "\\.txt\\'" org-file-apps) "kate %s")
       (add-to-list 'org-file-apps '("\\.txt\\'" . "kate %s") t))
     ;; Change .pdf association directly within the alist
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "acroread %s")))

;; Automatically refresh inline images that are generated from Babel blocks
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;; Enable multiple languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (plantuml . t)
   (ditaa . t)
   (dot . t)
   (gnuplot . t)
   (sh . t)
   (R . t)
   (perl . t)
   (ruby . t)
   (python . t)
   (js . t)
   (C . t)
   (haskell . t)))

;; Don't ask for confirmation on every =C-c C-c= code-block compile.
(setq org-confirm-babel-evaluate nil)

;; The next block makes org-babel aware that a lower-case 'r' in a =src= block header should be processed as R.
(add-to-list 'org-src-lang-modes
             '("r" . ess-mode))

;; add emacs lisp support for minted
(setq org-latex-custom-lang-environments
      '((emacs-lisp "common-lispcode")))

;; Make org do not open other frames
(setq org-link-frame-setup (quote ((vm . vm-visit-folder-other-frame)
                                   (vm-imap . vm-visit-imap-folder-other-frame)
                                   (gnus . org-gnus-no-new-news)
                                   (file . find-file)
                                   (wl . wl-other-frame))))

;; Add missing function
(defun org-reverse-string (string)
  (apply 'string (reverse (string-to-list string))))

;; Nice bulleted lists
(add-to-list 'load-path "~/.emacs.d/org-bullets")
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; CSS for the HTML
(setq org-html-style-include-scripts nil
      org-html-style-include-default nil)
(setq org-html-style
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://thomasf.github.io/solarized-css/solarized-light.min.css\" />")

;; Use Org bold, italics, code styles
(defun org-text-wrapper (txt &optional endtxt)
  "Wraps the region with the text passed in as an argument."
  (if (use-region-p)
      (save-restriction
        (narrow-to-region (region-beginning) (region-end))
        (goto-char (point-min))
        (insert txt)
        (goto-char (point-max))
        (if endtxt
            (insert endtxt)
          (insert txt)))
    (if (looking-at "[A-z]")
        (save-excursion
          (if (not (looking-back "[     ]"))
              (backward-word))
          (progn
            (mark-word)
            (org-text-wrapper txt endtxt)))
      (progn
        (insert txt)
        (let ((spot (point)))
          (insert txt)
          (goto-char spot))))))

(defun org-text-bold () "Wraps the region with asterisks."
       (interactive)
       (org-text-wrapper "*"))

(defun org-text-italics () "Wraps the region with slashes."
       (interactive)
       (org-text-wrapper "/"))

(defun org-text-code () "Wraps the region with equal signs."
       (interactive)
       (org-text-wrapper "="))

;; Stop Org splitting window vertically
(setq org-link-frame-setup (quote ((vm . vm-visit-folder-other-frame)
                                   (vm-imap . vm-visit-imap-folder-other-frame)
                                   (gnus . org-gnus-no-new-news)
                                   (file . find-file)
                                   (wl . wl-other-frame))))

;; Fix tab problem in some modes that grab the tab key so auto-complete and yasnipet dont work
(defun iy-ac-tab-noconflict ()
  (let ((command (key-binding [tab]))) ;; remember command
    (local-unset-key [tab]) ;; unset from (kbd "<tab>")
    (local-set-key (kbd "TAB") command))) ;; bind to (kbd "TAB")
(add-hook 'ruby-mode-hook 'iy-ac-tab-noconflict)
(add-hook 'markdown-mode-hook 'iy-ac-tab-noconflict)
(add-hook 'org-mode-hook 'iy-ac-tab-noconflict)

;; Org Table of Contents
(add-to-list 'load-path "~/.emacs.d/org-toc")
(when (require 'org-toc nil t)
  (add-hook 'org-mode-hook 'org-toc-enable))

;; Strike thru headlines for DONE task
;; Stolen from http://sachachua.com/blog/2012/12/emacs-strike-through-headlines-for-done-tasks-in-org/
(setq org-fontify-done-headline t)
(custom-set-faces
 '(org-done ((t (:foreground "PaleGreen"
                             :weight normal
                             :strike-through t))))
 '(org-headline-done
   ((((class color) (min-colors 16) (background dark))
     (:foreground "LightSalmon" :strike-through t)))))

;; Org Journal
(add-to-list 'load-path "~/.emacs.d/org-journal")
(require 'org-journal)

;; Pandoc
(add-to-list 'load-path "~/.emacs.d/pandoc-mode")
(when (require 'pandoc-mode nil 'noerror)
  (add-hook 'markdown-mode-hook 'turn-on-pandoc)
  (add-hook 'org-mode-hook 'pandoc-load-default-settings)
  (add-hook 'pandoc-mode-hook 'pandoc-load-default-settings))

(provide 'setup-org)
;;; setup-org.el ends here
