(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; 稳定版 MELPA （非 nightly，有版本号）
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;; org-mode 专用软件源。它几乎只服务于 org-plus-contrib 这一个包
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(unless (package-installed-p 'use-package) 
  (package-refresh-contents) 
  (package-install 'use-package))

(require 'use-package)
;; 让 use-package 永远按需安装软件包
(setq use-package-always-ensure t)

(use-package 
  better-defaults)
(use-package 
  elisp-format)
										; quelpa 的包
(use-package 
  quelpa 
  :config						   ; 在 (require) 之后需要执行的表达式
  (use-package 
	quelpa-use-package)					; 启用 quelpa-use-package
  (setq quelpa-checkout-melpa-p nil quelpa-update-melpa-p nil)) ; 启用这个 advice
(load-theme 'wombat t)											; 主题
(setq user-full-name "Keara Coara"		; 用于 git?
	  user-mail-address "for156th@gmail.com") 
(setq scroll-margin 4)								  ; 滚动边界4
(add-hook 'prog-mode-hook 'display-line-numbers-mode) ; 至少在这两个模式里显示行号
(add-hook 'text-mode-hook 'display-line-numbers-mode) 
(show-paren-mode 1)						; 括号匹配
(setq inhibit-startup-message t)		; 不使用默认启动页
(tool-bar-mode -1)						; 砍去 gui 要素
(menu-bar-mode -1) 
(scroll-bar-mode -1) 
(setq x-select-enable-clipboard t)		; 允许 Emacs 从外面复制进来
(setq make-backup-files nil)			; 不自动保存
(setq auto-save-default nil) 
(setq scroll-conservatively 100) 
(setq ring-bell-function 'ignore)		; 不许响铃
										; 缩进
(setq-default tab-width 4) 
(setq-default standard-indent 4) 
(setq c-basic-offset tab-width) 
(setq-default electric-indent-inhibit t) 
(setq-default indent-tabs-mode t) 
(setq backward-delete-char-untabify-method 'nil)
										; prettify symbols mode
(global-prettify-symbols-mode t)
										; 匹配括号
(setq electric-pair-pairs '((?\{ . ?\}) 
							(?\( . ?\)) 
							(?\[ . ?\]) 
							(?\" . ?\"))) 
(electric-pair-mode t)

										; 创建新窗口光标跟随。给 evil 做一个？
(defun split-and-follow-horizontally () 
  (interactive) 
  (split-window-below) 
  (balance-windows) 
  (other-window 1)) 
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)
(defun split-and-follow-vertically () 
  (interactive) 
  (split-window-right) 
  (balance-windows) 
  (other-window 1)) 
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)
(defalias 'yes-or-no-p 'y-or-n-p)		; 用 y 和 n 回答问题
(global-hl-line-mode t)					; 高亮当前行
(use-package 
  auto-package-update 
  :defer nil 
  :ensure t 
  :config (setq auto-package-update-delete-old-versions t) 
  (setq auto-pakage-update-hide-results t) 
  (auto-package-update-maybe))
(use-package 
  diminish 
  :ensure t)
(use-package 
  which-key 
  :ensure t 
  :diminish which-key-mode 
  :config (which-key-mode))

										; 分划出本地包
(setq custom-file "~/.emacs.d/custom.el") 
(unless (file-exists-p custom-file) 
  (write-region "" nil custom-file)) 
(load custom-file)
(use-package 
  esup 
  :ensure t 
  :pin melpa)
(use-package 
  dashboard								; Emacs 启动！
  :ensure t 
  :config (dashboard-setup-startup-hook) 
  (setq dashboard-banner-logo-title "NOW'S YOUR CHANCE TO BE A [[BIG SHOT]]") 
  (setq dashboard-startup-banner "~/.emacs.d/spamton_neo.gif"))
(use-package 
  beacon								; 真光标，有种打游戏的美感
  :ensure t 
  :diminish beacon-mode 
  :config (beacon-mode 1) 
  :config (setq beacon-size 40 beacon-color 0.1))
(use-package 
  sublimity								; 小地图 from sublime
  :quelpa (sublimity :fetcher github 
					 :repo "zk-phi/sublimity" 
					 :branch "master" 
					 :upgrade nil 
					 :files ("*.el")) 
  :config (require 'sublimity) 
  (require 'sublimity-map) 
  (sublimity-mode 1))
(use-package 
  yascroll								; 滚动条也
  :config (global-yascroll-bar-mode 1))

										;   (use-package centaur-tabs
										;	 :demand
										;	 :bind
										;	 :config
										;	 (centaur-tabs-mode t)
										;	 (setq centaur-tabs-style "slant"
										;		   centaur-tabs-height 32
										;		   centaur-tabs-set-icons t
										;		   centaur-tabs-plain-icons t
										;		   centaur-tabs-gray-out-icons 'buffer
										;		   centaur-tabs-set-bar 'under
										;		   x-underline-at-descent-line t
										;		   centaur-tabs-set-modified-marker t
										;		   centaur-tabs-change-fonts "fira-code"))
(use-package 
  powerline 
  :config (powerline-center-evil-theme))
(use-package 
  all-the-icons 
  :if (display-graphic-p))
(use-package 
  helm 
  :bind (("M-x" . helm-M-x) 
		 ("C-x C-f" . helm-find-files)) 
  :config (helm-mode 1))
(use-package 
  company
  ;; 等价于 (add-hook 'after-init-hook
  :hook (after-init . global-company-mode) 
  :config
  ;; setq 可以像这样连着设置多个变量的值
  (setq company-tooltip-align-annotations t ; 注释贴右侧对齐
		company-tooltip-limit 20            ; 菜单里可选项数量
		company-show-numbers t ; 显示编号（然后可以用 M-数字 快速选定某一项）
		company-idle-delay .1  ; 延时多少秒后弹出
		company-minimum-prefix-length 3	; 至少几个字符后开始补全
		))
(use-package 
  copilot 
  :quelpa (copilot :fetcher github 
				   :repo "zerolfx/copilot.el" 
				   :branch "main" 
				   :upgrade nil 
				   :files ("dist" "*.el"))) 
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion) 
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
(use-package 
  flycheck 
  :init ;; 在 (require) 之前需要执行的
  (setq flycheck-emacs-lisp-load-path 'inherit) 
  :config (global-flycheck-mode))

(use-package 
  projectile 
  :diminish projectile-mode 
  :config (setq projectile-cache-file (expand-file-name ".cache/projectile.cache"
														user-emacs-directory)) ;; 把它的缓存挪到 ~/.emacs.d/.cache/ 文件夹下，让 gitignore 好做
  (projectile-mode 1) ;; 全局 enable 这个 minor mode
  ;; 定义和它有关的功能的 leader key
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map))
(use-package 
  helm-projectile 
  :if (functionp 'helm) ;; 如果使用了 helm 的话，让 projectile 的选项菜单使用 Helm 呈现
  :config (helm-projectile-on))
(use-package 
  magit)
(use-package lsp-mode
  ;; 延时加载：仅当 (lsp) 函数被调用时再 (require)
  :commands (lsp)
  ;; 在哪些语言 major mode 下启用 LSP
  :hook (((ruby-mode
           php-mode
           typescript-mode
           ;; ......
           ) . lsp))
  :init ;; 在 (reuqire) 之前执行
  (setq lsp-auto-configure t ;; 尝试自动配置自己
        lsp-auto-guess-root t ;; 尝试自动猜测项目根文件夹
        lsp-idle-delay 0.500 ;; 多少时间idle后向服务器刷新信息
        lsp-session-file "~/.emacs/.cache/lsp-sessions") ;; 给缓存文件换一个位置
  )

;; 内容呈现
(use-package lsp-ui
  ;; 仅在某软件包被加载后再加载
  :after (lsp-mode)
  ;; 延时加载
  :commands (lsp-ui-mode)
  :bind
  (:map lsp-ui-mode-map
        ;; 查询符号定义：使用 LSP 来查询。通常是 M-.
        ([remap xref-find-references] . lsp-ui-peek-find-references)
        ;; 查询符号引用：使用 LSP 来查询。通常是 M-?
        ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
        ;; 该文件里的符号列表：类、方法、变量等。前提是语言服务支持本功能。
        ("C-c u" . lsp-ui-imenu))
  ;; 当 lsp 被激活时自动激活 lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :init
  ;; lsp-ui 有相当细致的功能开关。具体参考：
  ;; https://github.com/emacs-lsp/lsp-mode/blob/master/docs/tutorials/how-to-turn-off.md
  (setq lsp-enable-symbol-highlighting t
        lsp-ui-doc-enable t
        lsp-lens-enable t))


(use-package 
  yasnippet 
  :config
  ;; 全局启用这个 minor mode
  (yas-global-mode 1))

;; 再装一个通用模板库，省得没 template 用
(use-package 
  yasnippet-snippets 
  :after (yasnippet))

;; 模板生成工具，写代码时随手生成一个模板。强烈推荐使用
;; 使用方法： https://github.com/abo-abo/auto-yasnippet
(use-package 
  auto-yasnippet 
  :bind (("C-c & w" . aya-create) 
		 ("C-c & y" . aya-expand)) 
  :config (setq aya-persist-snippets-dir (concat user-emacs-directory "my/snippets")))
(use-package 
  helm-ag)
(use-package 
  ctrlf 
  :config (ctrlf-mode t))
;; 此时 C-s 已经被替换成 ctrlf 版本的了
(use-package 
  helm-swoop
  ;; 更多关于它的配置方法: https://github.com/ShingoFukuyama/helm-swoop
  ;; 以下我的配置仅供参考
  :bind (("M-i" . helm-swoop) 
		 ("M-I" . helm-swoop-back-to-last-point) 
		 ("C-c M-i" . helm-multi-swoop) 
		 ("C-x M-i" . helm-multi-swoop-all) 
		 :map isearch-mode-map 
		 ("M-i" . helm-swoop-from-isearch) 
		 :map helm-swoop-map ("M-i" . helm-multi-swoop-all-from-helm-swoop) 
		 ("M-m" . helm-multi-swoop-current-mode-from-helm-swoop)) 
  :config
  ;; 它像 helm-ag 一样，可以直接修改搜索结果 buffer 里的内容并 apply
  (setq helm-multi-swoop-edit-save t)
  ;; 如何给它新开分割窗口
  ;; If this value is t, split window inside the current window
  (setq helm-swoop-split-with-multiple-windows t))

(use-package 
  avy 
  :bind (("C-'" . avy-goto-char-timer) ;; Control + 单引号
		 ;; 复用上一次搜索
		 ("C-c C-j" . avy-resume)) 
  :config (setq avy-background t ;; 打关键字时给匹配结果加一个灰背景，更醒目
				avy-all-windows t ;; 搜索所有 window，即所有「可视范围」
				avy-timeout-seconds 0.3)) ;; 「关键字输入完毕」信号的触发时间


(use-package 
  vterm
  ;; https://github.com/akermu/emacs-libvterm
  ;; 请务必参照项目 README 作配置，以下不是我的完整配置。
  ;; 比如，如果你要和 shell 双向互动（对，它可以双向互动），
  ;; 那么 shell 需要做一点配置以解析 vterm 传递过来的信号
  :config (setq vterm-kill-buffer-on-exit t)) ;; shell 退出时 kill 掉这个 buffer
;; 使用 M-x vterm 新建一个 terminal
;; 在 terminal 中使用 C-c C-t 进入「选择」模式（类似 Tmux 里的 C-b [ ）


(use-package 
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


(use-package 
  evil 
  :config (evil-mode 1)) 
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
(evil-global-set-key 'normal (kbd "u") 'evil-previous-line) 
(evil-global-set-key 'normal (kbd "e") 'evil-next-line) 
(evil-global-set-key 'normal (kbd "n") 'evil-backward-char) 
(evil-global-set-key 'normal (kbd "i") 'evil-forward-char) 
(evil-global-set-key 'normal (kbd ",.")'evil-jump-item) 
(evil-global-set-key 'normal (kbd "U") 'my-previous-five-line) 
(evil-global-set-key 'normal (kbd "E") 'my-next-five-line) 
(evil-define-key 'normal org-mode-map "<tab>" 'org-cycle) 
(evil-define-key 'normal org-mode-map "TAB" 'org-cycle) 
(evil-define-key 'normal org-mode-map "<" 'evil-shift-left)
(evil-global-set-key 'visual (kbd "u") 'evil-previous-line) 
(evil-global-set-key 'visual (kbd "e") 'evil-next-line) 
(evil-global-set-key 'visual (kbd "n") 'evil-backward-char) 
(evil-global-set-key 'visual (kbd "i") 'evil-forward-char) 
(evil-global-set-key 'visual (kbd ",.")'evil-jump-item) 
(evil-global-set-key 'visual (kbd "U") 'my-previous-five-line) 
(evil-global-set-key 'visual (kbd "E") 'my-next-five-line)
(evil-global-set-key 'normal (kbd "N") 'evil-beginning-of-line) 
(evil-global-set-key 'normal (kbd "I") 'evil-end-of-line)
(evil-global-set-key 'visual (kbd "N") 'evil-beginning-of-line) 
(evil-global-set-key 'visual (kbd "I") 'evil-end-of-line)
(evil-global-set-key 'normal (kbd "j") 'evil-undo) 
(evil-global-set-key 'normal (kbd "s") 'evil-insert) 
(evil-global-set-key 'normal (kbd "L") 'evil-insert-line) 
(evil-global-set-key 'normal (kbd "`") 'evil-invert-char) 
(evil-global-set-key 'normal (kbd "S") 'save-buffer) 
(evil-global-set-key 'normal (kbd "Q") 'evil-quit) 
(evil-global-set-key 'normal (kbd ";") 'evil-ex) 
(evil-global-set-key 'normal (kbd "h") 'evil-forward-word-end) 
(evil-global-set-key 'normal (kbd "H") 'evil-forward-word-end) 
(evil-global-set-key 'normal (kbd "k") 
					 (if (eq evil-search-module 'evil-search) 'evil-ex-search-next
					   'evil-search-next)) 
(evil-global-set-key 'normal (kbd "K") 
					 (if (eq evil-search-module 'evil-search) 'evil-ex-search-previous
					   'evil-search-previous)) 
(evil-global-set-key 'normal (kbd "C-w u") 'evil-window-up) 
(evil-global-set-key 'normal (kbd "C-w e") 'evil-window-down) 
(evil-global-set-key 'normal (kbd "C-w n") 'evil-window-left) 
(evil-global-set-key 'normal (kbd "C-w i") 'evil-window-right)
(evil-global-set-key 'visual (kbd "j") 'evil-undo) 
(evil-global-set-key 'visual (kbd "s") 'evil-insert) 
(evil-global-set-key 'visual (kbd "L") 'evil-insert-line) 
(evil-global-set-key 'visual (kbd "`") 'evil-invert-char) 
(evil-global-set-key 'visual (kbd "S") 'save-buffer) 
(evil-global-set-key 'visual (kbd "Q") 'evil-quit) 
(evil-global-set-key 'visual (kbd ";") 'evil-ex) 
(evil-global-set-key 'visual (kbd "h") 'evil-forward-word-end) 
(evil-global-set-key 'visual (kbd "H") 'evil-forward-word-end) 
(evil-global-set-key 'visual (kbd "k") 
					 (if (eq evil-search-module 'evil-search) 'evil-ex-search-next
					   'evil-search-next)) 
(evil-global-set-key 'visual (kbd "K") 
					 (if (eq evil-search-module 'evil-search) 'evil-ex-search-previous
					   'evil-search-previous)) 
(evil-global-set-key 'visual (kbd "C-w u") 'evil-window-up) 
(evil-global-set-key 'visual (kbd "C-w e") 'evil-window-down) 
(evil-global-set-key 'visual (kbd "C-w n") 'evil-window-left) 
(evil-global-set-key 'visual (kbd "C-w i") 'evil-window-right)





;; 直接 HTTP get 一个 elisp
(use-package 
  dired+ 
  :quelpa (dired+ :fetcher url 
				  :url "https://www.emacswiki.org/emacs/download/dired+.el" 
				  :upgrade nil))
(set-frame-font "mononoki 20" nil t)	; 字体
(use-package 
  restart-emacs)						;Emacs（重新）启动！
(use-package 
  rainbow-delimiters					;彩虹括号
  :hook (prog-mode . rainbow-delimiters-mode))

(recentf-mode 1) 
(setq recentf-max-menu-items 25) 
(setq recentf-max-saved-items 25) 
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(global-set-key "<f12>")

(use-package 
  smartparens 
  :config (require 'smartparens-config))

(use-package markdown-mode)
(use-package markdown-toc)

(use-package org
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
            '(lambda ()
               (visual-line-mode 1))))


(use-package htmlize
  :ensure t)

(use-package ox-hugo
  :ensure t
  :pin melpa
  :after ox)
(use-package 
  mediawiki)
;(use-package
;  agda2-mode
;  :quelpa (agda2-mode :fetcher github 
;					 :repo "agda/agda" 
;					 :branch "master" 
;					 :upgrade nil 
;					 :files ("src/data/emacs-mode/*.el")) 
;					)

(use-package 
  auctex 
  :hook (TeX-mode . TeX-PDF-mode) 
  (TeX-mode . company-mode) 
  (LaTeX-mode . (lambda () 
				  (push (list 'output-pdf "Zathura") TeX-view-program-selection))) 
  :config (setq reftex-plug-into-AUCTeX t) 
  (setq TeX-parse-self t) 
  (setq-default TeX-master nil) 
  (setq TeX-open-quote  "<<") 
  (setq TeX-close-quote ">>") 
  (setq TeX-electric-sub-and-superscript t) 
  (setq font-latex-fontify-script nil) 
  (setq TeX-show-compilation nil) 
  (setq reftex-label-alist '(AMSTeX)))
(use-package 
  company-auctex 
  :config (company-auctex-init))
(use-package 
  company-reftex 
  :config (add-to-list 'company-backends 'company-reftex-citations) 
  (add-to-list 'company-backends 'company-reftex-labels))

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))
