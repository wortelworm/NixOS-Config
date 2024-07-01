#!/usr/bin/env bash
nix flake update path:$HOME/.dotfiles
./boot.sh "updates"
