package main

import (
	"context"
	"os"
	"os/signal"

	"github.com/spf13/cobra"
	"github.com/ydnikolaev/ai-framework/cli/internal/commands"
	"github.com/ydnikolaev/ai-framework/cli/internal/ui"
)

var version = "0.1.0"

func main() {
	// Graceful exit on Ctrl+C
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	rootCmd := &cobra.Command{
		Use:     "ag",
		Short:   "AI-Framework CLI",
		Long:    ui.Header("ag — AI-Framework Developer Tools"),
		Version: version,
	}

	// Add subcommands
	rootCmd.AddCommand(commands.NewProjectCmd(ctx))
	rootCmd.AddCommand(commands.SetupSSHCmd(ctx))
	rootCmd.AddCommand(commands.SetupRepoCmd(ctx))
	rootCmd.AddCommand(commands.DevRoutesCmd(ctx))
	rootCmd.AddCommand(commands.SetupCmd(ctx))

	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
