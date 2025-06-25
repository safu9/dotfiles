# Zsh configuration

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
fi

export LSCOLORS=exgxfxdxcxegedabagacad

# Completions

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

if [[ "$(uname -s)" == "Darwin" ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Aliases

alias ls='ls --color=auto -G'
alias l='ls --color=auto -G -F'
alias la='ls --color=auto -G -AF'
alias ll='ls --color=auto -G -alhF'
alias grep='grep --color=auto'

alias b='brew'
alias d='docker'
alias g='git'
alias npr='npm run'

# Prompt

source ~/dotfiles/src/git-prompt.sh

PROMPT='%F{blue}%m:%f%F{green}%~%f $(git_prompt)%# '
