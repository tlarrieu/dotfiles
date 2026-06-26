package commands

import (
	"math/rand/v2"
	"os"
	"strings"
)

func Random() string {
	files, err := os.ReadDir("palettes")
	if err != nil {
		panic(err)
	}
	file := files[rand.IntN(len(files))]
	name, _ := strings.CutSuffix(file.Name(), ".json")
	Apply(name)
	return name
}
