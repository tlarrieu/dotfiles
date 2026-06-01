; extends

(literal_value
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(literal_value
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)
