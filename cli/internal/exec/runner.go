package exec

import (
	"bytes"
	"context"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/ydnikolaev/ai-framework/cli/internal/ui"
)

// Runner executes shell commands and Python scripts
type Runner struct {
	ctx     context.Context
	workDir string
	verbose bool
}

// New creates a new Runner
func New(ctx context.Context, workDir string) *Runner {
	return &Runner{
		ctx:     ctx,
		workDir: workDir,
		verbose: os.Getenv("AG_VERBOSE") == "1",
	}
}

// Run executes a command and returns output
func (r *Runner) Run(name string, args ...string) (string, error) {
	cmd := exec.CommandContext(r.ctx, name, args...)
	cmd.Dir = r.workDir

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	if r.verbose {
		fmt.Printf("%s Running: %s %s\n", ui.Muted("→"), name, strings.Join(args, " "))
	}

	if err := cmd.Run(); err != nil {
		return "", fmt.Errorf("%w: %s", err, stderr.String())
	}

	return strings.TrimSpace(stdout.String()), nil
}

// RunInteractive runs command with stdin/stdout attached
func (r *Runner) RunInteractive(name string, args ...string) error {
	cmd := exec.CommandContext(r.ctx, name, args...)
	cmd.Dir = r.workDir
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.Run()
}

// RunPython executes a Python script
func (r *Runner) RunPython(scriptPath string, args ...string) error {
	allArgs := append([]string{scriptPath}, args...)
	return r.RunInteractive("python3", allArgs...)
}

// GitInit initializes a git repository
func (r *Runner) GitInit() error {
	_, err := r.Run("git", "init")
	return err
}

// GitAddSubmodule adds a git submodule
func (r *Runner) GitAddSubmodule(url, path string) error {
	_, err := r.Run("git", "submodule", "add", url, path)
	return err
}

// GitCommit creates a commit
func (r *Runner) GitCommit(message string) error {
	if _, err := r.Run("git", "add", "-A"); err != nil {
		return err
	}
	_, err := r.Run("git", "commit", "-m", message)
	return err
}

// GitRemoteAdd adds a remote
func (r *Runner) GitRemoteAdd(name, url string) error {
	_, err := r.Run("git", "remote", "add", name, url)
	return err
}

// GitPush pushes to remote
func (r *Runner) GitPush(remote, branch string) error {
	_, err := r.Run("git", "push", "-u", remote, branch)
	return err
}

// GHAuthStatus checks if gh is authenticated
func (r *Runner) GHAuthStatus() bool {
	_, err := r.Run("gh", "auth", "status")
	return err == nil
}

// GHUser returns the authenticated GitHub username
func (r *Runner) GHUser() (string, error) {
	return r.Run("gh", "api", "user", "-q", ".login")
}

// GHRepoCreate creates a GitHub repository
func (r *Runner) GHRepoCreate(name string, private bool) error {
	args := []string{"repo", "create", name, "--source=.", "--remote=origin", "--push"}
	if private {
		args = append(args, "--private")
	} else {
		args = append(args, "--public")
	}
	return r.RunInteractive("gh", args...)
}

// GHSSHKeyAdd adds SSH key to GitHub
func (r *Runner) GHSSHKeyAdd(keyPath, title string) error {
	_, err := r.Run("gh", "ssh-key", "add", keyPath, "--title", title, "--type", "authentication")
	return err
}

// SSHKeygen generates SSH key
func (r *Runner) SSHKeygen(keyPath, comment string) error {
	return r.RunInteractive("ssh-keygen", "-t", "ed25519", "-C", comment, "-f", keyPath, "-N", "")
}

// FileExists checks if file exists
func FileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

// AppendToFile appends content to file
func AppendToFile(path, content string) error {
	f, err := os.OpenFile(path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	defer f.Close()

	_, err = f.WriteString(content)
	return err
}
