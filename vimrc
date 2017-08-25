set nocompatible               " be iMproved
filetype off                   " required!

set number  "" Show line numbers
set textwidth=100   "" Line wrap (number of cols)
set showmatch   "" Highlight matching brace
set visualbell  "" Use visual bell (no beeping)

set hlsearch    "" Highlight all search results
set smartcase   "" Enable smart-case search
set ignorecase  "" Always case-insensitive
set incsearch   "" Searches for strings incrementally

set autoindent  "" Auto-indent new lines
set shiftwidth=4    "" Number of auto-indent spaces
set smartindent "" Enable smart-indent
set smarttab    "" Enable smart-tabs
set softtabstop=4   "" Number of spaces per Tab
set mouse=a " enable mouse in all modes
set wildmenu
set report=0
set hlsearch
set incsearch
set cursorline            " Color the cursorline

set undolevels=1000 "" Number of undo levels
set backspace=indent,eol,start  "" Backspace behaviour

set guifont=Monospace\ 9

autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType php let b:surround_45 = "<?php \r ?>"
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
autocmd FileType html,css EmmetInstall
au BufWrite * :Autoformat
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>pnu <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>pnu :call PhpInsertUse()<CR>
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>pne <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>pne :call PhpExpandClass()<CR>
autocmd FileType php inoremap <Leader>pns <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>pns :call PhpSortUse()<CR>


syntax enable
set background=dark
colorscheme valloric
set synmaxcol=256

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Package manager
Plugin 'VundleVim/Vundle.vim'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'jreybert/vimagit'
Plugin 'gisphm/vim-gitignore'

" PHP
Plugin 'shawncplus/phpcomplete.vim'
Bundle 'vim-php/vim-php-refactoring'
Bundle 'vim-php/vim-composer'
Plugin 'alvan/vim-php-manual'
Plugin 'lvht/phpfold.vim'
Plugin '2072/PHP-Indenting-for-VIm'
Plugin '2072/vim-syntax-for-PHP.git'
Plugin 'joonty/vdebug'
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'arnaud-lb/vim-php-namespace'

" WordPress
Plugin 'dsawardekar/wordpress.vim'
Plugin 'salcode/vim-wordpress-dict'
Plugin 'sudar/vim-wordpress-snippets'

" Omni
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'ervandew/supertab'

" Web
Plugin 'othree/html5.vim'
Plugin 'tpope/vim-haml'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'mattn/emmet-vim'
Plugin 'chrisbra/colorizer'
Plugin 'mklabs/grunt.vim'
Plugin 'groenewege/vim-less'
Plugin 'salcode/vim-error-log-shortcut'
Plugin 'Valloric/MatchTagAlways'

" Javascript
Plugin 'nono/jquery.vim'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'moll/vim-node'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'vim-scripts/vim-coffee-script'
Plugin 'mattn/webapi-vim'
Plugin 'elzr/vim-json'
Plugin '1995eaton/vim-better-javascript-completion'
Bundle 'lukaszkorecki/CoffeeTags'

" Code helper
Plugin 'townk/vim-autoclose'
Plugin 'chiel92/vim-autoformat'
Plugin 'thaerkh/vim-indentguides'
Plugin 'tpope/vim-surround'
Plugin 'keith/investigate.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-commentary'

" Misc
Plugin 'SirVer/ultisnips'
Bundle 'Shougo/vimproc'
Plugin 'mhinz/vim-startify'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'troydm/easytree.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-markdown'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'run2cmd/ide.vim'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'tpope/vim-projectionist'
Plugin 'farmergreg/vim-lastplace'
Plugin 'Raimondi/delimitMate'

" Themes
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()

let g:php_refactor_command='php /usr/local/bin/refactor.phar'
let g:phpcomplete_relax_static_constraint = 1
let g:phpcomplete_complete_for_unknown_classes = 0
let g:phpcomplete_search_tags_for_variables = 1
let g:phpcomplete_parse_docblock_comments = 1
let g:phpcomplete_enhance_jump_to_definition = 1
let g:php_refactor_command='/usr/local/bin/refactor.phar'
let g:php_namespace_sort_after_insert=1

let g:airline_theme='murmur'
let g:used_javascript_libs = 'underscore,backbone,vue,react'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%{gutentags#statusline()}

let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 10

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_php_phpcs_args = '--standard=/home/mte90/Desktop/Prog/CodeatCS/codeat.xml'
let g:tagbar_phpctags_memory_limit = '512M'

let g:user_emmet_install_global = 0

let g:javascript_plugin_jsdoc = 1
let g:tagbar_phpctags_bin='~/.vim/phpctags'
let g:lightline = {
    \ 'active': {
    \   'left': [['mode'], ['readonly', 'filename', 'modified'], ['tagbar', 'ale', 'gutentags']],
    \   'right': [['lineinfo'], ['filetype']]
    \ },
    \ 'inactive': {
    \   'left': [['absolutepath']],
    \   'right': [['lineinfo'], ['filetype']]
    \ },
    \ 'component': {
    \   'lineinfo': '%l\%L [%p%%], %c, %n',
    \   'tagbar': '%{tagbar#currenttag("[%s]", "", "f")}',
    \   'ale': '%{ale#statusline#Status()}',
    \   'gutentags': '%{gutentags#statusline("[Generating...]")}'
    \ },
\ }

let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
                            \ '*.phar', '*.ini', '*.rst', '*.md',
                            \ '*vendor/*/test*', '*vendor/*/Test*',
                            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
\ '*var/cache*', '*var/log*']
let g:gutentags_enabled                  = 1
let g:gutentags_generate_on_missing      = 0
let g:gutentags_generate_on_new          = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_define_advanced_commands = 1
let g:gutentags_resolve_symlinks = 1
let g:gutentags_file_list_command = {
      \   'markers': {
      \     '.git': 'git ls-files',
      \     '.hg': 'hg files',
      \   },
\ }
let g:gutentags_cache_dir = '~/.vim/tags/'

autocmd FileType php setlocal makeprg=php\ -l\ %
autocmd FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l
autocmd FileType php let b:delimitMate_excluded_regions = "Comment,String,phpStringDouble,phpHereDoc,phpStringSingle,phpComment"

:map <C-a> GVgg
:map <C-o> :e . <Enter>
:map <C-s> :w <Enter>
:map <C-c> y
:map <C-v> p
:map <C-x> d
:map <C-z> u
:map <C-w> :close <Enter>
:map <C-W> :q! <Enter>
:map <C-f> /
:map <C-h> :%s/
:map <A-s> :norm A;

filetype plugin indent on
filetype plugin on
