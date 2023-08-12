;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;

(global-set-key (kbd "<f5>") (lambda () (interactive) (find-file "~/.doom.d/config.org")))
(global-set-key (kbd "<f6>") (lambda () (interactive) (find-file "~/Shared/Playground/blog/content-org/blog-content.org")))
(global-set-key (kbd "<f7>") (lambda () (interactive) (find-file "~/Shared/Playground/Org/待完成事项.org")))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq doom-font (font-spec :family "Fira Code" :size 16))
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")
(setq evil-want-C-i-jump nil)
(defun repeat-command (proc times)
  (dotimes (_ times)
	(funcall proc)))
(defun my-previous-five-line ()
  (interactive)
  (repeat-command 'evil-previous-line 5))
(defun my-next-five-line ()
  (interactive)
  (repeat-command 'evil-next-line 5))
(setq my-evil-global-binding '(
        ("u" . evil-previous-line)
        ("e" . evil-next-line)
        ("n" . evil-backward-char)
        ("i" . evil-forward-char)
        (",." . evil-jump-item)
        ("U" . my-previous-five-line)
        ("E" . my-next-five-line)
        ("N" . evil-beginning-of-line)
        ("I" . evil-end-of-line)
        ("j" . evil-undo)
        ("l" . evil-insert)
        ("L" . evil-insert-line)
        ("`" . evil-invert-char)
        ("Q" . evil-quit)
        (";" . evil-ex)
        ("h" . evil-forward-word-end)
        ("H" . evil-forward-word-end)
        ("k" . evil-ex-search-next)
        ("K" . evil-ex-search-previous)
        ("C-w u" . evil-window-up)
        ("C-w e" . evil-window-down)
        ("C-w n" . evil-window-left)
        ("C-w i" . evil-window-right)))
(dolist (pair my-evil-global-binding)
    (evil-global-set-key 'normal (kbd (car pair)) (cdr pair))
    (evil-global-set-key 'visual (kbd (car pair)) (cdr pair)))

  (setq dashboard-banner-logo-title "NOW'S YOUR CHANCE TO BE A [[BIG SHOT]]")
(use-package! ox-hugo)
(use-package!
  rime
  :bind (:map rime-mode-map
			  ("C-`" . 'rime-send-keybinding))
  :custom (default-input-method "rime")
  (rime-librime-root "~/.emacs.d/librime/dist")
  :config (setq rime-translate-keybindings '("C-f" "C-b" "C-`"))
  (setq rime-show-candidate 'posframe)
  (setq mode-line-mule-info
		'((:eval (rime-lighter))))
  (setq rime-inline-ascii-trigger 'shift-l)
  (setq rime-inline-ascii-holder ?x)
  (setq rime-user-data-dir "~/.emacs.d/Rime"))
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
(beacon-mode 1)
(after! org
  (setq org-agenda-files (list "~/Shared/Playground/Org/"
                               "~/Shared/Playground/blog/content-org/博客.org")))
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(defun org-summary-todo-after-state-change ()
  "Switch headline to DONE when all subentries are DONE, to TODO otherwise."
  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
         (parent-end (save-excursion (org-up-heading-safe) (point)))
         (n-done 0)
         (n-not-done 0))
    (save-excursion
      (org-back-to-heading t)
      (org-show-subtree)
      (while (and (< (point) subtree-end)
                  (re-search-forward org-heading-regexp subtree-end t))
        (let ((state (org-get-todo-state)))
          (if (string= state "DONE")
              (setq n-done (1+ n-done))
            (setq n-not-done (1+ n-not-done)))))
    (when (= n-not-done 0)
      (save-excursion
        (goto-char parent-end)
        (org-todo "DONE"))))))

(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)
(add-hook 'org-after-todo-state-change-hook #'org-summary-todo-after-state-change)

(defun org-turn-subentries-to-todo (headline-point)
    (save-excursion
        (org-map-entries (lambda () (org-todo "TODO")) "/+DONE" 'tree)))

(defun org-toggle-subentries-to-todo ()
  "Toggle all subentries under a headline to TODO state."
  (interactive)
  (let ((headline-point (org-get-at-bol 'org-hd-marker)))
    (org-turn-subentries-to-todo headline-point)))

(map! :after org
      :map evil-normal-state-map
      :prefix "SPC m"
      :desc "Toggle subentries to TODO"
      "X" #'org-toggle-subentries-to-todo)


(setq org-hierarchical-todo-statistics t)


(set-evil-initial-state! 'vterm-mode 'emacs)
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
