""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" turn off vi-compatibility
set nocompatible

" always show cursor position
set ruler

" always show a status line
set laststatus=2

" insert a <tab>, not n spaces
set noexpandtab

" show command in status line
set showcmd

" don't redraw screen while exectuing macros
set lazyredraw

" allow backspace to erase over start of insert, line breaks ++
set bs=indent,eol,start

" I mostly use dark backgrounds
"set bg=dark
" I mostly use light backgrounds
set bg=light

" color scheme
"colorscheme darkblue
"colorscheme biogoo

" font
set guifont=Monospace\ 9

" avoid annoying "Hit ENTER to continue" prompts
set shortmess=atToOI

" incremental search
set incsearch

" hilight searches
set hlsearch

" show matches – not needed anymore since vim7 highlights matches
"set showmatch

" do not wrap around the end of the file when searching
set nowrapscan

" syntax-hilighting, yes please
syntax on

" allow hiding a buffer without saving it first
set hidden

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show matches above the command line when completing
set wildmenu

" always show lines below the cursor
set scrolloff=5

" make scrolling horizontally a bit more useful
"set nowrap
"set sidescroll=8
"set sidescrolloff=999
"set listchars=precedes:^,extends:$
"highlight NonText term=bold cterm=bold ctermfg=7
" or just wrap
set wrap

" support filetype plugins
filetype plugin on

" automatic indent
filetype indent on
set autoindent
set smartindent

" automatic folding
set foldmethod=syntax
set foldclose=all
set foldlevelstart=0
set foldnestmax=2

" make: smp
"set makeprg=make\ -j2

" right mouse button behaviour
" extend/popup/popup_setpos
set mousemodel=extend

" gui options:
" a: autoselect
" A: autoselect for the modeless selection
" c: console dialogs instead of popup dialogs
" f: foreground (no fork)
" i: use icon
" m: menu bar
" M: menu.vim is not sourced
" g: grey menu items
" t: tearoff menu items
" T: toolbar
" r: right-hand scrollbar
" R: right-hand scrollbar when there's a vertically split window
" l: left-hand scrollbar
" L: left-hand scrollbar when there's a vertically split window
" b: bottom scrollbar
" h: limit bottom scrollbar's size to the length of a line
" v: vertical layout for dialogs
" p: pointer callbacks for X11 GUI
" F: add a footer in Motif
set guioptions=aci

" ctags
set tags+=~/.cache/system-tags

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" extended % matching
runtime macros/matchit.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType perl,javascript,python set expandtab shiftwidth=4 softtabstop=4
autocmd FileType ruby,eruby,haskell,html,xml,xslt,css,pov,scheme set expandtab shiftwidth=2 softtabstop=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings and functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use F11 to toggle pastemode
set pastetoggle=<F11>

" turn off search highlighting with ^n
nmap <silent> <C-N> :silent noh<CR>

" Switch between buffers using ^H and ^L
nmap <C-H> :bp<CR>
nmap <C-L> :bn<CR>

" move _and_ scroll down one line with ^j
nnoremap <C-J> 1<C-D>:set scroll=0<CR>
" move _and_ scroll up one line with ^k
nnoremap <C-K> 1<C-U>:set scroll=0<CR>

" my grep supports -H
"set grepprg=grep\ -nH
" make :grep work like :vimgrep
set grepprg=internal

"set formatprg=par\ 'rTw80begqR'\ 'B=.,?_A_a'\ 'Q=_s>\|'\ 'P=.'

