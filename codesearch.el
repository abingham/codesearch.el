;;; codesearch.el --- An emacs extension for using the codesearch
;;; sourcecode indexer.
;;
;; Author: Austin Bingham <austin.bingham@gmail.com>
;; Version: 1
;; URL: https://github.com/abingham/codespeak.el
;;
;; This file is not part of GNU Emacs.
;;
;; Copyright (c) 2012 Austin Bingham
;;
;;; Commentary:
;;
;; Description:
;;
;; This extension allows you to use the codesearch code indexing
;; system in emacs.
;;
;; For more details, see the project page at
;; https://github.com/abingham/prosjekt.
;;
;; For more details on codesearch, see its project page at
;; http://code.google.com/p/codesearch/
;;
;; Installation:
;;
;; Copy codesearch.el to some location in your emacs load path. Then add
;; "(require 'codesearch)" to your emacs initialization (.emacs,
;; init.el, or something).
;;
;; Example config:
;;
;;   (require 'codesearch)
;;
;;; License:
;;
;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Code:


(defcustom codesearch-csearch "csearch"
  "The name of the csearch program."
  :type '(string)
  :group 'codesearch)

(defcustom codesearch-cindex "cindex"
  "The name of the cindex program."
  :type '(string)
  :group 'codesearch)

(defcustom codesearch-csearchindex nil
  "CSEARCHINDEX environment variable value used when calling csearch."
  :type '(string)
  :group 'codesearch)

(defun codesearch-search (pattern file-pattern)
  (interactive
   (list
    (read-string "Pattern: " (thing-at-point 'symbol))
    (read-string "File pattern: " ".*")))
  (let ((process-environment (copy-alist process-environment))
        (switch-to-visible-buffer t)
        (buff (get-buffer-create "*codesearch-results*")))
    (setenv "CSEARCHINDEX" codesearch-csearchindex)
    (with-current-buffer buff
      (read-only-mode 0)
      (erase-buffer)
      (call-process codesearch-csearch nil 't nil "-f" file-pattern "-n" pattern))
    (pop-to-buffer buff)
    (compilation-mode)))

(defun codesearch-build-index (dir)
  "Scan DIR to rebuild an index."
  (interactive
   (list
    (read-directory-name "Directory: ")))
  (let ((process-environment (copy-alist process-environment)))
    (setenv "CSEARCHINDEX" codesearch-csearchindex)
    (start-process "cindex" "*codesearch-index*" codesearch-cindex dir)))

(defun codesearch-update-index ()
  "Update an existing index."
  (interactive)
  (let ((process-environment (copy-alist process-environment)))
    (setenv "CSEARCHINDEX" codesearch-csearchindex)
    (start-process "cindex" "*codesearch-index*" codesearch-cindex)))

;;;###autoload(require 'codesearch)
(provide 'codesearch)
