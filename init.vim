"" These are native vim settings
set nocompatible
set number
set backspace=indent,eol,start
set showcmd
set history=100
set visualbell
set autoread
set hidden
let mapleader=","
set noswapfile
set nobackup
set nowb

" Keeps undo history across sessions by storing in a file
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

"" Indenting
set autoindent
set smartindent
set smarttab
set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth=2

" Indent with paste
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

"Not 100% on what these do
filetype plugin on
filetype indent on

" Show trailing whitespace as that dot thing
set list listchars=tab:\ \ ,trail:·

set nowrap
set linebreak

set foldmethod=indent
set foldnestmax=10
set nofoldenable

set wildmode=list:longest
set wildmenu
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Easier pane navigation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" 'Easier' window splits
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" Easy 'fat' arrows
imap <c-l> <space>=><space>

"" Searching
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
" // makes the search results not highlighted
" unless you interact with them again
nmap <silent> // :nohlsearch<CR>

"This is so 0 takes you to the first character
"of a line rather than the very start
nnoremap 0 ^
nnoremap ^ 0

"Remapping the awkward ctrl+^ to go back to previous file
nnoremap <C-b> <C-^>

" copy current filename into system clipboard - mnemonic: (c)urrent(f)ilename
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>

set clipboard=unnamed

"" Load Vundle Plugins
if filereadable(expand("~/.vim/vundles.vim"))
	source ~/.vim/vundles.vim
endif

" Load the settings files for the various plugins
let vimsettings = '~/.vim/settings'
for fpath in split(globpath(vimsettings, '*.vim'), '\n')
	exe 'source' fpath
endfor

nmap <C-t>r <Plug>SetTmuxVars

" vim-rspec mappings
map <Leader>f :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

"custom.vim is a file where you can add any extra things
"you want that you don't want version controlled.
"for example what colorscheme you decide to use
so ~/.vim/custom.vim

nnoremap <C-p> :call FlashCurrentLine()<CR>

function! FlashCurrentLine()
	set cul
	redraw
	sleep 300m
	set nocul
endfunction

" Replace the register with the pasted value when using 'p' to overwrite text.
" The vim default behavior is to fill the register with the text you just
" overwrote.
function! RestoreRegister()
  let @" = s:restore_reg
  if &clipboard == "unnamed"
      let @* = s:restore_reg
  endif
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()
