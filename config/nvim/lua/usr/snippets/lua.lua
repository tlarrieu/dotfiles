local au = [[vim.api.nvim_create_autocmd('${1:event}', {
  pattern = { ${2:pattern} },
  callback = function()
    $3
  end,
})]]

local snippet = [[return {
  snippets = {
    $0
  },
  skeletons = {}
}]]

local plugin = [[return {
  '$1',
  $0
}]]

return {
  snippets = {
    e = '---@',
    req = "require('${1:module}')",
    m = 'local M = {}\n\n$0\n\n return M',
    d = {
      inline = 'function($1) $2 end',
      block = 'local $1 = function($2)\n\t$0\nend',
    },
    l = 'local $1 = ',
    ['for'] = 'for ${1:x} in ${2:xs} do\n\t$0\nend',
    ['if'] = 'if ${1:cond} then\n\t$0\nend',
    ['eif'] = 'elseif ${1:cond} then\n\t$0',

    p = 'print(${1:arg})',
    pc = 'pcall(function() $0 end)',

    dump = "require('gears.debug').dump_return(${1:arg})",
    notif = "require('naughty').notify({ text = ${1:arg} })",

    n = 'vim.notify(${1:arg})',
    i = 'vim.inspect(${1:arg})',
    au = au,
    aug = "vim.api.nvim_create_augroup('${1:groupname}', {$2})",

    s = snippet,
  },
  skeletons = {
    ['snippets'] = snippet,
    ['plugin'] = plugin,
  }
}
