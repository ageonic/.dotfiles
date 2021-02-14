;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Aaron George"
      user-mail-address "angeorge.dev@gmail.com")

;; General config
(setq doom-theme 'doom-one
      projectile-project-search-path '("~/Projects/work/" "~/Projects/personal/"))

;; Org-mode config

(defun org-heading-insert-statistic-cookie ()
  (interactive)
  (save-excursion
    (outline-back-to-heading)
    (end-of-line)
    (insert " [/]")))

(defun org-find-task-categories ()
  (org-datetree-find-date-create (calendar-current-date))
  (goto-char (point-at-eol))
  (when (not (re-search-forward "Top 3 Priorities" nil t))
    (insert "\n- ~Top 3 Priorities~\n- ~Non-critical Tasks~\n- ~Todo Checklist~"))
  (goto-char (point-max)))

;; open today's subtree in the plan datetree
(defun org-open-plan ()
  (interactive)
  (find-file "~/Org/plan.org")
  (goto-char (point-max))
  (search-backward (format-time-string "%Y-%m-%d"))
  (org-narrow-to-subtree))

;; open a link to an org file as a narrow subtree
(defun org-open-narrow-link ()
  (interactive)
  (call-interactively #'org-open-at-point)
  (org-narrow-to-subtree))

(after! org
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-directory "~/Org/"
        org-default-notes-file (concat org-directory "/notes.org")
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-checkbox-hierarchical-statistics nil
        org-todo-keywords '((sequence "TODO(t!)" "WAIT(w@)" "PROJ(p!)" "|" "DONE(d!)" "CANC(c@)"))
        org-todo-keyword-faces
        '(("TODO" :foreground "#7c7c75")
          ("WAIT" :foreground "#9f7efe")
          ("PROJ" :foreground "#ffce52")
          ("DONE" :foreground "#50a14f")
          ("CANC" :foreground "#ff6480"))
        org-agenda-custom-commands
        '(("f" "Focus mode"
           ((agenda "")
            (tags-todo "CATEGORY=\"work\"-TODO=\"PROJ\"")
            (tags-todo "CATEGORY=\"personal\"-TODO=\"PROJ\""))
           ((org-agenda-sorting-strategy '(priority-down todo-state-up))))
          ("p" "Projects mode" ((todo "PROJ"))))
        org-capture-templates
          '(("d" "Add current task to daily planner" checkitem (file+function (lambda () (concat org-directory "plan.org")) org-find-task-categories)
             "- [ ] %a\n" :immediate-finish t)
            ("j" "Add an entry to work journal" entry (file (lambda () (concat org-directory "work-journal.org")))
             "* %U %?" :prepend t)
            ("p" "Add a personal todo" entry (file (lambda () (concat org-directory "personal.org")))
             "* TODO %?\n:LOGBOOK:\n- State \"TODO\"       from              %U\n:END:")
            ("w" "Add a work todo" entry (file (lambda () (concat org-directory "work.org")))
             "* TODO %?\n:LOGBOOK:\n- State \"TODO\"       from              %U\n:END:"))))

;; daily planning key bindings
(map! :leader
      (:prefix ("d" . "daily planner")
       :desc "Agenda view" "a" (lambda () (interactive) (org-agenda nil "f"))
       :desc "Org capture" "c" #'org-capture
       :desc "Insert as daily task" "d" (lambda () (interactive) (org-capture nil "d"))
       :desc "Open work-journal" "j" (lambda () (interactive) (find-file "~/Org/work-journal.org"))
       :desc "Insert statistic cookie" "k" #'org-heading-insert-statistic-cookie
       :desc "Open link in narrowed view" "l" #'org-open-narrow-link
       :desc "Open today's plan" "p" #'org-open-plan))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
