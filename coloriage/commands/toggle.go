package commands

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func Toggle() {
	mode, err := getMode()
	if err != nil {
		panic(err)
	}

	SetMode(invert(mode))
}

func Refresh() {
	mode, err := getMode()
	if err != nil {
		panic(err)
	}

	SetMode(mode)
}

func writeMode(data string, path ...string) {
	os.WriteFile(filepath.Join(path...), []byte(data), 0644)
}

func SetMode(mode string) {
	homedir, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}
	configdir := filepath.Join(homedir, ".config")

	// ---- GTK ----
	var gtktheme string
	if mode == "light" {
		gtktheme = "Nightfox-Light"
	} else {
		gtktheme = "Nordic"
	}
	writeMode(`Net/ThemeName "`+gtktheme+`"`, homedir, ".xsettingsd")
	exec.Command("xsettingsd").Start()
	exec.Command("gsettings", "set", "org.gnome.desktop.interface", "color-scheme", "prefer-"+mode).Run()

	go writeMode("include themes/"+mode+".conf", configdir, "kitty", "theme.conf")

	exec.Command("pkill", "--signal", "USR1", "kitty").Start()
	exec.Command("pkill", "--signal", "USR1", "nvim").Start()
	cmd := exec.Command("fish", "-c", "fish_config theme save "+mode)
	cmd.Stdin = strings.NewReader("y")

	exec.Command("awesome-client", "require('theme').config(); require('panel').reset()").Start()
	exec.Command("browser-setup", mode).Start()

	go writeMode(`@import "`+mode+`"`, configdir, "rofi", "variant.rasi")
	go writeMode("include "+mode, configdir, "zathura", "theme")

	wallpaper := filepath.Join(homedir, "Pictures", "wallpapers", "wallpaper-"+mode)
	fehbg := filepath.Join(homedir, ".fehbg")
	if _, err := os.Stat(wallpaper); err == nil {
		exec.Command("feh", "--bg-scale", wallpaper).Start()
	} else if _, err := os.Stat(fehbg); err == nil {
		exec.Command(fehbg).Start()
	}
}

func getMode() (str string, err error) {
	res, err := exec.Command("gsettings", "get", "org.gnome.desktop.interface", "color-scheme").Output()
	res = res[8 : len(res)-2]
	str = string(res)
	return
}

func invert(mode string) string {
	switch mode {
	case "light":
		return "dark"
	case "dark":
		return "light"
	default:
		panic("Unrecognized mode: " + mode)
	}
}
