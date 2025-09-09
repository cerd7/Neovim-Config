local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Salvar e sair
map("n", "<C-s>", ":w<CR>", opts)
map("n", "<C-q>", ":q<CR>", opts)
map("n", "<C-w>", ":bd<CR>", opts)

-- Navegar entre janelas
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Redimensionar janelas
map("n", "<C-Up>",    ":resize -2<CR>", opts)
map("n", "<C-Down>",  ":resize +2<CR>", opts)
map("n", "<C-Left>",  ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Criar divisões de janela
map("n", "<leader>l", ":vsplit<CR>", opts) -- Vertical split
map("n", "<leader>i", ":split<CR>", opts)  -- Horizontal split
map("n", "<leader>se", "<C-w>=", opts)      -- Equaliza splits
map("n", "<leader>sx", ":close<CR>", opts)  -- Fecha split

-- Move linhas
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)

-- Copiar
map("n", "C-c", '"+yy"', opts)
map("v", "C-c", '"+y"', opts)

-- Buscar arquivos
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- Terminal
map("n", "<leader>tt", ":ToggleTerm<CR>", opts)

-- Retornar para home
map("n",  "<leader>hh", ":Alpha<CR>", opts)

-- Menu lateral
map("n", "<leader>e", ":Neotree<CR>", opts)

-- Quebra de linha
map("n", "<A-z>", ":set wrap!<CR>", opts)
