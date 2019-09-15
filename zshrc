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
autoload -U colors; colors
# Customize to your needs...
if [[ "$OSTYPE" == "darwin"* ]]; then
    export EDITOR=/usr/local/bin/vim
    export VISUAL=/usr/local/bin/vim
fi
alias rsync_git="rsync -avz --exclude '*.git'"
alias grep="grep --color=always"
alias gitk="gitk & disown"
alias tmux="tmux -u"
# do not share history across tmux panes
#setopt noincappendhistory
#setopt nosharehistory

#if [[ ! -n $TMUX ]];then
#	export TERM=xterm-256color
#else
#	export TERM=screen-256color
#fi

export PATH=$PATH:/data/bin

if [[ -f ~/.openrc ]]; then
    source ~/.openrc
fi
if [[ -f /etc/zsh_command_not_found ]]; then
  source /etc/zsh_command_not_found
fi
export PATH=$PATH:/data/bin:$HOME/bin

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

# fix home / end keys
if [[ $OSTYPE == "darwin"* ]]; then
    bindkey "^[[H" beginning-of-line
    bindkey "^[[F" end-of-line
fi

bindkey "^R" history-incremental-search-backward
bindkey "^[b" forward-word
bindkey "^[f" backward-word
bindkey '^W' my-backward-delete-word

alias nsudo='nocorrect sudo'
alias lxc-ls='lxc-ls --fancy'
alias ll='ls -alh -G'
#unalias gb
export PATH=~/.local/bin:$PATH
#export VAGRANT_DEFAULT_PROVIDER=libvirt
#export GOROOT=/data/bin/go
export GOPATH=/home/lukasz/go
#export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
#export VAGRANT_HOME=$HOME/vagrant/.vagrant

# search brew packages first
#
PATH=/usr/local/bin:$PATH

alias kctl='kubectl -n kube-system'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/lukasz.leszczuk/.sdkman"
[[ -s "/Users/lukasz.leszczuk/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/lukasz.leszczuk/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[[ -s "/Users/lukasz.leszczuk/.gvm/scripts/gvm" ]] && source "/Users/lukasz.leszczuk/.gvm/scripts/gvm"
