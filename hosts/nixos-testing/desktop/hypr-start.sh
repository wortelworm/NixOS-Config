#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &
# setting wallpaper
# todos

# something with networks
nm-applet --indicator &

# the bar
waybar &

# notifications
dunst