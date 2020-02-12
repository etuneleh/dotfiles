;;; auto-generated stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bc75dfb513af404a26260b3420d1f3e4131df752c19ab2984a7c85def9a2917e" default)))
 '(evil-snipe-mode t)
 '(evil-snipe-override-mode t)
 '(global-evil-surround-mode 1)
 '(gud-tooltip-mode t)
 '(org-agenda-files (quote ("~/Documents/TODO.org")))
 '(package-selected-packages
   (quote
    (cider clojure-mode web-mode helm elfeed jenkins butler pulseaudio-control pinentry bosss emacs-bosss projectile-ripgrep dmenu projectile helm-firefox helm-company helm-unicode helm-tramp helm-ext helm-dictionary helm-eww helm-mu helm-exwm podcaster lispy helm-system-packages mu4e-conversation excorporate md4rd sx emms yasnippet-snippets google-translate fsharp-mode wgrep guix pdf-tools magit yasnippet company ivy mu4e-alert evil-mu4e smooth-scrolling doom-themes ggtags zenburn-theme which-key use-package smart-mode-line-atom-one-dark-theme sly ranger rainbow-delimiters ox-reveal org-ref org-re-reveal org-plus-contrib org-bullets omnisharp general geiser exwm evil-surround evil-snipe evil-org evil-magit evil-commentary evil-collection eval-sexp-fu eshell-prompt-extras counsel company-reftex auctex ace-link)))
 '(scroll-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; my emacs config
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
;; the following lines tell emacs where on the internet to look up
;; for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize) 

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package)

