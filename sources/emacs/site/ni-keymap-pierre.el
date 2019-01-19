(provide 'ni-keymap-pierre)
(NotBatchMode

;;;======================================================================
;;; aglemacs.el
;;;======================================================================
 (GNUEmacs23
  (global-set-key (kbd "RET") 'newline-and-indent)
  (global-set-key (kbd "<S-return>") 'newline)
  (OSX
   (global-set-key (kbd "<kp-delete>") 'delete-char)
  )
 )

 (GNUEmacs24
  ;; Disable electric mode so that 'enter' insert a new line without modifying
  ;; the current line but indents the actual new line.
  (when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
  (global-set-key (kbd "RET") 'electric-newline-and-maybe-indent)
  (global-set-key (kbd "<C-j>") 'newline)
 )

 (OSX
  (global-set-key (kbd "<home>") 'move-beginning-of-line)
  (global-set-key (kbd "<end>") 'move-end-of-line)
 )
 (Aquamacs
  (define-key osx-key-mode-map [home] 'beginning-of-line)
  (define-key osx-key-mode-map [end] 'end-of-line)
  (global-set-key [(control right)] 'forward-word)
  (global-set-key [(control left)] 'backward-word)
 )

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
 (global-set-key (key "M-1") 'other-window)

 ;; Forward/Backward word under point
 (global-set-key (key "M-p") 'agl-search-word-backward)
 (global-set-key (key "M-n") 'agl-search-word-forward)

 (global-set-key (key "C-h C-r") 'revert-buffer)

 (global-set-key "\C-h\C-w" 'ni-word-wrap-toggle)

 ;; Shell
 (global-set-key "\C-h\C-s" 'ham-shell)
 (global-set-key "\C-h\C-t" 'agl-select-visible-shell-window)
 (global-set-key "\C-h\C-p" 'agl-run-last-shell-command)

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
 (global-set-key "\C-h\C-l" 'goto-line)

 ;; remap regex search to Atl-s/r
 (global-set-key "\M-s" 'isearch-forward-regexp)
 (global-set-key "\M-r" 'isearch-backward-regexp)

 (global-set-key "\C-h\C-h" 'qrr)

 ;; extended expand
 (global-set-key [(meta /)] (make-agl-expand))

 ;; Previous/Next errors
 (define-key global-map "\M-2" 'previous-error)
 (define-key global-map "\M-3" 'next-error)

 ;; shift-down comments the current line and goes down
 (define-key global-map [(shift down)] 'agl-comment-and-go-down)
 ;; shift-up uncomments the current line and goes up
 (define-key global-map [(shift up)] 'agl-uncomment-and-go-up)
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

 (global-set-key (kbd "M-j") 'macro-join-line)

 (require 'golden-ratio-scroll-screen)
 (global-set-key (key "M-'") 'golden-ratio-scroll-screen-up)
 (global-set-key (key "M-;") 'golden-ratio-scroll-screen-down)
 (global-set-key (key "M-.") 'ni-goto-matching-bracket)
 (global-set-key (kbd "M->") 'ni-backward-left-bracket)
 (global-set-key (kbd "M-<") 'ni-forward-right-bracket)

;;;======================================================================
;;; aglemacs.el: mark-multiple, expand-region
;;;======================================================================
 (GNUEmacs24
  ;; Emacs 25+ already does inline rectangle replace
  (require 'inline-string-rectangle)
  (global-set-key (kbd "C-x r t") 'inline-string-rectangle))

 (global-set-key (kbd "C-<") 'mark-previous-like-this)
 (global-set-key (kbd "M-9") 'mark-previous-like-this) ;; M-(
 (global-set-key (kbd "C->") 'mark-next-like-this)
 (global-set-key (kbd "M-0") 'mark-next-like-this) ;; M-(
 (global-set-key (kbd "C-*") 'mark-all-like-this)
 (global-set-key (kbd "M-8") 'mark-all-like-this) ;; M-8

;;;======================================================================
;;; ni-autocomplete-company.el
;;;======================================================================
 (if (boundp 'company-ni-idl-complete)
     (progn
       ;; (global-set-key (kbd "C-/") 'company-complete-common)
       (global-set-key (kbd "C-/") 'company-ni-idl-complete)
     ))

;;;======================================================================
;;; ni-flymake.el
;;;======================================================================
 (global-set-key (kbd "M-4") 'aflymake-goto-prev-error)
 (global-set-key (kbd "M-5") 'aflymake-goto-next-error)
 (global-set-key (kbd "C-h C-c") 'aflymake-mode-or-syntax-check)

;;;======================================================================
;;; ni-autocomplete-pabbrev.el
;;;======================================================================
 (if (boundp 'make-agl-expand)
     (progn
       (global-set-key (kbd "C-/") 'make-agl-expand)
     ))

;;;======================================================================
;;; ni-org.el
;;;======================================================================
 (if (boundp 'org-store-link)
     (progn
       (global-set-key "\C-cl" 'org-store-link)
       (global-set-key "\C-ca" 'org-agenda)
     ))

;;;======================================================================
;;; ni-file-cache.el
;;;======================================================================

 ;; C-xC-f repmapped to ni-ffap, which opens the file at point be default, if
 ;; not found calls the default open file
 (global-set-key (key "C-x C-f") 'jcl-file-cache-ido-find-file)
 (define-key global-map (kbd "C-S-r") 'file-cache-ido-find-file)
 (define-key global-map (kbd "C-S-M-r") 'file-cache-update-my-cache)

;;;======================================================================
;;; ni-user-pierre.el
;;;======================================================================
 (global-set-key [f5] 'save-all-and-compile)
 (global-set-key [(control f5)] 'compile)
 (global-set-key [f6] 'previous-error)
 (global-set-key [f7] 'next-error)

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

 (global-set-key "\C-h\C-j" 'pt-regexp-search-dir)
 (global-set-key "\C-h\C-k" 'pt-regexp-current-dir)
 (global-set-key "\C-h\C-u" 'ni-vcs-grep-search-dir)
 (global-set-key "\C-h\C-i" 'ni-vcs-grep-current-dir)
 (global-set-key "\C-h\C-y" 'pt-work-regexp)
 (global-set-key "\C-h\C-g" 'occur)

 ;; Ctrl-l goto line, more convenient than C-c C-g...
 (global-set-key (key "C-l") 'goto-line)
 ;; Remap recenter-top-bottom (which is mapped to Ctrl-l by default) to Ctrl-Shift-L
 (global-set-key (key "C-S-l") 'recenter-top-bottom)

 (define-key global-map "\C-h\C-i" 'my-indent-buffer)

 (define-key global-map "\C-h\C-d" 'direx:jump-to-directory)

;;;======================================================================
;;; java-imports
;;;======================================================================
 (define-key java-mode-map (kbd "M-i") 'java-imports-add-import-dwim)

)
