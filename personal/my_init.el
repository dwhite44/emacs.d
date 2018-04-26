;; Enable / Configure parinfer 
(require 'use-package)
(use-package parinfer
  :ensure t
  :bind
  (:map parinfer-mode-map
        ("<tab>" . parinfer-smart-tab:dwim-right)
        ("C-i" . parinfer--reindent-sexp)
        ("C-M-i" . parinfer-auto-fix)
        ("C-," . parinfer-toggle-mode)
        :map parinfer-region-mode-map
        ("C-i" . indent-for-tab-command)
        ("<tab>" . parinfer-smart-tab:dwim-right) )
  :init
  (progn
     (setq parinfer-extensions
       '(defaults       ; should be included.
         pretty-parens  ; different paren styles for different modes.
         evil           ; If you use Evil.
         ;; lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
         ;;paredit        ; Introduce some paredit commands.
         smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
         smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(print "Set vim shift action to only use 2 spaces when in clojure mode")
(defun set-vim-shift-width ()
    (setq evil-shift-width 2))
(add-hook 'clojure-mode-hook #'set-vim-shift-width)

(print "Disable smartparens (doesn't work with parinfer)")
(require 'smartparens-config)
(defun parinfer-disable-smartparens ()
    (smartparens-global-mode 0))
(defun parinfer-enable-smartparens ()
    (smartparens-global-mode 1))
(add-hook 'parinfer-mode-enable-hook #'parinfer-disable-smartparens)
(add-hook 'parinfer-mode-disable-hook #'parinfer-enable-smartparens)

(print "set global key bindings")
(global-set-key [3 16] (quote projectile-find-file-in-known-projects))

(print "set default font")
(custom-set-faces                                                                                    
 '(default ((t (:height 150 :family "Menlo")))))

(print "Disable autosave and set backup files to single directory")
(setq auto-save-default nil)
(setq prelude-auto-save nil)
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
