package commands

import (
	"math/rand/v2"
	"os"
	"os/exec"
	"strings"
)

func Random() {
	files, err := os.ReadDir("palettes")
	if err != nil {
		panic(err)
	}
	file := files[rand.IntN(len(files))]
	name, _ := strings.CutSuffix(file.Name(), ".json")
	Apply(name)
	Refresh()
	exec.Command("/usr/bin/notify-send", "  You rolled "+name+"!").Run()
}
