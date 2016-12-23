#Mte90 user
alias casa='cd /home/mte90/Desktop'
alias www='cd /var/www'
alias yt2mp3='youtube-dl -l --extract-audio --audio-format=mp3 -w -c'
alias kate='kate -b'
alias wpp='cd ./wp-content/plugins'
alias wpt='cd ./wp-content/themes'
alias howdoi='howdoi -c'
alias git-commit-rename='git commit --amend'
alias git-remove-last-commit='git reset --soft HEAD~1'
alias phpdoc='phpcs -p -d memory_limit=512M --ignore=*composer*,*.js,*.css,*/lib --standard=PHPDoc ./'
alias phpdoccbf='phpcbf -p -d memory_limit=512M --ignore=*composer*,*.js,*.css,*/lib --standard=PHPDoc ./'
alias git-pass='ssh-add -t 36000'
alias git=hub
alias svn-revert='svn revert --recursive .'
export PATH=./vendor/bin:$PATH
export PATH=~/.composer/vendor/bin:$PATH

function mkcd(){ mkdir -p $@ && cd $_; }

function vvv-debug(){ tail -f /var/www/VVV/www/$1/htdocs/wp-content/debug.log; }

function git-merge-last-commit() { git reset --soft HEAD~$1 && git commit; }

function commit() { commit=$(kdialog --title 'Commit message' --inputbox 'Insert the commit' '') && git commit -m $commit; }

#Root

export XAUTHORITY=/home/mte90/.Xauthority
export $(dbus-launch)

alias update='apt update'
alias upgrade='apt upgrade'
alias aptforce='apt -o Dpkg::Options::=--force-overwrite install'
alias search='apt search'
alias policy='apt-cache policy'
alias deb64='dpkg --force-architecture -i'
alias apts='(kate /etc/apt/sources.list &)'
alias casa='cd /home/mte90/Desktop'
alias www='cd /var/www'
function mkcd(){ mkdir -p $@ && cd $_; }

echo -e '\e[1;31m';
echo "  ______  _____   _____  _______";
echo " |_____/ |     | |     |    |";
echo " |    \_ |_____| |_____|    |";
echo -e '\e[m';
