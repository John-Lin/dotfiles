let $LANG = 'en'  "set message language
set langmenu=en   "set menu's language of gvim. no spaces beside '='
set encoding=UTF-8
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'vim-scripts/Align'
" Plug 'vim-scripts/L9'
" Plug 'vim-scripts/FuzzyFinder'

" On-deand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'github/copilot.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-speeddating'
" Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'

Plug 'neomake/neomake'

Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'kana/vim-fakeclip'
Plug 'majutsushi/tagbar'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
Plug 'elzr/vim-json', {'for' : 'json'}
Plug 'Einenlum/yaml-revealer'
Plug 'towolf/vim-helm'
" Go
Plug 'fatih/vim-go'

" zig
Plug 'ziglang/zig.vim'

Plug 'hashivim/vim-terraform'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" indent
Plug 'Yggdroot/indentLine'

" ansible
" Plug 'pearofducks/ansible-vim'
Plug 'easymotion/vim-easymotion'

" Color Theme
" Plug 'arcticicestudio/nord-vim'
Plug 'folke/tokyonight.nvim'
" Plug 'connorholyday/vim-snazzy'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()

" zig
let g:zig_fmt_autosave = 0
" ===== copilot =====
let g:copilot_filetypes = {
      \ '*': v:true,
      \ 'plaintext': v:false,
      \ 'xml': v:false,
      \ }

" ====== coc-snippet
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()

function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" ====== easymotion
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"=====================================================
" General VIM Settings
""===================== SETTINGS ======================

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)
let g:neomake_go_enabled_makers = [ 'go', 'golangci_lint' ]

set nocompatible
filetype off
filetype plugin indent on

" color
syntax enable
set t_Co=256
set background=dark
" colors ir_black
" colorscheme PaperColor
" colorscheme nord
" colorscheme snazzy
" colorscheme dracula
" colorscheme tokyonight-night
colorscheme tokyonight-storm
" colorscheme tokyonight-moon
" colorscheme tokyonight-day

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"===================== CTAGS ======================
nmap <leader>l :TagbarToggle<CR>

if has('nvim')
    let g:gitgutter_sign_removed_first_line = "^_"
endif

if !has('nvim')
    set ttymouse=xterm2
    set ttyscroll=3
endif

set ttyfast
set expandtab

set sidescroll=1
set sidescrolloff=3
set showfulltag showmatch showcmd showmode
set textwidth=0

set noerrorbells
set ambiwidth=double
set formatoptions=tcroqnlM1

" scroll jump && scroll off
set sj=1 so=3

set winaltkeys=no showtabline=2 hlsearch
set nolazyredraw

"If you want to put swap files in a fixed place, put a command resembling the
"following ones in your .vimrc
" set  dir=~/tmp
set noswapfile

set  wildmenu
set  wildmode=longest,list
set  wildignore+=*.o,*.a,*.so,*.obj,*.lib,*.ncb,*.opt,*.plg,.svn,.git,*.lo,*.la,*.in
" set wildoptions

" statusline format
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",bom\":\"\")}]\ %-14.(%l,%c%v%)\ %p

" history
set history=500
set shiftround smarttab showcmd noerrorbells number expandtab
set laststatus=2
set sw=4 ts=4 sts=4

" no error bell,visual bell
" set novb
set modeline
set mat=15
" increase max memory to show syntax highlighting for large files
set maxmempattern=20000
set noignorecase

if has('persistent_undo')
    set undofile
    set undodir=~/.cache/vim
endif

" current is no smartcase for command line completion ignorecase
"set smartcase

set ruler incsearch nowrap autoindent smartindent showmatch bs=indent,eol,start
set ff=unix
"set wm=6

" encoding
" set fileencodings=utf-8,big5,gbk,sjis,euc-jp,euc-kr,utf-bom,iso8859-1

set fenc=utf-8
" set fencs=utf-8,utf-16le,big5,euc-jp,utf-bom,iso8859-1,utf-16le
" set fencs=ucs-bom,big5,utf-8,euc-jp,utf-bom,iso8859-1,utf-16le
" set fencs=shift-jis,big5,euc-jp,utf-8,utf-16le
" set fencs=utf-8,big5,euc-jp,utf-bom,iso8859-1,utf-16le
set fileencodings=ucs-bom,utf-8,euc-jp,big-5,sjis,default
set enc=utf-8
set tenc=utf-8
" =========================================================== }}}
"   fold options ============================================ {{{
"set  fdt=FoldText()
set nofoldenable
set vop=folds,cursor
" set fdc=2 " fdc: fold column
set fdn=2 " fdn: fold nest max
set fdl=3 " fdl: fold level

