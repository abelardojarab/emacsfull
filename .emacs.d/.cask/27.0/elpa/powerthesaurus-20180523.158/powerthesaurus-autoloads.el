;;; powerthesaurus-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "powerthesaurus" "powerthesaurus.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from powerthesaurus.el

(autoload 'powerthesaurus-lookup-word "powerthesaurus" "\
Find the given word's synonyms at powerthesaurus.org.

`BEGINNING' and `END' correspond to the selected text with a word to replace.
If there is no selection provided, additional input will be required.
In this case, a selected synonym will be inserted at the point.

\(fn BEGINNING END)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "powerthesaurus" '("powerthesaurus-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; powerthesaurus-autoloads.el ends here
