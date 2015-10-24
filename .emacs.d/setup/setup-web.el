;;; setup-web.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2015  abelardo.jara-berrocal

;; Author: abelardo.jara-berrocal <ajaraber@plxcj9064.pdx.intel.com>
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

(when (fboundp 'eww)
  (setq browse-url-browser-function 'eww-browse-url)
  (setq-default url-configuration-directory "~/.emacs.cache/url")
  (setq-default url-cookie-file "~/.emacs.cache/url/cookies")

  (advice-add 'url-http-user-agent-string :around
              (lambda (ignored)
                "Pretend to be a mobile browser."
                (concat
                 "User-Agent: "
                 "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30")))
  ) ;; when

(provide 'setup-web)
;;; setup-web.el ends here
