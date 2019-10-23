# ~/.bash_aliases

## Default alias

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

## Custom alias

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

### Shorten commands

alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ...'

alias d='docker'
alias dc='docker-compose'

alias g='git'

### Utils

alias bm='. bm'

alias reload='. ~/.profile'

alias pubip='curl https://ipinfo.io/ip'
alias locip='hostname -I | cut -d" " -f1'
