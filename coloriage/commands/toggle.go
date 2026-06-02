package commands

import "os/exec"

func Toggle(kind string) {
	exec.Command("toggle-light-and-dark.sh", kind).Run()
}

func Test() {
	exec.Command("xsettingsd").Start()
	exec.Command("awesome-client", "require('theme').config(); require('panel').reset()").Start()
	exec.Command("pkill", "--signal", "USR1", "nvim").Start()
	exec.Command("pkill", "--signal", "USR1", "kitty").Start()
}

func Refresh() {
	exec.Command("pkill", "--signal", "USR1", "nvim").Start()
	exec.Command("pkill", "--signal", "USR1", "kitty").Start()
}
