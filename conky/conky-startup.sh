#!/bin/sh

if [ "$DESKTOP_SESSION" = "gnome-wayland" ]; then 
   sleep 20s
   killall conky
   cd "$HOME/.conky/titus-conky"
   conky -c "$HOME/.conky/titus-conky/Titus.conkyrc" &
   exit 0
fi
if [ "$DESKTOP_SESSION" = "cinnamon" ]; then 
   sleep 20s
   killall conky
   cd "$HOME/.conky/titus-conky"
   conky -c "$HOME/.conky/titus-conky/Titus.conkyrc" &
   exit 0
fi
if [ "$DESKTOP_SESSION" = "i3" ]; then 
   sleep 20s
   killall conky
   cd "$HOME/.conky/titus-conky"
   conky -c "$HOME/.conky/titus-conky/Titus_i3.conkyrc" &
   exit 0
fi
