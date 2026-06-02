package main

import (
	"fmt"
	"os"

	"github.com/tlarrieu/coloriage/commands"
)

func main() {
	switch os.Args[1] {
	case "l", "list":
		commands.List()
	case "a", "apply":
		fmt.Println("applying '" + os.Args[2] + "'...")
		commands.Apply(os.Args[2])
		commands.Refresh()
	case "t", "toggle":
		commands.Toggle()
	case "s", "set":
		commands.SetMode(os.Args[2])
	default:
		panic("Unrecognized command")
	}
}