" window resize mapping "{{{
nm   <a-x> <c-w><c-w><c-w>_
nm   <a-=> <c-w>=
nn   <c-w>9  8<c-w>+
nn   <c-w>0  8<c-w>-
"}}}

" Bash-like command mapping ================================= "{{{
cnoremap  <c-a>   <home>
cnoremap  <c-e>   <end>
cnoremap  <c-b>   <left>
cnoremap  <c-d>   <del>
cnoremap  <c-f>   <right>
cnoremap  <C-_>   <c-f>

cnoremap  <c-n>   <down>
cnoremap  <c-p>   <up>
cnoremap  <C-*>   <c-a>

" Space commands {{{ all space command : expand tab to space.
com! -nargs=0 AllSpace :setlocal et | retab!
cabbr allspace AllSpace

" Mac Custom tabpage key for mac and other platform {{{
" window size key for macbook
if ( has('gui_mac') || has('gui_macvim') ) && has('gui_running')
    nmap <silent>  <D-->   :resize -5<CR>
    nmap <silent>  <D-=>   :resize +5<CR>
    nmap <silent>  <D-]>   :vertical resize +5<CR>
    nmap <silent>  <D-[>   :vertical resize -5<CR>

    nmap <silent>  <D-\>   <C-w><C-w>
    "  nmap <c-x>tf  :tabfind
    "  nmap <c-x>th  :tab help<CR>
    nmap <D-s>       :w<CR>

    " Switch to specific tab numbers with Command-number
    noremap <D-1> :tabn 1<CR>
    noremap <D-2> :tabn 2<CR>
    noremap <D-3> :tabn 3<CR>
    noremap <D-4> :tabn 4<CR>
    noremap <D-5> :tabn 5<CR>
    noremap <D-6> :tabn 6<CR>
    noremap <D-7> :tabn 7<CR>
    noremap <D-8> :tabn 8<CR>
    noremap <D-9> :tabn 9<CR>
    " Command-0 goes to the last tab
    noremap <D-0> :tablast<CR>
endif


nm      <c-n>   gt
nm      <c-p>   gT
nmap te :tabedit
nmap ts :tabedit %

" Trim white space ===========================
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()
noremap <leader>t :call TrimWhitespace()<CR>

" Plugin Settings

" ==================== Fugitive ====================
nnoremap <leader>gb :G blame<CR>

" Valloric/YouCompleteMe: YouCompleteMe
let g:ycm_min_num_of_chars_for_completion = 3
set completeopt-=preview
" let g:ycm_autoclose_preview_window_after_completion = 1


" ==================== COC.nvim ====================
" --------------------------------------------------
" coc.nvim default settings
" --------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" find file
nnoremap <silent> <space>f  :<C-u>CocList files<CR>
" most recent file
nnoremap <silent> <space>r  :<C-u>CocList mru<CR>
" grep
nnoremap <silent> <space>g  :<C-u>CocList grep<CR>
" ==================== COC.nvim ====================

" ==================== markdown ====================
" plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1 " YMAL Front Matter
let g:vim_markdown_json_frontmatter = 1 " JSON Front Mattetaugroup
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh']
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1

" ==================== vim-json ====================
let g:vim_json_syntax_conceal = 0

" fatih/vim-go
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
let g:go_info_mode = "gopls"
let g:go_def_mode = "gopls"
let g:go_fmt_command = "goimports"
let g:go_debug_windows = {
      \ 'vars':  'leftabove 35vnew',
      \ 'stack': 'botright 10new',
      \ }
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_build_constraints = 1
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

nmap <silent> <leader>db  :GoDebugBreakpoint<CR>
nmap <silent> <leader>ds  :GoDebugStart<CR>
nmap <silent> <leader>dp  :GoDebugStop<CR>
nmap <silent> <leader>dr  :GoDebugRestart<CR>
" Step Over
nmap <silent> <leader>dn  :GoDebugNext<CR>
" Step Into
nmap <silent> <leader>di  :GoDebugStep<CR>
" Step Out
nmap <silent> <leader>do  :GoDebugStepOut<CR>
nmap <silent> <leader>dc  :GoDebugContinue<CR>

nmap <silent> <leader>b   :GoBuild<CR>
nmap <silent> <leader>gt  :GoTest<CR>
nmap <silent> <leader>gr  :GoReferrers<CR>
nmap <silent> <leader>gf  :GoFillStruct<CR>

" " ==================== gof ==================
" if executable('gof')
"   command! -nargs=* Gof term ++close gof -t
" endif

" ==================== NerdTree ====================
let NERDTreeShowHidden=1
" " For toggling
nmap <silent> <leader>e  :NERDTreeToggle<CR>
nmap <silent> <leader>nf :NERDTreeFind<CR>
nmap <silent> <leader>nm :NERDTreeMirror<CR>

cabbr ntf  NERDTreeFind
cabbr ntm  NERDTreeMirror

function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction
autocmd VimEnter * call StartUp()

" Performance improvments when using vim in tmux
if has("mac")
  set nocursorline

  if exists("+relativenumber")
    set norelativenumber
  endif

  set foldlevel=0
  set foldmethod=manual
endif

" MacVim Settings
if has('gui_macvim')
    set showtabline=2
    set imdisable
    set transparency=0  " set transparency level
    set guioptions-=m
    set guioptions-=M
    set antialias
    set guifont=SF\ Mono:h16
    " set guifont=Consolas:h12
    " set guifont=Monaco:h14
    " set guifont=Menlo:h12
endif
" ctags
set tags=./tags,./TAGS,tags;~,TAGS;~
" cscope
" set cscopetag
" set csto=0
"
" if filereadable("cscope.out")
"    cs add cscope.out
" elseif $CSCOPE_DB != ""
"     cs add $CSCOPE_DB
" endif
" set cscopeverbose
set rtp+=/opt/homebrew/opt/fzf
