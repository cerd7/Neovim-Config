" Leader keybind
let mapleader = " "
let g:vsnip_disable_treesitter = 1

source ~/.config/nvim/settings.vim
source ~/.config/nvim/vim-plug/plugins.vim

luafile ~/.config/nvim/lua/plugins/notify_config.lua
luafile ~/.config/nvim/lua/plugins/cpmconfig.lua
luafile ~/.config/nvim/lua/plugins/devicons_config.lua
luafile ~/.config/nvim/lua/plugins.lua
source ~/.config/nvim/plug-config/telescope.vim

" Verificar instalação do JDTLS para Java
lua << EOF
local jdtls_installed = false
local jdtls_paths = {
  vim.fn.expand('~/.local/share/nvim/lsp_servers/jdtls'),
  vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls')
}

for _, path in ipairs(jdtls_paths) do
  if vim.fn.isdirectory(path) == 1 then
    jdtls_installed = true
    break
  end
end

if not jdtls_installed then
  vim.notify([[
    JDTLS (Java Language Server) não encontrado!
    Execute o script de instalação:
    ~/.config/nvim/scripts/install_jdtls.sh
  ]], vim.log.levels.WARN)
end
EOF

lua << EOF
-- Inicializar notify de forma segura
pcall(
  function() require('plugins.notify_config').setup()
  end)
EOF

" lsp-config
lua << EOF
-- Configuração LSP para Java
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    pcall(
      function() require("lsp.java_lsp").setup()
      end)
  end
})

-- Configuração LSP para web
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"typescript", "javascript", "typescriptreact", "javascriptreact", "typescript.tsx", "javascript.jsx", "css", "scss", "less", "html"},
  callback = function()
    pcall(
      function() require("lsp.dev_lsp").setup() 
      end)
  end
})
EOF

" lsp-config
augroup java_lsp
  autocmd!
  autocmd FileType java lua require("lsp.java_lsp").setup()
augroup END

augroup other_lsps
  autocmd!
  autocmd FileType typescript,javascript,typescriptreact,javascriptreact lua require("lsp.dev_lsp")
  autocmd FileType css,scss,less lua require("lsp.dev_lsp")
  autocmd FileType html lua require("lsp.dev_lsp")
  autocmd FileType vue lua require("lsp.dev_lsp")
augroup END

" Config nerdtree git
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 
let g:NERDTreeGitStatusShowIgnored = 1 " a heavy feature may cost much more time. default: 0

" Term
lua << EOF
require("toggleterm").setup{
  -- Configurações opcionais
  direction = "float",       -- terminal flutuante por padrão
  open_mapping = [[<leader>tt]], -- mapeia <leader>tt para abrir
  shade_terminals = true,
}

vim.cmd("colorscheme tokyonight")
EOF

