#!/usr/bin/env bash

if [ $# == 0 ]; then
    ./switch.sh
else
    ./switch.sh "$1" --boot
fi
