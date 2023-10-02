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
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     export EDITOR=/usr/local/bin/vim
#     export VISUAL=/usr/local/bin/vim
# fi
if [[ "$OSTYPE" == "linux"* ]]; then
    export EDITOR=/usr/bin/vim
    export VISUAL=/usr/bin/vim
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

export pATH=$PATH:/data/bin
export PATH="$PATH:/Users/llesz/.dotnet/tools"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$HOME/bin:$PATH"


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
export GOPATH=~/.go
#export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
#export VAGRANT_HOME=$HOME/vagrant/.vagrant

# search brew packages first
#
PATH=/usr/local/bin:$PATH

alias kctl='kubectl -n kube-system'
kubectl () {
    command kubectl $*
    if [[ -z $KUBECTL_COMPLETE ]]
    then
        source <(command kubectl completion zsh)
        KUBECTL_COMPLETE=1 
    fi
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/lukasz.leszczuk/.sdkman"
[[ -s "/Users/lukasz.leszczuk/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/lukasz.leszczuk/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[[ -s "/Users/lukasz.leszczuk/.gvm/scripts/gvm" ]] && source "/Users/lukasz.leszczuk/.gvm/scripts/gvm"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/llesz/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# jwt
decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'=' 
  fi
  echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}

decode_jwt(){
   decode_base64_url $(echo -n $2 | cut -d "." -f $1) | jq .
}

# Decode JWT header
alias jwth="decode_jwt 1"

# Decode JWT Payload
alias jwtp="decode_jwt 2"
