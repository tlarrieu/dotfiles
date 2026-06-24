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
	Orange  Color
	Pink    Color
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

func from(jsonPalette JsonPalette) (pal Palette) {
	pal.Black = Compose(jsonPalette.Black, jsonPalette.Bg, 0.2, 0.15)
	pal.Blue = Compose(jsonPalette.Blue, jsonPalette.Bg, 0.2, 0.15)
	pal.Cyan = Compose(jsonPalette.Cyan, jsonPalette.Bg, 0.2, 0.15)
	pal.Green = Compose(jsonPalette.Green, jsonPalette.Bg, 0.2, 0.15)
	pal.Magenta = Compose(jsonPalette.Magenta, jsonPalette.Bg, 0.2, 0.15)
	pal.Orange = Compose(jsonPalette.Orange, jsonPalette.Bg, 0.2, 0.15)
	pal.Pink = Compose(jsonPalette.Pink, jsonPalette.Bg, 0.2, 0.15)
	pal.Red = Compose(jsonPalette.Red, jsonPalette.Bg, 0.2, 0.15)
	pal.White = Compose(jsonPalette.White, jsonPalette.Bg, 0.2, 0.15)
	pal.Yellow = Compose(jsonPalette.Yellow, jsonPalette.Bg, 0.2, 0.15)
	pal.Accent = Compose(jsonPalette.Accent, jsonPalette.Bg, 0.2, 0.15)
	pal.Fg = Compose(jsonPalette.Fg, jsonPalette.Bg, 0.6, 0.5)
	pal.Bg = Fan(jsonPalette.Bg)
	sel := Compose(jsonPalette.Accent, jsonPalette.Bg, 0.3, 0.18)
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

	t.Light = from(jsonTheme.Light)
	t.Dark = from(jsonTheme.Dark)

	return
}
