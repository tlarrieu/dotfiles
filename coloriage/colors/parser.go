package colors

import (
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
)

type JsonPalette struct {
	Black   Color
	Blue    Color
	Cyan    Color
	Green   Color
	Magenta Color
	Red     Color
	White   Color
	Yellow  Color

	Accent Color

	Fg  Color
	Bg  Color
	Sel Color
}

type JsonTheme struct {
	Light JsonPalette
	Dark  JsonPalette
}

type Variant int

const (
	Light Variant = iota
	Dark
)

func from(jsonPalette JsonPalette, variant Variant) (pal Palette) {
	pal.Fg = Compose(jsonPalette.Fg, jsonPalette.Bg, 0.6, 0.5)
	pal.Bg = Compose(jsonPalette.Bg, jsonPalette.Fg, 0.95, 0.90)

	if variant == Light {
		pal.Black = pal.Fg
		pal.White = pal.Bg
	} else {
		pal.Black = pal.Bg
		pal.White = pal.Fg
	}

	pal.Blue = Compose(jsonPalette.Blue, jsonPalette.Bg, 0.2, 0.15)
	pal.Cyan = Compose(jsonPalette.Cyan, jsonPalette.Bg, 0.2, 0.15)
	pal.Green = Compose(jsonPalette.Green, jsonPalette.Bg, 0.2, 0.15)
	pal.Magenta = Compose(jsonPalette.Magenta, jsonPalette.Bg, 0.2, 0.15)
	pal.Red = Compose(jsonPalette.Red, jsonPalette.Bg, 0.2, 0.15)
	pal.Yellow = Compose(jsonPalette.Yellow, jsonPalette.Bg, 0.2, 0.15)

	pal.Accent = Compose(jsonPalette.Accent, jsonPalette.Bg, 0.2, 0.15)

	sel := Compose(jsonPalette.Accent, jsonPalette.Bg, 0.15, 0.10)
	pal.Sel = CompositeColor{sel.Dim, sel.Dimmer, sel.Dimmer}
	return
}

func LoadTheme(name string) (t Theme, err error) {
	var rawJson []byte
	path := filepath.Join("palettes", name+".json")
	rawJson, err = os.ReadFile(path)

	if err != nil {
		err = errors.New("Non existing palette: " + name)
		return
	}

	var jsonTheme JsonTheme
	err = json.Unmarshal(rawJson, &jsonTheme)

	t.Light = from(jsonTheme.Light, Light)
	t.Dark = from(jsonTheme.Dark, Dark)

	return
}
