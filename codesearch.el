(defcustom codesearch-csearch "csearch"
  "TODO"
  :type '(string)
  :group 'codesearch)

;; TODO: Add support for customizing the CSEARCHINDEX env variable

(defun codesearch-search (pattern)
  (interactive
   (list
    (read-string "Pattern: ")))
  (shell-command
   (format "%s -n %s" codesearch-csearch pattern)
   "*codesearch*")
  (save-current-buffer
    (set-buffer "*codesearch*")
    (grep-mode)))