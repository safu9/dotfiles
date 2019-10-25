#!/bin/bash
# Custom functions

## Simple bookmark

BMRC=~/.bmrc
touch $BMRC

function bm {
    if [ $# -eq 0 ]; then
        # show list
        column -t -s ':' $BMRC | sort -f
    elif [ $# -eq 1 ]; then
        if [[ $1 == -* ]]; then
            # remove bookmark if startswith hyphen
            sed -i "/^${1:1}:/d" $BMRC
            echo 'Bookmark removed.'
        else
            # go to bookmark
            cd $(grep "$1:" $BMRC | cut -d ':' -f 2)
        fi
    elif [ $# -eq 2 ]; then
        sed -i "/^${1}:/d" $BMRC
        echo "$1:$(realpath $2)" >> $BMRC
        echo 'Bookmark added.'
    fi
}

function _bm_completion {
    local curw=${COMP_WORDS[COMP_CWORD]}

    if [[ $curw != -* ]]; then
        local list=$(cut -d ':' -f 1 $BMRC)
    else
        local list=$(cut -d ':' -f 1 $BMRC | sed 's/^/-/')
    fi

    COMPREPLY=($(compgen -W "$list" -- ${curw}))
}
complete -F _bm_completion bm
