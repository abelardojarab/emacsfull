;;; mocker-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "mocker" "mocker.el" (0 0 0 0))
;;; Generated autoloads from mocker.el

(autoload 'mocker-let "mocker" "\
Generate temporary bindings according to MOCKSPECS then eval
BODY. The value of the last form in BODY is returned.
Each element of MOCKSPECS is a list (FUNC ARGS [OPTIONS]
RECORDS).

FUNC is the name of the function to bind, whose original
 definition must accept arguments compatible with ARGS.
OPTIONS can be :ordered nil if the records can be executed out of
order (by default, order is enforced).
RECORDS is a list ([:record-cls CLASS] ARG1 ARG2...).

Each element of RECORDS will generate a record for the
corresponding mock. By default, records are objects of the
`mocker-record' class, but CLASS is used instead if specified.
The rest of the arguments are used to construct the record
object. They will be passed to method `mocker-read-record' for
the used CLASS. This method must return a valid list of
parameters for the CLASS constructor. This allows to implement
specialized mini-languages for specific record classes.

\(fn MOCKSPECS &rest BODY)" nil t)

(function-put 'mocker-let 'lisp-indent-function '1)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mocker" '("mocker-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mocker-autoloads.el ends here
