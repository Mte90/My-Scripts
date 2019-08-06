#!/bin/sh

# How to use the script:
#     cat list.txt | xargs -n1 convert-to-redirect.sh

strip='https\:\/\/domain.tld'
redirect='https\:\/\/domain2.tld\/'
redirectmatch_htaccess='Redirect 301 '
redirect_htaccess=$(echo "/ $redirect" | tr '\n' ' ')

sed "s/$strip/$redirectmatch_htaccess/g;s/.$/$redirect_htaccess/;" list.txt > htaccess_redirect
