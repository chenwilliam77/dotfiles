;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BASIC EDITING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; User details
(setq user-full-name "William Chen")
(setq user-mail-address "wyc1@williams.edu")

;; Tabs
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)

;; Don't prompt when opening a symlink
(setq vc-follow-symlinks nil)

;; Default to unified diffs
(setq diff-switches "-u")

;; Mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

;; Load custom modes, e.g. Julia mode
(load "~/dotfiles/julia-mode.el")

;; Move backup files to central location
(setq backup-directory-alist
      `((".*" . , "~/.emacs.d/backup/")))
(setq auto-save-file-name-transforms
      `((".*" , "~/.emacs.d/backup/" t)))
(setq auto-save-list-file-prefix nil)

;; Set default max line width to 80 characters
(setq-default fill-column 80)

;; Unbind C-o (insertline, but I use C-o as my tmux prefix)
(global-unset-key (kbd "C-o"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ADVANCED EDITING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Increment and decrement numbers
(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))
(defun my-decrement-number-decimal (&optional arg)
  (interactive "p*")
  (my-increment-number-decimal (if arg (- arg) -1)))
(global-set-key (kbd "C-c =") 'my-increment-number-decimal)
(global-set-key (kbd "C-c -") 'my-decrement-number-decimal)

;; Delete trailing whitespace upon saving
;; Toggle auto-deleting with C-c w (useful for editing hunks in git add --patch)
(defvar my-inhibit-dtw nil)
(defun my-delete-trailing-whitespace ()
  (unless my-inhibit-dtw (delete-trailing-whitespace)))
(add-hook 'before-save-hook 'my-delete-trailing-whitespace)
(defun my-inhibit-dtw ()
  (interactive)
  (set (make-local-variable 'my-inhibit-dtw) (not my-inhibit-dtw))
  (message "Toggled deleting trailing whitespace in this buffer"))
(global-set-key (kbd "C-c w") 'my-inhibit-dtw)

;; Turn many spaces into just one space in a highlighted region
(defun just-one-space-in-region (beg end)
  "replace all whitespace in the region with single spaces"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (re-search-forward "\\s-+" nil t)
        (replace-match " ")))))
(global-set-key (kbd "C-x SPC") 'just-one-space-in-region)

;; Delete file and buffer
;; http://emacsredux.com/blog/2013/04/03/delete-file-and-buffer/
(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (if (yes-or-no-p "Really delete file and kill buffer? ")
            (progn
              (delete-file filename)
              (message "Deleted file %s" filename)
              (kill-buffer))
          (progn
            message "Did not delete file %s" filename))))))
(global-set-key (kbd "C-c D")  'delete-file-and-buffer)

;; Rename file and buffer
;; http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
(global-set-key (kbd "C-c R")  'rename-file-and-buffer)

;; Replace string
(global-set-key (kbd "C-c %") 'replace-string)

;; Octave mode for Matlab
(setq auto-mode-alist
      (cons
       '("\\.m$" . octave-mode)
       auto-mode-alist))
(add-hook 'octave-mode-hook (lambda ()
  (setq indent-tabs-mode t)
  (setq tab-stop-list (number-sequence 2 200 2))
  (setq tab-width 4)
  (setq indent-line-function 'insert-tab) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DISPLAY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable visual feedback on selections
(setq transient-mark-mode t)

;; Row and column numbers
(setq column-number-mode t)

;; Line numbers
(global-linum-mode t)
(setq linum-format "%4d ")
(global-set-key (kbd "C-x l") 'linum-mode) ; toggle linum-mode for tmux copy-paste

;; Unique buffer names, e.g. filename<dir1> and filename<dir2>
(require 'uniquify)
(setq uniquify-buffer-name-style (quote post-forward-angle-brackets))

;; Highlight matching and mismatched parentheses
(show-paren-mode t)
(setq show-paren-delay 0)

;; Highlight trailing whitespace
(setq-default show-trailing-whitespace t)

;; Colors
(set-face-attribute 'region nil :inverse-video t)
(set-face-foreground 'linum "brightblack")
(set-face-foreground 'minibuffer-prompt "brightblue")
(set-face-foreground font-lock-builtin-face "brightmagenta")
(set-face-foreground font-lock-comment-face "green")
(set-face-foreground font-lock-constant-face "brightcyan")
(set-face-foreground font-lock-function-name-face "blue")
(set-face-foreground font-lock-keyword-face "brightblue")
(set-face-foreground font-lock-string-face "brightred")
(set-face-foreground font-lock-type-face "brightcyan")
(set-face-foreground font-lock-variable-name-face "yellow")
(set-face-background 'trailing-whitespace "brightred")
(set-face-background 'show-paren-match "brightblack")
(set-face-background 'show-paren-mismatch "red")

;; Custom variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (manoj-dark)))
 '(doc-view-continuous t)
 '(inhibit-startup-screen t)
 '(markdown-asymmetric-header t)
 '(markdown-enable-math t)
 '(package-selected-packages (quote (ac-math auto-complete auctex-lua latex-preview-pane auctex-latexmk ## auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-latex-bold-face ((((class color) (background light)) (:inherit bold :foreground "brightred"))) t)
 '(font-latex-italic-face ((((class color) (background light)) (:inherit italic :foreground "brightred"))) t)
 '(font-latex-math-face ((((class color) (background light)) (:foreground "brightyellow"))) t)
 '(font-latex-sectioning-5-face ((((type tty pc) (class color) (background light)) (:foreground "magenta" :weight bold))) t))

;; Allow use of MELPA
;;  (require 'package)
;;  (add-to-list 'package-archives
;; 	         '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode
;; (require 'package)
;; (package-initialize)
;; (require 'auto-complete-config)
;; (ac-config-default)

;; ;; Activate auto-complete for latex modes (AUCTeX or Emacs' builtin one).
;; (add-to-list 'ac-modes 'latex-mode)

;; ;; Activate ac-math.
;; (eval-after-load "latex"
;;   '(when (featurep 'auto-complete)
;;      ;; See https://github.com/vspinu/ac-math
;;      (require 'ac-math)
;;      (defun ac-latex-mode-setup ()       ; add ac-sources to default ac-sources
;;        (setq ac-sources
;;          (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
;;              ac-sources)))
;;      (add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)))

;; Disable autoindent
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
