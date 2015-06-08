setlocal conceallevel=2
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

setlocal iskeyword+=?
setlocal iskeyword+=!

nnoremap <buffer> <leader><return> :call neoterm#test#run('file')<cr>
nnoremap <buffer> <return> :call neoterm#test#run('current')<cr>

let g:neomake_ruby_rubocop_maker = {
      \ 'args': ['-D'],
      \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
      \ }

let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']

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
