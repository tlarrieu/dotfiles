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
		commands.Apply()
		commands.Toggle("current")
		commands.Refresh()
	default:
		panic("Unrecognized command")
	}
}
