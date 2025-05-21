" Leader keybind
let mapleader = " "

source ~/.config/nvim/settings.vim
source ~/.config/nvim/vim-plug/plugins.vim

luafile ~/.config/nvim/lua/plugins.lua
luafile ~/.config/nvim/lua/plugins/compe-config.lua
source ~/.config/nvim/plug-config/lsp-config.vim
source ~/.config/nvim/plug-config/telescope.vim

" lsp-config
augroup java_lsp
  autocmd!
  autocmd FileType java lua require("lsp.java-lsp")
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

vim.cmd("colorscheme catppuccin-macchiato")
EOF

