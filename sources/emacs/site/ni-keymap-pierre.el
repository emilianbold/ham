(provide 'ni-keymap-pierre)
(NotBatchMode

;;;======================================================================
;;; aglemacs.el
;;;======================================================================
 ;; Disable electric mode so that 'enter' insert a new line without modifying
 ;; the current line but indents the actual new line.
 (when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
 (global-set-key (kbd "RET") 'electric-newline-and-maybe-indent)
 (global-set-key [(control return)] 'agl-newline-and-indent-same-level)

 (OSX
  (global-set-key (kbd "<home>") 'move-beginning-of-line)
  (global-set-key (kbd "<end>") 'move-end-of-line)
  ;; disable Cmd-w & Cmd-q which close emacs and the current frame. In
  ;; particular Cmd-w is a common mistake.
  (global-unset-key (kbd "s-w"))
  (global-unset-key (kbd "s-q"))
 )
 (Aquamacs
  (define-key osx-key-mode-map [home] 'beginning-of-line)
  (define-key osx-key-mode-map [end] 'end-of-line)
  (global-set-key [(control right)] 'forward-word)
  (global-set-key [(control left)] 'backward-word)
 )

 ;; ibuffer
 (global-set-key (key "C-x C-b") 'ibuffer)

 ; Delete without passing by the killring
 (global-set-key (kbd "C-S-k") 'agl-delete-line-backward) ; Ctrl+Shift+k
 (global-set-key (kbd "C-k") 'agl-delete-line)
 (global-set-key (kbd "M-d") 'agl-delete-word)
 (global-set-key (kbd "<M-backspace>") 'agl-backward-delete-word)
 (global-set-key (kbd "<C-backspace>") 'agl-backward-delete-word)

 ;; isearch - the defaults are _so_ annoying...
 (define-key isearch-mode-map (kbd "<backspace>") 'isearch-del-char) ; bs means bs
 (define-key isearch-mode-map (kbd "<delete>")    'isearch-delete-char)  ; delete means delete

 ;; There's as many variations of 'Meta' as they are stars in the sky...
 (global-set-key [(meta right)] 'forward-word)
 (global-set-key [(meta left)] 'backward-word)
 (global-set-key [(control right)] 'forward-word)
 (global-set-key [(control left)] 'backward-word)
 (global-set-key '[(meta up)] 'backward-paragraph)
 (global-set-key '[(meta down)] 'forward-paragraph)
 (global-set-key '[(control up)] 'backward-paragraph)
 (global-set-key '[(control down)] 'forward-paragraph)
 (global-set-key (key "ESC <up>") 'backward-paragraph)
 (global-set-key (key "ESC <down>") 'forward-paragraph)

 ;; Move to the 'next' window (in clockwise order)
 (global-set-key (key "M-`") 'other-window)
 (global-set-key (kbd "M-o") 'other-window)

 ;; Forward/Backward word under point
 (global-set-key (key "M-p") 'agl-search-word-backward)
 (global-set-key (key "M-n") 'agl-search-word-forward)

 (global-set-key (key "C-h C-r") 'revert-buffer)

 (global-set-key "\C-h\C-w" 'ni-word-wrap-toggle)

 ;; Shell
 (global-set-key "\C-h\C-s" 'ham-shell)
 (global-set-key "\C-h\C-t" 'agl-select-visible-shell-window)
 (global-set-key "\C-h\C-p" 'agl-run-last-shell-command)
 (global-set-key (key "C-h C-0") 'erase-buffer)

 ;; PgUp/Dn
 (global-set-key (kbd "C-v") 'scroll-up-command)
 (global-set-key (kbd "M-v") 'scroll-down-command)

 ;; Scroll one line at a time
 (global-set-key (quote [C-M-down]) (quote scroll-up-line))
 (global-set-key (quote [C-M-up]) (quote scroll-down-line))

 ;; Ctrl +/- increase/decrease font size
 (global-set-key (kbd "C-=") 'agl-increase-font-size)
 (global-set-key (kbd "C--") 'agl-decrease-font-size)

 ;; Goto line
 (global-set-key (key "C-l") 'goto-line-with-feedback)
 ;; Remap recenter-top-bottom (which is mapped to Ctrl-l by default) to Ctrl-Shift-L
 (global-set-key (key "C-S-l") 'recenter-top-bottom)

 ;; remap regex search to Atl-s/r
 (global-set-key "\M-s" 'isearch-forward-regexp)
 (global-set-key "\M-r" 'isearch-backward-regexp)

 ;; Search and replace in the current buffer
 (global-set-key "\C-h\C-h" 'qrr)

 ;; extended expand
 (global-set-key [(meta /)] (make-agl-expand))

 ;; shift-down comments the current line and goes down
 (define-key global-map [(shift down)] 'agl-comment-and-go-down)
 (define-key global-map (kbd "M-+") 'agl-comment-and-go-down)
 ;; shift-up uncomments the current line and goes up
 (define-key global-map [(shift up)] 'agl-uncomment-and-go-up)
 (define-key global-map (kbd "M-_") 'agl-uncomment-and-go-up)
 ;; inc number under cursor
 (define-key global-map (kbd "M-=") 'agl-increment-number-at-point)
 ;; dec number under cursor
 (define-key global-map (kbd "M--") 'agl-decrement-number-at-point)
 ;; UUID generation
 (global-set-key (kbd "C-M-g")   'agl-uuid1-to-buffer)
 (global-set-key (kbd "C-M-S-g") 'agl-uuid2-to-buffer)
 (global-set-key (kbd "M-G")     'agl-uuid3-to-buffer)

 ;; Begin/end of buffer
 (define-key global-map "\C-h\C-a" 'beginning-of-buffer)
 (define-key global-map "\C-h\C-e" 'end-of-buffer)

 (global-set-key (kbd "C-M-j") 'join-line)

 (global-set-key (key "M-5") 'ni-goto-matching-bracket)

;;;======================================================================
;;; aglemacs.el: mark-multiple, expand-region
;;;======================================================================
 (GNUEmacs24
  ;; Emacs 25+ already does inline rectangle replace
  (require 'inline-string-rectangle)
  (global-set-key (kbd "C-x r t") 'inline-string-rectangle))

 (global-set-key (kbd "M-9") 'mark-previous-like-this) ;; M-(
 (global-set-key (kbd "M-0") 'mark-next-like-this) ;; M-(
 (global-set-key (kbd "M-8") 'mark-all-like-this) ;; M-8

 (require 'expand-region)
 (global-set-key (kbd "M-@") 'er/expand-region) ;; M-S-2

;;;======================================================================
;;; ni-flymake.el
;;;======================================================================
 (global-set-key (kbd "M-3") 'aflymake-goto-next-error)
 (global-set-key (kbd "M-4") 'aflymake-goto-prev-error)
 (global-set-key (kbd "C-h C-c") 'aflymake-mode-or-syntax-check)
 (global-set-key (kbd "C-h C-f") 'ham-fix-current-buffer)

;;;======================================================================
;;; ni-org.el
;;;======================================================================
 (if (boundp 'org-store-link)
     (progn
       (global-set-key "\C-cl" 'org-store-link)
       (global-set-key "\C-ca" 'org-agenda)
     ))

;;;======================================================================
;;; ni-file-cache.el / projects / window navigation
;;;======================================================================

 ;;;; Open cached file
 (global-set-key (key "C-x C-f") 'ni-file-cache-find-file)
 (global-set-key (key "C-x f") 'ni-file-cache-find-file-at-point)

 ;;;; Fuzzy search
 ;; open file in project
 (global-set-key (kbd "C-x C-p") 'fzf-projectile)
 ;; open file in a directory
 (global-set-key (kbd "C-x p") 'fzf-directory)

 ;; go to file tree window
 (global-set-key (kbd "C-h C-d") 'direx:jump-to-project-file-other-window)
 (global-set-key (kbd "C-h d") 'direx:jump-to-project-file)

 ;;;; Swiper / Isearch
 ;; swiper isearch
 (global-set-key (kbd "C-s") 'ni-swiper-isearch)
 ;; emacs' isearch
 (global-set-key (kbd "C-S-s") 'isearch-forward)
 ;; swiper at point
 (global-set-key (kbd "C-;") 'swiper-thing-at-point)

;;;======================================================================
;;; ni-user-pierre.el
;;;======================================================================

 ;; Ask for compile command and then compile
 (global-set-key (key "C-h C-n") 'compile)
 ;; Save all then compile with the last compile command used
 (global-set-key (key "C-h C-b") 'save-all-and-compile)

 ;; Previous/Next errors
 (define-key global-map "\M-1" 'next-error)
 (define-key global-map "\M-2" 'previous-error)

 ;; Disabled the insert key, remap it to control + insert.
 (define-key global-map [(insert)] nil)
 (define-key global-map (key "C-o") 'overwrite-mode)

 ;; Map the Escape key to "actually stop whatever NOW" or "please don't screw
 ;; up my environment randomly...".
 ;;
 ;; Without this you're going to have a bad time mmk...
 ;;
 (define-key global-map [escape] 'keyboard-quit)
 (global-set-key [escape] 'keyboard-quit)

 (global-set-key [remap keyboard-quit] 'keyboard-escape-quit)

 (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

 (global-set-key "\C-h\C-k" 'ham-grep-regexp-search-dir)
 (global-set-key "\C-h\C-j" 'ham-grep-regexp-current-dir)
 (global-set-key "\C-h\C-y" 'ham-grep-work-regexp)
 (global-set-key "\C-h\C-g" 'occur)

 (define-key global-map "\C-h\C-\\" 'indent-region)

 (global-dumb-jump-mode 1)

 )
