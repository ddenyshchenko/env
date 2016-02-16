TERM=xterm-256color
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=yes
    fi
fi

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	PS1='\[\e[1;31m\][\A]\[\e[2;33m\]\u@\[\e[2;32m\]\h:\[\e[1;34m\]\w\$\[\e[0m\] '
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


# ssh-agent
if [ -f ~/.agent.env ] ; then
    . ~/.agent.env > /dev/null
if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
    echo "Stale agent file found. Spawning new agent… "
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi
else
    echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi

# enable color support of ls and also add handy aliases


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l -h -a'
alias la='ls -A -h'
alias l='ls -CF -h'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#my

export PATH="$HOME/.local/bin:$PATH"


alias wd='cd ~/wd'
alias ri='cd ~/wd/ri'
alias ingit='cd ~/wd/git.intropro'
alias dev='cd ~/wd/dev'

#function srvAlias () {
#ssh $1
#}

#eval "`dircolors -b $HOME/.lscolors`"

#function srvAlias () {
#  PWFILE='/home/dan/wd/ri/pw'
#  gpg ${PWFILE}.gpg
#	if [ -e ${PWFILE} ]; then
#		if [ "$(grep $1 ${PWFILE} -A 3 | grep Password | uniq | awk '{print $2}')" = "AD"  ]
#			then
#			grep ActiveDirectory ${PWFILE} -A 3 | grep Password | uniq | awk '{print $2}' | xclip -i
#			else
#			grep $1 ${PWFILE} -A 3 | grep Password | uniq | awk '{print $2}' | xclip -i
#		fi
#    rm $PWFILE
#
#	ssh -Y -F ~/.ssh/config $1
#	fi
#}

#function ssh_log () {
#if test ! -d /home/srv/logs/${1}; then mkdir /home/dan/srv/logs/${1}; fi
#script -af /home/dan/srv/logs/${1}/${1}-$(date '+%d-%B-%Y-%H_%M_%S') -c "ssh -Y -F ~/.ssh/config $1"
#}

#function ssh_log () {
#  PWFILE='/home/dan/wd/ri/pw'
#  gpg ${PWFILE}.gpg
#    if [ -e ${PWFILE} ]; then
#    grep $1 ${PWFILE} -A 3 | grep Password | uniq | awk '{print $2}' | xclip -i
#    rm $PWFILE
#if test ! -d /home/dan/srv/logs/${1}; then mkdir /home/dan/srv/logs/${1}; fi
#script -af /home/dan/srv/logs/${1}/${1}-$(date '+%d-%B-%Y-%H_%M_%S') -c "ssh -Y -F ~/.ssh/config $1"
#
#        fi
#}

#for i in $(grep Hostname ~/.ssh/config | awk '{print $2}')
#for i in $(cat /home/dan/win/wd/ri/servers_list | grep -v "#")
#do alias $i="ssh $i"
#alias sshlog_$i=""
#done

servers=`cat ~/.ssh/known_hosts | awk '{print $1}' | awk -F "," '{print $1}' | grep -v -e 172 -e 192 -e 91 -e 10.10 | grep -v -e "big-" -e docker-reg | sort`
bigserver=`cat ~/.ssh/known_hosts | awk '{print $1}' | awk -F "," '{print $1}' | grep -v -e 172 -e 192 -e 91 -e 10.10 | grep -e "big-" -e docker-reg | sort`

for i in $servers
do alias $i="ssh $i"
done

for i in $bigserver
    do
        alias $i="ssh -l big $i -p 8822"
        alias $i.8822="ssh -l bigdata $i"
done


complete -o default -W "$servers $bigserver" ssh
complete -o default -W "$servers $bigserver" scp
complete -W "$servers $bigserver" ping
complete -W "$servers $bigserver" telnet
complete -W "$servers $bigserver" nslookup
complete -W "$servers $bigserver" host

# grc
#alias cat='grc cat'
#alias ping='grc ping'




#export http_proxy=http://
#export https_proxy=http://
#export ftp_proxy=http://
#export use_proxy=on

dockerattach() {
  docker exec -it $1 bash
}

dockerip() {
  docker inspect -f "{{ .NetworkSettings.IPAddress }}" $1
}

connectviassh() {
	echo sshfs dan@$(hostname -I | awk '{print $1}'):$(pwd)
}

complete -W "$(docker ps | awk '{print $NF}' | grep -v NAMES)" dockerattach dockerip

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1

if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
	    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi

# disable hang on ctrl+s
stty -ixon
