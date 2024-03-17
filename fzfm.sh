#! /usr/bin/env bash
# This script uses fzf along with lsd to navigate directories and preview files
# error catching otherwise script continue envn after failiar
set -euo pipefail
# error e exit on cmd fail  ,  u for undefined variable, o option name e.g pipefail
# Function to browse directories and files interactively
fzfm() {
	while true; do
		selection="$(
			lsd -a | fzf --reverse \
				--height 95% \
				--info right \
				--prompt "Search: " \
				--border "bold" \
				--border-label "$(pwd)/" --prompt "Search: " \
				--bind "left:pos(2)+accept" \
				--bind "right:accept" \
				--bind "shift-up:preview-up" \
				--bind "shift-down:preview-down" \
				--preview-window=right:65% \
				--preview 'cd_pre="$(echo $(pwd)/$(echo {}))";
                    echo "Folder: " $cd_pre;
                    echo;
                    lsd -a --color=always "${cd_pre}";
                    txt_file="$(file {} | grep '[tT]ext' |wc -l)";
                    if [[ "${txt_file}" -eq 1 ]]; then 
                      # cat -t {} 2>/dev/null 
                      bat --style=numbers --theme=ansi --color=always  {} 2>/dev/null
                    else
                      chafa -c full --color-space rgb --dither none -p on -w 1 --size=20x6 {} 2>/dev/null
                      # chafa -c full --color-space rgb --dither none -p on -w 9 {} 2>/dev/null
                    fi
                   
                    '
		)"

		if [[ -d "${selection}" ]]; then
			>/dev/null cd "${selection}"
		else
			break
		fi
	done
}
clear
fzfm
