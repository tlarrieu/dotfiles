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

func SetMode(mode string) {
	homedir, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}

	// ---- GTK ----
	var gtktheme string
	if mode == "light" {
		gtktheme = `Net/ThemeName "Nightfox-Light"`
	} else {
		gtktheme = `Net/ThemeName "Nordic"`
	}
	os.WriteFile(filepath.Join(homedir, ".xsettingsd"), []byte(gtktheme), 0644)
	exec.Command("xsettingsd").Start()
	exec.Command("gsettings", "set", "org.gnome.desktop.interface", "color-scheme", "prefer-"+mode).Start()

	// ---- kitty ----
	os.WriteFile(filepath.Join(homedir, ".config", "kitty", "theme.conf"), []byte("include themes/"+mode+".conf"), 0644)

	// ---- fish ----
	cmd := exec.Command("fish", "-c", "fish_config theme save "+mode)
	cmd.Stdin = strings.NewReader("y")
	if err = cmd.Run(); err != nil {
		panic(err)
	}

	// ---- rofi ----
	os.WriteFile(filepath.Join(homedir, ".config", "rofi", "variant.rasi"), []byte(`@import "`+mode+`"`), 0644)

	// ---- zathura ----
	os.WriteFile(filepath.Join(homedir, ".config", "zathura", "theme"), []byte("include "+mode), 0644)

	// ---- chromium ----
	exec.Command("browser-setup", mode).Start()

	exec.Command("awesome-client", "require('theme').config(); require('panel').reset()").Start()
	exec.Command("pkill", "--signal", "USR1", "kitty").Start()
	exec.Command("pkill", "--signal", "USR1", "nvim").Start()

	// ---- wallpaper ----
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
