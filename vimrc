" not load for tiny vi
if !1 | finish | endif

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
set report=0
set hlsearch
set incsearch
set cursorline            " Color the cursorline
set undolevels=1000 "" Number of undo levels
set backspace=indent,eol,start  "" Backspace behaviour
set nobackup
set nowb
set noswapfile
set hidden
set ignorecase
set smartcase
set number
set guifont=DroidSansMono\ Nerd\ Font\ 11
set encoding=utf-8
set laststatus=2
set t_Co=256
set background=dark
set synmaxcol=256
set updatetime=250
set ai
set sw=4
set showtabline=2
" Set the file path as pwd
set autochdir
" Set global replacement as the default
set gdefault
" Better wrapping with indentation
set breakindent
set showbreak=\\\\\
set wildmenu
colorscheme valloric
syntax enable

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Package manager
Plugin 'VundleVim/Vundle.vim'
" display the result when searching
Plugin 'henrik/vim-indexed-search'
" wrapper for git and display git diff in the left gutter
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
" surrounding with whatever you want (paranthesis, quotes...)
Plugin 'tpope/vim-surround'
" easily search, substitute and abbreviate multiple version of words
Plugin 'tpope/vim-abolish'
" Match more stuff with % (html tag, LaTeX...)
Plugin 'tmhedberg/matchit'
" General autocomplete system
Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'roxma/nvim-yarp'
" startify for startup cow
Plugin 'mhinz/vim-startify'
" snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'sniphpets/sniphpets'
Plugin 'sniphpets/sniphpets-common'
" markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" php autocompletion engine and tools
Plugin 'padawan-php/padawan.vim'
Plugin 'padawan-php/deoplete-padawan'
Plugin 'StanAngeloff/php.vim'
" Plugin 'rayburgemeestre/phpfolding.vim'
Plugin 'arnaud-lb/vim-php-namespace'
Plugin '2072/vim-syntax-for-PHP.git'
Plugin 'nishigori/vim-php-dictionary'
 Plugin '2072/PHP-Indenting-for-VIm'
" php doc autocompletion
Plugin 'tobyS/vmustache' | Plugin 'tobyS/pdv'
" Syntax highlighting for vue js framework
Plugin 'posva/vim-vue'
" autoclose bracket and parenthesis when open
Plugin 'Townk/vim-autoclose'
" debugger, https://github.com/joonty/vdebug/pull/316
Plugin 'joonty/vdebug'
" object view
Plugin 'majutsushi/tagbar'
if !has('gui_running')
    Plugin 'ap/vim-buftabline'
endif
" Nerdtree + modifications: git icons plugin, color filetype plugin
Plugin 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Bundle 'jistr/vim-nerdtree-tabs'
" status bar
Plugin 'itchyny/lightline.vim'
" Tags are very important
Plugin 'ludovicchabant/vim-gutentags'
" undo tree
Plugin 'sjl/gundo.vim'
" registers
Plugin 'vim-scripts/YankRing.vim'
if !has('gui_running')
    " fzf - poweful search
    Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plugin 'junegunn/fzf.vim'
endif
" allow multisearch in current directory / multi replace as well
Plugin 'wincent/ferret'
" display the hexadecimal colors - useful for css and color config
Plugin 'ap/vim-css-color'
" Search stuff, helpful on editing
Plugin 'ctrlpvim/ctrlp.vim'
" WordPress
Plugin 'dsawardekar/wordpress.vim'
Plugin 'salcode/vim-wordpress-dict'
Plugin 'sudar/vim-wordpress-snippets'
" Echo error_log/console.error_log
Plugin 'salcode/vim-error-log-shortcut'
" Web
Plugin 'othree/html5.vim'
Plugin 'tpope/vim-haml'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'mattn/emmet-vim'
Plugin 'chrisbra/colorizer'
Plugin 'mklabs/grunt.vim'
Plugin 'groenewege/vim-less'
Plugin 'Valloric/MatchTagAlways'
Plugin 'othree/csscomplete.vim'
" close tags on </
Plugin 'docunext/closetag.vim'
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
Plugin 'lukaszkorecki/CoffeeTags'
" Align code
Plugin 'tommcdo/vim-lion'
" Cool icons"
Plugin 'ryanoasis/vim-devicons'
" Report lint errors
Plugin 'w0rp/ale'
Plugin 'maximbaz/lightline-ale'
" Wakatime
Plugin 'wakatime/vim-wakatime'
" Misc
Plugin 'editorconfig/editorconfig-vim'
Plugin 'wincent/terminus'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdcommenter'
call vundle#end()

