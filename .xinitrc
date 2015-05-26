#!/bin/bash
xrdb -merge .Xresources
stalonetray &
xscreensaver -no-splash &
feh --bg-scale /home/faust/test.png &
if [ -x /usr/bin/nm-applet ] ; then
    nm-applet --sm-disable &
fi
exec xmonad
