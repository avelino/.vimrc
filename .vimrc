"*****************************************************************************
"                                Basic Setup
"*****************************************************************************
"{{{
" Unleash all VIM power
set nocompatible

" Fix backspace indent
set backspace=indent,eol,start

filetype on
filetype plugin indent on

" Better modes.  Remeber where we are, support yankring
set viminfo=!,'100,\"100,:20,<50,s10,h,n~/.viminfo

" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Enable hidden buffers
set hidden

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,.pyc

" Remember last location in file
if has("autocmd")
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
endif

" GREP
set grepprg=ack

set bomb
set fileencoding=utf-8

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

"}}}



"*****************************************************************************
"                              Visual Settigns
"*****************************************************************************
"{{{
" colorscheme, fonts, menus and etc
set background=dark
syntax on
set ruler
set number

" Menus I like :-)
" This must happen before the syntax system is enabled
aunmenu Help.
aunmenu Window.
let no_buffers_menu=1
set mousemodel=popup
highlight BadWhitespace ctermbg=red guibg=red

if has("gui_running")
    set t_Co=256
    " colorscheme molokai
    colorscheme desert

    " Keep only:
    " * e: GUI Tabs
    " * g: Gray inactive menu items
    " * m: Menu bar
    " * r: Right hand scroll bar
    " * t: tearoff menu items
    set guioptions=egmrt
    set cursorline

    if has("mac")
        set guifont=Consolas:h10
        set fuoptions=maxvert,maxhorz
        " does not work properly on os x
        " au GUIEnter * set fullscreen
    else
        set guifont=DejaVu\ Sans\ Mono\ 10
    endif
else
    colorscheme torte
endif


" Disable the pydoc preview window for the omni completion
set completeopt-=preview

" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

" Status bar
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ %{fugitive#statusline()}

"}}}


"*****************************************************************************
"                               Abbreviations
"*****************************************************************************
"{{{
" no one is really happy until you have this shortcuts
cab W! w!
cab Q! q!
cab Wq wq
cab Wa wa
cab wQ wq
cab WQ wq
cab W w
cab Q q

"}}}


"*****************************************************************************
"                                 Variables
"*****************************************************************************
"{{{
" Conf Avelino
let g:snips_author = "Thiago Avelino"

" python support
" --------------
"  don't highlight exceptions and builtins. I love to override them in local
"  scopes and it sucks ass if it's highlighted then. And for exceptions I
"  don't really want to have different colors for my own exceptions ;-)
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

let html_no_rendering=1
let javascript_enable_domhtmlcss=1
let c_no_curly_error=1

let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'

" NERDTree configuration
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeShowBookmarks=1

" Command-T configuration
let g:CommandTMaxHeight=20

" FindFile
let g:FindFileIgnore = ['*.o', '*.pyc', '*.py~', '*.obj', '.git', '*.rbc', '*/tmp/*'] 

"}}}


"*****************************************************************************
"                                  Function
"*****************************************************************************
"{{{
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('')
    finally
       let &ic = ic
    endtry
endfun

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  noremap <buffer> <Leader>p :Mm <CR>
endfunction

" GUI Tab settings
function! GuiTabLabel()
    let label = ''
    let buflist = tabpagebuflist(v:lnum)
    if exists('t:title')
        let label .= t:title . ' '
    endif
    let label .= '[' . bufname(buflist[tabpagewinnr(v:lnum) - 1]) . ']'
    for bufnr in buflist
        if getbufvar(bufnr, '&modified')
            let label .= '+'
            break
        endif
    endfor
    return label
endfunction
set guitablabel=%{GuiTabLabel()}

"}}}


"*****************************************************************************
"                               Autocmd Rules
"*****************************************************************************
"{{{
" Some minor or more generic autocmd rules
" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart
" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" less comprez
autocmd BufNewFile,BufRead *.less set filetype=less
" txt
au BufRead,BufNewFile *.txt call s:setupWrapping()
" make use real tabs
au FileType make set noexpandtab


"********** Python 
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=110
      \ formatoptions+=croq softtabstop=4 smartindent
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 
      \smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd BufRead,BufNewFile *.py,*pyw set shiftwidth=4
autocmd BufRead,BufNewFile *.py,*.pyw set expandtab
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/
autocmd BufNewFile *.py,*.pyw set fileformat=unix
autocmd BufWritePre *.py,*.pyw normal m`:%s/\s\+$//e``
autocmd BufRead *.py,*.pyw set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
" code completion
autocmd FileType python set omnifunc=pythoncomplete#Complete

"********** Go 
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4

"********** PHP 
autocmd FileType php setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab

"********** Verilog 
autocmd FileType verilog setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

"********** HTML 
autocmd BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako,haml,daml,css,tmpl setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html,htmldjango,htmljinja,eruby,mako,haml,daml let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako,haml,daml source ~/.vim/scripts/closetag.vim
" code completion
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


"********** C/Obj-C/C++
autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79
autocmd FileType objc setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab colorcolumn=79

"********** vim
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType vim setlocal foldenable foldmethod=marker

"********** Javascript
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 colorcolumn=79
autocmd BufNewFile,BufRead *.json setlocal ft=javascript
" code completion
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

"********** Cmake
autocmd BufNewFile,BufRead CMakeLists.txt setlocal ft=cmake

"********** Ruby
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

"********** Markdown
" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()


"}}}




"*****************************************************************************
"                                  Mappings
"*****************************************************************************
"{{{

" Python Execution
noremap <C-K> :!python<CR>
noremap <C-L> :!python %<CR>

" Split Screen
noremap <Leader>h :split<CR>
noremap <Leader>v :vsplit<CR>

" Git
noremap <Leader>ga :!git add .<CR>
noremap <Leader>gc :!git commit -m '<C-R>="'"<CR>
noremap <Leader>gsh :!git push<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" ConqueTerm Shortcut
noremap <Leader>sh :ConqueTerm bash --login<CR>

" Paste to DPaste: http://dpaste.com/
noremap <Leader>p :Dpaste<CR>

" NerdTree shortcuts
noremap <Leader>n :NERDTreeToggle<CR>
noremap <Plug> :NERDTreeToggle<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
noremap <F3> :NERDTreeToggle<CR>

" ZoomWin configuration
noremap <Leader>z :ZoomWin<CR>

" Tabs shortcuts
noremap th :tabnext<CR>
noremap t] :tabnext<CR>
noremap tl :tabprev<CR>
noremap t[ :tabprev<CR>
noremap tn :tabnew<CR>
noremap tc :tabclose<CR>
noremap td :tabclose<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Bubble single lines
nnoremap <C-Up> [e
nnoremap <C-Down> ]e

" Bubble multiple lines
vnoremap <C-Up> [egv
vnoremap <C-Down> ]egv

" Gundo Toggler
nnoremap <Leader>u :GundoToggle<CR>
noremap <leader>c :GundoToggle<CR>

" Tag Code Navigation
nnoremap <Leader>f :TagbarToggle<CR>

" Find file
nnoremap <C-f> :FF<CR>
nnoremap <C-s> :FS<CR>
nnoremap <C-c> :FC .<CR>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Rope
noremap <leader>j :RopeGotoDefinition<CR>
noremap <leader>r :RopeRename<CR>

" Grep
noremap <leader>g :Ack <C-R>=""<CR>
noremap <leader>b :b <C-R>=""<CR>

"}}}


" TODO: Take a look at this
nnoremap   :call MatchCaseTag()
