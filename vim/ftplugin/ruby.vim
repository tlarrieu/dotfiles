call signify#SignifyMatch("rubyOperator", "rubyGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("rubyOperator", "rubyLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("rubyOperator", "rubyLambdaOperator", "\"->\"", "→")
call signify#SignifyMatch("rubyOperator", "rubyHashRocketOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("rubyOperator", "rubySpaceShipOperator", "\"<=>\"", "⇔")
call signify#SignifyMatch("rubyOperator", "rubyDifferentOperator", "\"!=\"", "≠")
call signify#SignifyMatch("rubyOperator", "rubyTimesOperator", "\" \\zs\\*\\ze \"", "×")
call signify#SignifyMatch("rubyOperator", "rubyOverOperator", "\" \\zs/\\ze \"", "÷")
call signify#SignifyMatch("rubyOperator", "rubyEqualOperator", "\"==\"", "≡")
call signify#SignifyMatch("rubyOperator", "rubyAndOperator", "\"&&\"", "∧")
call signify#SignifyMatch("rubyOperator", "rubyAndOperator", "\"||\"", "∨")
" call signify#SignifyMatch("rubyOperator", "rubyLambdaKeyword", "\"\\zslambda\\ze \"", "λ")
" call signify#SignifyMatch("rubyOperator", "rubyProcKeyword", "\"\\zsproc\\ze \"", "π")

" call signify#SignifyKeyword("rubyKeyword", "rubyLambdaKeyword", "lambda", "λ")
" call signify#SignifyKeyword("rubyKeyword", "rubyProcKeyword", "proc", "π")

setlocal iskeyword+=?
setlocal iskeyword+=!

nnoremap <buffer> <leader><return> :TestFile<cr>
nnoremap <buffer> <return> :TestNearest<cr>

" save code, run ruby, show output in preview window
function! Ruby_eval_vsplit() range
  let src = tempname()
  let dst = tempname()
  execute ": " . a:firstline . "," . a:lastline . "w " . src
  execute ":silent ! ruby " . src . " > " . dst . " 2>&1 "
  execute ":pclose!"
  execute ":redraw!"
  execute ":new"
  execute "normal \<C-W>l"
  execute ":e! " . dst
  execute ":set pvw"
  execute "normal \<C-W>h"
endfunction
vnoremap <buffer> <silent> <leader><space> :call Ruby_eval_vsplit()<cr>
nnoremap <buffer> <silent> <leader><space> mzggVG<leader><space>`z
