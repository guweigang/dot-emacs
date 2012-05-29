;; .emacs
;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" system-name))

(setq user-full-name "校长")
(setq user-mail-address "guweigang@baidu.com")

;;(setq default-font "Consolas-13")
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(transient-mark-mode t)
(display-time)
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(show-paren-mode 't)
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4) ; width for display tabs
(setq c-default-style "linux"
      c-basic-offset 4)
; gnu
; k&r
; bsd
; stroustrup
; linux
; python
; java
; user
; show line number the cursor is on, in status bar (the mode line)
(line-number-mode 1)
(column-number-mode 1)

; display line numbers in margin (fringe). Emacs 23 only.
(global-linum-mode 1) ; always show line numbers

; lines soft wrapped at word boundary
(global-visual-line-mode 1) ; 1 for on, 0 for off.

(add-to-list 'load-path "/share/.emacs.d")

;; (load "php-mode")

(require 'pi-php-mode)

(add-to-list 'auto-mode-alist
         '("\\.php[345]\\'\\|\\.php\\'\\|\\.phtml\\'" . php-mode))

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

;; (setq php-manual-file "~/php-complet-file")

;; nxhtml
(load "nxhtml/autostart.el")

;; yasnippet
(add-to-list 'load-path "/share/.emacs.d/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "/share/.emacs.d/yasnippet-0.6.1c/snippets")

; with the bellow code, when you do not have a text selection, 
; copy will just copy the current line
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
       (list (line-beginning-position) (line-end-position)) ) ) ))


