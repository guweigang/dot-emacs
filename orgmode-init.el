(add-to-list 'load-path "/share/.emacs.d/plugins/org-mode/lisp")
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-publish-project-alist
      '(("note-org"
         :base-directory "~/personal-org/note"
         :publishing-directory "~/personal-org/note/publish"
         :base-extension "org"
         :recursive t
         :publishing-function org-publish-org-to-html
         :auto-index nil
         :index-filename "index.org"
         :index-title "index"
         :link-home "index.html"
         :section-numbers nil
         :style "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>")
        ("note-static"
         :base-directory "~/personal-org/note"
         :publishing-directory "~/personal-org/note/publish"
         :recursive t
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|swf\\|zip\\|gz\\|txt\\|el"
         :publishing-function org-publish-attachment)
        ("note" 
         :components ("note-org" "note-static")
         :author "roy@solarphp.cn"
         )))