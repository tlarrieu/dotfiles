; extends

(branch) @git.branch

((title) @git.title (#eq? @git.title "Changes to be committed:")) @git.title.committed
((title) @git.title (#eq? @git.title "Changes not staged for commit:")) @git.title.not_committed
((title) @git.title (#eq? @git.title "Untracked files:")) @git.title.untracked

(change kind: (deleted)) @git.change.deleted
(generated_comment (change kind: (deleted)) (filepath) @git.change.deleted.filepath)

(change kind: (modified)) @git.change.modified
(generated_comment (change kind: (modified)) (filepath) @git.change.modified.filepath)

(change kind: (new)) @git.change.new
(generated_comment (change kind: (new)) (filepath) @git.change.new.filepath)

(change kind: (renamed)) @git.change.renamed
(generated_comment (change kind: (renamed)) (filepath) @git.change.renamed.filepath)
