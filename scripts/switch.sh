#!/usr/bin/env bash

# check argument
if [ $# != 1 ]; then
    echo 'Please give me exactly one argument with the name of this generation!'
    exit
fi


# set the name of this generation
export NIXOS_LABEL=${1// /_}
read NEXT_GENERATION_NUMBER <<< $(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1 | awk '{print $1+1;}')

# save changes to git, pushing is done manually
git add -A
git commit -m "$NIXOS_LABEL - `hostname` $NEXT_GENERATION_NUMBER"


sudo nixos-rebuild switch --flake path:$HOME/.dotfiles