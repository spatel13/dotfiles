(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(global-linum-mode 1)

(setq debug-on-error t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq show-paren-mode t)
;; this ensures that I am not asked to confirm that the theme can be loaded
(setq custom-safe-themes t)

(require 'package)

(setq package-archives '(
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package async
  :ensure t
  :config
  (progn
    async-bytecomp-package-mode t))

(use-package dracula-theme
  :ensure t)

;;; AUTO REFRESH PACKAGES
(when (not package-archive-contents)
    (package-refresh-contents))

(use-package indent-guide
  :ensure t
  :config
  (progn
    (indent-guide-global-mode)))

(use-package powerline
  :ensure t
  :config
  (progn
    (powerline-default-theme)))

;;; SPECIAL SYNTAX HIGHLIGHTING
;; Python operator and integer highlighting
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :ensure t
  :config
  (progn
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq python-indent 4)))
    (font-lock-add-keywords 'python-mode
					; adds object and str and fixes it so that keywords that
					; often appear with : are assigned as builtin-face	
			    '(("\\<\\(object\\|str\\|else\\|except\\|finally\\|try\\|\\)\\>" 0 'font-lock-keyword-face)
			      ;;("\\<[\\+-]?[0-9]+\\(.[0-9]+\\)?\\>" 0 'font-lock-constant-face)
			      ("\\<[\\+-]?[0-9]+\\(.[0-9]+\\)?+\\(j+\\)?\\>" 0 'font-lock-constant-face) 
			      ("\\([][{}()~^<>:!|&=,.\\+*/%-]\\)" 0 'warning)
			      )) ;; end font-lock-add-keywords
    ))

(use-package py-autopep8
  :ensure t
  :config
  (progn
    (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)))

(electric-pair-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e" "a4df5d4a4c343b2712a8ed16bc1488807cd71b25e3108e648d4a26b02bc990b3" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" default))
 '(package-selected-packages
   '(ob-async emacs-async protobuf-mode dockerfile-mode flycheck ivy-hydra counsel-projectile projectile use-package counsel ivy magit git-commit ghub writeroom-mode vue-html-mode rjsx-mode powerline indent-guide py-autopep8 smart-tabs-mode org-grep ido-vertical-mode ido-completing-read+ god-mode flx-ido dracula-theme auto-complete anaconda-mode ace-jump-mode))
 '(whitespace-style
   '(face trailing tabs spaces lines newline empty indentation::space space-before-tab space-mark tab-mark newline-mark)))

(setq require-final-newline t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun bjm-swiper-recenter (&rest args)
  "recenter display after swiper"
  (recenter))

(use-package ivy
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (define-key ivy-minibuffer-map (kbd "C-c j") 'ivy-immediate-done)
    (setq ivy-height 10)
    (setq ivy-count-format "(%d/%d) ")
    (setq ivy-display-style 'fancy)
    (setq ivy-virtual-abbreviate 'full)
    (setq magit-completing-read-function 'ivy-completing-read)
    (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
    (define-key ivy-minibuffer-map (kbd "C-c j") 'ivy-immediate-done)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "C-j") 'ivy-switch-buffer)
    (add-hook 'view-mode-hook
              (function (lambda ()
                          (define-key view-mode-map (kbd "C-j") 'ivy-switch-buffer))))))

(use-package counsel
  :ensure t
  :config
  (progn
    (global-set-key (kbd "C-c i m") 'counsel-imenu)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "C-h f") 'counsel-describe-function)
    (global-set-key (kbd "C-j") 'ivy-switch-buffer)
    (global-set-key (kbd "M-y") 'counsel-yank-pop)
    (global-set-key (kbd "M-l") 'counsel-bookmark)))

  
;; good bye helm, hello swiper
(use-package swiper
  :ensure t
  :config
  (progn
    (global-set-key "\C-s" 'swiper)
    (global-set-key "\C-r" 'swiper)
    (advice-add 'swiper :after #'bjm-swiper-recenter)))

(use-package projectile
  :ensure t
  :config
  (progn
    (projectile-global-mode)
    (setq projectile-enable-caching nil)
    (global-set-key (kbd "C-f") 'projectile-command-map)
    (setq projectile-completion-system 'ivy)
    ;; (require 'counsel-projectile)
    (setq projectile-switch-project-action 'projectile-dired)
    (bind-key* "C-f l" 'projectile-find-file-other-window)
    ;; use counsel-ag instead of projectile-ag
    (defalias 'projectile-ag 'counsel-ag)))

;; i <3 projectile
(use-package counsel-projectile
  :ensure t
  :config
  (progn
    (defalias 'projectile-ag 'counsel-ag)
    (global-set-key (kbd "C-f p") 'counsel-projectile-switch-project)
    (setq counsel-projectile-switch-project-action 'counsel-projectile-switch-project-action-vc)))

(use-package ivy-hydra
  :ensure t)

(use-package
  flycheck
  :ensure t
  :init
  (progn
    (add-hook 'after-init-hook #'global-flycheck-mode)
    (setq flycheck-highlighting-mode 'lines)))

;; this is for magit
(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-`") 'magit-status))

;; start magit in full frame rather than split the frame
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer (if (and (derived-mode-p 'magit-mode)
                         (memq (with-current-buffer buffer major-mode)
                               '(magit-process-mode
                                 magit-revision-mode
                                 magit-diff-mode
                                 magit-stash-mode
                                 magit-status-mode)))
                    nil
                  '(display-buffer-same-window)))))

(use-package dockerfile-mode
  :ensure t
  :config
  (progn
    (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))))
