(menu-bar-mode 1) 
(toggle-scroll-bar -1) 
(tool-bar-mode -1) 
(global-linum-mode 1)

(setq debug-on-error t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq show-paren-mode t)

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(package-initialize)

; list the packages you want
(setq package-list '(god-mode writeroom-mode ace-jump-mode anaconda-mode dash dracula-theme f flx flx-ido ghub git-commit ido-completing-read+ ido-vertical-mode let-alist magit magit-popup memoize org org-grep py-autopep8 with-editor indent-guide powerline neotree all-the-icons flycheck))

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(global-flycheck-mode)

(load "indent-guide") ;; best not to include the ending “.el” or “.elc”
(indent-guide-global-mode)

(load "powerline")
(powerline-default-theme)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

(require 'god-mode)
(defun my-update-cursor ()
  (setq cursor-type (if (or god-local-mode buffer-read-only)
                        'box
                      'bar)))

(add-hook 'god-mode-enabled-hook 'my-update-cursor)
(add-hook 'god-mode-disabled-hook 'my-update-cursor)
(global-set-key (kbd "<escape>") 'god-local-mode)

;;; SPECIAL SYNTAX HIGHLIGHTING
;; Python operator and integer highlighting
(require 'python)
(add-hook 'python-mode-hook 'anaconda-mode)
(font-lock-add-keywords 'python-mode
   ; adds object and str and fixes it so that keywords that
; often appear with : are assigned as builtin-face	
   '(("\\<\\(object\\|str\\|else\\|except\\|finally\\|try\\|\\)\\>" 0 'font-lock-keyword-face)
 ;;("\\<[\\+-]?[0-9]+\\(.[0-9]+\\)?\\>" 0 'font-lock-constant-face)
 ("\\<[\\+-]?[0-9]+\\(.[0-9]+\\)?+\\(j+\\)?\\>" 0 'font-lock-constant-face) 
   ("\\([][{}()~^<>:!|&=,.\\+*/%-]\\)" 0 'warning)
   )) ;; end font-lock-add-keywords

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;;; AUTO REFRESH PACKAGES
(when (not package-archive-contents)
    (package-refresh-contents))

;;; IDO CONFIG SECTION
(require 'flx-ido)
(require 'ido-vertical-mode)
(require 'ido-completing-read+)
(ido-mode 1)
(ido-vertical-mode 1)
(flx-ido-mode 1)
(ido-ubiquitous-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-face-nil t)
(setq ido-everywhere t)
(setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
(setq ido-vertical-show-count t)

(global-set-key
 "\M-x"
 (lambda ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (all-completions "" obarray 'commandp))))))

;; stop ido suggestion when doing a save-as
(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)

(electric-pair-mode t)

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; 
;; enable a more powerful jump back function from ace jump mode
;;
;; https://github.com/winterTTr/ace-jump-mode/wiki/AceJump-FAQ
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (dracula)))
 '(custom-safe-themes
   (quote
    ("a4df5d4a4c343b2712a8ed16bc1488807cd71b25e3108e648d4a26b02bc990b3" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" default)))
 '(package-selected-packages
   (quote
    (vue-html-mode rjsx-mode all-the-icons neotree powerline indent-guide py-autopep8 smart-tabs-mode writeroom-mode org-grep magit ido-vertical-mode ido-completing-read+ god-mode flx-ido dracula-theme auto-complete anaconda-mode ace-jump-mode)))
 '(whitespace-style
   (quote
    (face trailing tabs spaces lines newline empty indentation::space space-before-tab space-mark tab-mark newline-mark))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 100 :family "Hack")))))

(setq require-final-newline t)

(global-set-key (kbd "C-x g") 'magit-status)

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq python-indent 4)))

(require 'neotree)
 (global-unset-key "\C-\\")
(global-set-key (kbd "C-\\") 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
