vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set({ 'i', 'v' }, '<C-c>', '<Esc>', { noremap = true })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('x', '<leader>p', [["_dP]]) -- paste WON'T copy
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<leader><Tab>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<leader><S-Tab>', '<cmd>bprev<cr>')
vim.keymap.set('n', '<C-x>', '<cmd>bdel<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<leader>vp', '<cmd> vertical resize +5 <CR>')
vim.keymap.set('n', '<leader>vm', '<cmd> vertical resize -5 <CR>')

vim.keymap.set('n', '<leader>hp', '<cmd> resize +5 <CR>')
vim.keymap.set('n', '<leader>hm', '<cmd> resize -5 <CR>')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', '<leader>rp', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>') -- Replace all instance of current word in file

vim.keymap.set('n', '<leader>q', '<cmd> q <CR>')
vim.keymap.set('n', '<leader>qa', '<cmd> qa <CR>')

-- Unset arrow keys
vim.cmd [[
    noremap <Left> <Nop>
    noremap <Right> <Nop>
    noremap <Up> <Nop>
    noremap <Down> <Nop>


    inoremap <Left> <Nop>
    inoremap <Right> <Nop>
    inoremap <Up> <Nop>
    inoremap <Down> <Nop>
]]

-- Disable Mouse
vim.cmd [[
    set mouse=
]]
