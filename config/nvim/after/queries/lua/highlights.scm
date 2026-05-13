; extends

(break_statement) @keyword.break
(function_call name: (identifier) @keyword.raise (#eq? @keyword.raise "error"))
(function_call name: (identifier) @keyword.raise (#eq? @keyword.raise "assert"))
