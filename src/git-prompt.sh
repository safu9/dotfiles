#!/bin/zsh

# Git prompt for Zsh
# Originally from:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-prompt


autoload -Uz colors && colors

setopt prompt_subst

# Hook
autoload -U add-zsh-hook
add-zsh-hook precmd update_git_prompt_status

function update_git_prompt_status() {
    unset __CURRENT_GIT_PROMPT

    local git_status
    git_status=$(git status --porcelain=2 --branch 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        # Not a git repository
        __CURRENT_GIT_PROMPT=""
        return
    fi

    local branch=""
    local commit=""
    local ahead=0
    local behind=0
    local indexAdded=0
    local indexDeleted=0
    local indexModified=0
    local workingTreeAdded=0
    local workingTreeDeleted=0
    local workingTreeModified=0
    local conflicting=0

    for line in ${(f)git_status}; do
        if [[ $line == "# branch.head "* ]]; then
            branch=${line[(w)3]}
        elif [[ $line == "# branch.oid "* ]]; then
            commit=${line[(w)3]}
        elif [[ $line == "# branch.ab "* ]]; then
            # "# branch.ab +1 -2"
            ahead=${line[(w)3]#*+}
            behind=${line[(w)4]#*-}
        elif [[ $line == "1"* || $line == "2"* ]]; then
            case ${line[3]} in
                'A') ((indexAdded++)) ;;
                'D') ((indexDeleted++)) ;;
                'M') ((indexModified++)) ;;
                'R') ((indexModified++)) ;;  # Renamed
                'C') ((indexModified++)) ;;  # Copied
                'T') ((indexModified++)) ;;  # Type changed
            esac

            case ${line[4]} in
                'A') ((workingTreeAdded++)) ;;
                'D') ((workingTreeDeleted++)) ;;
                'M') ((workingTreeModified++)) ;;
                'R') ((workingTreeModified++)) ;;
                'C') ((workingTreeModified++)) ;;
                'T') ((workingTreeModified++)) ;;
            esac
        elif [[ $line == "u"* ]]; then
            ((conflicting++))
        elif [[ $line == "?"* ]]; then
            ((workingTreeAdded++))  # Untracked files
        fi
    done

    local prompt

    prompt="${ZSH_THEME_GIT_PROMPT_PREFIX}"

    if ((ahead > 0 && behind > 0)); then
        prompt="${prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_AND_BEHIND_COLOR}"
    elif ((ahead > 0)); then
        prompt="${prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_COLOR}"
    elif ((behind > 0)); then
        prompt="${prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_BEHIND_COLOR}"
    else
        prompt="${prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_COLOR}"
    fi

    if [[ $branch != "" && $branch != "(detached)" ]]; then
        prompt="${prompt}${branch}"
    elif [[ $commit == "(initial)" ]]; then
        prompt="${prompt}${commit}"
    else
        prompt="${prompt}${commit:0:7}"
    fi

    if ((ahead > 0 || behind > 0)); then
        if ((behind > 0)); then
            prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_BEHIND}${behind}"
        fi
        if ((ahead > 0)); then
            prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_AHEAD}${ahead}"
        fi
    else
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_EVEN}"
    fi
    prompt="${prompt}${reset_color}"

    prompt="${prompt}${ZSH_THEME_GIT_PROMPT_INDEX_COLOR}"
    if ((conflicting > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_CONFLICTING}${conflicting}"
    fi
    if ((indexAdded > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_ADDED}${indexAdded}"
    fi
    if ((indexModified > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_MODIFIED}${indexModified}"
    fi
    if ((indexDeleted > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_DELETED}${indexDeleted}"
    fi
    prompt="${prompt}${reset_color}"

    prompt="${prompt}${ZSH_THEME_GIT_PROMPT_WORKING_TREE_COLOR}"
    if ((workingTreeAdded > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_ADDED}${workingTreeAdded}"
    fi
    if ((workingTreeModified > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_MODIFIED}${workingTreeModified}"
    fi
    if ((workingTreeDeleted > 0)); then
        prompt="${prompt} ${ZSH_THEME_GIT_PROMPT_DELETED}${workingTreeDeleted}"
    fi
    prompt="${prompt}${reset_color}"

    prompt="${prompt}${ZSH_THEME_GIT_PROMPT_SUFFIX}"

    __CURRENT_GIT_PROMPT=$prompt
}

git_prompt() {
    if [ -n "$__CURRENT_GIT_PROMPT" ]; then
        echo "$__CURRENT_GIT_PROMPT"
    fi
}

# Theming values
ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_BRANCH_COLOR="${fg[cyan]}"
ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_COLOR="${fg[green]}"
ZSH_THEME_GIT_PROMPT_BRANCH_BEHIND_COLOR="${fg[yellow]}"
ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_AND_BEHIND_COLOR="${fg[red]}"
ZSH_THEME_GIT_PROMPT_INDEX_COLOR="${fg[green]}"
ZSH_THEME_GIT_PROMPT_WORKING_TREE_COLOR="${fg[red]}"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_DELETED="-"
ZSH_THEME_GIT_PROMPT_CONFLICTING="!"
ZSH_THEME_GIT_PROMPT_AHEAD="<"
ZSH_THEME_GIT_PROMPT_BEHIND=">"
ZSH_THEME_GIT_PROMPT_EVEN="="
