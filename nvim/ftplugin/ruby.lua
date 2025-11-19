vim.g.loaded_ruby_provider = 0

local params_for = function(kind)
  return {
    hidden = true,
    path_display = {
      'filename_first',
      shorten = { len = 1, exclude = { 1, -3, -2, -1 } }
    },
    find_command = { 'fd', '-tf', '--hidden', '-p', 'app/' .. kind },
    results_title = ' ' .. kind,
  }
end

vim.keymap.set('n', '<a-c>', function() return require('telescope.builtin').find_files(params_for('controllers')) end,
  { desc = 'Telescope controllers lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-m>', function() return require('telescope.builtin').find_files(params_for('models')) end,
  { desc = 'Telescope models lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-v>', function() return require('telescope.builtin').find_files(params_for('views')) end,
  { desc = 'Telescope views lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-s>', function() return require('telescope.builtin').find_files(params_for('services')) end,
  { desc = 'Telescope services lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-j>', function() return require('telescope.builtin').find_files(params_for('jobs')) end,
  { desc = 'Telescope jobs lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-d>', function() return require('telescope.builtin').find_files(params_for('lib')) end,
  { desc = 'Telescope POROs lookup (Ruby on Rails)' })
