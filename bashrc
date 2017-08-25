# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -h'

    alias grep='grep --color=auto --exclude-dir=\.git'
fi


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# CD stuff
alias casa='cd /home/mte90/Desktop'
alias www='cd /var/www'
alias vvv='cd /var/www/VVV/www'
alias back='cd "$OLDPWD"'
alias wpp='cd ./htdocs/wp-content/plugins 2>/dev/null;cd ./wp-content/plugins 2>/dev/null'
alias wpt='cd ./htdocs/wp-content/themes 2>/dev/null;cd ./wp-content/themes 2>/dev/null'
# Misc
alias biggest='BLOCKSIZE=1048576; du -x -h | sort -nr | head -10'
alias yt2mp3='youtube-dl -l --extract-audio --audio-format=mp3 -w -c'
alias kate='kate -b'
# dev
# https://github.com/gleitz/howdoi
alias howdoi='howdoi -c'
alias phpdoc='phpcs -p -d memory_limit=512M --ignore=*composer*,*.js,*.css,*vendor*,*/lib,index.php,*tests*,*config* --standard=PHPDoc ./'
alias phpdoccbf='phpcbf -p -d memory_limit=512M --ignore=*composer*,*.js,*.css,*vendor*,*/lib,index.php,*tests*,*config* --standard=PHPDoc ./'
alias qafoo='/opt/QualityAnalyzer/bin/analyze --exclude=lib,composer,node_modules'
export PATH=./vendor/bin:$PATH
export PATH=./composer/bin:$PATH
export PATH=~/.composer/vendor/bin:$PATH

up(){ DEEP=$1; [ -z "${DEEP}" ] && { DEEP=1; }; for i in $(seq 1 ${DEEP}); do cd ../; done; }

function mkcd(){ mkdir -p $@ && cd $_; }

function vvv-debug(){
    log="/var/www/VVV/www/$1/htdocs/wp-content/debug.log"
    if [ -f $log ]; then
        actualsize=$(du -k $log | cut -f 1)
        if [ $actualsize -ge 300 ]; then
            rm $log;
        fi
    fi
    echo "" > $log
    multitail -cS php -m 600 /var/www/VVV/www/$1/htdocs/wp-content/debug.log;
}


# https://github.com/github/hub
if [ -f /hub.bash_completion ]; then
    . /hub.bash_completion
fi
# For Git
eval "$(hub alias -s)"
alias git-commit-rename='git commit --amend'
alias git-remove-last-commit='git reset --soft HEAD~1'
alias git-pass='ssh-add -t 36000'
alias gpm="git push origin master"
alias git-restage="git update-index --again"
# add and remove new/deleted files from git index automatically
alias gitar="git ls-files -d -m -o -z --exclude-standard | xargs -0 git update-index --add --remove"
function git-merge-last-commit() { git reset --soft HEAD~$1 && git commit; }
function commit() { commit=$(kdialog --title 'Commit message' --inputbox 'Insert the commit' '') && git commit -m "$commit" && echo "$commit"; }
alias svn-revert='svn cleanup & svn cleanup &  sqlite3 .svn/wc.db "delete from work_queue" && svn revert --recursive .'

# https://github.com/riobard/bash-powerline
. ~/.bash_powerline

# https://github.com/dvorka/hstr
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=1000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi

