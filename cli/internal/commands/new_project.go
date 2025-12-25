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

const aiFrameworkURL = "git@github.com:ydnikolaev/ai-framework.git"

// NewProjectCmd creates the 'ag new' command
func NewProjectCmd(ctx context.Context) *cobra.Command {
	return &cobra.Command{
		Use:   "new [project-name]",
		Short: "Create a new project with ai-framework",
		Long:  "Creates a complete new project: git init, submodule, SSH keys, GitHub repo",
		Args:  cobra.MaximumNArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			return runNewProject(ctx, args)
		},
	}
}

func runNewProject(ctx context.Context, args []string) error {
	fmt.Println(ui.Header("🚀 New Project Setup"))
	fmt.Println()

	// Check prerequisites
	fmt.Println(ui.Title("Checking prerequisites..."))
	runner := exec.New(ctx, ".")

	if !runner.GHAuthStatus() {
		fmt.Println(ui.Cross(), ui.ErrorText("GitHub CLI not authenticated"))
		fmt.Println(ui.Muted("   Run: gh auth login"))
		return fmt.Errorf("gh not authenticated")
	}
	fmt.Println(ui.Check(), "gh authenticated")

	ghUser, err := runner.GHUser()
	if err != nil {
		return fmt.Errorf("failed to get GitHub user: %w", err)
	}
	fmt.Println(ui.Check(), "GitHub user:", ui.Success(ghUser))
	fmt.Println()

	// Get project name
	var projectName string
	var visibility string = "private"

	if len(args) > 0 {
		projectName = args[0]
	} else {
		form := ui.NewProjectForm(&projectName, &visibility)
		if err := form.Run(); err != nil {
			return err
		}
	}

	if projectName == "" {
		return fmt.Errorf("project name required")
	}

	// Check if directory exists
	projectDir := filepath.Join(".", projectName)
	if exec.FileExists(projectDir) {
		return fmt.Errorf("directory already exists: %s", projectDir)
	}

	fmt.Println(ui.Title("Creating project: ") + ui.Success(projectName))
	fmt.Println()

	// Step 1: Create directory and git init
	fmt.Println(ui.Title("Step 1/5:"), "Creating directory...")
	if err := os.MkdirAll(projectDir, 0755); err != nil {
		return err
	}

	projectRunner := exec.New(ctx, projectDir)
	if err := projectRunner.GitInit(); err != nil {
		return err
	}
	fmt.Println(ui.Check(), "Git initialized")

	// Step 2: Add submodule
	fmt.Println()
	fmt.Println(ui.Title("Step 2/5:"), "Adding ai-framework submodule...")
	if err := projectRunner.GitAddSubmodule(aiFrameworkURL, "ai-framework"); err != nil {
		return err
	}
	fmt.Println(ui.Check(), "Submodule added")

	// Step 3: Run setup.sh
	fmt.Println()
	fmt.Println(ui.Title("Step 3/5:"), "Running setup.sh...")
	setupPath := filepath.Join(projectDir, "ai-framework", "setup.sh")
	if err := exec.New(ctx, filepath.Join(projectDir, "ai-framework")).RunInteractive("bash", setupPath); err != nil {
		return err
	}
	fmt.Println(ui.Check(), "Setup complete")

	// Step 4: Setup SSH
	fmt.Println()
	fmt.Println(ui.Title("Step 4/5:"), "Setting up SSH keys...")
	if err := runSSHSetup(ctx, projectDir, projectName, ghUser); err != nil {
		fmt.Println(ui.Warning("SSH setup failed, continuing..."))
	} else {
		fmt.Println(ui.Check(), "SSH configured")
	}

	// Step 5: Create repo
	fmt.Println()
	fmt.Println(ui.Title("Step 5/5:"), "Creating GitHub repository...")
	if err := runRepoSetup(ctx, projectDir, projectName, visibility == "private", ghUser); err != nil {
		fmt.Println(ui.Warning("Repo setup failed, continuing..."))
	} else {
		fmt.Println(ui.Check(), "Repository created")
	}

	// Summary
	fmt.Println()
	fmt.Println(ui.Header("✅ Project created successfully!"))
	fmt.Println()
	fmt.Println("  Directory:", projectDir)
	fmt.Println("  Repository:", fmt.Sprintf("https://github.com/%s/%s", ghUser, projectName))
	fmt.Println("  SSH alias:", fmt.Sprintf("github-%s", projectName))
	fmt.Println()
	fmt.Println(ui.Muted("Next steps:"))
	fmt.Println(ui.Muted(fmt.Sprintf("  cd %s", projectName)))
	fmt.Println(ui.Muted("  # Edit .env with your tokens"))
	fmt.Println(ui.Muted("  make dev-full"))

	return nil
}
