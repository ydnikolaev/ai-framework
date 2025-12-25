package commands

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/cobra"
	"github.com/ydnikolaev/ai-framework/cli/internal/config"
	"github.com/ydnikolaev/ai-framework/cli/internal/exec"
	"github.com/ydnikolaev/ai-framework/cli/internal/ui"
)

// SetupSSHCmd creates the 'ag ssh' command
func SetupSSHCmd(ctx context.Context) *cobra.Command {
	return &cobra.Command{
		Use:   "ssh",
		Short: "Setup SSH keys for this project",
		Long:  "Generates SSH key, configures ~/.ssh/config, adds key to GitHub",
		RunE: func(cmd *cobra.Command, args []string) error {
			cwd, _ := os.Getwd()
			projectName := config.GetProjectName(cwd)
			
			// Get GitHub user
			runner := exec.New(ctx, cwd)
			ghUser, _ := runner.GHUser()
			
			return runSSHSetup(ctx, cwd, projectName, ghUser)
		},
	}
}

func runSSHSetup(ctx context.Context, projectDir, projectName, ghUser string) error {
	fmt.Println(ui.Header("🔐 SSH Setup"))
	fmt.Println()

	if projectName == "" {
		var serverIP string
		form := ui.SSHForm(&projectName, &serverIP)
		if err := form.Run(); err != nil {
			return err
		}
	}

	keyName := fmt.Sprintf("id_ed25519_%s", projectName)
	keyPath := filepath.Join(os.Getenv("HOME"), ".ssh", keyName)
	keyTitle := fmt.Sprintf("%s-deploy", projectName)

	fmt.Println("  Project:", ui.Success(projectName))
	fmt.Println("  Key:", ui.Muted(keyPath))
	fmt.Println()

	runner := exec.New(ctx, projectDir)

	// Generate SSH key
	if exec.FileExists(keyPath) {
		fmt.Println(ui.Warning("Key already exists, skipping generation"))
	} else {
		fmt.Println(ui.Title("Generating SSH key..."))
		if err := runner.SSHKeygen(keyPath, keyTitle); err != nil {
			return err
		}
		fmt.Println(ui.Check(), "Key generated")
	}

	// Add to ~/.ssh/config
	sshConfig := filepath.Join(os.Getenv("HOME"), ".ssh", "config")
	configEntry := fmt.Sprintf(`
# === %s ===
Host github-%s
  HostName github.com
  User git
  IdentityFile %s
  IdentitiesOnly yes
`, projectName, projectName, keyPath)

	configContent, _ := os.ReadFile(sshConfig)
	if !strings.Contains(string(configContent), fmt.Sprintf("Host github-%s", projectName)) {
		fmt.Println(ui.Title("Adding to ~/.ssh/config..."))
		if err := exec.AppendToFile(sshConfig, configEntry); err != nil {
			return err
		}
		fmt.Println(ui.Check(), fmt.Sprintf("Added github-%s alias", projectName))
	} else {
		fmt.Println(ui.Warning("SSH config already exists"))
	}

	// Add to GitHub via gh CLI
	if runner.GHAuthStatus() {
		fmt.Println(ui.Title("Adding key to GitHub..."))
		pubKeyPath := keyPath + ".pub"
		if err := runner.GHSSHKeyAdd(pubKeyPath, keyTitle); err != nil {
			fmt.Println(ui.Warning("Failed to add key to GitHub (may already exist)"))
		} else {
			fmt.Println(ui.Check(), "Key added to GitHub as", ui.Success(keyTitle))
		}
	} else {
		// Copy to clipboard
		fmt.Println(ui.Warning("gh not authenticated, copying key to clipboard..."))
		pubKeyPath := keyPath + ".pub"
		exec.New(ctx, ".").Run("pbcopy")
		if pubKey, err := os.ReadFile(pubKeyPath); err == nil {
			fmt.Println(ui.Muted("Public key:"))
			fmt.Println(string(pubKey))
		}
	}

	fmt.Println()
	fmt.Println(ui.Check(), ui.Success("SSH setup complete!"))
	fmt.Println()
	fmt.Println(ui.Muted(fmt.Sprintf("Usage: git clone git@github-%s:%s/repo.git", projectName, ghUser)))

	return nil
}
