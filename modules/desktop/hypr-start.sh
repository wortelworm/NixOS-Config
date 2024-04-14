#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &
# setting wallpaper
swww img ~/.dotfiles/resources/wallpaper.png &

# something with networks
nm-applet --indicator &

# the bar
waybar &

# notifications
dunst