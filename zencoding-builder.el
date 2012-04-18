;; (require 'zencoding-builder)
;; (define-key zencoding-mode-keymap (kbd "M-RET") 'zencoding-builder)

(defvar zencoding-builder-start-point nil)
(make-variable-buffer-local 'zencoding-builder-start-point)

(defvar zencoding-builder-end-point nil)
(make-variable-buffer-local 'zencoding-builder-end-point)

(defvar zencoding-builder-window nil)
(make-variable-frame-local 'zencoding-builder-window)

(defun zencoding-expand-from-minibuffer ()
  (condition-case v
      (let ((expr (with-selected-window (minibuffer-window) (minibuffer-contents)))
            markup markup-filled)
        (when expr
          (setq markup (if (equal expr "") ""
                         (zencoding-transform (car (zencoding-expr expr)))))
          (setq markup-filled (replace-regexp-in-string "><" ">\n<" markup))
          (with-selected-window zencoding-builder-window
            (delete-region zencoding-builder-start-point zencoding-builder-end-point)
            (insert markup-filled)
            (indent-region zencoding-builder-start-point (point))
            (setq zencoding-builder-end-point (point)))))
    (error (zencoding-builder-cleanup))))

(defun zencoding-builder-setup ()
  (setq zencoding-builder-start-point (point)
        zencoding-builder-end-point (point)
        zencoding-builder-buffer (current-buffer)
        zencoding-builder-window (selected-window))
  (add-hook 'post-command-hook 'zencoding-expand-from-minibuffer))

(defun zencoding-builder-cleanup ()
  (remove-hook 'post-command-hook 'zencoding-expand-from-minibuffer)
  (setq zencoding-builder-start-point nil
        zencoding-builder-end-point nil
        zencoding-builder-window nil))

(defun zencoding-builder ()
  (interactive)
  (zencoding-builder-setup)
  (condition-case v
      (read-string "zen: ")
    (quit (zencoding-builder-cleanup)))
  (zencoding-builder-cleanup))

(provide 'zencoding-builder)