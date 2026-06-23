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

	Fg  CompositeColor
	Bg  CompositeColor
	Sel Sel
}

type JsonTheme struct {
	Light JsonPalette
	Dark  JsonPalette
}

func from(jsonPalette JsonPalette) (pal Palette) {
	pal.Black = Compose(jsonPalette.Black, jsonPalette.Bg.Base)
	pal.Blue = Compose(jsonPalette.Blue, jsonPalette.Bg.Base)
	pal.Cyan = Compose(jsonPalette.Cyan, jsonPalette.Bg.Base)
	pal.Green = Compose(jsonPalette.Green, jsonPalette.Bg.Base)
	pal.Magenta = Compose(jsonPalette.Magenta, jsonPalette.Bg.Base)
	pal.Orange = Compose(jsonPalette.Orange, jsonPalette.Bg.Base)
	pal.Pink = Compose(jsonPalette.Pink, jsonPalette.Bg.Base)
	pal.Red = Compose(jsonPalette.Red, jsonPalette.Bg.Base)
	pal.White = Compose(jsonPalette.White, jsonPalette.Bg.Base)
	pal.Yellow = Compose(jsonPalette.Yellow, jsonPalette.Bg.Base)
	pal.Accent = Compose(jsonPalette.Accent, jsonPalette.Bg.Base)
	pal.Fg = jsonPalette.Fg
	pal.Bg = jsonPalette.Bg
	pal.Sel = jsonPalette.Sel
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
