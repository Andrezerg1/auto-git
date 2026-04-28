#!/usr/bin/env bash

function exit_exception(){
    if [ $? -eq 130 ]; then
        echo "Exiting..."
        exit 1
    fi
}

function switch_branc(){
    selected=$(git branch --format="%(refname:short)" | fzf --height 40% --layout=reverse --border\
    --preview "git -c color.ui=always log --oneline $(echo {})" --color bg:#222222
    )

    exit_exception    

    echo "Branch selecionada: [$selected]"

    git switch "$selected"
}

function merge(){
    selected=$(git branch --format="%(refname:short)" | fzf --height 100% --layout=reverse --border\
    --preview "git -c color.ui=always diff $(git branch | grep "^*" | tr -d "* " )" --color bg:#222222
    )

    exit_exception    

    echo "Branch selecionada: [$selected]"

    git merge "$selected"
}

function delete_branch(){
    selected=$(git branch --format="%(refname:short)" | fzf --height 40% --layout=reverse --border\
    --preview "git -c color.ui=always log --oneline $(echo {})" --color bg:#222222
    )

    exit_exception    

    echo "Branch selecionada: [$selected]"

    git branch -d "$selected"
}

function main(){
    
    options=(\
        "1 - Switch branch" \
        "2 - Git merge" \
        "3 - Deletar branch" \
        "Exit" \
    )
    selected=$( for opt in "${options[@]}"; do echo "$opt" ; done | fzf +m )
    selected=$(git branch --format="%(refname:short)" | fzf --height 40% --layout=reverse --border \
    --preview "git -c color.ui=always log --oneline {}" --color bg:#222222
    )

    exit_exception

    case "$selected" in
    "${options[0]}")
        switch_branch
        exit 0
        ;;
    "${options[1]}")
        merge
        exit 0
        ;;
    "${options[2]}")
        delete_branch
        exit 0
        ;;
    "${options[3]}")
        exit
        exit 0
        ;;
    *)
        exit 0
        ;;
esac
}

main