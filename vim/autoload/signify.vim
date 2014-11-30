function! signify#SignifyMatch(type_name, new_type, pattern, glyph)
  " Conceal feature required to continue (vim ≥ 7.3)
  if !has('conceal')
    finish
  endif

  " Conceal 'function' with a glyph
  execute "syntax match " a:new_type a:pattern " conceal cchar=" . a:glyph

  " Link up syntax
  execute "hi link" a:new_type a:type_name
  execute "hi! link Conceal " a:type_name

  setlocal conceallevel=1
  setlocal concealcursor=c
endf

function! signify#SignifyKeyword(type_name, new_type, keyword, glyph)
  " Conceal feature required to continue (vim ≥ 7.3)
  if !has('conceal')
    finish
  endif

  " Conceal 'function' with a glyph
  execute "syntax keyword " a:new_type a:keyword " conceal cchar=" . a:glyph

  " Link up syntax
  execute "hi link" a:new_type a:type_name
  execute "hi! link Conceal " a:type_name

  setlocal conceallevel=1
  setlocal concealcursor=c
endf
