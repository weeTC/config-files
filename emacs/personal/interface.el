;;; Interface
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)
(use-package which-key)
(setq which-key-mode t)
(setq visible-bell t)

;; Client-server properties
(require 'server)
(unless (server-running-p)
  (server-start))

;; Global packages
(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package helm
  :diminish helm-mode
  :bind (("M-SPC" . helm-M-x)
		 ("<escape>" . keyboard-quit)
		 )
  :config
  (helm-mode 1)
  (setq helm-autoresize-mode t)
  (setq helm-buffer-max-length 40)
  (setq helm-echo-input-in-header-line t)
  (define-key helm-map (kbd "S-SPC") 'helm-toggle-visible-mark)
  (define-key helm-find-files-map (kbd "C-k") 'helm-find-files-up-one-level))

(use-package avy
  :config
  (setq avy-keys (list ?u?h?e?t?o?n?a?s?i?d))
  (setq avy-background t))

(use-package company
  :diminish company-mode
  :config
  (global-company-mode)
  (setq company-idle-delay 0.2)
  (setq company-selection-wrap-around t)
  (define-key company-active-map [tab] 'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

;; Setting up evil
(use-package evil
  :init
  (use-package evil-leader
	:config
    (global-evil-leader-mode)
	(evil-leader/set-leader "<SPC>")
	(evil-leader/set-key
	  "SPC" 'avy-goto-word-or-subword-1'
	  "," 'other-window
	  "." 'mode-line-other-buffer
	  "b" 'helm-mini
	  "c" 'comment-dwim
	  "d" 'kill-this-buffer
	  "f" 'helm-imenu
	  "h" 'fontify-and-browse
	  "i" 'find-user-init-file
	  "l" 'whitespace-mode
	  "o" 'delete-other-windows
	  "p" 'helm-show-kill-ring
	  "s" 'sp-up-sexp
	  "t" 'find-main-todo-file
	  "w" 'save-buffer
	  "x" 'helm-M-x
	  "y" 'yank-to-x-clipboard)
	)
  (use-package evil-surround
    :config
    (global-evil-surround-mode))
  (use-package evil-smartparens
	:config
	(evil-smartparens-mode t))
  (use-package evil-goggles
	:config
	(evil-goggles-mode)
	(evil-goggles-use-diff-faces))
  (use-package evil-indent-plus)

  :config
  (evil-mode 1)
										; Basic navigation
  :config
  (define-key evil-normal-state-map 
    "h" 'evil-backward-char)
  (define-key evil-visual-state-map 
    "h" 'evil-backward-char)
  (define-key evil-normal-state-map 
    "j" 'evil-next-visual-line)
  (define-key evil-visual-state-map 
    "j" 'evil-next-visual-line)
  (define-key evil-normal-state-map 
    "gj" 'evil-next-line)
  (define-key evil-visual-state-map 
    "gj" 'evil-next-line)
  (define-key evil-normal-state-map 
    "k" 'evil-previous-visual-line)
  (define-key evil-visual-state-map 
    "k" 'evil-previous-visual-line)
  (define-key evil-normal-state-map 
    "gk" 'evil-previous-line)
  (define-key evil-visual-state-map 
    "gk" 'evil-previous-line)
  (define-key evil-normal-state-map 
    "l" 'evil-forward-char)
  (define-key evil-visual-state-map 
    "l" 'evil-forward-char)
										;Move around windows
  (define-key evil-normal-state-map (kbd "M-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "M-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "M-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "M-l") 'evil-window-right)
										; Escape quits everything
  (defun minibuffer-keyboard-quit ()
	"Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
	(interactive)
	(if (and delete-selection-mode transient-mark-mode mark-active)
		(setq deactivate-mark  t)
	  (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
	  (abort-recursive-edit)))
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
  (global-set-key [escape] 'evil-exit-emacs-state)


										; Working with Helm
  (define-key evil-ex-map "b" 'helm-mini)
  (define-key evil-ex-map "e" 'helm-find-files))

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd ":") 'evil-repeat-find-char)
  (define-key evil-motion-state-map (kbd "-") 'evil-ex)
  (define-key evil-normal-state-map "-" 'evil-ex)
  (define-key evil-visual-state-map "-" 'evil-ex))

;; Auto-saving
(recentf-mode t)
(setq recetnf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
