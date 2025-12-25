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

// DevRoutesCmd creates the 'ag routes' command
func DevRoutesCmd(ctx context.Context) *cobra.Command {
	return &cobra.Command{
		Use:   "routes",
		Short: "Add dev tunnel routes to Traefik",
		Long:  "Adds dev.domain and api-dev.domain routes to Traefik on server",
		RunE: func(cmd *cobra.Command, args []string) error {
			return runDevRoutes(ctx)
		},
	}
}

func runDevRoutes(ctx context.Context) error {
	fmt.Println(ui.Header("🔧 Dev Routes Setup"))
	fmt.Println()

	cwd, _ := os.Getwd()
	cfg, err := config.Load(cwd)
	if err != nil {
		return err
	}

	if cfg.ProdServer == "" || cfg.Domain == "" {
		return fmt.Errorf("PROD_SERVER and DOMAIN required in .env")
	}

	projectName := cfg.ProjectName
	if projectName == "" {
		projectName = config.GetProjectName(cwd)
	}

	fmt.Println("  Project:", ui.Success(projectName))
	fmt.Println("  Domain:", ui.Muted(cfg.Domain))
	fmt.Println("  Server:", ui.Muted(cfg.ProdServer))
	fmt.Println()

	// Routes to add
	devDomain := fmt.Sprintf("dev.%s", cfg.Domain)
	apiDevDomain := fmt.Sprintf("api-dev.%s", cfg.Domain)

	fmt.Println(ui.Title("Routes to add:"))
	fmt.Println("  •", devDomain, "→", "host.docker.internal:31337")
	fmt.Println("  •", apiDevDomain, "→", "host.docker.internal:31338")
	fmt.Println()

	// Confirm
	var confirmed bool
	form := ui.ConfirmForm("Add these routes to server?", &confirmed)
	if err := form.Run(); err != nil {
		return err
	}

	if !confirmed {
		fmt.Println(ui.Muted("Cancelled"))
		return nil
	}

	// Generate YAML - use string concat to escape backticks
	bt := "`" // backtick for YAML
	routesYAML := fmt.Sprintf(`
# === %s Dev Tunnels ===
http:
  routers:
    %s-dev:
      rule: "Host(%s%s%s)"
      service: "%s-dev-service"
      entryPoints:
        - "websecure"
      tls:
        certResolver: "letsencrypt"
    
    %s-api-dev:
      rule: "Host(%s%s%s)"
      service: "%s-api-dev-service"
      entryPoints:
        - "websecure"
      tls:
        certResolver: "letsencrypt"

  services:
    %s-dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31337"
    
    %s-api-dev-service:
      loadBalancer:
        servers:
          - url: "http://host.docker.internal:31338"
`, projectName, projectName, bt, devDomain, bt, projectName,
		projectName, bt, apiDevDomain, bt, projectName,
		projectName, projectName)

	// Execute on server
	runner := exec.New(ctx, cwd)

	fmt.Println(ui.Title("Adding routes to server..."))

	// SSH command to append to dynamic.yml
	sshCmd := fmt.Sprintf("cat >> ~/traefik/dynamic.yml << 'EOF'%sEOF", routesYAML)
	if _, err := runner.Run("ssh", cfg.ProdServer, sshCmd); err != nil {
		return fmt.Errorf("failed to add routes: %w", err)
	}
	fmt.Println(ui.Check(), "Routes added")

	// Restart Traefik
	fmt.Println(ui.Title("Restarting Traefik..."))
	if _, err := runner.Run("ssh", cfg.ProdServer, "cd ~/traefik && docker compose restart traefik"); err != nil {
		return fmt.Errorf("failed to restart Traefik: %w", err)
	}
	fmt.Println(ui.Check(), "Traefik restarted")

	fmt.Println()
	fmt.Println(ui.Check(), ui.Success("Dev routes added!"))
	fmt.Println()
	fmt.Println(ui.Muted("Test with:"))
	fmt.Println(ui.Muted(fmt.Sprintf("  curl -I https://%s", devDomain)))

	return nil
}
