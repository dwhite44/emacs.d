(prelude-require-packages '(ng2-mode))
(require 'ng2-mode)

(eval-when-compile
  (require 'use-package))

(print "Install direnv package")
(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(print "Install / Setup csharp-mode package")
(add-to-list 'c-default-style '(csharp-mode . "c#"))

(use-package csharp-mode
  :ensure t
  :mode "\\.cs$"
  :config
  (setq csharp-want-imenu nil))

(defun my-csharp-mode-hook ()
  ;; enable the stuff you want for C# here
  (electric-pair-mode 1)       ;; Emacs 24
  (electric-pair-local-mode 1)) ;; Emacs 25

(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.cshtml\\'" . web-mode))

(print "Install / Setup Groovy Mode")
(use-package groovy-mode
  :ensure t
  :mode "\\.groovy")

(print "Install / Setup parinfer")
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
        ("<tab>" . parinfer-smart-tab:dwim-right))
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
    ;;(add-hook 'cider-repl-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(print "Set vim shift action to only use 2 spaces when in clojure mode")
(defun set-vim-shift-width ()
    (setq evil-shift-width 2))
(add-hook 'clojure-mode-hook #'set-vim-shift-width)

(print "Turn off cleaning up whitespace")
(setq prelude-clean-whitespace-on-save nil)

(print "Disable smartparens (doesn't work with parinfer)")
(require 'smartparens-config)
(defun parinfer-disable-smartparens ()
    (smartparens-global-mode 0))
(defun parinfer-enable-smartparens ()
    (smartparens-global-mode 1))
(add-hook 'parinfer-mode-enable-hook #'parinfer-disable-smartparens)
(add-hook 'parinfer-mode-disable-hook #'parinfer-enable-smartparens)

(print "Set smartparens strict mode off globally")
(add-hook 'cider-repl-mode-hook #'turn-off-smartparens-strict-mode)
;;(setq smartparens-global-strict-mode -1)

(print "set global key bindings")
(global-set-key [134217840] (quote projectile-find-file-in-known-projects))

(print "set default font")
(custom-set-faces
 '(default ((t (:height 160 :family "Menlo")))))

(print "Disable autosave and set backup files to single directory")
(setq auto-save-default nil)
(setq prelude-auto-save nil)
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
(super-save-stop)

(print "Set evil mode to insert for some windows")
(defun evil-set-insert ()
  (setq evil-default-state 'insert))
(add-hook 'cider-repl-mode-hook #'evil-set-insert)
(add-hook 'cider-error-mode-hook #'evil-set-insert)

(print "Set to always include line numbers on left-side of window")
(global-linum-mode t)

(print "Set to allow deleting current text and pasting from clipboard. Prevents
        the deleted text from being put into clipboard")
(setq save-interprogram-paste-before-kill t)
