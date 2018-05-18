setlocal conceallevel=0
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

setlocal iskeyword+=?
setlocal iskeyword+=!

iabbrev <buffer> pry binding.pry

let b:deoplete_sources = ['omni', 'tag', 'buffer', 'file']

nnoremap <buffer> <return> :TestLast \| Topen<cr>

augroup Test
  autocmd!
  autocmd BufEnter *_spec.rb,*_test.rb
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestFile \| Topen<cr>
  autocmd BufEnter *_spec.rb,*_test.rb
        \ nnoremap <silent> <buffer> <return>
        \ :TestNearest \| Topen<cr>
  autocmd BufEnter Gemfile
        \ nnoremap <silent> <buffer> <return>
        \ :new<bar>call termopen('bundle')<cr>
  autocmd BufEnter *.gemspec
        \ nnoremap <silent> <buffer> <return>
        \ :new<bar>call termopen('bundle')<cr>
  autocmd BufEnter main.rb
        \ nnoremap <silent> <buffer> <return>
        \ :T ./main.rb<cr>
augroup END

function! Migrate(direction)
  let l:filename = expand('%:t')
  let l:cmd = 'bundle exec rake db:migrate:' . a:direction
  let l:options = 'VERSION=' . matchstr(l:filename, '\v\d+')
  new
  call termopen(l:cmd . ' ' . l:options)
endfunction

augroup Migration
  autocmd!
  autocmd BufEnter db/migrate/*
        \ map <silent> <buffer> <return>
        \ :call Migrate('up')<cr>
  autocmd BufEnter db/migrate/*
        \ map <silent> <buffer> <leader><return>
        \ :call Migrate('down')<cr>
augroup END

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

let b:fzf_tags_config = {
  \   'function': { 'identifiers': ['f', 'F'], 'prompt': 'meth' },
  \   'class': { 'identifiers': ['c', 'm'], 'prompt': 'class' }
  \ }
nnoremap <silent> <c-c> :FZFtags class<cr>
nnoremap <silent> <c-l> :FZFtags function<cr>
