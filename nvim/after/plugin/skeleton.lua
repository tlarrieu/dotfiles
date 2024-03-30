local function expand(name)
  vim.cmd.startinsert()
  vim.api.nvim_feedkeys(name, "insert", false)
  vim.api.nvim_input('<tab>')

  return true
end

local function bootstrap()
  -- Index all snipets for filetypes
  local xs = {}
  for ft in vim.o.filetype:gmatch("([^.]+)") do
    for _, item in pairs(require('luasnip').available()[ft] or {}) do
      xs[item.name] = true
    end
  end

  -- query projectionist
  local skeleton = (vim.fn['projectionist#query']('skeleton')[1] or {})[2]

  if skeleton and not xs[skeleton] then
    require('notify').notify(
      'Skeleton "' .. skeleton .. '" not found for filetype "' .. vim.o.filetype .. '"',
      vim.log.levels.WARN,
      { title = "skeleton.lua" }
    )
    return false
  end

  skeleton = skeleton or "_skel"
  if xs[skeleton] then return expand(skeleton) end

  return false
end

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  callback = bootstrap,
  group = vim.api.nvim_create_augroup("luasnip_hooks", {})
})