; kill whole line
(global-set-key (kbd "M-0") 'kill-whole-line)
; If you want kill-line to kill including the line ending char
(setq kill-whole-line t)

;; auto complete
(add-to-list 'load-path "/share/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/share/.emacs.d/ac-dict")
(ac-config-default)
(define-key ac-completing-map "\C-n" 'ac-next)
(define-key ac-completing-map "\C-p" 'ac-previous)
(defun ac-yasnippet-candidate ()
  (let ((table (yas/get-snippet-tables major-mode)))
    (if table
      (let (candidates (list))
            (mapcar (lambda (mode)  
              (maphash (lambda (key value)
                (push key candidates))   
              (yas/snippet-table-hash mode)))
            table)
        (all-completions ac-prefix candidates)))))

(defface ac-yasnippet-candidate-face
  '((t (:background "sandybrown" :foreground "black")))
  "Face for yasnippet candidate.")

(defface ac-yasnippet-selection-face
  '((t (:background "coral3" :foreground "white")))
  "Face for the yasnippet selected candidate.")

(defvar ac-source-yasnippet
  '((candidates . ac-yasnippet-candidate)
    (action . yas/expand)
    (limit . 3)
    (candidate-face . ac-yasnippet-candidate-face)
    (selection-face . ac-yasnippet-selection-face)) 
  "Source for Yasnippet.")

;; psvn
(require 'psvn)

;; git
(add-to-list 'load-path "/share/.emacs.d/git-emacs")
(require 'git-emacs)

(add-to-list 'load-path "/share/.emacs.d/magit")
(require 'magit)

;; tabbar
(add-to-list 'load-path "/share/.emacs.d/tabbar")
(require 'tabbar)
(tabbar-mode 1)

(global-set-key (kbd "C-c <up>") 'tabbar-forward-group)
(global-set-key (kbd "C-c <down>") 'tabbar-backward-group)
(global-set-key (kbd "C-c <right>") 'tabbar-forward-tab)
(global-set-key (kbd "C-c <left>") 'tabbar-backward-tab)

;; add a buffer modification state indicator in the tab label,
;; and place a space around the label to make it looks less crowd
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value
        (if (and (buffer-modified-p (tabbar-tab-value tab))
                 (buffer-file-name (tabbar-tab-value tab)))
            (concat " * " (concat ad-return-value " "))
          (concat " " (concat ad-return-value " ")))))
;; called each time the modification state of the buffer changed
(defun ztl-modification-state-change ()
  (tabbar-set-template tabbar-current-tabset nil)
  (tabbar-display-update))
;; first-change-hook is called BEFORE the change is made
(defun ztl-on-buffer-modification ()
  ;(set-buffer-modified-p t)
  (ztl-modification-state-change))

;; hooks for tabbar
(add-hook 'after-save-hook 'ztl-modification-state-change)
;; this doesn't work for revert, I don't know
(add-hook 'before-revert-hook 'ztl-modification-state-change)
(add-hook 'first-change-hook 'ztl-on-buffer-modification)
;; (add-hook 'tabbar-mode-hook (lambda ()
;;                               (if (eq this-command 'undo)
;;                                   ())
;;                              ))

;; cedet
(setq integrated-cedet-p (and (>= emacs-major-version 23)
                              (>= emacs-minor-version 2)))
(unless integrated-cedet-p
  (progn
    (setq cedet-lib "/path/foo")
    (setq cedet-info-dir "/path/bar")))

(if (boundp 'cedet-info-dir)
    (add-to-list 'Info-default-directory-list cedet-info-dir))

(if (boundp 'cedet-lib)
    (load-file cedet-lib))

(semantic-mode 1)

(global-ede-mode t)

(if (boundp 'semantic-load-enable-excessive-code-helpers)
    ; Add-on CEDET
    (progn
      (semantic-load-enable-excessive-code-helpers)
      ; TODO: should already be enabled by previous line
      (global-semantic-idle-completions-mode)
      (global-semantic-tag-folding-mode))
   ; Integrated CEDET
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


; ecb
(add-to-list 'load-path "/share/.emacs.d/ecb")
; (require 'ecb)
(require 'ecb-autoloads)

;; muse
(load-file "/share/.emacs.d/muse-init.el")

;; org-mode
(load-file "/share/.emacs.d/orgmode-init.el")

;; color theme
(if (eq window-system 'x)
    (progn
      (setq default-font "DejaVu Sans Mono")
      (add-to-list 'load-path "/share/.emacs.d/color-theme-6.6.0")
      (require 'color-theme)
      (eval-after-load "color-theme"
        '(progn
           (color-theme-initialize)
           (color-theme-hober)))))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(ecb-key-map (quote ("C-c ." (t "fh" ecb-history-filter) (t "fs" ecb-sources-filter) (t "fm" ecb-methods-filter) (t "fr" ecb-methods-filter-regexp) (t "ft" ecb-methods-filter-tagclass) (t "fc" ecb-methods-filter-current-type) (t "fp" ecb-methods-filter-protection) (t "fn" ecb-methods-filter-nofilter) (t "fl" ecb-methods-filter-delete-last) (t "ff" ecb-methods-filter-function) (t "p" ecb-nav-goto-previous) (t "n" ecb-nav-goto-next) (t "lc" ecb-change-layout) (t "lr" ecb-redraw-layout) (t "lw" ecb-toggle-ecb-windows) (t "lt" ecb-toggle-layout) (t "s" ecb-window-sync) (t "r" ecb-rebuild-methods-buffer) (t "a" ecb-toggle-auto-expand-tag-tree) (t "x" ecb-expand-methods-nodes) (t "h" ecb-show-help) (nil "C-c e" ecb-goto-window-edit-last) (t "g1" ecb-goto-window-edit1) (t "g2" ecb-goto-window-edit2) (t "gc" ecb-goto-window-compilation) (nil "C-c 0" ecb-goto-window-directories) (nil "C-c 1" ecb-goto-window-sources) (nil "C-c 2" ecb-goto-window-methods) (nil "C-c 3" ecb-goto-window-history) (t "ga" ecb-goto-window-analyse) (t "gb" ecb-goto-window-speedbar) (t "md" ecb-maximize-window-directories) (t "ms" ecb-maximize-window-sources) (t "mm" ecb-maximize-window-methods) (t "mh" ecb-maximize-window-history) (t "ma" ecb-maximize-window-analyse) (t "mb" ecb-maximize-window-speedbar) (t "e" eshell) (t "o" ecb-toggle-scroll-other-window-scrolls-compile) (t "\\" ecb-toggle-compile-window) (t "/" ecb-toggle-compile-window-height) (t "," ecb-cycle-maximized-ecb-buffers) (t "." ecb-cycle-through-compilation-buffers))))
 '(ecb-options-version "2.40")
 '(inlimg-global-mode nil)
 '(inlimg-slice (quote (0 0 400 100)))
 '(php-file-patterns (quote ("\\.php[s34]?\\'" "\\.inc\\'")))
 '(show-paren-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(git--mark-blob-face ((((class color) (background light)) (:foreground "white"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 8)) (:background "black"))))
 '(mumamo-background-chunk-submode1 ((((class color) (min-colors 8)) (:background "black"))))
 '(mumamo-background-chunk-submode2 ((((class color) (min-colors 8)) (:background "black"))))
 '(mumamo-background-chunk-submode3 ((((class color) (min-colors 8)) (:background "black"))))
 '(mumamo-background-chunk-submode4 ((((class color) (min-colors 8)) (:background "black")))))

;; 光标在匹配的括号之间跳转
(global-set-key (kbd "C-c n") 'forward-list)
(global-set-key (kbd "C-c p") 'backward-list)

(global-set-key (kbd "<f7>") 'align-regexp)
(global-set-key (kbd "<f8>") 'split-window-horizontally)
(global-set-key (kbd "<f9>") 'split-window-vertically)
(global-set-key (kbd "<f10>") 'delete-window)
(global-set-key (kbd "<f11>") 'delete-other-windows)
(global-set-key (kbd "<f12>") 'other-window)
(global-set-key (kbd "<select>") 'move-end-of-line)
(global-set-key (kbd "C-\\") 'backward-kill-word)

;; 高亮当前行
(global-hl-line-mode 1)
(set-face-attribute hl-line-face nil :underline t :foreground "black" :background "yellow")
;(global-set-key (kbd "<select>") 'move-end-of-line)
(global-set-key [f5] 'revert-buffer)

;; (global-set-key [C-f5] 'revert-buffer-with-coding-system)
(defalias 'yes-or-no-p 'y-or-n-p)


(global-set-key (kbd "C-+") 'toggle-hiding)

;; (require 'hideshow)
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'php-mode-hook        'hs-minor-mode)
(defvar hs-special-modes-alist
  (mapcar 'purecopy
  '((c-mode "{{{" "}}}" "/[*/]" nil nil)
    (php-mode "{{{" "}}}" "/[*/]" nil nil)
    (c++-mode "{" "}" "/[*/]" nil nil)
    (java-mode "{" "}" "/[*/]" nil nil)
    (js-mode "{" "}" "/[*/]" nil))))

(load "folding" 'nomessage 'noerror)
(folding-mode-add-find-file-hook)


; stops selection with a mouse being immediately injected to the kill ring
(setq mouse-drag-copy-region nil)
; stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-primary nil)
; makes killing/yanking interact with clipboard X11 selection
(setq x-select-enable-clipboard t)
(require 'fringe)

(add-to-list 'load-path "/share/.emacs.d/emacs-calfw")
(require 'calfw)
(require 'calfw-org)
(require 'calfw-cal)

;; Month
(setq calendar-month-name-array
  ["一月" "二月" "三月" "四月" "五月" "六月"
   "七月" "八月" "九月" "十月" "十一月" "十二月"])
;; Week days
(setq calendar-day-name-array
      ["周日" "周一" "周二" "周三" "周四" "周五" "周六"])
;; First day of the week
(setq calendar-week-start-day 0) ; 0:Sunday, 1:Monday

