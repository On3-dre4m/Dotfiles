if pgrep picom > /dev/null; then
    killall picom
else 
    picom -b &
fi
