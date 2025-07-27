#!/bin/zsh

# Git prompt for Zsh
# Originally from:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git-prompt


autoload -Uz colors && colors

function update_git_prompt() {
    local prompt_prefix=$1
    local prompt_suffix=$2

    local git_status
    local git_exec="git"
    if [[ $(uname -r) == *"WSL"* && $(pwd) == "/mnt/"* ]]; then
        # Workaround for performance issues with WSL
        git_exec="git.exe"
    fi
    git_status=$($git_exec status --porcelain=2 --branch 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        # Not a git repository
        PROMPT="${prompt_prefix}${prompt_suffix}"
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

    local git_prompt

    git_prompt="${ZSH_THEME_GIT_PROMPT_PREFIX}"

    if ((ahead > 0 && behind > 0)); then
        git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_AND_BEHIND_COLOR}"
    elif ((ahead > 0)); then
        git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_COLOR}"
    elif ((behind > 0)); then
        git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_BEHIND_COLOR}"
    else
        git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_BRANCH_COLOR}"
    fi

    if [[ $branch != "" && $branch != "(detached)" ]]; then
        git_prompt="${git_prompt}${branch}"
    elif [[ $commit == "(initial)" ]]; then
        git_prompt="${git_prompt}${commit}"
    else
        git_prompt="${git_prompt}${commit:0:7}"
    fi

    if ((ahead > 0 || behind > 0)); then
        if ((behind > 0)); then
            git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_BEHIND}${behind}"
        fi
        if ((ahead > 0)); then
            git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_AHEAD}${ahead}"
        fi
    else
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_EVEN}"
    fi
    git_prompt="${git_prompt}%{${reset_color}%}"

    git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_INDEX_COLOR}"
    if ((conflicting > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_CONFLICTING}${conflicting}"
    fi
    if ((indexAdded > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_ADDED}${indexAdded}"
    fi
    if ((indexModified > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_MODIFIED}${indexModified}"
    fi
    if ((indexDeleted > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_DELETED}${indexDeleted}"
    fi
    git_prompt="${git_prompt}%{${reset_color}%}"

    git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_WORKING_TREE_COLOR}"
    if ((workingTreeAdded > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_ADDED}${workingTreeAdded}"
    fi
    if ((workingTreeModified > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_MODIFIED}${workingTreeModified}"
    fi
    if ((workingTreeDeleted > 0)); then
        git_prompt="${git_prompt} ${ZSH_THEME_GIT_PROMPT_DELETED}${workingTreeDeleted}"
    fi
    git_prompt="${git_prompt}%{${reset_color}%}"

    git_prompt="${git_prompt}${ZSH_THEME_GIT_PROMPT_SUFFIX}"

    PROMPT="${prompt_prefix}${git_prompt}${prompt_suffix}"
}

# Theming values
ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_BRANCH_COLOR="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_COLOR="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_BRANCH_BEHIND_COLOR="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_BRANCH_AHEAD_AND_BEHIND_COLOR="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_INDEX_COLOR="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_WORKING_TREE_COLOR="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_DELETED="-"
ZSH_THEME_GIT_PROMPT_CONFLICTING="!"
ZSH_THEME_GIT_PROMPT_AHEAD="<"
ZSH_THEME_GIT_PROMPT_BEHIND=">"
ZSH_THEME_GIT_PROMPT_EVEN="="
