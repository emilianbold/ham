(provide 'ni-treemacs)

(GNUEmacsMin25

(add-to-list 'load-path (concat ENV_DEVENV_EMACS_SCRIPTS "/treemacs"))
(require 'treemacs)
(require 'treemacs-projectile)
(require 'cfrs)

(setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
      treemacs-deferred-git-apply-delay        0.5
      treemacs-directory-name-transformer      #'identity
      treemacs-display-in-side-window          t
      treemacs-eldoc-display                   t
      treemacs-file-event-delay                5000
      treemacs-file-extension-regex            treemacs-last-period-regex-value
      treemacs-file-follow-delay               0.2
      treemacs-file-name-transformer           #'identity
      treemacs-follow-after-init               t
      treemacs-expand-after-init               t
      treemacs-git-command-pipe                ""
      treemacs-goto-tag-strategy               'refetch-index
      treemacs-indentation                     2
      treemacs-indentation-string              " "
      treemacs-is-never-other-window           nil
      treemacs-max-git-entries                 5000
      treemacs-missing-project-action          'ask
      treemacs-move-forward-on-expand          nil
      treemacs-no-png-images                   nil
      treemacs-no-delete-other-windows         t
      treemacs-project-follow-cleanup          nil
      treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
      treemacs-position                        'left
      treemacs-read-string-input               'from-child-frame
      treemacs-recenter-distance               0.1
      treemacs-recenter-after-file-follow      nil
      treemacs-recenter-after-tag-follow       nil
      treemacs-recenter-after-project-jump     'always
      treemacs-recenter-after-project-expand   'on-distance
      treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
      treemacs-show-cursor                     nil
      treemacs-show-hidden-files               t
      treemacs-silent-filewatch                nil
      treemacs-silent-refresh                  nil
      treemacs-sorting                         'alphabetic-asc
      treemacs-select-when-already-in-treemacs 'move-back
      treemacs-space-between-root-nodes        t
      treemacs-tag-follow-cleanup              t
      treemacs-tag-follow-delay                1.5
      treemacs-text-scale                      nil
      treemacs-user-mode-line-format           nil
      treemacs-user-header-line-format         nil
      treemacs-width                           35
      treemacs-width-is-initially-locked       nil
      treemacs-workspace-switch-cleanup        nil)

;; We have to use follow mode unfortunately, without it the tree jumps
;; "randomly" at times which is absurdly annoying.
(treemacs-follow-mode t)

(defun ni-treemacs-find-file () ""
       (interactive)
       (treemacs-find-file)
       (treemacs-select-window))

;; You might need to run `M-x all-the-icons-install-fonts` and restart emacs
;; for the font icons to be setup properly.
(IsNotTerminal
 (require 'all-the-icons)
 (require 'treemacs-all-the-icons)
 (treemacs-load-theme "all-the-icons"))

)
