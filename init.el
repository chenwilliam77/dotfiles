;; Currently, I don't use init.el in my own set up
;; as of Aug. 2021

;; Load auto math complete
(load auto-complete-auctex)

;; Load package for auto math complete
(require 'auto-complete-auctex)

(require 'package)
(package-initialize)
(require 'auto-complete-config)
(ac-config-default)

;; Activate auto-complete for latex modes (AUCTeX or Emacs' builtin one).
(add-to-list 'ac-modes 'latex-mode)

;; Activate ac-math.
(eval-after-load "latex"
  '(when (featurep 'auto-complete)
     ;; See https://github.com/vspinu/ac-math
     (require 'ac-math)
     (defun ac-latex-mode-setup ()       ; add ac-sources to default ac-sources
       (setq ac-sources
         (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
             ac-sources)))
     (add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)))
