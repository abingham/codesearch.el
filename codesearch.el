;;; codesearch.el --- Easy access to the codesearch tools
;;
;; Author: Austin Bingham <austin.bingham@gmail.com>
;; Version: 1
;; URL: https://github.com/abingham/codespeak.el
;; Keywords: tools, development, search
;; Package-Requires: ((dash "2.8.0"))
;;
;; This file is not part of GNU Emacs.
;;
;; Copyright (c) 2012-2014 Austin Bingham
;;
;;; Commentary:
;;
;; Description:
;;
;; This extension allows you to use the codesearch code indexing
;; system in emacs.
;;
;; For more details, see the project page at
;; https://github.com/abingham/codesearch.el.
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
;; This elisp extension assumes you've got the codesearch tools -
;; csearch and cindex - installed. See the codesearch-csearch and
;; codesearch-cindex variables for more information.
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

(require 'dash)

(defgroup codesearch nil
  "Variables related to codesearch."
  :prefix "codesearch-"
  :group 'tools)

(defcustom codesearch-csearch "csearch"
  "The name of the csearch program."
  :type '(string)
  :group 'codesearch)

(defcustom codesearch-cindex "cindex"
  "The name of the cindex program."
  :type '(string)
  :group 'codesearch)

(defcustom codesearch-csearchindex "~/.csearchindex"
  "CSEARCHINDEX environment variable value used when calling csearch."
  :type '(string)
  :group 'codesearch)

(defun codesearch-get-indexed-directories ()
  "Get the list of directories currently being indexed."
  (let ((process-environment (copy-alist process-environment)))
    (setenv "CSEARCHINDEX" (expand-file-name codesearch-csearchindex))
    (with-temp-buffer
      (let ((result (process-file codesearch-cindex nil (current-buffer) nil "-list")))
        (when (= result 0)
          (-slice (split-string (buffer-string) "\n") 0 -1))))))

;;;###autoload
(defun codesearch-search (pattern file-pattern)
  "Search files matching FILE-PATTERN in the index for PATTERN."
  (interactive
   (list
    (read-string "Pattern: " (thing-at-point 'symbol))
    (read-string "File pattern: " ".*")))
  (let ((process-environment (copy-alist process-environment))
        (switch-to-visible-buffer t)
        (buff (get-buffer-create "*codesearch-results*")))
    (setenv "CSEARCHINDEX" (expand-file-name codesearch-csearchindex))
    (with-current-buffer buff
      (read-only-mode 0)
      (erase-buffer)
      (start-file-process "csearch" buff codesearch-csearch "-f" file-pattern "-n" pattern))
    (pop-to-buffer buff)
    (compilation-mode)))

;;;###autoload
(defun codesearch-build-index (dir &optional reset)
  "Add the contents of DIR to the index.

If RESET is true, the index contents for DIR (if any) are cleared
out first."
  (interactive
   (list
    (read-directory-name "Directory: ")
    (y-or-n-p "Reset? ")))
  (let ((process-environment (copy-alist process-environment))
        (args (if reset '("-reset"))))
    (setenv "CSEARCHINDEX" (expand-file-name codesearch-csearchindex))
    (apply 'start-file-process
           "cindex"
           (get-buffer-create "*codesearch-index*")
           codesearch-cindex
           (expand-file-name dir)
           args)))

;;;###autoload
(defun codesearch-update-index ()
  "Rescan all of the directories currently in the index, updating
the index with the new contents."
  (interactive)
  (let ((process-environment (copy-alist process-environment)))
    (setenv "CSEARCHINDEX" codesearch-csearchindex)
    (start-file-process "cindex" (get-buffer-create "*codesearch-index*") codesearch-cindex)))

;;;###autoload
(defun codesearch-list-directories ()
  "List the directories currently being indexed."
  (interactive)
  (let ((dirs (codesearch-get-indexed-directories))
        (buff (get-buffer-create "*codesearch-directories*")))
    (with-current-buffer buff
      (erase-buffer)
      (insert "[codesearch: currently indexed directories]\n\n")
      (mapcar
       (lambda (dir) (insert (format "%s\n" dir)))
       dirs))
    (display-buffer buff)))

(provide 'codesearch)

;;; codesearch.el ends here
