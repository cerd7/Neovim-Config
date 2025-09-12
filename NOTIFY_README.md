# Nvim-Notify Configuration

## 🎨 Notify Moderno - Canto Superior

O nvim-notify foi configurado para exibir mensagens no **canto superior direito** com um design moderno e temas personalizáveis.

## ✨ Características

- 📍 **Posição**: Canto superior direito
- 🎨 **Tema**: Catppuccin Mocha (padrão)
- ⏱️ **Timeout**: 3 segundos
- 🎯 **Animação**: Suave com bordas arredondadas
- 🌈 **Ícones**: Emojis modernos
- 🎨 **Temas**: Múltiplos temas disponíveis

## 🚀 Como Usar

### Comandos Disponíveis

```vim
:NotifyTest     " Testar todos os tipos de notificação
:NotifyConfig   " Mostrar configuração atual
:NotifyTheme    " Alterar tema (com autocomplete)
```

### Exemplos de Uso

```lua
-- Notificação simples
vim.notify("Mensagem de informação")

-- Notificação com título
vim.notify("Operação concluída!", "info", {
  title = "Sucesso"
})

-- Notificação de erro
vim.notify("Erro encontrado!", "error", {
  title = "Erro",
  timeout = 5000
})
```

## 🎨 Temas Disponíveis

### Catppuccin Mocha (Padrão)
```vim
:NotifyTheme catppuccin_mocha
```

### Nord
```vim
:NotifyTheme nord
```

### Dracula
```vim
:NotifyTheme dracula
```

### Tokyo Night
```vim
:NotifyTheme tokyo_night
```

## 🔧 Configuração Técnica

### Aparência
- **Fundo**: #1e1e2e (Catppuccin Mocha)
- **Bordas**: Arredondadas com padding
- **Ícones**: Emojis coloridos
- **Fonte**: Negrito para títulos

### Posicionamento
- **Horizontal**: Canto direito da tela
- **Vertical**: Topo da tela
- **Direção**: De baixo para cima (stack)

### Animação
- **FPS**: 60 para suavidade
- **Estágios**: Fade in/out suave
- **Transições**: Bordas arredondadas

## 📋 Tipos de Notificação

| Tipo | Ícone | Cor | Descrição |
|------|-------|-----|-----------|
| `info` | ℹ️ | Azul | Informações gerais |
| `warn` | ⚠️ | Amarelo | Avisos |
| `error` | ❌ | Vermelho | Erros |
| `debug` | 🐛 | Verde | Debug |
| `trace` | ✎ | Rosa | Trace |

## 🎯 Exemplo de Uso no LSP

As notificações são automaticamente usadas pelo LSP:

```vim
-- Quando LSP se conecta
vim.notify("TypeScript LSP anexado com sucesso", "info", {
  title = "LSP Conectado"
})

-- Quando há erros
vim.notify("Erro de sintaxe encontrado", "error", {
  title = "Erro de Sintaxe"
})
```

## 🔄 Integração com Outros Plugins

O notify é integrado com:
- **LSP**: Notificações de conexão/erro
- **Git**: Status de operações
- **Instalação**: Progresso de instalação
- **Debug**: Informações de debug

## 🛠️ Troubleshooting

### Notificações não aparecem
```vim
:checkhealth notify
:NotifyTest
```

### Tema não muda
```vim
:NotifyTheme catppuccin_mocha
:source ~/.config/nvim/lua/plugins/notify_theme.lua
```

### Performance
Se as animações estiverem lentas:
```vim
" Reduzir FPS no notify_config.lua
fps = 30
```

## 📁 Arquivos de Configuração

```
~/.config/nvim/lua/plugins/
├── notify_config.lua      # Configuração principal
└── notify_theme.lua       # Temas e cores
```

## 🎨 Personalização

Para personalizar ainda mais, edite `notify_theme.lua`:

```lua
-- Adicionar novo tema
M.meu_tema = {
  normal = {
    fg = "#ffffff",
    bg = "#000000",
  },
  border = {
    fg = "#ff0000",
    bg = "#000000",
  },
}
```

As notificações agora aparecem no canto superior com design moderno! 🎉
