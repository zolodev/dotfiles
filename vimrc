




" /$$    /$$ /$$$$$$ /$$      /$$ /$$$$$$$   /$$$$$$ 
"| $$   | $$|_  $$_/| $$$    /$$$| $$__  $$ /$$__  $$
"| $$   | $$  | $$  | $$$$  /$$$$| $$  \ $$| $$  \__/
"|  $$ / $$/  | $$  | $$ $$/$$ $$| $$$$$$$/| $$      
" \  $$ $$/   | $$  | $$  $$$| $$| $$__  $$| $$      
"  \  $$$/    | $$  | $$\  $ | $$| $$  \ $$| $$    $$
"   \  $/    /$$$$$$| $$ \/  | $$| $$  | $$|  $$$$$$/
"    \_/    |______/|__/     |__/|__/  |__/ \______/ 
"   By: Zolo
"   Last_updated: 2022-07-10 




"--------------------------------------------
" CUSTOM SETTING 
"--------------------------------------------

let mapleader=" "

call plug#begin('~/.vim/plugins')

" syntax highlight latex 
Plug 'lervag/vimtex'

" Center the content and remove any distraction. 
Plug 'junegunn/goyo.vim'

"
" New plugins - 2019-12-06
"

" Powerline - Shows information in the bottom of vim window
"Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" flake-8 check python scripts to follow PEP-8
Plug 'nvie/vim-flake8'

" check your syntax on each save
Plug 'vim-syntastic/syntastic'

" Ctrl+p best searhc
Plug 'kien/ctrlp.vim'

" GIT commands
Plug 'tpope/vim-fugitive'

call plug#end()

" Theme and color
    let g:solarized_termcolors=256
    set background=dark
    colorscheme solarized
    " colorscheme badwolf
    " let g:Powerline_symbols = 'fancy'


" Some basics:
	set nocompatible
	filetype plugin on
	
    " enable syntax processing
    syntax enable
    syntax on

	" set default encoding to be utf-8
    set encoding=utf-8
    set fileencoding=utf-8

    
    " Setting the clipboard shared between vim and desktop
    set clipboard=unnamed
    
    " Set no swapfile
    set noswapfile
    
    " Fix <TAB> and translate them to normal spaces of 4
    set tabstop=4
    set softtabstop=4
    set expandtab
    
    " Set the line numbers 
    set number 
	" set number relativenumber
    
    " show the cursor position all the time 
    set ruler

    " Set a visual ruler of where 80 chars
    set colorcolumn=80

    " hard rule to fit text inside max width of 80
    " set textwidth=80

    " wrap text
    set nowrap
    
    " show command in bottom bar
    "set showcmd
    
    " set a line under the current line being edited
    set cursorline
    
    " highlight matching [{()}]
    set showmatch
    
    " enable folding
    set foldenable
    
    " space /open/closes folds
    nnoremap <space> za


" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo  \| set linebreak<CR>
    " :Goyo 50%+25%x50%-25%

" Autobuild:
	map <leader>c :w! \| !pdflatex <c-r>%<CR><CR>


au BufNewFile,BufRead *.py
    \ set tabstop=4 | 
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

"au BufNewFile,BufRead *.js, *.html, *.css
"    \ set tabstop=2
"    \ set softtabstop=2 |
"    \ set shiftwidth=2


" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Let python code look good
let python_highlight_all=1


" Airline plugin settings
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline#extensions#tabline#formatter = 'default'

" let g:airline_theme='solarized'
let g:airline_theme='bubblegum'
"let g:airline_theme='luna'


" Rebind in insert mode, Space*2 will search and replace  and put into
" insert mode agian
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l

" Add <em> tags and  (FeT>i) moves the cursor to '>' and put the user into 
" insert mode.
autocmd FileType html inoremap ;i <em></em><Space><++><Esc>FeT>i




