set t_Co=256
syntax on
set number
set backspace=2
set autoindent
set nocompatible               " be iMproved, required
set tabstop=4                  " switch the tab to 4 space 
set shiftwidth=4     
set expandtab                  " save tab ro space
set ignorecase                 " not case sensitive
set hlsearch
set mouse=a

filetype off                   " required!

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" python-mode 
let g:pymode_folding = 1 
let g:pymode_motion = 1
" let g:pymode_lint = 0

" EasyMotion
let g:EasyMotion_leader_key = '\'

" Airline
let g:airline_powerline_fonts = 0
let g:airline_theme = 'badwolf'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '▶'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_detect_paste=1

if !exists('g:airline_symbols')
          let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

"Powerline
"let g:Powerline_symbols = 'fancy'
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

" colorscheme ** $ cp -r ~/.vim/bundle/wombat256.vim/colors ~/.vim ** 
colorscheme wombat256mod
let python_highlight_all = 1

" Cscope && Pycscope
autocmd FileType python nmap <F9> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' -o -iname '*.py' >cscope.files<CR>
  \:!pycscope -S -i cscope.files -f cscope.out<CR>
  \:cs reset<CR>

function! LoadCscope()
      let db = findfile("cscope.out", ".;")
        if (!empty(db))
            let path = strpart(db, 0, match(db, "/cscope.out$"))
            set nocscopeverbose " suppress 'duplicate connection' error
            exe "cs add " . db . " " . path
            set cscopeverbose
        endif
endfunction
au BufEnter /* call LoadCscope()
" call LoadCscope()

if has('cscope')
    set cscopetag cscopeverbose
    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif

    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    cnoreabbrev css cs show
    cnoreabbrev csh cs help

    command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
endif


"NERDTree shortcuts
map <F2> :NERDTreeToggle<CR>

"Conque
let g:ConqueTerm_Color = 2
let g:ConqueTerm_StartMessages = 0
map <F8> :ConqueTermSplit bash<CR>

"Tagbar list
map <F5> :TagbarToggle<CR>

"Pydiction
let g:pydiction_location = '/home/john/.vim/bundle/Pydiction/complete-dict'

" My Plugins here:
" original repos on github
Plugin 'msanders/snipmate.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'vim-scripts/c.vim'
Plugin 'klen/python-mode'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
"Plugin 'Lokaltog/powerline'
"Plugin 'Lokaltog/vim-powerline'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" non github repos

"Plugin 'git://git.wincent.com/command-t.git'

" vim-scripts repos
Plugin 'wombat256.vim'
Plugin 'L9'
Plugin 'cscope.vim'
Plugin 'python.vim'
Plugin 'AutoComplPop'
Plugin 'matchit.zip'
Plugin 'python_match.vim'
Plugin 'surround.vim'
Plugin 'mako.vim'
Plugin 'nginx.vim'
Plugin 'vim-indent-object'
Plugin 'FuzzyFinder'
Plugin 'Pydiction'
"Plugin 'desert.vim'
Plugin 'taglist.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
