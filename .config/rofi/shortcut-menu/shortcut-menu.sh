#!/usr/bin/env bash

# Current Theme
dir="$HOME/.config/rofi/shortcut-menu"
theme='style-1'

# Help text
help_text="<b>Super+Return:</b> Open terminal
<b>Super+Shift+q:</b> Kill focused window
<b>Super+d:</b> Open launcher
<b>Super+Arrow:</b> Move focus to left/down/up/right container
<b>Super+Shift+Arrow:</b> Move focused container to left/down/up/right workspace
<b>Super+1-0:</b> Switch to workspace 1-10
<b>Super+Shift+1-0:</b> Move focused container to workspace 1-10
<b>Super+b:</b> Split container horizontally
<b>Super+v:</b> Split container vertically
<b>Super+s:</b> Switch to stacking layout
<b>Super+w:</b> Switch to tabbed layout
<b>Super+e:</b> Toggle split layout
<b>Super+f:</b> Toggle fullscreen mode for focused container
<b>Super+Shift+space:</b> Toggle floating mode for focused container
<b>Super+space:</b> Swap focus between tiling area and floating area
<b>Super+a:</b> Move focus to parent container
<b>Super+Shift+minus:</b> Move focused container to scratchpad
<b>Super+minus:</b> Show next scratchpad window/hide focused scratchpad window
<b>Super+r:</b> Enter resize mode (use arrow keys to resize focused container)
<b>Super+Shift+e:</b> Exit Sway
<b>Super+l:</b> Open powermenu
<b>Super+Shift+R:</b> Record a screencast
<b>Super+Shift+B:</b> Toggle smart borders
<b>Super+Pause:</b> Passthrough mode
"

# Rofi CMD
rofi_cmd() {
    echo -e "$help_text" | rofi -dmenu \
                -i \
                -markup-rows \
                -no-show-icons \
                -p "" \
                -theme ${dir}/${theme}.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
    run_cmd="$(rofi_cmd)"
}

# Actions
run_rofi
