; extends

(program (comment)* ((statement) @paragraph))
(statement) @sentence.outer @sentence.inner
(subquery) @sentence.inner

(term) @parameter.inner @parameter.outer
(from (relation) @parameter.inner @parameter.outer)
(join) @parameter.inner @parameter.outer