;; defaults suggested by blog and extended by me
(setq delete-old-versions -1)		; delete excess backup versions silently
(setq version-control t)		; use version control
(setq vc-make-backup-files t)		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))) ; which directory to put backups file
(setq vc-follow-symlinks t)				       ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))) ;transform backups file name
(setq inhibit-startup-screen t)	; inhibit startup screen
(setq ring-bell-function 'ignore)	; silent bell when you make a mistake
(set-language-environment "UTF-8")
(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character
(setq default-major-mode 'text-mode)
(blink-cursor-mode -1)
(setq revert-without-query '("*pdf")) ; automatically revert pdf-files
(add-to-list 'default-frame-alist
	     '(font . "Source Code Pro"))
(add-hook 'focus-out-hook (lambda () (when buffer-file-name (save-buffer))))
(recentf-mode 1)
(setq delete-by-moving-to-trash t)
(setq-default indent-tabs-mode nil)

(setq
 initial-scratch-message
 "Welcome!") ; print a default message in the empty scratch buffer opened at startup

(defalias 'yes-or-no-p 'y-or-n-p) ;reduce typing effort
(electric-pair-mode 1) ;close brackets

;; useful functions
(defun system-name= (&rest names)
  (cl-some
    (lambda (name)
      (string-equal name (system-name)))
    names))

(defun find-config-file ()
  "open emacs configuration file"
  (interactive)
  (find-file "~/.emacs"))

(defun load-config-file ()
  "load emacs configuration file"
  (interactive)
  (load-file "~/.emacs"))

(defun find-dotfile-dir ()
  "open dotfile directory"
  (interactive)
  (find-file "~/.dotfiles/dotfiles/"))

(defun ambrevar/toggle-window-split ()
  "Switch between vertical and horizontal split.
It only works for frames with exactly two windows.
(Credits go to ambrevar and his awesome blog)"
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer )
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))


;; packages with configuration
(use-package general :ensure t
  :init
  (setq general-override-states '(insert
				  emacs
				  hybrid
				  normal
				  visual
				  motion
				  operator
				  replace))
  :config
  (general-evil-setup t)
  (general-auto-unbind-keys)

  (general-create-definer my-leader-def
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "s-SPC"
    :states '(motion normal emacs))

  (general-create-definer my-local-leader-def
    :keymaps 'override
    :prefix "-"
    :states '(motion normal))

  (general-nmap "Y" "y$")

  (general-define-key "ESC" 'keyboard-quit :which-key "abort command")
  (general-define-key "TAB" 'company-complete :which-key "trigger completion")

  (general-define-key
   :keymaps 'override
   :states 'normal
   "gb" '(pop-tag-mark :which-key "go back"))

  ;; many spacemacs bindings go here
  (my-leader-def
    "SPC" '(helm-M-x :which-key "M-x")
    "a" '(:ignore t :which-key "applications")
    "ad" '(deer :which-key "call deer")
    "ab" '(helm-eww :which-key "open browser")
    "am" '(mu4e :which-key "open mail")
    "ap" '(helm-system-packages :which-key "package management")
    "ao" '(sx-search :which-key "search stackoverflow")
    "ar" '(md4rd :which-key "reddit")
    "at" '(ansi-term :which-key "open ansi-term")
    "aS" '(eshell :which-key "open existing eshell")
    "as" '((lambda () (interactive) (eshell 'N)) :which-key "open new eshell")
    "g"  '(:ignore t :which-key "git")
    "/"  '(helm-occur t :which-key "helm-occur")
    "cc" '(org-capture :which-key "org capture")
    "f" '(:ignore t :which-key "file")
    "fs" '(save-buffer :which-key "save file")
    "fS" '(write-file :which-key "save file as")
    "ff" '(helm-find-files :which-key "find file")
    "fed" '(find-config-file :which-key "find config file")
    "fer" '(load-config-file :which-key "load config file")
    "feD" '(find-dotfile-dir :which-key "find dotfile directory")
    "ft"  '(find-todo :which-key "find todo file")
    "fz"  '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "find scratch buffer")
    "fp" '(helm-locate :which-key "helm-locate")
    "fg" '(helm-do-grep-ag :which-key "helm-ag")
    "b" '(:ignore t :which-key "buffer")
    "bb" '(helm-mini :which-key "switch buffer")
    "be" '(helm-exwm :which-key "switch to exwm buffer")
    "bd" '(kill-this-buffer :which-key "kill buffer")
    "w"  '(:ignore t :which-key "window management")
    "w TAB"  '(lambda () (interactive) (ivy--switch-buffer-action (buffer-name (other-buffer (current-buffer)))))
    ;; "w2"  'spacemacs/layout-double-columns
    ;; "w3"  'spacemacs/layout-triple-columns
    ;; "wb"  'spacemacs/switch-to-minibuffer-window
    "wd"  'evil-window-delete
    "wH"  'evil-window-move-far-left
    "wh"  'evil-window-left
    "wJ"  'evil-window-move-very-bottom
    "wj"  'evil-window-down
    "wK"  'evil-window-move-very-top
    "wk"  'evil-window-up
    "wL"  'evil-window-move-far-right
    "wl"  'evil-window-right
    "wm"  'delete-other-windows
    "ws"  'split-window-below
    "wS"  'split-window-below-and-focus
    "w-"  'split-window-below
    "wU"  'winner-redo
    "wu"  'winner-undo
    "wv"  'split-window-right
    "wV"  'split-window-right-and-focus
    "ww"  'other-window
    "w="  'balance-windows
    "r"   '(:ignore t :which-key "recent-files")
    "rr"  'helm-recentf
    "w+"  '(ambrevar/toggle-window-split :which-key "toggle window split")
    "e"  '(:ignore t :which-key "eval elisp")
    "ee"  'eval-last-sexp
    "ef"  'eval-defun
    "ep"  'eval-print-last-sexp
    "i"   '(:ignore :which-key "internet")
    "id"  '((lambda () (interactive) (my-open-url "https://www.dazn.com")) :which-key "dazn")
    "ig"  '((lambda () (interactive) (my-open-url "https://www.dragongoserver.net/status.php")) :which-key "dgs")
    "iy"  '((lambda () (interactive) (my-open-url "https://www.youtube.com/")) :which-key "youtube")
    "ss"  'shutdown
    "sr"  'reboot
    "sl"  (lambda () (interactive) (shell-command "/usr/bin/slock"))))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config (evil-mode 1))

(use-package evil-collection
  :after (evil helm) 
  :ensure t
  :init
  (setq evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1)
 (evil-define-key 'operator global-map "s" 'evil-surround-edit)
    (evil-define-key 'operator global-map "S" 'evil-Surround-edit)
    (evil-define-key 'visual global-map "s" 'evil-surround-region)
    (evil-define-key 'visual global-map "gS" 'evil-Surround-region))

(use-package evil-snipe
  :ensure t
  :config
  (setq evil-snipe-scope 'visible)
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1)
  (evil-define-key 'visual evil-snipe-local-mode-map "z" 'evil-snipe-s)
  (evil-define-key 'visual evil-snipe-local-mode-map "Z" 'evil-snipe-S))

(use-package evil-commentary
  :ensure t
  :init (evil-commentary-mode))

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode)

;;appearance
;; (use-package zenburn-theme :ensure t)
;; ;; (use-package cyberpunk-theme :ensure t)
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-vibrant t))

(use-package smart-mode-line-atom-one-dark-theme
  :ensure t)

;; (use-package doom-modeline
;;   :ensure t
;;   :hook (after-init . doom-modeline-mode)
;;   :config
;;   (setq doom-modeline-height 25)
;;   )

(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1))

