(provide 'ni-theme-wombat)
(require 'ni-base)

;;;======================================================================
;;; Color theme - Based on Wombat from Emacs 24
;;;======================================================================
(if t (NotBatchMode
 (agl-begin-time-block "Color themes")

 (custom-set-faces
  '(default ((((class color)) (:background "#242424" :foreground "#f6f3e8"))))
  '(cursor ((((class color)) (:background "#656565"))))

  ;; Highlighting faces
  '(fringe ((((class color)) (:background "#303030"))))
  '(highlight ((((class color)) (:background "#454545" :foreground "#ffffff"
                                             :underline t))))
  '(region ((((class color)) (:background "#444444" :foreground "#f6f3e8"))))
  '(secondary-selection ((((class color)) (:background "#333366" :foreground "#f6f3e8"))))
  '(isearch ((((class color)) (:background "#343434" :foreground "#857b6f"))))
  '(lazy-highlight ((((class color)) (:background "#384048" :foreground "#a0a8b0"))))

  ;; Mode line faces
  '(mode-line ((((class color)) (:background "#444444" :foreground "#f6f3e8"))))
  '(mode-line-inactive ((((class color)) (:background "#444444" :foreground "#857b6f"))))

  ;; Escape and prompt faces
  '(minibuffer-prompt ((((class color)) (:foreground "#e5786d"))))
  '(escape-glyph ((((class color)) (:foreground "#ddaa6f" :weight bold))))

  ;; Font lock faces
  '(font-lock-builtin-face ((((class color)) (:foreground "#e5786d"))))
  '(font-lock-comment-face ((((class color)) (:foreground "#99968b"))))
  '(font-lock-constant-face ((((class color)) (:foreground "#e5786d"))))
  '(font-lock-function-name-face ((((class color)) (:foreground "#cae682"))))
  '(font-lock-keyword-face ((((class color)) (:foreground "#8ac6f2" :weight bold))))
  '(font-lock-string-face ((((class color)) (:foreground "#95e454"))))
  '(font-lock-type-face ((((class color)) (:foreground "#92a65e" :weight bold))))
  '(font-lock-variable-name-face ((((class color)) (:foreground "#cae682"))))
  '(font-lock-warning-face ((((class color)) (:foreground "#ccaa8f"))))

  ;; Button and link faces
  '(link ((((class color)) (:foreground "#8ac6f2" :underline t))))
  '(link-visited ((((class color)) (:foreground "#e5786d" :underline t))))
  '(button ((((class color)) (:background "#333333" :foreground "#f6f3e8"))))
  '(header-line ((((class color)) (:background "#303030" :foreground "#e7f6da"))))

  ;; Gnus faces
  '(gnus-group-news-1 ((((class color)) (:weight bold :foreground "#95e454"))))
  '(gnus-group-news-1-low ((((class color)) (:foreground "#95e454"))))
  '(gnus-group-news-2 ((((class color)) (:weight bold :foreground "#cae682"))))
  '(gnus-group-news-2-low ((((class color)) (:foreground "#cae682"))))
  '(gnus-group-news-3 ((((class color)) (:weight bold :foreground "#ccaa8f"))))
  '(gnus-group-news-3-low ((((class color)) (:foreground "#ccaa8f"))))
  '(gnus-group-news-4 ((((class color)) (:weight bold :foreground "#99968b"))))
  '(gnus-group-news-4-low ((((class color)) (:foreground "#99968b"))))
  '(gnus-group-news-5 ((((class color)) (:weight bold :foreground "#cae682"))))
  '(gnus-group-news-5-low ((((class color)) (:foreground "#cae682"))))
  '(gnus-group-news-low ((((class color)) (:foreground "#99968b"))))
  '(gnus-group-mail-1 ((((class color)) (:weight bold :foreground "#95e454"))))
  '(gnus-group-mail-1-low ((((class color)) (:foreground "#95e454"))))
  '(gnus-group-mail-2 ((((class color)) (:weight bold :foreground "#cae682"))))
  '(gnus-group-mail-2-low ((((class color)) (:foreground "#cae682"))))
  '(gnus-group-mail-3 ((((class color)) (:weight bold :foreground "#ccaa8f"))))
  '(gnus-group-mail-3-low ((((class color)) (:foreground "#ccaa8f"))))
  '(gnus-group-mail-low ((((class color)) (:foreground "#99968b"))))
  '(gnus-header-content ((((class color)) (:foreground "#8ac6f2"))))
  '(gnus-header-from ((((class color)) (:weight bold :foreground "#95e454"))))
  '(gnus-header-subject ((((class color)) (:foreground "#cae682"))))
  '(gnus-header-name ((((class color)) (:foreground "#8ac6f2"))))
  '(gnus-header-newsgroups ((((class color)) (:foreground "#cae682"))))

  ;; Message faces
  '(message-header-name ((((class color)) (:foreground "#8ac6f2" :weight bold))))
  '(message-header-cc ((((class color)) (:foreground "#95e454"))))
  '(message-header-other ((((class color)) (:foreground "#95e454"))))
  '(message-header-subject ((((class color)) (:foreground "#cae682"))))
  '(message-header-to ((((class color)) (:foreground "#cae682"))))
  '(message-cited-text ((((class color)) (:foreground "#99968b"))))
  '(message-separator ((((class color)) (:foreground "#e5786d" :weight bold))))

  ;; Flymake
  '(flymake-errline ((((class color)) (:underline "red"))))
  '(flymake-warnline ((((class color)) (:underline "yellow"))))

  ;; Shell
  '(comint-highlight-input ((t (:bold t))))
  '(comint-highlight-prompt ((t (:foreground "pale violet red"))))

  ;; Rainbow colors
  ;; '(rainbow-delimiters-depth-1-face ((t (:foreground "dark red"))))
  ;; '(rainbow-delimiters-depth-2-face ((t (:foreground "dark green"))))
  ;; '(rainbow-delimiters-depth-3-face ((t (:foreground "deep pink"))))
  ;; '(rainbow-delimiters-depth-4-face ((t (:foreground "yellow"))))
  ;; '(rainbow-delimiters-depth-5-face ((t (:foreground "green"))))
  ;; '(rainbow-delimiters-depth-6-face ((t (:foreground "light blue"))))
  ;; '(rainbow-delimiters-depth-7-face ((t (:foreground "orange"))))
  ;; '(rainbow-delimiters-depth-8-face ((t (:foreground "slate blue"))))
  ;; '(rainbow-delimiters-depth-9-face ((t (:foreground "light gray"))))
  ;; '(rainbow-delimiters-unmatched-face ((t (:foreground "white"))))

  '(rainbow-delimiters-depth-1-face ((t (:foreground "dark gray"))))
  '(rainbow-delimiters-depth-2-face ((t (:foreground "green"))))
  '(rainbow-delimiters-depth-3-face ((t (:foreground "gold"))))
  '(rainbow-delimiters-depth-4-face ((t (:foreground "turquoise"))))
  '(rainbow-delimiters-depth-5-face ((t (:foreground "orange"))))
  '(rainbow-delimiters-depth-6-face ((t (:foreground "slate blue"))))
  '(rainbow-delimiters-depth-7-face ((t (:foreground "yellow"))))
  '(rainbow-delimiters-depth-8-face ((t (:foreground "light blue"))))
  '(rainbow-delimiters-depth-9-face ((t (:foreground "#7f7f7f"))))
  '(rainbow-delimiters-unmatched-face ((t (:foreground "white"))))

  )
 )
)