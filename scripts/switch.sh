#!/usr/bin/env bash

check_args() {
   if [ $# == 2 ]; then
        if [ $2 == "--boot" ]; then
            return 0;
        fi
    fi
    if [ $# != 1 ]; then
        echo 'Usage: switch.sh <description> [--boot]'
        exit
    fi
}
check_args "$@"


# set the name of this generation
export NIXOS_LABEL=${1// /_}
read NEXT_GENERATION_NUMBER <<< $(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1 | awk '{print $1+1;}')

# build the system and check for errors
nh os build
if [ $? != 0 ]; then
    echo
    echo 'Failed to build, aborting!'
    exit
fi

# save changes to git, pushing is done manually
git add -A
git commit -m "$1 - `hostname` $NEXT_GENERATION_NUMBER"
git push


if [ $# == 2 ]; then
    nh os boot
else
    nh os switch
fi

