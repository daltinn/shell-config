# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source $HOME/.zshrc.local
source $SHELL_CONFIG_PATH_CUSTOM/zshrc-pre.d/*.zsh

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/snap/bin:/usr/local/bin:/usr/local/go/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$SHELL_CONFIG_PATH_BASE/oh-my-zsh"

ZSH_THEME=powerlevel10k/powerlevel10k

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$SHELL_CONFIG_PATH_BASE/oh-my-zsh-custom

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git 
	ansible
	brew
	compleat
	git-prompt
	ssh-agent
	docker
	docker-compose
	ubuntu
	emoji
	kubectl
	helm
	history-substring-search
	virtualenv
	#virtualenvwrapper
	pyenv
	vi-mode
	tmux
	zsh-syntax-highlighting
	zsh-autosuggestions
	z
	)
# disabled plugin:
# per-directory-history

# ssh-askpass:
zstyle :omz:plugins:ssh-agent agent-forwarding off
#zstyle :omz:plugins:ssh-agent identities id_rsa

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fix color in zsh-autosuggestions
#export TERM=screen-256color

# speedup paste
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# ctrl-backspace remove previous word
bindkey '^H' backward-kill-word
# alt-backspace remove previous word
bindkey '^[' backward-kill-word

bindkey '^[[1;5D' backward-word		# ctrl-left - backward word
bindkey '^[[1;5C' forward-word		# ctrl-rigth - forward word

bindkey '^[[1;3D' backward-word         # alt-left - backward word
bindkey '^[[1;3C' forward-word          # alt-rigth - forward word

#eval "$(_MOLECULE_COMPLETE=source molecule)"


# Set the default kube context if present
DEFAULT_KUBE_CONTEXTS="$HOME/.kube/config"
if test -f "${DEFAULT_KUBE_CONTEXTS}"
then
  export KUBECONFIG="$DEFAULT_KUBE_CONTEXTS"
fi

# Additional contexts should be in ~/.kube/custom-contexts 
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/custom-contexts"
mkdir -p "${CUSTOM_KUBE_CONTEXTS}"

OIFS="$IFS"
IFS=$'\n'
for contextFile in `find -L "${CUSTOM_KUBE_CONTEXTS}" -type f -name "*.yml" -o -name "*.yaml"`  
do
    export KUBECONFIG="$contextFile:$KUBECONFIG"
done
IFS="$OIFS"
# END kube context

###### HISTORY ######
### local and global history
# from https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history
# bindkey "^[[1;5A" up-line-or-history      # [CTRL] + Cursor up
# bindkey "^[[1;5B" down-line-or-history    # [CTRL] + Cursor down
bindkey "^[[1;3A" up-line-or-history        # [ALT] + Cursor up (ALT - Mac compatible, CTRL-Up binded for system)
bindkey "^[[1;3B" down-line-or-history      # [ALT] + Cursor down

bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
    }
zle -N up-line-or-local-history

down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
    }
zle -N down-line-or-local-history
# end local and global history

# history search after type by substring in any place
bindkey "^[[1;6A" history-substring-search-up       # [CTRL] + [Shift] + Cursor up
bindkey "^[[1;6B" history-substring-search-down     # [CTRL] + [Shift] + Cursor down
# history search after type by substring from begining
bindkey "^[[1;5A" history-beginning-search-backward # [CTRL] + Cursor up
bindkey "^[[1;5B" history-beginning-search-forward  # [CTRL] + Cursor down

# disable saving to history for space prafixed command
setopt histignorespace

### end history

alias gstf='git status ; git ls-files -v . | grep "^[Sh]"'

# directory history
setopt pushdsilent
alias dh='dirs -v'

alias kcx=kubectx
alias kns=kubens

# vn for enter ci cmd mode
bindkey -M viins 'vn' vi-cmd-mode
# bindkey -M viins '^[' vi-cmd-mode # using ESC broke line editing hotkeys in insert mode

# expand alias
# autoload -Uz compinit; compinit;
# bindkey "^Xa" _expand_alias
# zstyle ':completion:*' completer _expand_alias _complete _ignored
# zstyle ':completion:*' regular true

# Expand alias with zsh-autosuggestions plugin enabled
expand_aliases() {
    zle autosuggest-clear
    zle _expand_alias
}
zle -N expand_aliases
bindkey "^x" expand_aliases

case `uname` in
  Darwin)
    source $SHELL_CONFIG_PATH_BASE/conf/zshrc_darwin.zsh
  ;;
  Linux)
    # commands for Linux go here
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac

# last lines
source $SHELL_CONFIG_PATH_CUSTOM/zshrc-post.d/*.zsh
autoload -Uz compinit; compinit
