define cecho
	@tput setaf $(1)
	@echo $(2)
	@tput sgr0
endef

BASEDIR := $(shell pwd)
PACMAN := $(shell type pacman 2>&1 > /dev/null && echo 1 || echo 0)
APT := $(shell type apt 2>&1 > /dev/null && echo 1 || echo 0)

all: dotfiles

.PHONY: bootstrap
bootstrap: packages fonts gtk-theme dotfiles services X11 shell crontab root-dotfiles

.PHONY: dotfiles
dotfiles: links templates

.PHONY: fonts
fonts: TMP:=/tmp/CaskaydiaCove.zip
fonts: DIR:=~/.fonts/CaskaydiaCove
fonts: VERSION=3.3.0
fonts:
	@wget --quiet https://github.com/ryanoasis/nerd-fonts/releases/download/v$(VERSION)/CascadiaCode.zip -O $(TMP)
	@rm -rf $(DIR)
	@mkdir -p $(DIR)
	@cd $(DIR) && unzip $(TMP)
	@fc-cache -fr

.PHONY: gtk-theme
gtk-theme: NAME:=NumixSolarized
gtk-theme: TMP:=/tmp/$(NAME).tar.gz
gtk-theme: DIR:=/usr/share/themes
gtk-theme: VERSION=20230408
gtk-theme:
	@wget --quiet https://github.com/Ferdi265/numix-solarized-gtk-theme/releases/download/$(VERSION)/NumixSolarized-$(VERSION).tar.gz -O $(TMP)
	@tar xvzf $(TMP) --directory=/tmp
	@sudo rm -rf $(DIR)/Numix*
	@sudo mv -f /tmp/$(NAME)/* $(DIR)/.

.PHONY: crontab
crontab:
	@sh crontab.sh

.PHONY: links
links:
	$(call cecho, 3, Linking configuration files...)
	@mkdir -p ~/.config
	@$(foreach file,$(wildcard config/*),ln -sfFT $(BASEDIR)/$(file) ~/.config/$(notdir $(file));)
	@mkdir -p ~/.local/share/applications
	@$(foreach file,$(wildcard local/share/applications/*),ln -sfFT $(BASEDIR)/$(file) ~/.local/share/applications/$(notdir $(file));)
	@mkdir -p ~/scripts
	@$(foreach file,$(wildcard scripts/*),ln -sfFT $(BASEDIR)/$(file) ~/scripts/$(notdir $(file));)
	@ln -sfFT $(BASEDIR)/projections.json ~/.projections.json
	@ln -sfFT $(BASEDIR)/lua ~/lua
	@ln -sfFT $(BASEDIR)/gtkrc-2.0 ~/.gtkrc-2.0
	@ln -sfFT $(BASEDIR)/nvim ~/.config/nvim
	@ln -sfFT $(BASEDIR)/vifm ~/.vifm
	@ln -sfFT $(BASEDIR)/bashrc ~/.bashrc
	@ln -sfFT $(BASEDIR)/browser-config ~/.browser-config
	@ln -sfFT $(BASEDIR)/gitconfig ~/.gitconfig
	@ln -sfFT $(BASEDIR)/gitignore ~/.gitignore
	@git config --global core.excludesFile ~/.gitignore
	@ln -sfFT $(BASEDIR)/psqlrc ~/.psqlrc
	@ln -sfFT $(BASEDIR)/irbrc ~/.irbrc
	@ln -sfFT $(BASEDIR)/pryrc ~/.pryrc
	@ln -sfFT $(BASEDIR)/rubocop.yml ~/.rubocop.yml
	@ln -sfFT $(BASEDIR)/tslint.json ~/tslint.json
	@ln -sfFT $(BASEDIR)/newsboat ~/.newsboat
	@ln -sfFT $(BASEDIR)/apps ~/apps
	@ln -sfFT $(BASEDIR)/ncpamixer.conf ~/.ncpamixer.conf
	@ln -sfFT $(BASEDIR)/xprofile ~/.xprofile
	@[ -f ~/.profile ] && rm ~/.profile || /bin/true
	@ln -sfFT $(BASEDIR)/xresources ~/.Xresources
	@mkdir -p ~/.Xresources.d
	@$(foreach file,$(wildcard xresources.d/*),ln -sfFT $(BASEDIR)/$(file) ~/.Xresources.d/$(notdir $(file));)
	@ln -sfFT $(BASEDIR)/xmodmap.lavie-hz750c ~/.Xmodmap
	@ln -sfFT $(BASEDIR)/dir_colors ~/.dir_colors
	@ln -sfFT $(BASEDIR)/lesskey ~/.lesskey
	@ln -sfFT $(BASEDIR)/ghci ~/.ghci
	$(call cecho, 2, Done.)

.PHONY: templates
templates: ~/.Xresources.d/local
templates: ~/.config/kitty/theme.conf
templates: ~/.config/rofi/variant.rasi
templates: ~/.config/btop/themes/current.theme
templates: ~/.xsettingsd

~/.Xresources.d/local:
	@cp $(BASEDIR)/templates/.Xresources.d/local ~/.Xresources.d/local

~/.config/kitty/theme.conf:
	@cp $(BASEDIR)/templates/.config/kitty/theme.conf ~/.config/kitty/theme.conf

~/.config/rofi/variant.rasi:
	@cp $(BASEDIR)/templates/.config/rofi/variant.rasi ~/.config/rofi/variant.rasi

~/.config/btop/themes/current.theme:
	@cp $(BASEDIR)/config/btop/themes/light.theme ~/.config/btop/themes/current.theme

~/.xsettingsd:
	@cp $(BASEDIR)/templates/.xsettingsd ~/.xsettingsd

.PHONY: root-dotfiles
root-dotfiles:
	$(call cecho, 3, Copying root nvim config...)
	@sudo cp $(BASEDIR)/templates/root/.bashrc /root/.bashrc
	@sudo mkdir -p /root/.config/nvim
	@sudo cp $(BASEDIR)/templates/root/nvim.lua /root/.config/nvim/init.lua
	$(call cecho, 2, Done.)

.PHONY: packages
ifeq ($(PACMAN), 1)
packages:
	$(call cecho, 3, Installing packages...)
	@sudo pacman -S --color always --needed --noconfirm yay
	@yay -S --color always --needed --noconfirm $(shell cat packages-arch.txt | grep -v "#")
	$(call cecho, 2, Done.)
else ifeq ($(APT), 1)
packages: ~/git/neovim
packages: ~/git/awesome
packages: ~/git/picom
packages:
	$(call cecho, 3, Installing packages...)
	@sudo cp ./ubuntu-sources.list /etc/apt/sources.list.d/ubuntu.sources
	@sudo apt update
	@sudo apt install -y $(shell cat packages-ubuntu.txt | grep -v "#")
	@mkdir -p ~/bin
	@ln -sfFT /usr/bin/fdfind ~/bin/fd
	@cd ~/git/neovim \
		&& git fetch \
		&& git checkout v0.11.3 \
		&& make CMAKE_BUILD_TYPE=RelWithDebInfo \
		&& cd build \
		&& cpack -G DEB \
		&& sudo dpkg -i nvim-linux-x86_64.deb
	@sudo apt build-dep awesome
	@cd ~/git/awesome \
		&& git clean -f \
		&& git checkout . \
		&& make package \
		&& cd build \
		&& sudo apt install -y ./*.deb \
		&& sudo cp ~/git/awesome/awesome.desktop /usr/share/xsessions/awesome.desktop
	@cd ~/git/picom && \
		meson setup --buildtype=release build && \
		ninja -C build && \
		sudo ninja -C build install
	$(call cecho, 2, Done.)
else
packages:
	@echo Unsupported distro
	exit 1
endif

~/git/neovim:
	@git clone https://github.com/neovim/neovim ~/git/neovim

~/git/awesome:
	@git clone https://github.com/awesomewm/awesome ~/git/awesome

~/git/picom:
	@git clone https://github.com/yshui/picom ~/git/picom

.PHONY: services
services:
	$(call cecho, 3, Configuring services...)
	@sudo systemctl enable lightdm || /bin/true
	@sudo systemctl enable NetworkManager
	@mkdir -p ~/.local/share/mpd
	@systemctl enable mpd --user
	@sudo timedatectl set-ntp true
	$(call cecho, 2, Done.)

.PHONY: X11
X11:
	$(call cecho, 3, Linking X11 files...)
	@$(foreach file,$(wildcard xorg.conf.d/*),sudo ln -sfFT $(BASEDIR)/xorg.conf.d/$(notdir $(file)) /etc/X11/xorg.conf.d/$(notdir $(file));)
	$(call cecho, 2, Done.)

.PHONY: shell
shell:
ifneq (/usr/bin/fish, $(shell grep $(USER) /etc/passwd | awk -F ':' '{ print $$7 }'))
	$(call cecho, 3, Configuring shell...)
	@chsh -s /usr/bin/fish
	$(call cecho, 2, Done.)
endif

.PHONY: repos
repos: ~/.neorg
repos: ~/git/rss
repos: ~/git/accounting

~/.neorg:
	$(call cecho, 3, Getting notes...)
	git clone git@github.com:tlarrieu/notes.git ~/.neorg
	$(call cecho, 2, Done.)

~/git/rss:
	$(call cecho, 3, Getting rss config...)
	git clone git@github.com:tlarrieu/rss.git ~/git/rss
	make -C ~/git/rss
	$(call cecho, 2, Done.)

~/git/accounting:
	$(call cecho, 3, Getting accounting config...)
	git clone git@github.com:tlarrieu/accounting.git ~/git/accounting
	make -C ~/git/accounting
	$(call cecho, 2, Done.)
