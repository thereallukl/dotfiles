#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
source ~/.zsh/kubernetes
autoload -U colors; colors
RPROMPT='%{$fg[cyan]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
# Customize to your needs...
export EDITOR=/usr/local/bin/vim
export VISUAL=/usr/local/bin/vim
alias rsync_git="rsync -avz --exclude '*.git'"
alias grep="grep --color=always"
alias gitk="gitk & disown"

# do not share history across tmux panes
setopt noincappendhistory
setopt nosharehistory

if [[ ! -n $TMUX ]];then
	export TERM=xterm-256color
else
	export TERM=screen-256color
fi

export PATH=$PATH:/data/bin

if [[ -f ~/.openrc ]]; then
    source ~/.openrc
fi
if [[ -f /etc/zsh_command_not_found ]]; then
  source /etc/zsh_command_not_found
fi
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
export PATH=$PATH:/data/bin:$HOME/bin
if [[ -e /usr/local/bin/virtualenvwrapper.sh ]]; then
  source /usr/local/bin/virtualenvwrapper.sh || source /usr/bin/virtualenvwrapper.sh
else
  source /usr/bin/virtualenvwrapper.sh
fi

lrc(){
    start=$(date +%s)
    "$@"
    [ $(($(date +%s) - start)) -le 5 ] || notify-send "Notification" "Long\
 	running command \"$(echo $@)\" took $(($(date +%s) - start)) seconds to finish"
}
# support for sudo + aliases from http://www.zsh.org/mla/users/2008/msg01229.html
alias sudo='noglob do_sudo '
function do_sudo
{
	integer glob=1
	local -a run
	run=( command sudo )
	if [[ $# -gt 1 && $1 = -u ]]; then
		run+=($1 $2)
		shift ; shift
	fi
	(($# == 0)) && 1=/bin/zsh
	while (($#)); do
		case "$1" in
			command|exec|-) shift; break ;;
			nocorrect) shift ;;
			noglob) glob=0; shift ;;
			*) break ;;
		esac
	done
	if ((glob)); then
	    PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $~==*
	else
		PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $==*
	fi
}

my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
        zle backward-delete-word
}
zle -N my-backward-delete-word


bindkey "^R" history-incremental-search-backward
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey '^W' my-backward-delete-word

alias nsudo='nocorrect sudo'
alias lxc-ls='lxc-ls --fancy'
alias ll='ls -alh -G'
#unalias gb
export PATH=~/.local/bin:$PATH
#export VAGRANT_DEFAULT_PROVIDER=libvirt
#export GOROOT=/data/bin/go
#export GOPATH=/home/lukasz/.go
#export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
#export VAGRANT_HOME=$HOME/vagrant/.vagrant

# search brew packages first
#
PATH=/usr/local/bin:$PATH
if [ $(uname) != "Darwin" ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
    if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
        source /usr/local/bin/virtualenvwrapper.sh 
    elif [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
      source /usr/bin/virtualenvwrapper.sh
    fi
else
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
    export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
fi
source ~/.helm_completion
source ~/.kubectl_completion

function getToken
{
  secret=$(kubectl get secret | grep --color=never $1| cut -f1 -d" ")
  # echo $secret
  token=$(kubectl get secret $secret -o yaml | yq .data.token 2>/dev/null | tr -d '"' | base64 -D)
  echo $token
}


alias kctl='kubectl -n kube-system'
alias kovt='kubectl -n medialon-ovt'
alias king='kubectl -n ingress-nginx'
alias knex='kubectl -n nexxis'
