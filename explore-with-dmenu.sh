#!/bin/bash
#
# Calls dmenu on the given array of choices.
# If the selected choice is a folder, recursively open dmenu with the folder's contents as choices.
# If the selection is not a folder, or the same folder, denoted as '.', attempt to open it with
# xdg-open or a comparable tool.
# It can also open a terminal program at the given path.
#
# author: andreasl

function define_standard_settings {
    selected_path="$HOME"

    choices=(
        '<open terminal here>'
        '.'
        '..'
        "$(ls "$selected_path")"
        )

    if [ "$(uname)" == "Darwin" ] ; then
        open_command='open'
        open_terminal_command='open -a Terminal'
    else
        open_command='xdg-open'
        open_terminal_command='gnome-terminal --working-directory'
    fi
}

define_standard_settings
source "${XDG_CONFIG_HOME:-$HOME}/.edmrc" 2>/dev/null

while : ; do
    dmenu_result="$(printf '%s\n' "${choices[@]}" | dmenu -i -p "${selected_path}" -l 50 ${@})" || exit 1
    if [ "$dmenu_result" = '<open terminal here>' ]; then
        eval "$open_terminal_command" "\"${selected_path}\""
        exit 0
    fi
    if [[ $dmenu_result =~ ^/.* ]]; then
        selected_path="$dmenu_result"
    elif [[ $dmenu_result =~ ^h?[ft]?tps?: ]]; then
        eval "${open_command} \"${dmenu_result}\""
        exit 0
    else
        selected_path="$(realpath "${selected_path}/${dmenu_result}")"
    fi
    if [ -f "$selected_path" ] || [ "$dmenu_result" = '.' ]; then
        eval "${open_command} \"${selected_path}\""
        exit 0
    elif [ -d "$selected_path" ]; then
        choices=( '<open terminal here>' '.' '..' "$(ls "$selected_path")")
    else
        selected_path="$(dirname "$selected_path")"
    fi
done
