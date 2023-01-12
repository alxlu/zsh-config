#!/bin/zsh

[ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx

eval $(/opt/homebrew/bin/brew shellenv)
