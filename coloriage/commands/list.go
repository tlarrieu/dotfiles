package commands

import (
	"fmt"
	"os"
	"strings"
)

func List() {
	files, err := os.ReadDir("palettes")
	if err != nil {
		panic(err)
	}

	for _, file := range files {
		name, _ := strings.CutSuffix(file.Name(), ".json")
		fmt.Println(name)
	}

}
