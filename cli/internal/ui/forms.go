package ui

import (
	"errors"

	"github.com/charmbracelet/huh"
)

// NewProjectForm creates form for new project setup
func NewProjectForm(projectName *string, visibility *string) *huh.Form {
	return huh.NewForm(
		huh.NewGroup(
			huh.NewInput().
				Title("Project Name").
				Description("lowercase, only a-z, 0-9, -").
				Placeholder("mybot").
				Value(projectName).
				Validate(func(s string) error {
					if s == "" {
						return errors.New("project name is required")
					}
					return nil
				}),

			huh.NewSelect[string]().
				Title("Repository Visibility").
				Options(
					huh.NewOption("Private", "private"),
					huh.NewOption("Public", "public"),
				).
				Value(visibility),
		),
	).WithTheme(huh.ThemeDracula())
}

// ConfirmForm creates a confirmation dialog
func ConfirmForm(message string, confirmed *bool) *huh.Form {
	return huh.NewForm(
		huh.NewGroup(
			huh.NewConfirm().
				Title(message).
				Affirmative("Yes").
				Negative("No").
				Value(confirmed),
		),
	).WithTheme(huh.ThemeDracula())
}

// SSHForm creates form for SSH setup
func SSHForm(projectName *string, serverIP *string) *huh.Form {
	return huh.NewForm(
		huh.NewGroup(
			huh.NewInput().
				Title("Project Name").
				Description("Used for SSH key naming").
				Value(projectName).
				Validate(func(s string) error {
					if s == "" {
						return errors.New("project name is required")
					}
					return nil
				}),

			huh.NewInput().
				Title("Server IP").
				Description("Optional - press Enter to skip").
				Placeholder("1.2.3.4").
				Value(serverIP),
		),
	).WithTheme(huh.ThemeDracula())
}

// SetupForm creates interactive setup form
func SetupForm(projectName *string, backend *string, frontend *string, database *string) *huh.Form {
	return huh.NewForm(
		huh.NewGroup(
			huh.NewInput().
				Title("Project Name").
				Placeholder("mybot").
				Value(projectName),
		),
		huh.NewGroup(
			huh.NewSelect[string]().
				Title("Backend").
				Options(
					huh.NewOption("Go (Chi)", "go-chi"),
					huh.NewOption("Go (Fiber)", "go-fiber"),
					huh.NewOption("Node.js", "nodejs"),
					huh.NewOption("None", "none"),
				).
				Value(backend),

			huh.NewSelect[string]().
				Title("Frontend").
				Options(
					huh.NewOption("Nuxt 4", "nuxt4"),
					huh.NewOption("Vue 3", "vue3"),
					huh.NewOption("React", "react"),
					huh.NewOption("None", "none"),
				).
				Value(frontend),

			huh.NewSelect[string]().
				Title("Database").
				Options(
					huh.NewOption("PostgreSQL", "postgres"),
					huh.NewOption("SQLite", "sqlite"),
					huh.NewOption("None", "none"),
				).
				Value(database),
		),
	).WithTheme(huh.ThemeDracula())
}

// RepoForm creates form for repository setup
func RepoForm(repoName *string, visibility *string, createNew *bool) *huh.Form {
	return huh.NewForm(
		huh.NewGroup(
			huh.NewInput().
				Title("Repository Name").
				Value(repoName),

			huh.NewSelect[string]().
				Title("Visibility").
				Options(
					huh.NewOption("Private", "private"),
					huh.NewOption("Public", "public"),
				).
				Value(visibility),

			huh.NewConfirm().
				Title("Create new repository on GitHub?").
				Description("No = use existing repository").
				Value(createNew),
		),
	).WithTheme(huh.ThemeDracula())
}
