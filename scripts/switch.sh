#!/usr/bin/env bash
# number_of_arguments=$#
# if [ $# != 1 ]; then
#     echo 'Please give me exactly one argument with the name of this generation!'
#     exit
# fi

# set the name of this generation
# export NIXOS_LABEL="${$1// /_}"
sudo nixos-rebuild switch --flake path:$HOME/.dotfiles