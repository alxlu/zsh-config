#!/bin/zsh

[ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx

if [ -f "/opt/homebrew/bin/brew" ]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi
