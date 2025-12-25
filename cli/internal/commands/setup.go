package commands

import (
	"context"
	"fmt"
	"os"
	"path/filepath"

	"github.com/spf13/cobra"
	"github.com/ydnikolaev/ai-framework/cli/internal/exec"
	"github.com/ydnikolaev/ai-framework/cli/internal/ui"
)

// SetupCmd creates the 'ag setup' command
func SetupCmd(ctx context.Context) *cobra.Command {
	return &cobra.Command{
		Use:   "setup",
		Short: "Interactive framework setup",
		Long:  "Runs interactive setup to configure project stack and copy templates",
		RunE: func(cmd *cobra.Command, args []string) error {
			return runSetup(ctx)
		},
	}
}

func runSetup(ctx context.Context) error {
	fmt.Println(ui.Header("⚙️ AI-Framework Setup"))
	fmt.Println()

	// Get form values
	var projectName string
	var backend string = "go-chi"
	var frontend string = "nuxt4"
	var database string = "postgres"

	form := ui.SetupForm(&projectName, &backend, &frontend, &database)
	if err := form.Run(); err != nil {
		return err
	}

	fmt.Println()
	fmt.Println(ui.Title("Configuration:"))
	fmt.Println("  Project:", ui.Success(projectName))
	fmt.Println("  Backend:", ui.Muted(backend))
	fmt.Println("  Frontend:", ui.Muted(frontend))
	fmt.Println("  Database:", ui.Muted(database))
	fmt.Println()

	// Confirm
	var confirmed bool
	confirmForm := ui.ConfirmForm("Proceed with setup?", &confirmed)
	if err := confirmForm.Run(); err != nil {
		return err
	}

	if !confirmed {
		fmt.Println(ui.Muted("Cancelled"))
		return nil
	}

	// Find framework and project dirs
	cwd, _ := os.Getwd()
	frameworkDir := cwd

	// Check if we're in ai-framework or project root
	if filepath.Base(cwd) == "ai-framework" {
		// We're in ai-framework, project root is parent
		frameworkDir = cwd
	} else {
		// We're in project root
		frameworkDir = filepath.Join(cwd, "ai-framework")
	}

	// Run the bash setup script for now
	// In future, this can be fully Go-native
	fmt.Println(ui.Title("Running setup..."))

	setupScript := filepath.Join(frameworkDir, "setup.sh")
	runner := exec.New(ctx, frameworkDir)

	if err := runner.RunInteractive("bash", setupScript); err != nil {
		return err
	}

	fmt.Println()
	fmt.Println(ui.Check(), ui.Success("Setup complete!"))
	fmt.Println()
	fmt.Println(ui.Muted("Next: edit .env with your tokens"))

	return nil
}
