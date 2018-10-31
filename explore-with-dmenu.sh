#!/bin/bash

# Calls dmenu on the given array of choices.
# If the selected choice is a folder, recursively open dmenu with the folder's contents as choices.
# If the selection is not a folder, or the same folder, denoted as '.', attempt to open it with
# xdg-open or a comparable tool.
# It can also open a terminal program at the given path.
#
# author: andreasl
# version: 18-10-31


function define_standard_settings {

    selected_path="${HOME}"

    choices=(
        '<open terminal here>'
        '.'
        '..'
        "$(ls -t "${selected_path}")"
        )

    if [ "$(uname)" == "Darwin" ] ; then
        open_command='open'
        open_terminal_command='open -a Terminal'
    else
        open_command='xdg-open'
        open_terminal_command='konsole --workdir'
    fi

}

define_standard_settings
source "${HOME}/.edmrc" 2>/dev/null

while : ; do

    dmenu_result="$(printf '%s\n' "${choices[@]}" | dmenu -i -p "${selected_path}" -l 100)"  # -i: ignore case
    if [ $? != 0 ] ; then
        exit 1
    fi

    if [ "${dmenu_result}" = '<open terminal here>' ]; then
        eval "${open_terminal_command}" "\"${selected_path}\""
        exit 0
    fi

    selected_path="$(realpath "${selected_path}/${dmenu_result}")"

    if [ -f "${selected_path}" -o "${dmenu_result}" = "." ]; then
        eval "${open_command}" "\"${selected_path}\""
        exit 0
    elif [ -d "${selected_path}" ]; then
        choices=( '<open terminal here>' '.' '..' "$(ls "${selected_path}")")
    fi

done