(use-package smart-mode-line
  :after smart-mode-line-atom-one-dark-theme
  :ensure t
  :config
  (setq sml/theme 'atom-one-dark)
  (setq mode-line-format
	'("%e"
	  (:eval (propertize
		  (format (concat "<%s> "
				  (unless (null (my-exwm-get-other-workspace)) "[%s] "))
			  exwm-workspace-current-index
			  (my-exwm-get-other-workspace))
		  'face 'sml/numbers-separator))
	  ;; (:eval (if (exwm-workspace--active-p exwm-workspace--current)
	  ;; 	     (format "%s " exwm-workspace-current-index)
	  ;; 	     (format "%s " (my-exwm-get-other-workspace)))) ;; TODO this is always true, determine the correct variable
	  sml/pos-id-separator
	  mode-line-mule-info
	  mode-line-client
	  mode-line-modified
	  mode-line-remote
	  mode-line-frame-identification
	  mode-line-buffer-identification
	  sml/pos-id-separator
	  mode-line-front-space
	  mode-line-position
	  evil-mode-line-tag
	  (vc-mode vc-mode)
	  sml/pre-modes-separator
	  mode-line-modes
	  mode-line-misc-info
	  mode-line-end-spaces))
  (sml/setup)
  (set-face-background 'mode-line-inactive "light")) 
(tool-bar-mode -1)
(menu-bar-mode -1)
(menu-bar-no-scroll-bar)

;; eshell
(setq eshell-cmpl-ignore-case t)

(use-package eshell-prompt-extras
  :ensure t
  :config
  (setq eshell-highlight-prompt t
	eshell-prompt-function 'epe-theme-lambda))

(use-package ranger :ensure t
  :commands (ranger)
  :config
  (general-define-key
   :keymaps 'ranger-normal-mode-map
   "cp" '(my-dired-convert-to-pdf :which-key "convert to pdf")
   "gr" '(ranger-refresh :which-key "refresh"))
  (setq ranger-cleanup-eagerly t)
  (ranger-override-dired-mode t))

(use-package helm
  :after helm-exwm
  :ensure t
  :config
  (general-define-key
   :keymaps 'helm-find-files-map
   "M-H" 'left-char
   "M-L" 'right-char
   "M-y" 'helm-ff-run-copy-file
   "M-r" 'helm-ff-run-rename-file
   "M-s" 'helm-ff-run-find-file-as-root
   "M-o" 'helm-ff-run-switch-other-frame
   "M-O" 'helm-ff-run-switch-other-window)
  (general-define-key
   :keymaps 'helm-buffer-map
   "M-d" 'helm-buffer-run-kill-persistent)
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-M-x-fuzzy-match t)
  (setq helm-buffers-fuzzy-matching           t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-file-cache-fuzzy-match           t)
  (setq helm-imenu-fuzzy-match                t)
  (setq helm-mode-fuzzy-match                 t)
  (setq helm-locate-fuzzy-match               t) 
  (setq helm-quick-update                     t)
  (setq helm-recentf-fuzzy-match              t)
  (setq helm-exwm-emacs-buffers-source (helm-exwm-build-emacs-buffers-source))
  (setq helm-exwm-source (helm-exwm-build-source))
  (setq helm-mini-default-sources `(helm-exwm-emacs-buffers-source
                                    helm-exwm-source
                                    helm-source-recentf))
  (helm-mode 1))

(use-package helm-system-packages
  :ensure t)

(use-package helm-eww
  :ensure t)

(use-package helm-dictionary
  :ensure t)

(use-package helm-tramp
  :ensure t)

(use-package helm-unicode
  :ensure t)

(use-package company
  :ensure t
  :config
  (setq company-dabbrev-downcase nil)
  (setq read-file-name-completion-ignore-case t)
  (global-company-mode 1))

(use-package yasnippet
  :ensure t
  :config
  (progn
    (yas-global-mode 1)
    (add-to-list 'company-backends 'company-yasnippet t)
    ;; Add yasnippet support for all company backends
    ;; https://github.com/syl20bnr/spacemacs/pull/179
    (defvar company-mode/enable-yas t
      "Enable yasnippet for all backends.")
    (defun company-mode/backend-with-yas (backend)
      (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
	  backend
	(append (if (consp backend) backend (list backend))
		'(:with company-yasnippet))))
    (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))))

(use-package yasnippet-snippets
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (my-leader-def
    :states 'normal
    "p" 'projectile-command-map)
  (projectile-mode 1))

(use-package projectile-ripgrep
  :ensure t)

(use-package magit
  :ensure t
  :general (my-leader-def
	     "gs" '(magit-status :which-key "git status")))

(use-package evil-magit :ensure t)

(use-package ediff :ensure t)

(unless (system-name= "localhost" "lina")
  (use-package pdf-tools
    :ensure t
    :init
    (pdf-tools-install)
    :magic ("%PDF" . pdf-view-mode)
    :config
    (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
    (setq pdf-view-continuous nil)
    (evil-collection-init 'pdf)
    (setq pdf-view-midnight-colors '("WhiteSmoke" . "gray16"))
    :general
    (general-define-key
     :states '(motion normal)
     :keymaps 'pdf-view-mode-map
     ;; evil-style bindings
     ;; "SPC"  nil ;TODO where to put this globally?
     "-"  nil ;TODO where to put this globally?
     "j"  '(pdf-view-scroll-up-or-next-page :which-key "scroll down")
     "k"  '(pdf-view-scroll-down-or-previous-page :which-key "scroll up")
     ;; "j"  '(pdf-view-next-line-or-next-page :which-key "scroll down")
     ;; "k"  '(pdf-view-previous-line-or-previous-page :which-key "scroll up")
     "L"  '(image-forward-hscroll :which-key "scroll right")
     "H"  '(image-backward-hscroll :which-key "scroll left")
     "l"  '(pdf-view-next-page :which-key "page down")
     "h"  '(pdf-view-previous-page :which-key "page up")
     "u"  '(pdf-view-scroll-down-or-previous-page :which-key "scroll down")
     "d"  '(pdf-view-scroll-up-or-next-page :which-key "scroll up")
     "/"  '(isearch-forward :which-key search forward)
     "?"  '(isearch-backward :which-key search backward)
     "0"  '(image-bol :which-key "go left")
     "$"  '(image-eol :which-key "go right"))
    (my-local-leader-def
      ;; :states 'normal
      :keymaps 'pdf-view-mode-map
      ;; Scale/Fit
      ;; "f"  nil
      "fw"  '(pdf-view-fit-width-to-window :which-key "fit width")
      "fh"  '(pdf-view-fit-height-to-window :which-key "fit heigth")
      "fp"  '(pdf-view-fit-page-to-window :which-key "fit page")
      "m"  '(pdf-view-set-slice-using-mouse :which-key "slice using mouse")
      "b"  '(pdf-view-set-slice-from-bounding-box :which-key "slice from bounding box")
      "R"  '(pdf-view-reset-slice :which-key "reset slice")
      "zr" '(pdf-view-scale-reset :which-key "zoom reset"))))

;;;programming languages
;; lisp
(use-package lispy
  :ensure t)

(use-package sly
  :ensure t
  :config
  (lispy-mode 1)
  (setq inferior-lisp-program "/usr/bin/sbcl --load /home/klingenberg/quicklisp.lisp")
  :general (my-local-leader-def
	     :keymaps 'lisp-mode-map
	     "'" '(sly :which-key "start reps")
	     "e" '(:ignore :which-key "eval")
	     "ef" '(sly-eval-defun :which-key "eval function")
	     "ee" '(sly-eval-last-expression :which-key "eval last expression")
	     "eb" '(sly-eval-buffer :which-key "eval buffer")))

(use-package geiser
  :ensure t
  :config
  (when (system-name= "klingenberg-tablet")
   (with-eval-after-load 'geiser-guile
     (add-to-list 'geiser-guile-load-path "~/guix-packages/guix/"))
   (with-eval-after-load 'yasnippet
     (add-to-list 'yas-snippet-dirs "~/guix-packages/guix/etc/snippets")))
  :general (my-local-leader-def
	     :keymaps 'scheme-mode-map
	     "'" '(geiser :which-key "start reps")
	     "e" '(:ignore :which-key "eval")
	     "ef" '(geiser-eval-definition :which-key "eval definition")
	     "ee" '(geiser-eval-last-sexp :which-key "eval last expression")
	     "eb" '(geiser-eval-buffer :which-key "eval buffer")))

;; (use-package clojure-mode
;;   :ensure t)

(use-package cider
  :ensure t)

(use-package eval-sexp-fu
  :ensure t
  :config
  (setq eval-sexp-fu-flash-face
	'((((class color)) (:background "black" :foreground "gray" :bold t))
	  (t (:inverse-video nil)))))
;;org
(use-package org
  :ensure org-plus-contrib
  :config
  (setq org-startup-indented t)
  (add-hook 'org-mode-hook '(lambda () (org-indent-mode 1)))
  (add-hook 'org-mode-hook 'flyspell-mode)
  ;; in case drastic measures are required:
  ;; (setq org-latex-pdf-process
  ;; 	'("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
  ;; 	  "bibtex %b"
  ;; 	  "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
  ;; 	  "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (add-to-list 'org-export-backends 'beamer)
  (add-to-list 'org-export-backends 'md)
  (setq org-confirm-babel-evaluate nil)
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((lisp . t)))
  (setq org-babel-lisp-eval-fn 'sly-eval)
  (setq org-default-notes-file "~/Documents/TODO.org")
  :general
    (my-local-leader-def
      :keymaps 'org-mode-map
      "e" '(org-export-dispatch :which-key "export")
      "a" '((lambda () (interactive)
      		    (let ((current-prefix-arg '-)) ; simulate pressing C-u
      		      (call-interactively 'org-export-dispatch))) :which-key "repeat last export")
      "s" '(org-edit-special :which-key "edit source code")
      "l" '(:ignore :which-key "links")
      "ll" '(org-insert-link :which-key "insert link")
      "lf" '((lambda () (interactive)
      		    (let ((current-prefix-arg '(4))) ; simulate pressing C-u
      		      (call-interactively 'org-insert-link))) :which-key "insert link to file"))
    (general-define-key
     :states '(motion normal)
     :keymaps 'org-mode-map
     "RET" '(org-open-at-point :which-key "open link")))

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook '(lambda () (org-bullets-mode 1))))

(use-package org-ref
  :ensure t
  :init
  (setq org-latex-pdf-process (list "latexmk -shell-escape -f -pdf %f"))
  :config
  (setq org-ref-ivy-cite t)
  (setq org-ref-default-bibliography '("~/HESSENBOX-DA/bibliography/bibliography.bib"))
  (setq bibtex-completion-library-path "~/HESSENBOX-DA/bibliography/bibtex-pdfs")
  :general
  (my-local-leader-def
    :keymaps 'org-mode-map
    "r" '(:ignore :which-key "references")
    "rc" '(org-ref-helm-insert-cite-link :which-key "insert citation")
    "rr" '(org-ref-insert-ref-link :which-key "insert reference")))

(use-package org-bullets
  :ensure t
  :after org
  :config
  (org-bullets-mode 1))

(use-package org-re-reveal
  :ensure t)

(use-package ggtags
  :ensure t)

(use-package wgrep
  :ensure t)

;;latex (auctex)
(use-package tex
  :ensure auctex
  :init
    (setq
     ;; TeX-command-default 'LaTeX
     TeX-view-program-selection '((output-pdf "PDF Tools"))
     TeX-source-correlate-start-server t
     TeX-auto-save t
     TeX-parse-self t
     TeX-syntactic-comment t
     ;; Synctex support
     TeX-source-correlate-start-server nil
     ;; Don't insert line-break at inline math
     LaTeX-math-abbrev-prefix "#"
     LaTeX-fill-break-at-separators nil)
  :config
    (TeX-interactive-mode -1)
    (TeX-source-correlate-mode -1)
    (setq TeX-electric-math '("\\(" . "\\)"))
    (setq TeX-electric-sub-and-superscript t)
    (setq TeX-save-query nil)
    (reftex-mode 1)
    (add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer)
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
    (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
    (add-hook 'LaTeX-mode-hook
	      (lambda ()
		(progn
		  (push '(?d . ("\\left\( " . " \\right\)")) evil-surround-pairs-alist)
		  (push '(?\$ . ("\\\(" . "\\\)")) evil-surround-pairs-alist))))
    ;; (general-define-key
    ;;  :states '(motion normal)
    ;;  :keymaps 'LaTeX-mode-map
    ;;  "-"  nil)
    ;; (add-to-list 'company-backends 'company-auctex t)
    (add-to-list 'company-backends 'company-math t)
  :general
  (my-local-leader-def
    :keymaps 'LaTeX-mode-map
    "-"   'TeX-recenter-output-buffer         
    "."   'LaTeX-mark-environment
    "*"   'LaTeX-mark-section
    "a"   'TeX-command-run-all                
    "b"   'TeX-command-master
    "e"   'TeX-next-error
    "k"   'TeX-kill-job                       
    "l"   'TeX-recenter-output-buffer         
    "m"   'TeX-insert-macro                   
    "v"   'TeX-view                           
    "c" '(:ignore :which-key "change")
    "cs" '(:ignore :which-key "change environment")
    "cse" '((lambda() (interactive) (LaTeX-environment 1)) :which-key "change current environment")
    "yae" '((lambda() (interactive)
	      (progn
		(LaTeX-mark-environment)
		(kill-ring-save 0 0 t))) :which-key "yank current environment")
    "dae" '((lambda() (interactive)
	      (progn 
		(LaTeX-mark-environment)
		(kill-region 0 0 t))) :which-key "delete current environment")
    ;; TeX-doc is a very slow function
    "hd"  'TeX-doc
    "xb"  'latex/font-bold
    "xc"  'latex/font-code
    "xe"  'latex/font-emphasis
    "xi"  'latex/font-italic
    "xr"  'latex/font-clear
    "xo"  'latex/font-oblique
    "xfc" 'latex/font-small-caps
    "xff" 'latex/font-sans-serif
    "xfr" 'latex/font-serif
    "r"   '(:ignore :which-key "reftex")
    "rt" '(reftex-toc :which-key "table of contents")
    "rr"   '(reftex-cleveref-cref :which-key "cref")
    "rc"   '(reftex-citation :which-key "cite")
    "ol" '(lambda() (interactive) (find-file "definLocal.tex"))
    "og" '(lambda() (interactive) (find-file (getenv "LatexGlobalConfig")))
    "ob" '(lambda() (interactive) (find-file "bibliography.bib"))))

;; (use-package auctex-latexmk
;;   :ensure t
;;   :defer t
;;   :init
;;   (progn
;;     (auctex-latexmk-setup)
;;     (setq auctex-latexmk-inherit-TeX-PDF-mode t)))

(use-package company-reftex
  :ensure t
  :config
  (add-to-list 'company-backends 'company-reftex-labels t)
  (add-to-list 'company-backends 'company-reftex-citations t))

;; browser
(use-package eww
  :ensure t
  ;; :general
  ;; (general-define-key
  ;;  "f" 'ace-link)
  )

(use-package ace-link
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :init (rainbow-delimiters-mode t))

;; html
(use-package web-mode
  :ensure t)

(use-package emms
  :ensure t
  :config
  (emms-standard)
  (emms-default-players))

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-feeds
        '("https://www.zeitsprung.fm/feed/mp3/")))

;; (use-package podcaster
;;   :ensure t
;;   :config
;;   (add-to-list 'podcaster-feeds-urls "https://www.zeitsprung.fm/feed/mp3/"))

(require 'washing-machine-timer "~/Dropbox/Helen+Dario/washing-machine-timer.el")
