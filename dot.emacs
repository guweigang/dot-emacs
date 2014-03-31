;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;; (setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

(setq user-full-name "Gu Weigang")
(setq user-mail-address "guweigang@outlook.com")

(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(display-time)
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(transient-mark-mode t)
(show-paren-mode 't)
(setq-default indent-tabs-mode nil)

(electric-pair-mode t)


;; display line numbers in margin (fringe), for emacs 23
;; always show line numbers
(global-linum-mode 1) 
(line-number-mode 1)
(column-number-mode 1)
(setq linum-format "%4d \u2502")

;; lines soft wrapped at word boundary
;; 1 for on, 0 for off.
(global-visual-line-mode 1) 
(menu-bar-mode 0)
(add-to-list 'load-path "~/.emacs.d")

(setq-default c-indent-tabs-mode t
                c-indent-level 4         
                c-argdecl-indent 0       
                c-tab-always-indent t
                backward-delete-function nil)

(defun my-c-mode-hook ()
  ;(c-set-style "k&r")
  (c-set-offset 'substatement-open '0) ; brackets should be at same indentation level as the statements they open
  (c-set-offset 'inline-open '+)
  (c-set-offset 'block-open '+)
  (c-set-offset 'brace-list-open '+)   ; all "opens" should be indented by the c-indent-level
  (c-set-offset 'case-label '+))       ; indent case labels by c-indent-level, too
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(global-set-key (kbd "C-c n") 'forward-list)
(global-set-key (kbd "C-c p") 'backward-list)

(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "<f7>") 'align-regexp)
(global-set-key (kbd "<f8>") 'split-window-horizontally)
(global-set-key (kbd "<f9>") 'split-window-vertically)
(global-set-key (kbd "<f10>") 'delete-window)
(global-set-key (kbd "<f11>") 'delete-other-windows)
(global-set-key (kbd "<f12>") 'other-window)
(global-set-key (kbd "C-\\") 'backward-kill-word)

;; yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)

;; cedet
(setq integrated-cedet-p (and (>= emacs-major-version 23)
                              (>= emacs-minor-version 2)))
(unless integrated-cedet-p
  (progn
    (setq cedet-lib "~/.emacs.d/cedet")
    (setq cedet-info-dir "~/.emacs.d/cedet/info")))
(if (boundp 'cedet-info-dir)
    (add-to-list 'Info-default-directory-list cedet-info-dir))
(if (boundp 'cedet-lib)
    (load-file cedet-lib))
(semantic-mode 1)
(global-ede-mode t)

(if (boundp 'semantic-load-enable-excessive-code-helpers)
    ;; add-on cedet
    (progn
      (semantic-load-enable-excessive-code-helpers)
      ;; @TODO should already be enabled by previous line
      (global-semantic-idle-completions-mode)
      (global-semantic-tag-folding-mode))
  ;; integrated cedet
  (setq semantic-default-submodes
        '(global-semanticdb-minor-mode
          global-semantic-idle-scheduler-mode
          global-semantic-idle-summary-mode
          global-semantic-idle-completions-mode
          global-semantic-decoration-mode
          global-semantic-highlight-func-mode
          global-semantic-stickyfunc-mode)))
(if (boundp 'semantic-ia) (require 'semantic-ia))
(if (boundp 'semantic-gcc) (require 'semantic-gcc))

;; ecb
(add-to-list 'load-path "~/.emacs.d/ecb")
(require 'ecb)

;; psvn
(require 'psvn)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("79de7deba6c34d1c0c39996683f5d01ff3c9503130799ec9a5ed2ae559dff60b" "2feb511d65a880fd3a0f8807b43df51157851d3e5403a20935b319e134f2ca3d" "9688bed8ccce7497bfc4d5d392a7fa560f97683628e74423b55da9d07e74d5e9" "59d340a28bc7ad6e0205be7b8a7f57c6c64baba75535205b97a255500a2c8e3e" "a37387f9b7279fd5cffe7f7ead250ea7264b939c8ae82d00734cfc819c5346b4" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(ecb-key-map (quote ("C-c ." (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (nil "C-c e" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (nil "C-c 0" ecb-goto-window-directories) (nil "C-c 1" ecb-goto-window-sources) (nil "C-c 2" ecb-goto-window-methods) (nil "C-c 3" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote (("/" "/") "/home/work/git/mysql-replication-listener")))
 '(php-executable "/home/work/local/php/bin/php")
 '(php-manual-path "/home/work/.emacs.d/php-chunked-xhtml/")
 '(safe-local-variable-values (quote ((eval when (fboundp (quote rainbow-mode)) (rainbow-mode 1)) (header-auto-update-enabled)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; tabbar
(add-to-list 'load-path "~/.emacs.d/tabbar")
(require 'tabbar)
(tabbar-mode 1)
;;(add-to-list 'load-path "~/.emacs.d/tabbar-ruler")
;; If you want tabbar
;;(setq tabbar-ruler-global-tabbar 't)
;; if you want a global ruler
;;(setq tabbar-ruler-global-ruler 't)
;; If you want a popup menu.
;;(setq tabbar-ruler-popup-menu 't)
;; If you want a popup toolbar
;;(setq tabbar-ruler-popup-toolbar 't) 
;;(require 'tabbar-ruler)
(global-set-key (kbd "C-c <up>") 'tabbar-forward-group)
(global-set-key (kbd "C-c <down>") 'tabbar-backward-group)
(global-set-key (kbd "C-c <right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-c <left>") 'tabbar-backward-tab)

;;add a buffer modification state indicator in the tab label,
;;and place a space around the label to make it looks less crowd
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
        (if (and (buffer-modified-p (tabbar-tab-value tab))
                 (buffer-file-name (tabbar-tab-value tab)))
            (concat " * " (concat ad-return-value " "))
          (concat " " (concat ad-return-value " ")))))
;;called each time the modification state of the buffer changed
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))
;;first-change-hook is called BEFORE the change is made
(defun ztl-on-buffer-modification ()
  (set-buffer-modified-p t)
  (ztl-modification-state-change))
(add-hook 'after-save-hook 'ztl-modification-state-change)
;;this doesn't work for revert, I don't know
(add-hook 'before-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)

;;with the bellow code, when you do not have a text selection,
;;copy will just copy the current line
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is copied.")
       (list (line-beginning-position) (line-end-position)) ) ) ))

(defadvice kill-region (before slick-copy activate compile)
  "When called interactively with no active region, cut the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (progn
       (message "Current line is cut.")
       (list (line-beginning-position) (line-end-position))))))

;;kill whole line
(global-set-key (kbd "M-0") 'kill-whole-line)
;;If you want kill-line to kill including the line ending char
(setq kill-whole-line t)

;;yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")

;;popup
(add-to-list 'load-path "~/.emacs.d/popup-el")
(require 'popup)

;;fuzzy
(require 'fuzzy)

;;auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(define-key ac-completing-map "\C-n" 'ac-next)
(define-key ac-completing-map "\C-p" 'ac-previous)

;;auto-complete and yasnippet
(require 'auto-complete-yasnippet)

;;flymake
(require 'flymake)
(eval-after-load 'flymake '(require 'flymake-cursor))

;;php
(require 'php-mode)
(add-to-list 'auto-mode-alist
             '("\\.php[345]\\'\\|\\.php\\'" . php-mode))
(add-hook 'php-mode-hook
          '(lambda () (define-abbrev php-mode-abbrev-table "ex" "extends")))
(add-hook 'php-mode-hook (lambda ()
                           (defun php-lineup-arglist-intro (langelem)
                             (save-excursion
                               (goto-char (cdr langelem))
                               (vector (+ (current-column) c-basic-offset))))
                           (defun php-lineup-arglist-close (langelem)
                             (save-excursion
                               (goto-char (cdr langelem))
                               (vector (current-column))))
                           (c-set-offset 'arglist-intro 'php-lineup-arglist-intro)
                           (c-set-offset 'arglist-close 'php-lineup-arglist-close)
                           (c-set-offset 'case-label '+)))
(add-hook 'php-mode-hook (lambda () (subword-mode 1)))
(require 'flymake-php)
(add-hook 'php-mode-hook 'flymake-php-load)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.volt\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.twig\\'" . web-mode))

;;color theme
;; (add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme/")
(load-theme 'soothe)

;; apache mode
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

(add-to-list 'auto-mode-alist '("\\.json\\'" . js-mode))

;; helm
;; (add-to-list 'load-path "~/.emacs.d/helm")
;; (require 'helm-config)
;; (helm-mode 1)
;; (add-to-list 'load-path "~/.emacs.d/helm-c-yasnippet")
;; (require 'helm-c-yasnippet)

;;git
(add-to-list 'load-path "~/.emacs.d/git-modes")
(add-to-list 'load-path "~/.emacs.d/magit")
(require 'magit)

;; full screen magit-status
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

(add-to-list 'load-path "~/.emacs.d/multiple-cursors")
(require 'multiple-cursors)
(global-set-key (kbd "C-c >") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c <") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c a") 'mc/mark-all-like-this)

(add-to-list 'load-path "~/.emacs.d/s.el")
(add-to-list 'load-path "~/.emacs.d/dash.el")

;;projectile
;;(add-to-list 'load-path "~/.emacs.d/projectile")
;;(require 'projectile)
;;(require 'helm-projectile)
;;(projectile-global-mode)
;;(add-hook 'php-mode-hook #'(lambda () (projectile-mode)))

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

(require 'coffee-mode)

(require 'header2)
(add-hook 'write-file-hooks 'auto-update-file-header)
(add-hook 'php-mode-hook 'auto-make-header)

(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/home/work/bin/sbcl --noinform")
;; Replace "sbcl" with the path to your implementation
;;(setq inferior-lisp-program "sbcl")

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)  
;;(evil-mode 1)

(require 'undo-tree)
(global-undo-tree-mode)

;;(require 'twig)
;;(setq auto-mode-alist
;;      (append '(("\\.twig?$" . twig-minor-mode)) auto-mode-alist))
;;(add-to-list 'auto-mode-alist '("\\.twig$" . twig-minor-mode))

(add-to-list 'load-path "~/.emacs.d/org-8.0.3/lisp")
(add-to-list 'load-path "~/.emacs.d/org-8.0.3/contrib/lisp" t)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+")))

(add-to-list 'load-path "~/.emacs.d/mustache.el")
(add-to-list 'load-path "~/.emacs.d/ht.el")

(add-to-list 'load-path "~/.emacs.d/org-page")
(require 'org-page)
(setq op/repository-directory "/home/work/git/guweigang.github.io/")
(setq op/repository-org-branch "source")
(setq op/repository-html-branch "master")
(setq op/site-domain "http://guweigang.com/")
(setq op/site-main-title "闭眼听世界")
(setq op/site-sub-title "心如松静意无尘，气若浮萍了无痕！")
(setq op/personal-github-link "https://github.com/guweigang")
(setq op/personal-disqus-shortname "guweigang")
(setq op/personal-google-analytics-id "cnwggu@gmail.com")
;;(setq op/theme "~/.emacs.d/org-page/themes/gray")

(require 'htmlize)
;;(require 'jinja2-mode)

(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

(require 'newlisp)
(add-to-list 'auto-mode-alist '("\\.lsp$" . newlisp-mode))
(add-to-list 'interpreter-mode-alist '("newlisp" . newlisp-mode))
;; if needed
(newlisp-mode-setup)
(defun newlisp-mode-user-hook ()
  (setq comment-start "; ")
  (setq tab-width 8)
  (setq indent-tabs-mode nil))
(add-hook 'newlisp-mode-hook 'newlisp-mode-user-hook)
;; Make Emacs' "speedbar" recognize newlisp files
(eval-after-load "speedbar" '(speedbar-add-supported-extension ".lsp"))

(require 'git-messenger)
(global-set-key (kbd "C-x v p") 'git-messenger:popup-message)

(require 'minimap)
(defun minimap-toggle ()
  "Toggle minimap for current buffer."
  (interactive)
  (if (not (boundp 'minimap-bufname))
      (setf minimap-bufname nil))
  (if (null minimap-bufname)
      (progn (minimap-create)
             (set-frame-width (selected-frame) 100))
    (progn (minimap-kill)
           (set-frame-width (selected-frame) 80))))

(add-to-list 'load-path "/home/work/.emacs.d/gccsense-0.1/etc")
(require 'gccsense)
(add-hook 'c-mode-common-hook
          (lambda ()
            (flymake-mode)
            (gccsense-flymake-setup)))
(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key (kbd "C-c a g") 'gccsense-complete)
            (local-set-key (kbd "C-c a a") 'ac-complete-gccsense)))
