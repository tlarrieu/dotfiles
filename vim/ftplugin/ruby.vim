call signify#SignifyMatch("rubyOperator", "rubyGreaterEqualOperator", "\">=\"", "≥")
call signify#SignifyMatch("rubyOperator", "rubyLesserEqualOperator", "\"<=\"", "≤")
call signify#SignifyMatch("rubyOperator", "rubyLambdaOperator", "\"->\"", "→")
call signify#SignifyMatch("rubyOperator", "rubyHashRocketOperator", "\"=>\"", "⇒")
call signify#SignifyMatch("rubyOperator", "rubySpaceShipOperator", "\"<=>\"", "⇔")
call signify#SignifyMatch("rubyOperator", "rubyDifferentOperator", "\"!=\"", "≠")
call signify#SignifyMatch("rubyOperator", "rubyTimesOperator", "\" \\zs\\*\\ze \"", "×")
" call signify#SignifyMatch("rubyOperator", "rubyOverOperator", "\". \\zs/\\ze .\"", "÷")
call signify#SignifyMatch("rubyOperator", "rubyEqualOperator", "\"==\"", "≡")
call signify#SignifyMatch("rubyOperator", "rubyAndOperator", "\"&&\"", "∧")
call signify#SignifyMatch("rubyOperator", "rubyAndOperator", "\"||\"", "∨")
" call signify#SignifyMatch("rubyOperator", "rubyLambdaKeyword", "\"\\zslambda\\ze \"", "λ")
" call signify#SignifyMatch("rubyOperator", "rubyProcKeyword", "\"\\zsproc\\ze \"", "π")

" call signify#SignifyKeyword("rubyKeyword", "rubyLambdaKeyword", "lambda", "λ")
" call signify#SignifyKeyword("rubyKeyword", "rubyProcKeyword", "proc", "π")

setlocal iskeyword+=?
setlocal iskeyword+=!
setlocal foldmethod=syntax

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

let b:switch_custom_definitions =
  \[
  \  ['&&', '||'],
  \  {
  \    '\Ctrue':  'false',
  \    '\Cfalse': 'true',
  \  },
  \  {
  \     'if true or (\(.*\))':          'if false and (\1)',
  \     'if false and (\(.*\))':        'if \1',
  \     'if \%(true\|false\)\@!\(.*\)': 'if true or (\1)',
  \  },
  \  {
  \    ':\(\k\+\)\s*=>\s*': '\1: ',
  \    '\<\(\k\+\): ':      ':\1 => ',
  \  },
  \  {
  \    '"\(\k\+\)"':                '''\1''',
  \    '''\(\k\+\)''':              ':\1',
  \    ':\(\k\+\)\@>\%(\s*=>\)\@!': '"\1"\2',
  \  },
  \  {
  \    '"\(.\+\)"':                '''\1''',
  \    '''\(.\+\)''':              '"\1"',
  \  },
  \  {
  \    'lambda { |\(.*\)| \(.*\) }': '->(\1) { \2 }',
  \    'lambda {|\(.*\)| \(.*\)}': '->(\1) { \2 }',
  \    'lambda { \(.*\) }': '-> { \1 }',
  \    'lambda {\(.*\)}': '-> { \1 }',
  \  },
  \  {
  \    '\(expect.*\.\)\(to\) ':     '\1not_\2 ',
  \    '\(expect.*\.\)\(not_\)\(to\) ': '\1\3 ',
  \  },
  \  ['be_truthy', 'be_falsey']
  \]
