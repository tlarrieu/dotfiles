package main

import (
	"os"

	"github.com/tlarrieu/coloriage/commands"
)

func main() {
	switch os.Args[1] {
	case "list":
		commands.List()
	case "apply":
		commands.Apply()
	default:
		panic("Unrecognized command")
	}
}
