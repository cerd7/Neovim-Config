# LSP Configuration for Web Development

## 🚀 Quick Start

### 1. Install Language Servers
```bash
chmod +x ~/.config/nvim/scripts/install_web_lsp.sh
~/.config/nvim/scripts/install_web_lsp.sh
```

### 2. Verify Installation
```bash
~/.config/nvim/scripts/check_lsp.sh
```

### 3. Test LSP in Neovim
1. Open a `.js`, `.ts`, `.css`, or `.html` file
2. Run `:LspDiag` to check LSP status
3. Test features:
   - `gd` - Go to definition
   - `K` - Hover documentation
   - `<leader>rn` - Rename symbol
   - `<C-x><C-o>` - Omni completion

## 🔧 LSP Features

### TypeScript/JavaScript
- ✅ IntelliSense
- ✅ Go to definition
- ✅ Find references
- ✅ Rename refactoring
- ✅ Hover documentation
- ✅ Auto-completion
- ✅ Error diagnostics
- ✅ Auto-formatting

### CSS/SCSS/Less
- ✅ IntelliSense for CSS properties
- ✅ Color previews
- ✅ Go to definition
- ✅ Hover documentation
- ✅ Error diagnostics

### HTML
- ✅ IntelliSense for HTML tags
- ✅ Auto-completion
- ✅ Hover documentation
- ✅ Error diagnostics

## 🛠️ Troubleshooting

### LSP Not Starting
```vim
:LspDiag          " Check LSP status
:LspStart tsserver " Start TypeScript LSP manually
:LspRestart       " Restart all LSP clients
:LspLogs          " Show LSP logs
```

### No Auto-Completion
1. Ensure `nvim-cmp` is installed: `:PlugInstall`
2. Check if LSP is attached: `:LspInfo`
3. Restart LSP: `:LspRestart`

### No Diagnostics
1. Check diagnostic config: `:LspDiag`
2. Restart LSP: `:LspRestart`
3. Check logs: `:LspLog`

### Performance Issues
- Add to `init.vim`: `let g:vsnip_disable_treesitter = 1`
- Restart Neovim

## 📋 Keybindings

| Keybinding | Action |
|------------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>f` | Format document |
| `<leader>e` | Show diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

## 🔍 Advanced Commands

- `:LspInfo` - Show LSP information
- `:LspLog` - Show LSP logs
- `:LspDiag` - Check LSP status
- `:LspTest` - Test LSP features
- `:LspRestart` - Restart LSP
- `:LspStart <server>` - Start specific LSP server

## 📁 File Structure

```
~/.config/nvim/
├── lua/lsp/
│   ├── dev_lsp.lua          # Main LSP configuration
│   ├── lsp_keymap.lua       # LSP keybindings
│   ├── diagnostic.lua       # Basic diagnostics
│   ├── diagnostic_advanced.lua # Advanced diagnostics
│   └── init.lua             # LSP initialization
├── scripts/
│   ├── install_web_lsp.sh   # Install script
│   └── check_lsp.sh         # Verification script
└── init.vim                 # Main configuration
```

## 🎯 Supported Languages

- **JavaScript** (`.js`, `.jsx`)
- **TypeScript** (`.ts`, `.tsx`)
- **CSS** (`.css`)
- **SCSS** (`.scss`)
- **Less** (`.less`)
- **HTML** (`.html`)

## 💡 Tips

1. **Auto-formatting**: Files are automatically formatted on save
2. **Virtual text**: Error messages appear inline
3. **Floating windows**: Press `K` for detailed documentation
4. **Multiple cursors**: Use `<C-n>` for multi-cursor editing
5. **Quick fixes**: Use `<leader>ca` for code actions

## 🐛 Common Issues

### "LSP not attached"
- Check if file type is supported
- Run `:LspDiag` to verify
- Try `:LspStart tsserver`

### "Command not found"
- Run installation script again
- Check PATH: `which typescript-language-server`

### "No completion"
- Ensure nvim-cmp is loaded
- Check LSP capabilities: `:LspInfo`

For more help, check `:help lsp` in Neovim.
