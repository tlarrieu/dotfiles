package main

import (
	"os"

	"github.com/tlarrieu/coloriage/commands"
)

func main() {
	switch os.Args[1] {
	case "l", "list":
		commands.List()
	case "a", "apply":
		if len(os.Args) > 2 {
			commands.Apply(os.Args[2])
		}
		commands.Refresh()
	case "t", "toggle":
		commands.Toggle()
	case "s", "set":
		commands.SetMode(os.Args[2])
	case "r", "random":
		commands.Random()
	default:
		panic("Unrecognized command")
	}
}
