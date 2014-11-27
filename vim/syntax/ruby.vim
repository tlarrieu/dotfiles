function! SignifyMatch(type_name, new_type, pattern, glyph)
    " Conceal feature required to continue (vim ≥ 7.3)
    if !has('conceal')
        finish
    endif

    " Conceal 'function' with a glyph
    execute "syntax match " a:new_type a:pattern " conceal cchar=" . a:glyph

    " Link up syntax
    execute "hi link" a:new_type a:type_name
    execute "hi! link Conceal " a:type_name

    setlocal conceallevel=2
    setlocal concealcursor=c
endf

" call SignifyMatch("rubyKeyword", "rubyLambdaKeyword", "lambda", "λ")
" call SignifyMatch("rubyKeyword", "rubyLambdaKeyword", "proc", "λ")
" call SignifyMatch("rubyKeyword", "rubyDoKeyword", "do", "δ")
call SignifyMatch("rubyOperator", "rubyLambdaOperator", "\"->\"", "→")
call SignifyMatch("rubyOperator", "rubyHashRocketOperator", "\"=>\"", "⇒")
call SignifyMatch("rubyOperator", "rubySpaceShipOperator", "\"<=>\"", "⇔")
call SignifyMatch("rubyOperator", "rubyDifferentOperator", "\"!=\"", "≠")

" syntax keyword Operator lambda conceal cchar=λ
" syntax keyword Operator proc conceal cchar=λ
" syntax keyword Operator do conceal cchar=※
