#!/usr/bin/env bash
# aco-menu: the one menu of the ACO desktop, built on rofi.
#
#   aco-menu apps                      app launcher (plus windows; calc/emoji if installed)
#   aco-menu windows                   switch between open windows
#   aco-menu [options] < entries       pick one line from stdin (dmenu), print it
#
# Options for the dmenu form:
#   --prompt TEXT        icon or short label before the input   (default: 󰍉)
#   --placeholder TEXT   grey text in the empty input
#   --message TEXT       one line of explanation above the list
#   --lines N            visible rows                            (default: theme, 7)
#   --width N            window width in em                      (default: theme)
#   --password           hide the input, print what was typed
#   --icons              rows carry icons (rofi "\0icon\x1f<name or path>")
#   --grid               large image tiles, for example wallpapers (implies --icons)
#   --index              print the row number instead of the text
#   --markup             rows may contain Pango markup (for example coloured dots)
#
# Exit status 1 when cancelled (Esc). Calling it while a menu is open closes that
# menu and exits 130, so the same key opens and closes it and callers can tell
# "closed from outside" from "cancelled".
set -euo pipefail

if pgrep -x rofi >/dev/null; then
    pkill -x rofi
    exit 130
fi

have_plugin() { [[ -f /usr/lib/rofi/$1.so ]]; }

case ${1:-} in
    apps)
        modes=drun,window
        have_plugin calc && modes+=,calc
        have_plugin emoji && modes+=,emoji
        # A search icon instead of the mode name; the mode switcher names the modes.
        exec rofi -show drun -modes "$modes" -theme-str 'inputbar { children: [ textbox-search, entry ]; }
            textbox-search { expand: false; str: "󰍉"; font: @aco-font-icon; text-color: @aco-muted; vertical-align: 0.5; }' 
        ;;
    windows)
        exec rofi -show window -modes window
        ;;
    -h | --help)
        sed -n '2,/^set -euo/p' "${BASH_SOURCE[0]}" | sed '$d; s/^# \{0,1\}//'
        exit 0
        ;;
esac

prompt="󰍉" placeholder="" message="" lines="" width="" theme=""
# Plain menus reserve no icon column; --icons/--grid switch icons back on.
args=(-dmenu -i -no-show-icons)
while (($#)); do
    if [[ $1 == --*=* ]]; then
        set -- "${1%%=*}" "${1#*=}" "${@:2}"
    fi
    case $1 in
        --prompt) prompt=$2; shift ;;
        --placeholder) placeholder=$2; shift ;;
        --message) message=$2; shift ;;
        --lines) lines=$2; shift ;;
        --width) width=$2; shift ;;
        --password) args+=(-password) ;;
        --icons) args+=(-show-icons) ;;
        --grid)
            args+=(-show-icons)
            theme+='listview { columns: 4; lines: 2; spacing: 8px; flow: horizontal; }'
            theme+='element { orientation: vertical; padding: 8px; spacing: 6px; }'
            theme+='element-icon { size: 9em; }'
            theme+='element-text { horizontal-align: 0.5; }'
            theme+='window { width: 50em; }'
            ;;
        --index) args+=(-format i) ;;
        --markup) args+=(-markup-rows) ;;
        *) echo "aco-menu: unknown option '$1' (see aco-menu --help)" >&2; exit 2 ;;
    esac
    shift
done

args+=(-p "$prompt")
[[ -n $placeholder ]] && theme+="entry { placeholder: \"${placeholder//\"/\\\"}\"; }"
[[ -n $message ]] && args+=(-mesg "$message")
[[ -n $lines ]] && args+=(-l "$lines")
[[ -n $width ]] && theme+="window { width: ${width}em; }"
[[ -n $theme ]] && args+=(-theme-str "$theme")
exec rofi "${args[@]}"
