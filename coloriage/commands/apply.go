package commands

import (
	"fmt"
	"os"
	"path/filepath"
	"text/template"

	"github.com/tlarrieu/coloriage/colors"
)

type Mapping struct {
	app       string
	dir       []string
	extension string
}

func apply(palette colors.Palette, dir []string, software, out string) (err error) {
	var raw []byte
	path := filepath.Join("templates", software+".tmpl")
	raw, err = os.ReadFile(path)
	tmpl, err := template.New(path).Funcs(template.FuncMap{
		"bare": func(c colors.Color) string {
			return colors.ToHex(c)[1:]
		},
	}).Parse(string(raw))

	if err != nil {
		return
	}

	themedir := filepath.Join(dir...)
	if err = os.MkdirAll(themedir, os.ModePerm); err != nil {
		return
	}

	f, err := os.Create(filepath.Join(themedir, out))
	if err != nil {
		return
	}
	defer f.Close()

	return tmpl.Execute(f, palette)
}

func build(name string) (err error) {
	theme, err := colors.LoadTheme(name)

	if err != nil {
		return
	}

	homedir, err := os.UserHomeDir()
	if err != nil {
		return
	}
	config := filepath.Join(homedir, ".config")

	mappings := []Mapping{
		{app: "nvim", dir: []string{config, "nvim", "lua", "colors"}, extension: ".lua"},
		{app: "awesome", dir: []string{config, "awesome", "colors"}, extension: ".lua"},
		{app: "kitty", dir: []string{config, "kitty", "themes"}, extension: ".conf"},
		{app: "fish", dir: []string{config, "fish", "themes"}, extension: ".theme"},
		{app: "rofi", dir: []string{config, "rofi"}, extension: ".rasi"},
		{app: "zathura", dir: []string{config, "zathura"}},
	}

	if err = os.RemoveAll("theme"); err != nil {
		return
	}

	for _, mapping := range mappings {
		if err = apply(theme.Light, mapping.dir, mapping.app, "light"+mapping.extension); err != nil {
			return
		}
		if err = apply(theme.Dark, mapping.dir, mapping.app, "dark"+mapping.extension); err != nil {
			return
		}
	}

	return
}

func Apply() {

	fmt.Println("applying '" + os.Args[2] + "'...")
	if err := build(os.Args[2]); err != nil {
		fmt.Println(err)
		fmt.Println("run `coloriage list` to see available palettes")
		os.Exit(1)
	}
}
