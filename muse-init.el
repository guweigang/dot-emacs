;;; Setup

;; Add to load path
(add-to-list 'load-path "/share/.emacs.d/muse/lisp")
(add-to-list 'load-path "/share/.emacs.d/muse/experimental")

;; Initialize
(require 'outline)       ; I like outline-style faces
(require 'muse)          ; load generic module
(require 'muse-colors)   ; load coloring/font-lock module
(require 'muse-mode)     ; load authoring mode
(require 'muse-blosxom)  ; load blosxom module
(require 'muse-docbook)  ; load DocBook publishing style
(require 'muse-html)     ; load (X)HTML publishing style
(require 'muse-latex)    ; load LaTeX/PDF publishing styles
(require 'muse-latex2png) ; publish <latex> tags
(require 'muse-project)  ; load support for projects
(require 'muse-texinfo)  ; load Info publishing style
(require 'muse-wiki)     ; load Wiki support
(require 'muse-xml)      ; load XML support
;;(require 'muse-message)  ; load message support (experimental)


;; This uses a different header and footer than normal
(muse-derive-style "my-xhtml" "xhtml"
                   :header "~/personal-site/muse/templates/header.html"
                   :footer "~/personal-site/muse/templates/footer.html")

(muse-derive-style "lisp-xhtml" "xhtml"
                   :header "~/personal-site/muse/templates/generic-header.html"
                   :footer "~/personal-site/muse/templates/generic-footer.html")

(muse-derive-style "blog-xhtml" "xhtml"
                   :header "~/personal-site/blog/templates/generic-header.html"
                   :footer "~/personal-site/blog/templates/generic-footer.html")

(setq muse-project-alist
      '(
        ("Blog" ("~/personal-site/blog"
                    :default "index")
         (:base "blog-xhtml"
                :base-url "http://roygu.com"
                :path "~/personal-site/blog"))
        
        ("Aura PHP" ("~/personal-site/aura-php"
                     :default "index")
         (:base "lisp-xhtml"
                :base-url "http://roygu.com"
                :path "~/personal-site/aura-php/manual"))
        
        ("Emacs Lisp" ("~/personal-site/lisp"
                       :default "index")
         (:base "lisp-xhtml"
                :base-url "http://bullsoft.org/lisp/emacs"
                :path "~/personal-site/lisp/manual"))
        ))


;;Sometimes, I want the code in the page mark with line number. So I
;;hack some function to add the line number automaticly. And I try to
;;highlight the source code in muse-mode, but sometimes it failed.
;;I don't know why. This is my solution, might it is helpful:

(defun muse-html-src-tag (beg end attrs)
  "Publish the region using htmlize.The language to use may be specified by the 
  \"lang\" attribute. Muse will look for a function named LANG-mode, where LANG 
  is the value of the \"lang\" attribute. This tag requires htmlize 1.34 or later 
  in order to work."

  (if (condition-case nil
          (progn
            (require 'htmlize)
            (if (fboundp 'htmlize-region-for-paste)
                nil
              (muse-display-warning
               (concat "The `htmlize-region-for-paste' function was not"
                       " found.\nThis is available in htmlize.el 1.34"
                       " or later."))
              t))
        (error nil t))
    ;; if htmlize.el was not found, treat this like an example tag
    (muse-publish-example-tag beg end)
    (muse-publish-ensure-block beg)
    (let* ((mode (and (assoc "lang" attrs)
                      (intern (concat (cdr (assoc "lang" attrs))
                                      "-mode"))))
           (text (delete-and-extract-region beg end))
           (number (and (assoc "number" attrs)
                        (string-to-number (cdr (assoc "number" attrs)))))
           (htmltext
            (with-temp-buffer
              (insert text)
              (if (functionp mode)
                  (funcall mode)
                (fundamental-mode))
              (font-lock-fontify-buffer)
              ;; silence the byte-compiler
              (when (fboundp 'htmlize-region-for-paste)
                ;; transform the region to HTML
                (htmlize-region-for-paste (point-min) (point-max))))))
      (save-restriction
        (narrow-to-region (point) (point))
        (insert htmltext)
        (goto-char (point-min))
        (re-search-forward "<pre\\([^>]*\\)>\n?" nil t)
        (replace-match "<pre class=\"src\">")
        (when number
          (forward-line 1)
          (while (not (eobp))
            (insert (format "%4d  " number))
            (setq number (1+ number))
            (forward-line 1))
          (forward-line 0)
          (if (looking-at "^\\s-*[0-9]+  </pre>")
              (delete-region (point) (+ (point) 6))))
        (goto-char (point-max))
        (muse-publish-mark-read-only (point-min) (point-max))))))

(defvar muse-colors-overlays nil)

(defun muse-colors-src-tag (beg end)
  "Strip properties and mark as literal."
  (muse-unhighlight-region beg end)
  (save-excursion
    (goto-char beg)
    (when (re-search-forward "<src\\(.*\\)>" nil t)
      (setq beg (match-end 0))
      (let* ((attrs (mapcar
                     (lambda (pair)
                       (setq pair (split-string pair "="))
                       (setcdr pair (substring (cadr pair) 1 -1))
                       pair)
                     (split-string (match-string 1))))
             (mode (and (assoc "lang" attrs)
                        (intern-soft (concat (cdr (assoc "lang" attrs))
                                             "-mode"))))
             (number (and (assoc "number" attrs)
			  (setq number (string-to-number (cdr (assoc "number" attrs)))))))

        (goto-char end)
        (setq end (if (re-search-backward "</src>" nil t)
                      (match-beginning 0)
                    (point-max)))
        (when (and mode (fboundp mode))
          (let ((src (buffer-substring-no-properties beg end))
                (fs 1)
                (font-lock-verbose nil)
                fe face face-list)
            (with-temp-buffer
              (funcall mode)
              (insert src)
              (font-lock-fontify-buffer)
              (or (get-text-property fs 'face)
                  (setq fs (next-single-property-change fs 'face)))
              (while (and fs (< fs (point-max)))
                (setq fe (or (next-single-property-change fs 'face)
                             (point-max))
                      face (get-text-property fs 'face))

		(and face fe (setq face-list (cons (list (1- fs) (1- fe) face) face-list)))
                (setq fs fe)))
            (when face-list
              (dolist (f (nreverse face-list))
                (put-text-property (+ beg (car f)) (+ beg (cadr f))
                                   'face (nth 2 f))))))
        (when number
          (let (ov ovs)
            ;; remove overlays in current block and not valid
            (mapc (lambda (o)
                    (let ((pos (overlay-start o)))
                      (when pos
                        (if (and (> pos beg) (< pos end))
                            (delete-overlay o)
                          (push o ovs)))))
                  muse-colors-overlays)
            (setq muse-colors-overlays ovs)
            (goto-char beg)
            (forward-line 1)
            (while (and (not (eobp)) (< (point) end))
              (when (not (looking-at "</src>"))
                (setq ov (make-overlay (point) (point)))
                (push ov muse-colors-overlays)
                (overlay-put ov 'before-string (format "%4d  " number))
                (setq number (1+ number)))
              (forward-line 1))))))))

(add-hook 'muse-mode-hook
          (lambda ()
            (add-hook 'font-lock-mode-hook
                      (lambda ()
                        (when (and (boundp 'muse-colors-overlays)
                                   muse-colors-overlays
                                   (null font-lock-mode))
                          (mapcar 'delete-overlay muse-colors-overlays)))
                      nil t)
            (make-local-variable 'muse-colors-overlays)))

(add-to-list 'muse-colors-tags '("src" t nil nil muse-colors-src-tag))
