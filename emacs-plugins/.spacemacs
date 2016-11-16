; http://www.wilkesley.org/~ian/xah/emacs/elisp_next_prev_user_buffer.html
; http://www.wilkesley.org/~ian/xah/emacs/emacs_stop_cursor_enter_prompt.html

; TO DO
; ========
; http://ergoemacs.org/emacs/elisp_close_buffer_open_last_closed.html
; http://www.wilkesley.org/~ian/xah/misc/ergoemacs_vi_mode.html
; use single key for switching bufffer use xah function for switch

; lots of good tips


; https://github.com/thunderboltsid/vim-configuration/blob/master/vimrc
; https://github.com/magnars/.emacs.d

;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.
(setq-default dotspacemacs-configuration-layers '(themes-megapack))

( defun dotspacemacs/layers ()
		"Configuration Layers declaration.
		You should not put any user code in this function besides modifying the variable
		values."

		(setq-default
				;; Base distribution to use. This is a layer contained in the directory
				;; `+distribution'. For now available distributions are `spacemacs-base'
				;; or `spacemacs'. (default 'spacemacs)
				dotspacemacs-distribution 'spacemacs
				;; List of additional paths where to look for configuration layers.
				;; Paths must have a trailing slash (i.
				dotspacemacs-configuration-layer-path '()
				;; List of configuration layers to load. If it is the symbol `all' instead
				;; of a list then all discovered layers will be installed.
				dotspacemacs-configuration-layers
				'(
				 ;; ----------------------------------------------------------------
				 ;; Example of useful layers you may want to use right away.
				 ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
				 ;; <M-m f e R> (Emacs style) to install them.
				 ;; ----------------------------------------------------------------
				 (auto-completion :variables
							   auto-completion-return-key-behavior 'complete
							   auto-completion-tab-key-behavior 'cycle
							   auto-completion-complete-with-key-sequence nil
							   auto-completion-complete-with-key-sequence-delay 0.1
							   auto-completion-private-snippets-directory nil)
							   
				 ;; better-defaults
				 emacs-lisp
				 ;; git
				 ;; markdown
				 ;; org
				 ;; (shell :variables
				 ;;        shell-default-height 30
				 ;;        shell-default-position 'bottom)
				 ;; spell-checking
				 ;; syntax-checking
				 ;; version-control
				 )
				;; List of additional packages that will be installed without being
				;; wrapped in a layer. If you need some configuration for these
				;; packages, then consider creating a layer. You can also put the
				;; configuration in `dotspacemacs/user-config'.
				dotspacemacs-additional-packages '()
				;; A list of packages and/or extensions that will not be install and loaded.
				dotspacemacs-excluded-packages '()
				;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
				;; are declared in a layer which is not a member of
				;; the list `dotspacemacs-configuration-layers'. (default t)
				dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
		"Initialization function.
		This function is called at the very startup of Spacemacs initialization
		before layers configuration.
		You should not put any user code in there besides modifying the variable
		values."
		;; This setq-default sexp is an exhaustive list of all the supported
		;; spacemacs settings.
		(setq-default
		;; If non nil ELPA repositories are contacted via HTTPS whenever it's
		;; possible. Set it to nil if you have no way to use HTTPS in your
		;; environment, otherwise it is strongly recommended to let it set to t.
		;; This variable has no effect if Emacs is launched with the parameter
		;; `--insecure' which forces the value of this variable to nil.
		;; (default t)
		dotspacemacs-elpa-https t
		;; Maximum allowed time in seconds to contact an ELPA repository.
		dotspacemacs-elpa-timeout 5
		;; If non nil then spacemacs will check for updates at startup
		;; when the current branch is not `develop'. (default t)
		dotspacemacs-check-for-update nil
		;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
		;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
		;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
		;; unchanged. (default 'vim)
		dotspacemacs-editing-style 'hybrid
		;; If non nil output loading progress in `*Messages*' buffer. (default nil)
		dotspacemacs-verbose-loading nil
		;; Specify the startup banner. Default value is `official', it displays
		;; the official spacemacs logo. An integer value is the index of text
		;; banner, `random' chooses a random text banner in `core/banners'
		;; directory. A string value must be a path to an image format supported
		;; by your Emacs build.
		;; If the value is nil then no banner is displayed. (default 'official)
		dotspacemacs-startup-banner 'official
		;; List of items to show in the startup buffer. If nil it is disabled.
		;; Possible values are: `recents' `bookmarks' `projects'.
		;; (default '(recents projects))
		dotspacemacs-startup-lists '(recents projects)
		;; Number of recent files to show in the startup buffer. Ignored if
		;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
		dotspacemacs-startup-recent-list-size 10
		;; Default major mode of the scratch buffer (default `text-mode')
		dotspacemacs-scratch-mode 'text-mode
		;; List of themes, the first of the list is loaded when spacemacs starts.
		;; Press <SPC> T n to cycle to the next theme in the list (works great
		;; with 2 themes variants, one dark and one light)
		dotspacemacs-themes '(spacemacs-dark
							 spacemacs-light
							 solarized-light
							 solarized-dark
							 leuven
							 monokai
							 zenburn)
		;; If non nil the cursor color matches the state color in GUI Emacs.
		dotspacemacs-colorize-cursor-according-to-state t
		;; Default font. `powerline-scale' allows to quickly tweak the mode-line
		;; size to make separators look not too crappy.
		dotspacemacs-default-font '("Source Code Pro"
								   :size 15
								   :weight normal
								   :width normal
								   :powerline-scale 1.1)
		;; The leader key
		dotspacemacs-leader-key "SPC"
		;; The leader key accessible in `emacs state' and `insert state'
		;; (default "M-m")
		dotspacemacs-emacs-leader-key "M-m"
		;; Major mode leader key is a shortcut key which is the equivalent of
		;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
		dotspacemacs-major-mode-leader-key ","
		;; Major mode leader key accessible in `emacs state' and `insert state'.
		;; (default "C-M-m)
		dotspacemacs-major-mode-emacs-leader-key "C-M-m"
		;; These variables control whether separate commands are bound in the GUI to
		;; the key pairs C-i, TAB and C-m, RET.
		;; Setting it to a non-nil value, allows for separate commands under <C-i>
		;; and TAB or <C-m> and RET.
		;; In the terminal, these pairs are generally indistinguishable, so this only
		;; works in the GUI. (default nil)
		dotspacemacs-distinguish-gui-tab nil
		;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
		;; The command key used for Evil commands (ex-commands) and
		;; Emacs commands (M-x).
		;; By default the command key is `:' so ex-commands are executed like in Vim
		;; with `:' and Emacs commands are executed with `<leader> :'.
		dotspacemacs-command-key ":"
		;; If non nil `Y' is remapped to `y$'. (default t)
		dotspacemacs-remap-Y-to-y$ t
		;; Name of the default layout (default "Default")
		dotspacemacs-default-layout-name "Default"
		;; If non nil the default layout name is displayed in the mode-line.
		;; (default nil)
		dotspacemacs-display-default-layout nil
		;; If non nil then the last auto saved layouts are resume automatically upon
		;; start. (default nil)
		dotspacemacs-auto-resume-layouts t
		;; Location where to auto-save files. Possible values are `original' to
		;; auto-save the file in-place, `cache' to auto-save the file to another
		;; file stored in the cache directory and `nil' to disable auto-saving.
		;; (default 'cache)
		dotspacemacs-auto-save-file-location 'cache
		;; Maximum number of rollback slots to keep in the cache. (default 5)
		dotspacemacs-max-rollback-slots 5
		;; If non nil then `ido' replaces `helm' for some commands. For now only
		;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
		;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
		dotspacemacs-use-ido nil
		;; If non nil, `helm' will try to minimize the space it uses. (default nil)
		dotspacemacs-helm-resize nil
		;; if non nil, the helm header is hidden when there is only one source.
		;; (default nil)
		dotspacemacs-helm-no-header nil
		;; define the position to display `helm', options are `bottom', `top',
		;; `left', or `right'. (default 'bottom)
		dotspacemacs-helm-position 'bottom
		;; If non nil the paste micro-state is enabled. When enabled pressing `p`
		;; several times cycle between the kill ring content. (default nil)
		dotspacemacs-enable-paste-micro-state nil
		;; Which-key delay in seconds. The which-key buffer is the popup listing
		;; the commands bound to the current keystroke sequence. (default 0.4)
		dotspacemacs-which-key-delay 0.4
		;; Which-key frame position. Possible values are `right', `bottom' and
		;; `right-then-bottom'. right-then-bottom tries to display the frame to the
		;; right; if there is insufficient space it displays it at the bottom.
		;; (default 'bottom)
		dotspacemacs-which-key-position 'bottom
		;; If non nil a progress bar is displayed when spacemacs is loading. This
		;; may increase the boot time on some systems and emacs builds, set it to
		;; nil to boost the loading time. (default t)
		dotspacemacs-loading-progress-bar t
		;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
		;; (Emacs 24.4+ only)
		dotspacemacs-fullscreen-at-startup nil

		;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
		;; Use to disable fullscreen animations in OSX. (default nil)
		dotspacemacs-fullscreen-use-non-native nil
		;; If non nil the frame is maximized when Emacs starts up.
		;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
		;; (default nil) (Emacs 24.4+ only)
		dotspacemacs-maximized-at-startup t
		;; A value from the range (0..100), in increasing opacity, which describes
		;; the transparency level of a frame when it's active or selected.
		;; Transparency can be toggled through `toggle-transparency'. (default 90)
		dotspacemacs-active-transparency 90
		;; A value from the range (0..100), in increasing opacity, which describes
		;; the transparency level of a frame when it's inactive or deselected.
		;; Transparency can be toggled through `toggle-transparency'. (default 90)
		dotspacemacs-inactive-transparency 90
		;; If non nil unicode symbols are displayed in the mode line. (default t)
		dotspacemacs-mode-line-unicode-symbols t
		;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
		;; scrolling overrides the default behavior of Emacs which recenters the
		;; point when it reaches the top or bottom of the screen. (default t)
		dotspacemacs-smooth-scrolling t
		;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
		;; derivatives. If set to `relative', also turns on relative line numbers.
		;; (default nil)
		dotspacemacs-line-numbers nil
		;; If non-nil smartparens-strict-mode will be enabled in programming modes.
		;; (default nil)
		dotspacemacs-smartparens-strict-mode nil
		;; Select a scope to highlight delimiters. Possible values are `any',
		;; `current', `all' or `nil'. Default is `all' (highlight any scope and
		;; emphasis the current one). (default 'all)
		dotspacemacs-highlight-delimiters 'all
		;; If non nil advises quit functions to keep server open when quitting.
		;; (default nil)
		dotspacemacs-persistent-server nil
		;; List of search tool executable names. Spacemacs uses the first installed
		;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
		;; (default '("ag" "pt" "ack" "grep"))
		dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
		;; The default package repository used if no explicit repository has been
		;; specified with an installed package.
		;; Not used for now. (default nil)
		dotspacemacs-default-package-repository nil
		;; Delete whitespace while saving buffer. Possible values are `all'
		;; to aggressively delete empty line and long sequences of whitespace,
		;; `trailing' to delete only the whitespace at end of lines, `changed'to
		;; delete only whitespace for changed lines or `nil' to disable cleanup.
		;; (default nil)
		dotspacemacs-whitespace-cleanup nil
		))

(defun dotspacemacs/user-init ()
		"Initialization function for user code.
		It is called immediately after `dotspacemacs/init', before layer configuration
		executes.
		 This function is mostly useful for variables that need to be set
		before packages are loaded. If you are unsure, you should try in setting them in
		`dotspacemacs/user-config' first."
		(setq-default evil-escape-key-sequence "jf")  
		(server-start)
		(setq spacemacs-evil-cursors '(("normal" "#ff00ff" box)
                                   ("insert" "chartreuse3" (bar . 2))
                                   ("emacs" "SkyBlue2" box)
                                   ("hybrid" "red" (bar . 2))
                                   ("replace" "chocolate" (hbar . 2))
                                   ("evilified" "LightGoldenrod3" box)
                                   ("visual" "gray" (hbar . 2))
                                   ("motion" "plum3" box)
                                   ("lisp" "green" box)
                                   ("iedit" "green" box)
                                   ("iedit-insert" "green" (bar . 2))))

		
		)



(defun dotspacemacs/user-config ()
		"Configuration function for user code.
		This function is called at the very end of Spacemacs initialization after
		layers configuration.
		This is the place where most of your configurations should be done. Unless it is
		explicitly specified that a variable should be set before a package is loaded,
		you should place you code here."
		  (global-hl-line-mode 1) ; Disable current line highlight
		  (global-linum-mode) ; Show line numbers by default
		  (setq custom-enabled-themes '(whiteboard))
		  (setq cursor-type '(bar . 4))
		
		

(recentf-mode 1) ; keep a list of recently opened files
(setq initial-major-mode (quote text-mode)) ; default mode
(defalias 'list-buffers 'ibuffer) ; always use ibuffer
;; make frequently used commands short
(defalias 'qrr 'query-replace-regexp)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'dnml 'delete-non-matching-lines)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'sl 'sort-lines)
(defalias 'rr 'reverse-region)
(defalias 'rs 'replace-string)

(defalias 'g 'grep)
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)
(defalias 'rb 'revert-buffer)
(defalias 'sh 'shell)
(defalias 'fb 'flyspell-buffer)
(defalias 'sbc 'set-background-color)
(defalias 'rof 'recentf-open-files)
(defalias 'lcd 'list-colors-display)
(defalias 'cc 'calc)
; elisp
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'eis 'elisp-index-search)
(defalias 'lf 'load-file)
; major modes
(defalias 'hm 'html-mode)
(defalias 'tm 'text-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'om 'org-mode)
(defalias 'ssm 'shell-script-mode)
; minor modes
(defalias 'wsm 'whitespace-mode)
(defalias 'gwsm 'global-whitespace-mode)
(defalias 'vlm 'visual-line-mode)
(defalias 'glm 'global-linum-mode)
; Save the above in file and name it my-alias.el, then put it in your ~/.emacs.d/ directory. Then, in your emacs init file, add:
; (load "my-alias")
;; Tell emacs where is your personal elisp lib dir

; save the place in files

(require 'saveplace)
(setq-default save-place t)
(global-set-key (kbd "<f6>") (lambda() (interactive)(find-file "~/.emacs")))

(global-set-key [f1] 'shell-other-window) ; shell
(global-set-key (kbd "M-9") 'kill-whole-line)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<f8>") 'xah-run-current-file)

;; Automatically reload files was modified by external program
(global-auto-revert-mode 1)
;; and display "half modal" warning about it
;(require 'w32-msgbox)
(setq revert-buffer-function 'inform-revert-modified-file)

(global-set-key (kbd "<mouse-3>") 'nil)
(fset 'evil-visual-update-x-selection 'ignore)
(setq mouse-drag-copy-region nil)
(setq x-select-enable-primary nil)
(setq visible-bell 1)
(cd "C:\\Users\\cibin\\AppData\\Roaming\\.emacs.d\\config\\others\\el-qrencode-master")
(load-file "C:\\Users\\cibin\\AppData\\Roaming\\.emacs.d\\config\\others\\el-qrencode-master\\load.el")
; (load-file "~/.emacs.d/config/personal-configs/filecache.el")

;; Load up starter kit customizations

; (require 'starter-kit-defuns)
; (require 'starter-kit-bindings)

(load-file "C:\\Users\\cibin\\AppData\\Roaming\\.emacs.d\\config\\personal-configs\\starter-kit-bindings.el")
(load-file "C:\\Users\\cibin\\AppData\\Roaming\\.emacs.d\\config\\personal-configs\\filecache.el")
(file-cache-read-cache-from-file)

(electric-pair-mode 1) ; automatically insert right brackets when left one is typed?
(show-paren-mode 1) ; turn on bracket match highlight

; http://ergoemacs.org/emacs/emacs_make_modern.html 
; save minibuffer history
(savehist-mode 1)

(setq backup-by-copying t) ; stop emacs's backup changing the file's creation date of the original file?

;; backup in one place. flat, no tree structure
; (setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
; all backups are placed in one place
; This will create backup files flat in the given dir, and the backup file names will have “!” characters in place of the directory separator.
(setq make-backup-file-name-function 'my-backup-file-name)

(desktop-save-mode 1) ; save/restore opened files from last session
(global-visual-line-mode 1) ; soft line wrap ; 1 for on, 0 for off.


(require 'ido) ; part of emacs

(defvar xah-filelist nil "Association list of file/dir paths. Used by `xah-open-file-fast'. Key is a short abbrev string, Value is file path string.")

(setq xah-filelist
      '(
        ("3emacs" . "~/.emacs.d/" )
        ("git" . "~/git/" )
        ("todo" . "~/todo.org" )
        ("keys" . "~/git/my_emacs_init/my_keybinding.el" )
        ("download" . "~/Downloads/" )
        ("pictures" . "~/Pictures/" )
        ;; more here
        ) )

		
(menu-bar-mode -1)
(when (display-graphic-p)
	(tool-bar-mode -1)
	(scroll-bar-mode -1))


(set-face-attribute 'vertical-border nil :foreground (face-attribute 'fringe :background))
(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq initial-buffer-choice "~/")

(setq scroll-step            1
      scroll-conservatively  10000)


(require 'dired-x)
(require 'dired-aux)

(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "evince")
        ("\\.\\(?:djvu\\|eps\\)\\'" "zathura")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.\\(?:csv\\|odt\\|ods\\)\\'" "libreoffice")
        ("\\.\\(?:mp4\\|mp3\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "vlc")
        ("\\.html?\\'" "firefox")))
		

(global-set-key [(control x) (control r)] 'rename-this-file)

; color themes, deftheme style (added in emacs 24).
(load-theme 'manoj-dark)



(global-set-key (kbd "M-p") 'move-line-region-up)
(global-set-key (kbd "M-n") 'move-line-region-down)
(global-set-key (kbd "M-<up>") 'move-line-region-up)
(global-set-key (kbd "M-<down>") 'move-line-region-down)
; (global-set-key (kbd "M-<up>") 'move-line-up)
; (global-set-key (kbd "M-<down>") 'move-line-down)

; (global-set-key (kbd "M-<up>") 'move-region-up)
; (global-set-key (kbd "M-<down>") 'move-region-down)


(global-set-key [?\C-h] 'delete-backward-char)
; (global-set-key [?\C-x ?h] 'help-command)    ;; overrides mark-whole-buffer


(global-set-key [C-right] 'geosoft-forward-word)
(global-set-key [C-left] 'geosoft-backward-word) 
(global-set-key [f4] 'bubble-buffer) 
		


; to make sure case is preserved when expanding
(setq dabbrev-case-replace nil)		

(global-set-key [S-return]   'open-next-line)
(global-set-key [C-S-return] 'open-previous-line)
(global-set-key (kbd "C-o") 'open-next-line)
(global-set-key (kbd "M-o") 'open-previous-line)

;	

; ===========

;https://github.com/mcandre/dotfiles/blob/master/.emacs
;; Open project file by fuzzy name

(use-package fiplr
  :bind ("C-p" . fiplr-find-file)
  :defines fipl-ignored-globs
  :config
  (setq fiplr-ignored-globs
        '((directories
           ;; Version control
           (".git"
            ".svn"
            ".hg"
            ".bzr"
            ;; NPM
            "node_modules"
            ;; Bower
            "bower_components"
            ;; Maven
            "target"
            ;; Gradle
            "build"
            ".gradle"
            ;; Python
            "__pycache__"
            ;; IntelliJ
            ".idea"
            ;; Infer
            "infer-out"))
          (files
           ;; Emacs
           (".#*"
            ;; Vim
            "*~"
            ;; Objects
            "*.so"
            "*.o"
            "*.obj"
            "*.hi"
            ;; Media
            "*.jpg"
            "*.png"
            "*.gif"
            "*.pdf"
            ;; Archives
            "*.gz"
            "*.zip"))))
			
 ;; Better TAB handling
  (define-key *fiplr-keymap* (kbd "TAB")
    (lambda ()
(interactive))))
  (use-package markdown-mode
    :mode ("\\.md$" . gfm-mode)
    :init
    ;; Use markdown-mode for *scratch*
    (setq initial-scratch-message nil
          initial-major-mode 'gfm-mode)
    :config
    ;; Block indent for Markdown
    (add-hook 'markdown-mode-hook
              (lambda ()

                (setq indent-tabs-mode nil
                      tab-width 4)
                (define-key markdown-mode-map (kbd "TAB") 'traditional-indent)
                (define-key markdown-mode-map (kbd "<backtab>") 'traditional-outdent)
                (define-key markdown-mode-map (kbd "M-<left>") nil)
                (define-key markdown-mode-map (kbd "M-<right>") nil)
                ;; Remove triple backtick 'features'
                (define-key gfm-mode-map (kbd "`") nil))))


; ====
;; Typing text replaces marked regions
(delete-selection-mode 1)


(setq enablmÍrecursive-minibuffers t) ;; allow recursive editing in minibuffer

(follow-mode t)                       ;; follow-mode allows easier editing of long files

(global-set-key [f5]          '(lambda () (interactive) (kill-buffer (current-buffer))))

; to have the name of the file as the name of the window:
(setq frame-title-format '(buffer-file-name "Emacs: %b (%f)" "Emacs: %b"))



;; from ; https://snarfed.org/dotfiles/.emacs
;; C-8 for *scratch*, C-9 for *compilation*.
;; (use M-8, etc as alternates since C-number keys don't have ascii control
;; codes, so they can't be used in terminal frames.)
(defun switch-to-scratch ()
  (interactive) (bury-then-switch-to-buffer "*scratch*"))
(global-set-key [(control \8)] 'switch-to-scratch)
(global-set-key [(control x) (\8)] 'switch-to-scratch)
(global-set-key [(meta \8)] 'switch-to-scratch)

; interpret and use ansi color codes in shell buffers
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'diff-mode-hook 'ansi-color-for-comint-mode-on)

; don't highlight trailing whitespace in some modes
(dolist (hook '(shell-mode-hook compilation-mode-hook diff-mode-hook))
  (add-hook hook (lambda () (set-variable 'show-trailing-whitespace nil))))

 
message("loading not installed/untested packages")
; go to the last change
(package-require 'goto-chg)
(global-set-key [(control .)] 'goto-last-change)
(global-set-key (kbd "C-.") 'goto-last-change)
; M-. can conflict with etags tag search. But C-. can get overwritten
; by flyspell-auto-correct-word. And goto-last-change needs a really
; fast key.
(global-set-key [(meta .)] 'goto-last-change)
; ensure that even in worst case some goto-last-change is available
(global-set-key [(control meta .)] 'goto-last-change)

;; Highlight TODO and FIXME in comments 
(package-require 'fic-ext-mode)
(add-something-to-mode-hooks '(c++ tcl emacs-lisp python text markdown latex) 'fic-ext-mode)

; ======


;; Fast line numbers
(use-package nlinum
  :config
  ;; Line number gutter in ncurses mode
  (unless window-system
    (setq nlinum-format "%d "))
  ;; :idle
  (global-nlinum-mode))
  
; extra major modes!
(require 'markdown-mode)


) ; end of user-config()




 
(defun rename-this-file (new-file-name)
  "Renames this file and switches the buffer to point to the new file."
  (interactive "FRename to: ")
  (let ((orig-buffer (current-buffer)))
    (rename-file buffer-file-name new-file-name)
    (find-file new-file-name)
    (kill-buffer orig-buffer)))





(defun add-something-to-mode-hooks (mode-list something)
  "helper function to add a callback to multiple hooks"
  (dolist (mode mode-list)
    (add-hook (intern (concat (symbol-name mode) "-mode-hook")) something)))




; https://www.emacswiki.org/emacs/OpenNextLine
    ;; Behave like vi's o command
    (defun open-next-line (arg)
      "Move to the next line and then opens a line.
    See also `newline-and-indent'."
      (interactive "p")
      (end-of-line)
      (open-line arg)
      (next-line 1)
      (when newline-and-indent
        (indent-according-to-mode)))


    ;; Behave like vi's O command
    (defun open-previous-line (arg)
      "Open a new line before the current one. 
     See also `newline-and-indent'."
      (interactive "p")
      (beginning-of-line)
      (open-line arg)
      (when newline-and-indent
        (indent-according-to-mode)))

    ;; Autoindent open-*-lines
    (defvar newline-and-indent t
      "Modify the behavior of the open-*-line functions to cause them to autoindent.")
	  

; bubble-buffer

(defvar LIMIT 1)
(defvar time 0)
(defvar mylist nil)

(defun time-now ()
   (car (cdr (current-time))))

(defun bubble-buffer ()
   (interactive)
   (if (or (> (- (time-now) time) LIMIT) (null mylist))
       (progn (setq mylist (copy-alist (buffer-list)))
          (delq (get-buffer " *Minibuf-0*") mylist)
          (delq (get-buffer " *Minibuf-1*") mylist)))
   (bury-buffer (car mylist))
   (setq mylist (cdr mylist))
   (setq newtop (car mylist))
   (switch-to-buffer (car mylist))
   (setq rest (cdr (copy-alist mylist)))
   (while rest
     (bury-buffer (car rest))
     (setq rest (cdr rest)))
   (setq time (time-now)))



(defun move-region (start end n)
;;https://www.emacswiki.org/emacs/MoveRegion
  "Move the current region up or down by N lines."
  (interactive "r\np")
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (let ((start (point)))
      (insert line-text)
      (setq deactivate-mark nil)
      (set-mark start))))

(defun move-region-up (start end n)
  "Move the current line up by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) -1 (- n))))

(defun move-region-down (start end n)
  "Move the current line down by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) 1 n)))




(defun move-line (n)
;; https://www.emacswiki.org/emacs/MoveLine
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(defun move-line-region-up (&optional start end n)
  (interactive "r\np")
  (if (use-region-p) (move-region-up start end n) (move-line-up n)))

(defun move-line-region-down (&optional start end n)
  (interactive "r\np")
  (if (use-region-p) (move-region-down start end n) (move-line-down n)))

  
  
  
  
  

; http://geosoft.no/development/emacs.html
 ; For fast navigation within an Emacs buffer it is necessary to be able to move swiftly between words. The functions below change the default Emacs behavour on this point slightly, to make them a lot more usable.
; Note the way that the underscore character is treated. This is convinient behaviour in programming. Other domains may have different requirements, and these functions should be easy to modify in this respect.

(defun geosoft-forward-word ()
   ;; Move one word forward. Leave the pointer at start of word
   ;; instead of emacs default end of word. Treat _ as part of word
   (interactive)
   (forward-char 1)
   (backward-word 1)
   (forward-word 2)
   (backward-word 1)
   (backward-char 1)
   (cond ((looking-at "_") (forward-char 1) (geosoft-forward-word))
         (t (forward-char 1))))

(defun geosoft-backward-word ()
   ;; Move one word backward. Leave the pointer at start of word
   ;; Treat _ as part of word
   (interactive)
   (backward-word 1)
   (backward-char 1)
   (cond ((looking-at "_") (geosoft-backward-word))
         (t (forward-char 1))))
		 
		 

;; make backup to a designated dir, mirroring the full path

(defun my-backup-file-name (fpath)
"Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* (
        (backupRootDir "~/.emacs.d/emacs-backup/")
        (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, ➢ for example: “C:”
        (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
        )
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath
  )
)

(defun xah-open-file-fast ()
"Prompt to open a file from `xah-filelist'.
URL `http://ergoemacs.org/emacs/emacs_hotkey_open_file_fast.html'
Version 2015-04-23"
; Call xah-open-file-fast, then it will prompt with real-time name completion as you type.
; You should assign it a key. For example, 【F8】, so you can open a file by 【F8 1】, 【F8 2】, etc.
  (interactive)
  ; (let ((-abbrevCode
         ; (ido-completing-read "Open:" (mapcar (lambda (-x) (car -x)) xah-filelist))))
    ; (find-file (cdr (assoc -abbrevCode xah-filelist))))
	; OR
	(let ((j 1) (file (car xah-filelist)))
(while file
(let ((name (intern (format "Open:%s" (car file)))))
(fset name `(lambda () (interactive) (find-file ,(cdr file))))
(setq file (nth j xah-filelist))
(or (< j 10) (setq file nil j 0))
(global-set-key (kbd (format "<f2> %d" j)) name)
(setq j (1+ j)))))
	)
(defun xah-new-empty-buffer ()
  "Open a new empty buffer.
URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
Version 2016-08-11"
  (interactive)
  (let ((-buf (generate-new-buffer "untitled")))
    (switch-to-buffer -buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)))

(defun shell-other-window ()
  "Open a `shell' in a new window."
  (interactive)
  (let ((buf (shell)))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-window buf)))
	
	
(defun inform-revert-modified-file (&optional p1 p2)
      "bdimych custom function"
      (let ((revert-buffer-function nil))
			 (message "File modified. Reloaded." ) ; %s: %s" title body)
            (revert-buffer p1 p2)
        ;(w32-msgbox (buffer-file-name) "Emacs: Modified file automatically reverted" 'vb-ok-only 'vb-information nil t)
      )
    )
	
	


(defun reload-settings ()
;These little helper functions let me access and reload my configuration whenever I want to make any changes. 
		  (interactive)
		  (org-babel-load-file "~/.emacs.d/settings.org"))
		  
  


(defconst +win-path+ "C:/" "Windows root path.")
;;; Cygwin
(let ((cygwin-dir (concat +win-path+ "cygwin64/bin")))
		(when (file-exists-p cygwin-dir)
		(setq shell-file-name "bash"
		explicit-shell-file-name "bash")
		(setenv "SHELL" shell-file-name)
		(setenv "CYGWIN" "nodosfilewarning")

		(when (require 'cygwin-mount nil t)
		(cygwin-mount-activate)
		(setq w32shell-cygwin-bin cygwin-dir))))
		
(defun cygwin-shell ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin64/bin/bash"))
    (call-interactively 'shell)))
(defun xah-copy-file-path (&optional *dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.
URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2016-07-17"
  (interactive "P")
  (let ((-fpath
         (if (equal major-mode 'dired-mode)
             (expand-file-name default-directory)
           (if (null (buffer-file-name))
               (user-error "Current buffer is not associated with a file.")
             (buffer-file-name)))))
    (kill-new
     (if (null *dir-path-only-p)
         (progn
           (message "File path copied: 「%s」" -fpath)
           -fpath
           )
       (progn
         (message "Directory path copied: 「%s」" (file-name-directory -fpath))
         (file-name-directory -fpath))))))
	
	
	(defun xah-open-file-at-cursor ()
  "Open the file path under cursor.
If there is text selection, uses the text selection for path.
If the path starts with “http://”, open the URL in browser.
Input path can be {relative, full path, URL}.
Path may have a trailing “:‹n›” that indicates line number. If so, jump to that line number.
If path does not have a file extension, automatically try with “.el” for elisp files.
This command is similar to `find-file-at-point' but without prompting for confirmation.

URL `http://ergoemacs.org/emacs/emacs_open_file_path_fast.html'"
  (interactive)
  (
  ; let ((-path (if (use-region-p)
                   ; (buffer-substring-no-properties (region-beginning) (region-end))
                 ; (let (p0 p1 p2)
                   ; (setq p0 (point))
                   ; ; chars that are likely to be delimiters of full path, e.g. space, tabs, brakets.
                   ; (skip-chars-backward "^  \"\t\n`'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\`")
                   ; (setq p1 (point))
                   ; (goto-char p0)
                   ; (skip-chars-forward "^  \"\t\n`'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\'")
                   ; (setq p2 (point))
                   ; (goto-char p0)
                   ; (buffer-substring-no-properties p1 p2)))))
	let ((-path  (setq -path
      (buffer-substring-no-properties
       (line-beginning-position)
       (line-end-position)))
       )	)	 
				   
			(message "path is")
			(message -path)
	; if text is a url		
    ; (if (string-match-p "\\`https?://" -path)
        ; (browse-url -path)
	; (pcase "yyy" 		
		; ("nill" (message "hi" ))
		; ("noo" (message "no" ))
		; ("yyy" (message "hellllll" ))
	; )


(setq -path (replace-regexp-in-string "/cygdrive/\\(.\\)" "\\1:" -path))
		(if (file-exists-p -path)
                (find-file -path)
      (progn ; not starting “http://”
	  
        (if (string-match "^\\`\\([^:]+?\\):\\([0-9]*\\)\\(.*\\)\\'" -path)
            (progn
              (let (
                    (-fpath (match-string 1 -path))
                    (-line-num (string-to-number (match-string 2 -path))))
					(message "fpath is")
					(message -fpath)
                (if (file-exists-p -fpath)
                    (progn
                      (find-file -fpath)
                      (goto-char 1)
                      (forward-line (1- -line-num)))
                  (progn
                    (when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" -fpath))
                      (find-file -fpath))))))
          (progn
		  
			(message "pathhh is")
			(message -path)
            (if (file-exists-p -path)
                (find-file -path)
              (if (file-exists-p (concat -path ".el"))
                  (find-file (concat -path ".el"))
                (when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" -path))
                  (find-file -path ))))))
				  
				  
				  ))))
	
	
	
	
	
(defun my-compile()
(interactive)
(shell)
(goto-char (point-max))
(comint-kill-input)
(insert "ls -l")
; send enter
; (comint-send-input)
)	

(defun say-word (word)
; copies current word to variable.
; instead of showing default text showing up, empty arg is sent as the argument
  (interactive (list
                (read-string (format "word (%s): " (thing-at-point 'word))
                             nil nil (thing-at-point 'word))))
  (message "The word is %s" word))
  
(defun paste-from-x-clipboard()
; execute in minibuffer
  (interactive)
  (let ((value
       (read-from-minibuffer prompt initial nil nil
                             history default inherit)))
  (if (and (equal value "") default)
      (if (consp default) (car default) default)
    value))
  ; (shell-command "ls-l")
  (shell-command value)
								 
  )
  
(defun ff (arg)
  "Prompt user to enter a string, with input history support."
  (interactive
   (list
    (read-string "Enter (use up/down for history) :" "grep")
		))
  ; (message "String is %s." arg)
  (shell-command arg))
  
  

(defun sm-minibuffer-insert-val2 (exp)
; http://stackoverflow.com/questions/10121944/passing-emacs-variables-to-minibuffer-shell-commands
  (interactive
   (list (let ((enable-recursive-minibuffers t))
           (read-from-minibuffer "Insert: "
                                 nil read-expression-map t
                                 'read-expression-history))))
    (let ((val (with-selected-window (minibuffer-selected-window)
                 (eval exp)))
          (standard-output (current-buffer)))
      (prin1 val)))
  
(defun sm-minibuffer-insert-val (exp)
; http://stackoverflow.com/questions/10121944/passing-emacs-variables-to-minibuffer-shell-commands
  (interactive
   (list (let ((enable-recursive-minibuffers t))
           (read-from-minibuffer "Insert: "
                                 nil read-expression-map t
                                 'read-expression-history))))
    (let ((val (with-selected-window (minibuffer-selected-window)
                 (eval exp)))
          (standard-output (current-buffer)))
      (prin1 val)))
  
(defun xah-run-current-file ()
		"Execute the current file.
		For example, if the current buffer is the file x.py, then it'll call 「python x.py」 in a shell.
		The file can be Emacs Lisp, PHP, Perl, Python, Ruby, JavaScript, Bash, Ocaml, Visual Basic, TeX, Java, Clojure.
		File suffix is used to determine what program to run.

		If the file is modified or not saved, save it automatically before run.

		URL `http://ergoemacs.org/emacs/elisp_run_current_file.html'
		version 2016-01-28"
		(interactive)
		(let (
			 (ξsuffix-map
			  ;; (‹extension› . ‹shell program name›)
			  `(
				("php" . "php")
				("pl" . "perl")
				("py" . "python")
				("ahk" . ,(if (string-equal system-type "windows-nt") "C:/Progra~1/AutoHotkey/AutoHotkey.exe" "C:/Progra~1/AutoHotkey/AutoHotkey.exe"))
				("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
				("rb" . "ruby")
				("go" . "go run")
				("js" . "node") ; node.js
				("sh" . "bash")
				("clj" . "java -cp /home/xah/apps/clojure-1.6.0/clojure-1.6.0.jar clojure.main")
				("rkt" . "racket")
				("ml" . "ocaml")
				("vbs" . "cscript")
				("tex" . "pdflatex")
				("latex" . "pdflatex")
				("java" . "javac")
				;; ("pov" . "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640")
				))

			 ξfname
			 ξfSuffix
			 ξprog-name
			 ξcmd-str)

		(when (null (buffer-file-name)) (save-buffer))
		(when (buffer-modified-p) (save-buffer))

		(setq ξfname (buffer-file-name))
		(setq ξfSuffix (file-name-extension ξfname))
		(setq ξprog-name (cdr (assoc ξfSuffix ξsuffix-map)))
		(setq ξcmd-str (concat ξprog-name " \""   ξfname "\""))

		(cond
		 ((string-equal ξfSuffix "el") (load ξfname))
		 ((string-equal ξfSuffix "java")
		  (progn
			(shell-command ξcmd-str "*xah-run-current-file output*" )
			(shell-command
			 (format "java %s" (file-name-sans-extension (file-name-nondirectory ξfname))))))
		 (t (if ξprog-name
				(progn
				  (message "Running…")
				  (shell-command ξcmd-str "*xah-run-current-file output*" ))
			  (message "No recognized program file suffix for this file."))))))
		  

		  
		  
;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-delay 0.3)
 '(blink-cursor-mode t)
 '(comint-completion-addsuffix t)
 '(comint-completion-autolist t)
 '(comint-input-ignoredups t)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(comint-scroll-to-bottom-on-output t)
 '(cursor-type (quote (hbar . 4)))
 '(custom-enabled-themes (quote (whiteboard)))
 '(custom-safe-themes
   (quote
    ("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(hybrid-mode t)
 '(line-spacing 0.2)
 '(package-selected-packages
   (quote
    (s powerline hydra spinner parent-mode projectile pkg-info epl flx smartparens iedit anzu highlight pos-tip company yasnippet packed dash helm avy helm-core async auto-complete popup package-build bind-key bind-map evil cygwin-mount persp-mode ws-butler window-numbering which-key volatile-highlights vi-tilde-fringe use-package spacemacs-theme spaceline solarized-theme smooth-scrolling restart-emacs rainbow-delimiters quelpa popwin pcre2el paradox page-break-lines open-junk-file neotree move-text macrostep lorem-ipsum linum-relative leuven-theme info+ indent-guide ido-vertical-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-company helm-c-yasnippet helm-ag google-translate golden-ratio flx-ido fill-column-indicator fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-args evil-anzu eval-sexp-fu elisp-slime-nav define-word company-statistics company-quickhelp clean-aindent-mode buffer-move bracketed-paste auto-yasnippet auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
'(mode-line ((t (:background "SpringGreen4" :foreground "#ffffff" :box (:line-width 1 :color "#5d4d7a"))))))
