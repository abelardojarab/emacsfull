;;; hledger-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "hledger-core" "hledger-core.el" (0 0 0 0))
;;; Generated autoloads from hledger-core.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-core" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-defuns" "hledger-defuns.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from hledger-defuns.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-defuns" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-input" "hledger-input.el" (0 0 0 0))
;;; Generated autoloads from hledger-input.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-input" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-mail" "hledger-mail.el" (0 0 0 0))
;;; Generated autoloads from hledger-mail.el

(autoload 'hledger-enable-reporting "hledger-mail" "\
Report every month on `hledger-reporting-day'." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-mail" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-mode" "hledger-mode.el" (0 0 0 0))
;;; Generated autoloads from hledger-mode.el

(autoload 'hledger-company "hledger-mode" "\
Company backend for ‘hledger-mode’.
COMMAND, ARG and IGNORED the regular meanings.

\(fn COMMAND &optional ARG &rest IGNORED)" t nil)

(defvar hledger-mode-map (let ((map (make-keymap))) (define-key map (kbd "C-c C-i") 'hledger-append-clipboard-to-journal) (define-key map (kbd "C-c C-d") 'hledger-reschedule) (define-key map (kbd "C-c C-b") 'hledger-edit-amount) (define-key map (kbd "C-c C-p") 'hledger-backward-entry) (define-key map (kbd "C-c C-n") 'hledger-next-or-new-entry) (define-key map (kbd "RET") 'hledger-ret-command) (define-key map (kbd "<backtab>") 'hledger-backtab-command) map))

(autoload 'hledger-mode "hledger-mode" "\


\(fn)" t nil)

(autoload 'hledger-view-mode "hledger-mode" "\


\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-mode" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-navigate" "hledger-navigate.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from hledger-navigate.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-navigate" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-reports" "hledger-reports.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from hledger-reports.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-reports" '("hledger-")))

;;;***

;;;### (autoloads nil "hledger-suggest" "hledger-suggest.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from hledger-suggest.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-suggest" '("hledger-suggest")))

;;;***

;;;### (autoloads nil "hledger-webservice" "hledger-webservice.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from hledger-webservice.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hledger-webservice" '("hledger-")))

;;;***

;;;### (autoloads nil nil ("hledger-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; hledger-mode-autoloads.el ends here
