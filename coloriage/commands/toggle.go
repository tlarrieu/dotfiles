package commands

import "os/exec"

func Toggle(kind string) {
	exec.Command("toggle-light-and-dark.sh", kind).Run()
}

func Refresh() {
	exec.Command("pkill", "--signal", "USR1", "nvim").Run()
	exec.Command("pkill", "--signal", "USR1", "kitty").Run()
}
