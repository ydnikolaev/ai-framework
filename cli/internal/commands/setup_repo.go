package commands

import (
	"context"
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/ydnikolaev/ai-framework/cli/internal/config"
	"github.com/ydnikolaev/ai-framework/cli/internal/exec"
	"github.com/ydnikolaev/ai-framework/cli/internal/ui"
)

// SetupRepoCmd creates the 'ag repo' command
func SetupRepoCmd(ctx context.Context) *cobra.Command {
	return &cobra.Command{
		Use:   "repo",
		Short: "Create GitHub repository and push",
		Long:  "Creates repo on GitHub, commits, and pushes initial code",
		RunE: func(cmd *cobra.Command, args []string) error {
			cwd, _ := os.Getwd()
			projectName := config.GetProjectName(cwd)
			
			runner := exec.New(ctx, cwd)
			ghUser, _ := runner.GHUser()
			
			return runRepoSetup(ctx, cwd, projectName, true, ghUser)
		},
	}
}

func runRepoSetup(ctx context.Context, projectDir, projectName string, private bool, ghUser string) error {
	fmt.Println(ui.Header("🔗 GitHub Repository Setup"))
	fmt.Println()

	runner := exec.New(ctx, projectDir)

	// Check prerequisites
	if !runner.GHAuthStatus() {
		return fmt.Errorf("gh not authenticated, run: gh auth login")
	}

	if ghUser == "" {
		var err error
		ghUser, err = runner.GHUser()
		if err != nil {
			return err
		}
	}

	fmt.Println("  GitHub user:", ui.Success(ghUser))
	fmt.Println("  Repository:", ui.Success(fmt.Sprintf("%s/%s", ghUser, projectName)))
	fmt.Println()

	// Form for customization
	var repoName = projectName
	var visibility = "private"
	if !private {
		visibility = "public"
	}
	var createNew = true

	form := ui.RepoForm(&repoName, &visibility, &createNew)
	if err := form.Run(); err != nil {
		return err
	}

	// Initial commit
	fmt.Println(ui.Title("Creating initial commit..."))
	if err := runner.GitCommit("Initial commit with ai-framework"); err != nil {
		fmt.Println(ui.Warning("Commit failed (may already exist)"))
	} else {
		fmt.Println(ui.Check(), "Committed")
	}

	// Create repo or just push
	if createNew {
		fmt.Println(ui.Title("Creating repository on GitHub..."))
		if err := runner.GHRepoCreate(repoName, visibility == "private"); err != nil {
			return err
		}
		fmt.Println(ui.Check(), "Repository created and pushed!")
	} else {
		// Just add remote and push
		fmt.Println(ui.Title("Adding remote and pushing..."))
		remoteURL := fmt.Sprintf("git@github-%s:%s/%s.git", projectName, ghUser, repoName)
		_ = runner.GitRemoteAdd("origin", remoteURL)
		
		if _, err := runner.Run("git", "branch", "-M", "main"); err != nil {
			return err
		}
		if err := runner.GitPush("origin", "main"); err != nil {
			return err
		}
		fmt.Println(ui.Check(), "Pushed to existing repository!")
	}

	fmt.Println()
	fmt.Println(ui.Check(), ui.Success("Repository setup complete!"))
	fmt.Println()
	fmt.Println("  URL:", fmt.Sprintf("https://github.com/%s/%s", ghUser, repoName))

	return nil
}
