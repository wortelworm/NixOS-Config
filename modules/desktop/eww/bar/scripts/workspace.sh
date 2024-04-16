#!/usr/bin/env bash
# this has been made to work with hyprland,
# using the hyprctl command

# outputs the current state
# TODO maybe only output active, so that eww does
# not have to reparse this every time anything happens
write_workspaces() {
    output="
        (box \
            :class \"works\" \
            :orientation \"h\" \
            :spacing 5 \
            :space-evenly \"false\""

    active_id=`hyprctl activeworkspace | awk '/workspace ID/ {print $3}' | head -n 1`
    if ! [[ $active_id =~ ^[0-9]+$ ]]; then
        echo "\"Couldn't detect active workspace :($active_id\""
        return
    fi

    # there are more workspaces, but whatever
    for i in {1..7}; do
        if [ $active_id = $i ]; then
            active=" active"
        else
            active=""
        fi

        output+=" (button :onclick \"hyprctl dispatch workspace $i\" :class \"w$active\" \"\")"
    done


    output+=")"

    echo $output
}

# subscribe to general events, redraw the bar each time
write_workspaces
socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock |
    while read -r line; do
        write_workspaces
    done
