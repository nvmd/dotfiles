#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xsetroot -cursor_name left_ptr
setxkbmap -layout us

/usr/bin/xscreensaver -no-splash &
/usr/bin/start-pulseaudio-x11

exec trayer --edge top --align right --margin 580 --widthtype percent --width 10 --heighttype pixels --height 16 --SetDockType true --SetPartialStrut true --transparent true --tint 0x000000 --expand true &

#start xmonad
#exec ck-launch-session xmonad
xmonad
