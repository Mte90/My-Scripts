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
alias phpdoc='phpcs -d memory_limit=512M --ignore=*cmb*,index.php,*.js,WP_*,CPT_*,*.css --standard=PHPDoc'
alias phpdoccbf='phpcbf -d memory_limit=512M --ignore=*cmb*,index.php,*.js,WP_*,CPT_* --standard=PHPDoc'
alias git-pass='ssh-add -t 36000'
alias svn-revert='svn revert --recursive .'

function mkcd(){ mkdir -p $@ && cd $_; }

function vvv-debug-tail(){ tail -f /var/www/VVV/www/$1/htdocs/wp-content/debug.log; }

alias vvv-debug=vvv-debug-tail

# Bash completion for Yeoman generators - tested in Ubuntu, OS X and Windows (using Git bash)
function _yo_generator_complete_() {
	# local node_modules if present
	local local_modules=$(if [ -d node_modules ]; then echo "node_modules:"; fi)
	# node_modules in /usr/local/lib if present
	local usr_local_modules=$(if [ -d /usr/local/lib/node_modules ]; then echo "/usr/local/lib/node_modules:"; fi)
	# node_modules in user's Roaming/npm (Windows) if present
	local win_roam_modules=$(if [ -d $(which yo)/../node_modules ]; then echo "$(which yo)/../node_modules:"; fi)
	# concat and also add $NODE_PATH
	local node_dirs="${local_modules}${usr_local_modules}${win_roam_modules}${NODE_PATH}"
	# split $node_dirs and return anything starting with 'generator-', minus that prefix
	local generators_all=$(for dir in $(echo $node_dirs | tr ":" "\n"); do command ls -1 $dir | grep ^generator- | cut -c11-; done)
	# get the word fragment
	local word=${COMP_WORDS[COMP_CWORD]}
	# don't attempt to filter w/`grep` if `$word` is empty
	local generators_filtered=$(if [ -z "$word" ]; then echo "$generators_all"; else echo "$generators_all" | grep $word; fi)
	
	COMPREPLY=($generators_filtered)
	}
complete -F _yo_generator_complete_ yo

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
