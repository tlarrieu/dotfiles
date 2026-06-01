package commands

import "os/exec"

func Toggle(kind string) {
	exec.Command("toggle-light-and-dark.sh", kind).Run()
}
