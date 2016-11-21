C-c C-l : link
|a|b| <tab>
reorder using M-up/down

C-c C-e export
source code
<s tab python
C-c ' to edit in corresponding mode
C-c C-c evaluate the above

TODO abcabc M-S-RET

C-c C-t : cycle thru states
C-d : deadline

C-c |
M-left/right : moves column
M_S-left/right : add col
S-left/right : modifies date

check fiplr
markdown mode for scratch

popular configs
; (good, has many compilation tricks) https://snarfed.org/dotfiles/.emacs
https://github.com/mcandre/dotfiles/blob/master/.emacs


==
tutorials
C-c C-d : goto current wd in the current shell

C-c p f : projectile find
C-x n n

    Narrow down to between point and mark (narrow-to-region). 
C-x n w

    Widen to make the entire buffer accessible again (widen). 
C-x n p

    Narrow down to the current page (narrow-to-page). 
C-x n d

    Narrow down to the current defun (narrow-to-defun). 
	
	M-x diff-buffer-with-file
	C-i = tab in many
C-x C-j open in dired
SPC w b to return focus to the minibuffer.
in ido mode:
C-j previews the file
C-f quit ido to normal mode
C-x C-b ; d deletes
aggresive indent mode

(key-chord-define-global "jj" 'avy-goto-word-1)
(key-chord-define-global "jl" 'avy-goto-line)
(key-chord-define-global "jk" 'avy-goto-char)
(key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
(key-chord-define-global "uu" 'undo-tree-visualize)
(key-chord-define-global "xx" 'execute-extended-command)
(key-chord-define-global "yy" 'browse-kill-ring)

(defvar key-chord-tips '("Press <jj> quickly to jump to the beginning of a visible word."
                         "Press <jl> quickly to jump to a visible line."
                         "Press <jk> quickly to jump to a visible character."
                         "Press <JJ> quickly to switch to previous buffer."
                         "Press <uu> quickly to visualize the undo tree."
                         "Press <xx> quickly to execute extended command."
                         "Press <yy> quickly to browse the kill ring."))



; ===

;; use org-bullets-mode for utf8 symbols as org bullets
(load-file "C:\\Users\\cibin\\AppData\\Roaming\\.emacs.d\\lisp\\org-bullets.el")
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-face-name (quote org-bullet-face))

(setq org-bullets-bullet-list '(;;; Large
    "◉"
    "○"
    "✸"
    "✿"
    ;; ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
    ;;; Small
    ;; ► • ★ ▸
    ))
	

M-p/n send ^+up/down in n++


(switch-to-buffer qrencode-buffer-name)











	 ; computer specific loading of configuration  https://github.com/hjz/emacs/blob/master/init.el
verrrrry goooood http://sachachua.com/blog/2009/01/emacs-file-cak�e-and-ido/
http://www.draketo.de/light/english/emacs/babcore
goto chg

http://www.draketo.de/light/english/emacs/babcore
3.13 Basic key chords

https://www.emacswiki.org/emacs/FileNameCache
https://www.emacswiki.org/emacs/OpenNextLine
https://github.com/hjz/emacs/blob/master/config/filecache.el
==

	
(defun cbn_search () 
(interactive)  
    (setq mylist (list "red" "blue" "yellow" "clear" "i-dont-know"))
  (ido-completing-read "What, ... is your favorite color? " mylist) 
)





; https://www.emacswiki.org/emacs/InteractivelyDoThings
(defun my-ido-project-files ()
      "Use ido to select a file from the project."
      (interactive)
      (let (my-project-root project-files tbl)
      ; (unless project-details (project-root-fetch))
      ; (setq my-project-root (cdr project-details))
      (setq my-project-root "C:/cbn_gits/AHK")

      ;; get project files
      (setq project-files 
	    (split-string 
	     (shell-command-to-string 
	      (concat "lfind "
		      my-project-root
		      ; " \\( -name \"*.svn\" -o -name \"*.git\" \\) -prune -o -type f -print | grep -E  \"\.(ahk)$\""
		      " \\( -name \"*.*\"  \\) -prune -o -type f -print"
		      )) "\n"))
      ;; populate hash table (display repr => path)
      (setq tbl (make-hash-table :test 'equal))
      (let (ido-list)
      (mapc (lambda (path)

	      ;; format path for display in ido list
	      (setq key (replace-regexp-in-string "\\(.*?\\)\\([^/]+?\\)$" "\\2|\\1" path))
	      ;; strip project root
	      (setq key (replace-regexp-in-string my-project-root "" key))
	      ;; remove trailing | or /
	      (setq key (replace-regexp-in-string "\\(|\\|/\\)$" "" key))
	      (puthash key path tbl)
	      (push key ido-list)
	      )
	    project-files
	    )
      (find-file (gethash (ido-completing-read "project-files: " ido-list) tbl)))))

    ;; bind to a key for quick access
    (define-key global-map [f6] 'my-ido-project-files)

=
example of ido read
(defun crux-recentf-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (completing-read "Choose recent file: "
                               (mapcar #'abbreviate-file-name recentf-list)
                               nil t)))
    (when file
(find-file file))))
	
	====
	
	
	
to do:
smart got to line end  ; go to end or go to the last 
link a hotkey for crux funtions added .spacemacs
sort files on mtime https://www.emacswiki.org/emacs/InteractivelyDoThings
get from prelude:
C-x O 	Go back to previous window (the inverse of other-window (C-x o)).
C-c k 	Kill all open buffers except the one you're currently in.
C-c d 	Duplicate the current line (or region).
=====
to do: in #2:: make run emacs shell here as the first option
emacs --eval (shell)
configure avy; avy is a GNU Emacs package for jumping to visible text using a char-
(defvar find-file-root-dir "~/"
  "Directory from which to start all find-file's")
(defun find-file-in-root  �
  "Make find-file always start at some root directory."
  (interactive)
  (let ((default-directory find-file-root-dir))
    (call-interactively 'find-file)))
(global-set-key (kbd "C-x C-f") 'find-file-in-root!�

	https://www.emacswiki.org/emacs/EndOfLineTips

hotkeys.ahk::printscreen::saved to default- di{�lay path also

C-x r N = rectangle number lines
show length of selection in modeline


============DONE=============
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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

;; Fast line numbers
(use-package nlinum
  :config
  ;; Line number gutter in ncurses mode
  (unless window-system
    (setq nlinum-format "%d "))
  ;; :idle
  (global-nlinum-mode))

(setq enablmÍrecursive-minibuffers t) ;; allow recursive editing in minibuffer
(resize-minibuffer-mode 1)            ;; minibuffer gets resized if it becomes too big
(follow-mode t)                       ;; follow-mode allowP easier editing of long files

(global-set-key [f5]          '(lambda () (interactive) (kill-buffer (current-buffer))))

; to have the name of the file as the name of the window:
(setq frame-title-format '(buffer-file-name "Emacs: %b (%f)" "Emacs: %b"))

; ======
; extra major modes!
(require 'markdown-mode)

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

 
 
(defun rename-this-file (new-file-name)
  "Renames this file and switches the buffer to point to the new file."
  (interactive "FRename to: ")
  (let ((orig-buffer (current-buffer)))
    (rename-file buffer-file-name new-file-name)
    (find-file new-file-name)
    (kill-buffer orig-buffer)))

(global-set-key [(control x) (control r)] 'rename-this-file)

; color themes, deftheme style (added in emacs 24).
(load-theme 'manoj-dark)

 