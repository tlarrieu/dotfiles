[group("system"), doc("lightdm, NetworkManager, mpd, timedatectl")]
services: (green "services: enabling...") && (yellow "services: done.")
  -sudo systemctl enable lightdm
  -sudo systemctl enable NetworkManager
  @mkdir -p ~/.local/share/mpd
  -sudo systemctl --user enable mpd
  -sudo timedatectl set-ntp true

[group("system"), doc("set default shell (fish by default)")]
shell bin="/usr/bin/fish":
  #!/usr/bin/env bash
  if [ ! "$SHELL" = "{{bin}}" ]; then chsh -s {{bin}}; fi

[group("system")]
crontab:
  #!/usr/bin/env sh
  crontab > /dev/null <<-CRONTAB
  DISPLAY=:0
  DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

  0 19 * * * ~/scripts/toggle-light-and-dark.sh dark
  0 9 * * * ~/scripts/toggle-light-and-dark.sh light
  CRONTAB
