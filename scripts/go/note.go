package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"
)

func run() error {
	if len(os.Args) < 2 {
		return fmt.Errorf(
			"you need to specify a filename",
		)
	}

	input := os.Args[1:2][0]
	reg, err := regexp.Compile("[^a-zA-Z0-9]+")
	if err != nil {
		return fmt.Errorf(
			"cleaning filename: %s",
			err,
		)
	}
	s := reg.ReplaceAllString(input, " ")
	fileName := strings.ToLower(s)

	if err != nil {
		return fmt.Errorf(
			"creating a slug: %s",
			err,
		)
	}

	notesDir := os.Getenv("NOTESDIR")
	destination := fmt.Sprintf(
		"%s/0-inbox/%s.md",
		notesDir,
		fileName,
	)

	f, err := os.Create(destination)
	if err != nil {
		return fmt.Errorf(
			"creating a file: %s",
			err,
		)
	}

	defer f.Close()

	now := time.Now()
	formatedTime := now.Format("200601021504")
	d2 := []byte(
		fmt.Sprintf(
			"# \n\n\nLinks:\n%s",
			formatedTime,
		),
	)
	if _, err := f.Write(d2); err != nil {
		return fmt.Errorf(
			"writing to a file: %s",
			err,
		)
	}

	cmd := exec.Command("nvim", destination)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	if err := cmd.Run(); err != nil {
		return fmt.Errorf(
			"error: %s",
			err,
		)
	}

	return nil

}

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(
			os.Stderr, "error: %v\n",
			err,
		)
		os.Exit(1)
	}
}
