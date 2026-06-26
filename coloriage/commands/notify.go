package commands

import (
	"os/exec"
)

func Notify(msg string) {
	exec.Command("/usr/bin/notify-send", msg).Run()
}
