#!/usr/bin/env bash

if [ $# == 0 ]; then
    echo "Usage: boot.sh <description>"
else
    ./switch.sh "$1" --boot
fi
