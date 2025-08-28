; extends

(branch) @git.branch
((title) @git.title (#eq? @git.title "Changes to be committed:")) @git.title.committed
((title) @git.title (#eq? @git.title "Untracked files:")) @git.title.untracked
(change kind: (deleted)) @git.change.deleted
(change kind: (modified)) @git.change.modified
(change kind: (new)) @git.change.new
