" Home tab
let g:startify_bookmarks = [
            \ {'g': '/var/www/VVV/www/glossary/htdocs/wp-content/plugins/glossary/glossary.php'},
            \ {'w': '/var/www/VVV/www/woocommerce/htdocs/wp-content/plugins/woo-fiscalita-italiana/woo-fiscalita-italiana.php'},
            \ {'b': '/var/www/VVV/www/boilerplate/htdocs/wp-content/plugins/'},
            \ {'d': '/var/www/VVV/www/daniele/htdocs/wp-content/themes/daniele.tech-2019/'},
            \ {'c': '/var/www/VVV/www/cmlearning/htdocs/wp-content/plugins/cmlearning/'},
            \ {'o': '/home/mte90/Desktop/Prog/GlotDict/'},
            \ {'s': '/home/mte90/Desktop/Prog/Share-Backported/'}
\]
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Most Recent'] },
          \ { 'type': 'sessions',  'header': ['   Sessions']    },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']   },
          \ { 'type': 'commands',  'header': ['   Commands']    },
\ ]
let g:startify_custom_header = map(split(system('fortune | cowsay -W 90 -f eyes'), '\n'), '" ". v:val')
let g:startify_files_number = 5
let g:startify_padding_left = 5 
