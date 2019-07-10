" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" Jordan custom

" Pretty colors

"set termguicolors
set background=dark
set t_Co=256

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

silent! colorscheme gruvbox

set number
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Enable folding
set foldmethod=indent
set foldlevel=99


" set the desired text with for gq
set textwidth=120

autocmd BufRead  COMMIT_EDITMSG  setlocal tw=72 colorcolumn=72

" draw a vertical line at 120
" https://stackoverflow.com/a/3765575
if exists('+colorcolumn')
    set colorcolumn=120
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Enable folding with the spacebar
nnoremap <space> za

" Highlight trailing whitepsace
match ExtraWhitespace /\s\+$/


" Disable arrow keys to break bad habit
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>

let g:ale_completion_enabled = 1

" allow using // to search for visual select
vnoremap // y/<C-R>"<CR>
call plug#begin('~/.vim/plugged')
Plug 'jordan-heemskerk/vim-pydocstring', { 'branch': 'google-style' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-scripts/groovy.vim'
Plug 'wikitopian/hardmode'
Plug 'w0rp/ale'
call plug#end()

" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()

"alias :w !sudo tee % > /dev/null to :Sw to save as sudo
command! -nargs=0 Sw w !sudo tee % > /dev/null


let g:ale_python_flake8_options = '--max-line-length=120'
let g:ale_linters = { 'python': ['pyls', 'flake8'] }
let g:ale_python_pyls_executable = 'python3 /usr/bin/pyls'
let g:ale_python_pyls_config = {
      \   'pyls': {
      \     'plugins': {
      \       'pylint': {
      \         'enabled': v:false
      \       }
      \     }
      \   }
      \ }

" Customize ALE gutter signs (so style (ie. flake8) errors are only warnings)
let g:ale_sign_column_always = 1
let g:ale_sign_style_error = '--'
highlight link ALEStyleErrorSign AleWarningSign

" Sync the unamed register with the clipboard register
" https://stackoverflow.com/a/23947324
set clipboard^=unnamed

" Don't insert anything from autocomplete unless it is actually selected
set completeopt+=noinsert

" End Jordan custome

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

set backupdir=~/.vim_backup,.
set directory=~/.vim_backup,.

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
