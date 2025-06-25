# Zsh configuration

bindkey -e

setopt auto_cd
setopt extended_glob
setopt glob_dots
setopt share_history

HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_save_no_dups

# Colors

autoload -Uz colors && colors

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export LSCOLORS=gxfxcxdxbxegedabagacad

# Completions

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

if [[ "$(uname -s)" == "Darwin" ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Aliases

alias ls='ls -G'

alias l='ls -F'
alias la='ls -AF'
alias ll='ls -alhF'

alias b='brew'
alias d='docker'
alias g='git'
alias npr='npm run'

# Prompt

PROMPT='%F{blue}%n@%m%f %F{green}%1~%f %# '
