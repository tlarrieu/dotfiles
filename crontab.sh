#!/bin/sh

crontab > /dev/null <<-CRONTAB
DISPLAY=:0
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

*/5 22 * * * notify-send "Time to sleep" "GO TO BED" -u critical
0 19 * * * ~/scripts/toggle-light-and-dark.sh dark
0 9 * * * ~/scripts/toggle-light-and-dark.sh light
CRONTAB
