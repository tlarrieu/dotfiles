#!/bin/sh

ACTION=`zenity --width=90 --height=247 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" FALSE Logout TRUE Shutdown FALSE Reboot FALSE LockScreen FALSE Suspend`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Logout)
    echo "awesome.quit()" | awesome-client
    ;;
  Shutdown)
    zenity --question --text "Are you sure you want to halt?" && systemctl poweroff
    ;;
  Reboot)
    zenity --question --text "Are you sure you want to reboot?" && systemctl reboot
    ;;
  Suspend)
    systemctl suspend
    ;;
  LockScreen)
    slock
    ;;
  esac
fi

