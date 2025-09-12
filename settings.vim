" =============================================================================
" Interface
" =============================================================================
set number                              " Mostra os números das linhas
set relativenumber                      " Mostra os números das linhas relativas à posição do cursor
set ruler                               " Mostra a posição do cursor
set cmdheight=1                         " Altura da linha de comando
set showtabline=2                       " Sempre mostra a barra de abas
set laststatus=2                        " Sempre mostra a barra de status
set cursorline                          " Destaca a linha atual
set pumheight=10                        " Altura máxima do menu de autocompletar
set background=dark                     " Define o fundo como escuro para melhor contraste do tema
set termguicolors                       " Habilita cores de 24-bit (True Color)

" =============================================================================
" Comportamento do Texto e Edição
" =============================================================================
syntax enable                           " Habilita o realce de sintaxe
set hidden                              " Permite trocar de buffer sem salvar
set nowrap                              " Desabilita a quebra de linha automática
set encoding=utf-8                      " Define a codificação de caracteres para a interface
set fileencoding=utf-8                  " Define a codificação de caracteres para os arquivos
set iskeyword+=-                        " Trata palavras com hífen como uma única palavra
set mouse=a                             " Habilita o uso do mouse em todos os modos
set splitbelow                          " Abre novos splits horizontais abaixo do atual
set splitright                          " Abre novos splits verticais à direita do atual
set conceallevel=0                      " Evita que caracteres sejam ocultados (ex: em Markdown)
set clipboard+=unnamed                  " Usa a área de transferência do sistema

" =============================================================================
" Indentação
" =============================================================================
set tabstop=2                           " Define a largura de uma tabulação como 2 espaços
set shiftwidth=2                        " Define o número de espaços para indentação automática
set expandtab                           " Converte tabulações em espaços
set smartindent                         " Habilita a indentação inteligente para novos blocos
set autoindent                          " Mantém a indentação da linha anterior

" =============================================================================
" Configurações Específicas de Linguagem
" =============================================================================
let g:markdown_fenced_languages = ['vim', 'help']

