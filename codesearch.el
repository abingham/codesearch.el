(defcustom codesearch-csearch "csearch"
  "The name of the csearch program."
  :type '(string)
  :group 'codesearch)

(defcustom codesearch-csearchindex nil
  "CSEARCHINDEX environment variable value used when calling csearch.")

(defun codesearch-search (pattern)
  (interactive
   (list
    (read-string "Pattern: ")))
  (let ((process-environment (copy-alist process-environment))
        (switch-to-visible-buffer t))
    (pop-to-buffer "*codesearch*")
    (grep-mode)
    (setenv "CSEARCHINDEX" codesearch-csearchindex)
    (shell-command
     (format "%s -n %s" codesearch-csearch pattern)
     "*codesearch*")))
