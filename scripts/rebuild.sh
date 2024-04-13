#!/usr/bin/env bash
# todo: set NIXOS_LABEL if got an argument
# or maybe even force an argument
sudo nixos-rebuild switch --flake path:$HOME/.dotfiles