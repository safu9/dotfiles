# Zsh configuration

setopt auto_cd
setopt extended_glob
setopt glob_dots
setopt share_history

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt hist_save_no_dups

bindkey "^[[1;5C" forward-word  # Ctrl + Right Arrow
bindkey "^[[1;5D" backward-word  # Ctrl + Left Arrow

# Colors

autoload -Uz colors && colors

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
fi

export LSCOLORS=exgxfxdxcxegedabagacad

# Completions

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

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

autoload -Uz colors && colors

autoload -U add-zsh-hook
add-zsh-hook precmd update_prompt

function update_prompt() {
    local prompt_prefix="%{%F{blue}%}%m:%{%f%}%{%F{green}%}%~%{%f%} "
    local prompt_suffix="%# "

    update_git_prompt "$prompt_prefix" "$prompt_suffix"
}

# Plugins

if [[ "$(uname -s)" == "Linux" ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$(uname -s)" == "Darwin" ]]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

