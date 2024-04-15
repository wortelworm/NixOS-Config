#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &
# setting wallpaper once it is running
(
    until swww query; do
        sleep 0.1s
    done
    swww img ~/.dotfiles/resources/wallpaper.png &
) &


# something with networks
nm-applet --indicator &

# the bar, TODO should test if the open bar also needs a delay
# maybe the eww open command is enough
# eww daemon &
eww open bar &

# notifications
dunst