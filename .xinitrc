#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -cursor_name left_ptr
setxkbmap -layout us

exec trayer --edge top --align right --margin 450 --widthtype percent --width 10 --heighttype pixels --height 16 --SetDockType true --SetPartialStrut true --transparent true --tint 0x000000 --expand true &

#start xmonad
#exec ck-launch-session xmonad
xmonad
