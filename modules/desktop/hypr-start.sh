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

# the bar
# waybar &
eww daemon

# notifications
dunst