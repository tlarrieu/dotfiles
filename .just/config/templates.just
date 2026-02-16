[group("config/templates")]
templates: (template ".Xresources.d/local") \
  (template ".xsettingsd") \
  (template ".config/kitty/theme.conf") \
  (template ".config/zathura/theme") \
  (template ".config/rofi/variant.rasi")

[group("config/templates")]
root: (green "Linking root configuration files...") && (yellow "Done.")
  sudo cp {{BASEDIR}}/templates/root/.bashrc /root/.bashrc
  sudo mkdir -p /root/.config/nvim
  sudo cp {{BASEDIR}}/templates/root/nvim.lua /root/.config/nvim/init.lua
