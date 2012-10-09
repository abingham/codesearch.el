(defcustom codesearch-csearch "csearch"
  "The name of the csearch program."
  :type '(string)
  :group 'codesearch)

;; TODO: Add support for customizing the CSEARCHINDEX env variable

(defun codesearch-search (pattern)
  (interactive
   (list
    (read-string "Pattern: ")))
  (let ((process-environment (copy-alist process-environment))
        (switch-to-visible-buffer t))
    (pop-to-buffer "*codesearch*")
    (grep-mode)
    (setenv "CSEARCHINDEX" "/Users/abingham/projects/ackward/CSEARCH")
    (shell-command
     (format "%s -n %s" codesearch-csearch pattern)
     "*codesearch*")))