" Add support of stuff on different files
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
autocmd FileType php.wordpress setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType php let b:surround_45 = "<?php \r ?>"
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Alias for git add
autocmd User fugitive command! -bar -buffer -nargs=* Gadd :Gwrite <args>
" nerdtree configuration
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    if (expand("%:t") != '')
      exe ":NERDTreeFind"
    else
      exe ":NERDTreeToggle"
    endif
  endif
endfunction
"  don't display informations (type ? for help and so on)
let g:NERDTreeMinimalUI = 1
"  don't replace the native vim file explorer
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowBookmarks = 0
let g:NERDTreeCascadeOpenSingleChildDir = 1
:let g:NERDTreeWinSize=35
"  change the arrows
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
if !has('gui_running')
    " Open by default
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    autocmd StdinReadPre * let s:std_in=1
endif
"  ignore files
let NERDTreeIgnore = ['\.pyc$', '__init__.py', '__pycache__','.sass*','composer','node_modules']
" Webdevicons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let entry_format = "'   ['. index .']'. repeat(' ', (3 - strlen(index)))"
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
if exists('*WebDevIconsGetFileTypeSymbol')  " support for vim-devicons
  let entry_format .= ". WebDevIconsGetFileTypeSymbol(entry_path) .' '.  entry_path"
else
  let entry_format .= '. entry_path'
endif
" fzf for search files
if !has('gui_running')
    autocmd VimEnter * command! -nargs=* Ag call fzf#run({
    \ 'source':  printf('ag -U --nogroup --column --color "%s"',
    \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
    \ 'sink*':    function('<sid>ag_handler'),
    \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
    \            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
    \            '--color hl:68,hl+:110',
    \ 'down':    '50%'
    \ })

    autocmd VimEnter * command! -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \ <bang>0)
endif
" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1
"  deoplete tab-complete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
let g:deoplete#file#enable_buffer_path = 1
"  Compatibility with phpcomplete
let g:deoplete#omni_patterns = {}
let g:deoplete#sources = {}
let g:deoplete#sources.php = ['padawan', 'ultisnips', 'buffer']
"  delay for auto complete and refresh
let g:deoplete#auto_complete_delay= 75
let g:deoplete#auto_refresh_delay= 5
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
"  compatibility with phpcd
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']
" CtrlP
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn))$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }

" vdebug
let g:vdebug_options = {}
let g:vdebug_options["port"] = 9000
let g:vdebug_options["ide_key"] = "VVVDEBUG"
let g:vdebug_keymap = {
\    "run" : "<F5>",
\    "run_to_cursor" : "<F9>",
\    "step_over" : "<F2>",
\    "step_into" : "<F3>",
\    "step_out" : "<F4>",
\    "close" : "<F6>",
\    "detach" : "<F7>",
\    "set_breakpoint" : "<F10>",
\    "get_context" : "<F11>",
\    "eval_under_cursor" : "<F12>",
\    "eval_visual" : "<F8>",
\}
let g:vdebug_options["path_maps"] = {
\       "/srv/www/runexp": "/home/www/VVV/www/runexp",
\       "/srv/www/woocommerce": "/home/www/VVV/www/woocommerce",
\       "/srv/www/glossary": "/home/www/VVV/www/glossary",
\       "/srv/www/demo": "/home/www/VVV/www/demo"
\}
"  redefine the characters
autocmd VimEnter * sign define breakpt text= texthl=DbgBreakptSign linehl=DbgBreakptLine
autocmd VimEnter * sign define current text= texthl=DbgCurrentSign linehl=DbgCurrentLine
" GutenTags
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
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
                            \ '*.phar', '*.ini', '*.rst', '*.md',
                            \ '*vendor/*/test*', '*vendor/*/Test*',
                            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
