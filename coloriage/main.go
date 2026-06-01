package main

import (
	"os"
	"os/exec"

	"github.com/tlarrieu/coloriage/commands"
)

func main() {
	switch os.Args[1] {
	case "list":
		commands.List()
	case "apply":
		commands.Apply()
		commands.Toggle("current")
		// FIX: fix remove this line once we understand why it does not work through the bash script
		exec.Command("pkill", "--signal", "USR1", "nvim").Run()
	default:
		panic("Unrecognized command")
	}
}