\ '*var/cache*', '*var/log*']
let g:gutentags_cache_dir = '~/.vim/tags/'
" A better line
let g:lightline = {
    \ 'active': {
    \   'left': [['mode', 'paste'], ['readonly', 'filename', 'modified'], ['tagbar', 'gitbranch']],
    \   'right': [['lineinfo'], ['filetype'], [ 'linter_errors', 'linter_warnings', 'linter_ok' ]]
    \ },
    \ 'inactive': {
    \   'left': [['mode', 'paste'], ['readonly', 'filename', 'modified'], ['tagbar', 'gitbranch']],
    \   'right': [['lineinfo'], ['filetype']]
    \ },
    \ 'component': {
    \   'lineinfo': '%l\%L [%p%%]',
    \   'tagbar': '%{tagbar#currenttag("[%s]", "", "f")}',
    \   'gitbranch': '%{&filetype=="help"?"":exists("*fugitive#head")?fugitive#head():""}'
    \ },
    \ 'component_function': {
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \ }
\ }
function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
let g:lightline.component_expand = {
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \ }
" Home tab
let g:startify_bookmarks = [
            \ {'1': '/var/www/VVV/www/glossary/htdocs/wp-content/plugins/glossary/glossary.php'},
            \ {'2': '/var/www/VVV/www/woocommerce/htdocs/wp-content/plugins/woo-fiscalita-italiana/woo-fiscalita-italiana.php'},
            \ {'3': '/var/www/VVV/www/boilerplate/htdocs/wp-content/plugins/'},
            \ {'4': '/var/www/VVV/www/runexp/htdocs/wp-content/plugins/crm-runningexperience/'},
            \ {'5': '/home/mte90/Desktop/Prog/GlotDict/'},
            \ {'6': '/home/mte90/Desktop/Prog/Share-Backported/'}
\]
" Emmett
let g:user_emmet_install_global = 1
" PhpDoc
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
" Padawan stuff
let g:padawan#cli = '/opt/padawan/padawan.php/bin/padawan'
let g:padawan#server_command = '/opt/padawan/padawan.php/bin/padawan-server'
"  Run with vim
:call padawan#StartServer()
" Buftabline
if !has('gui_running')
    let g:buftabline_numbers = 2
endif
" Ultisnip
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
" JS smart complete
let g:vimjs#smartcomplete = 1
" Ale linting (installed on system: phpmd, phpcs, coffeelint, sass-lint, htmlhint, prettier)
let g:ale_php_phpcs_standard  = '/home/mte90/Desktop/Prog/CodeatCS/codeat.xml'
let g:ale_sign_error = 'EE'
let g:ale_sign_warning = 'WW'
let g:ale_change_sign_column_color = 1
" php
:let g:PHP_autoformatcomment = 1
" Indent lines
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1
" Nerdcommenter
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
" Align text around a chosen character
let g:lion_squeeze_spaces = 1

" Hotkeys
" Select all
:map <C-a> GVgg
" Save file
:map <C-s> :w <Enter>
" Copy
:map <C-c> y
" Paste
:map <C-v> p
" Cut
:map <C-x> d
" Back
:map <C-z> u
" Replace
:map <C-r> :Ack
" close tab
:map <C-w> :close <Enter>
" Search in the file
:map <C-t> /
" Search in the project files
nnoremap <leader>a :Rg<space>
" Search all
:map <C-h> :%s/
" Open Folder tab current directory
nmap <leader>n :call NERDTreeToggleInCurDir()<CR>
" Open folder tab
:map <C-p> :NERDTreeTabsToggle<CR>
" To search on history with fuzzy
nmap <leader>h :History<cr>
" View all the files
nmap <leader>b :Buffers<cr>
" Search in all the files
nmap <leader>f :Files<cr>
" Object view
nmap <F8> :TagbarToggle<CR>
" Undo tree tab
nnoremap <F5> :GundoToggle<CR>
if !has('gui_running')
    " Switch buffers
    nmap <leader>1 <Plug>BufTabLine.Go(1)
    nmap <leader>2 <Plug>BufTabLine.Go(2)
    nmap <leader>3 <Plug>BufTabLine.Go(3)
    nmap <leader>4 <Plug>BufTabLine.Go(4)
    nmap <leader>5 <Plug>BufTabLine.Go(5)
    nmap <leader>6 <Plug>BufTabLine.Go(6)
    nmap <leader>7 <Plug>BufTabLine.Go(7)
    nmap <leader>8 <Plug>BufTabLine.Go(8)
    nmap <leader>9 <Plug>BufTabLine.Go(9)
    nmap <leader>0 <Plug>BufTabLine.Go(10)
endif
" Format code
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
" Vim PHP format
nmap <C-f> <ESC>gg=G<CR>
" Emmett
let g:user_emmet_leader_key='<C-E>' " require also a comma ,
" navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Toggle comments
nmap <C-d> <plug>NERDCommenterToggle<CR>
" Align =
nmap <C-=> <ESC>gl=<CR>

" C = Ctrl
" leader = \
" <leader>el for error_log/console.log
" On visual mode . repeat the last thing you done in edit mode
" * highlitght the word where it is your cursor
" :e and write the path

:filetype plugin indent on
:filetype plugin on
:filetype indent on
