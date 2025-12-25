package config

import (
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
	"gopkg.in/yaml.v3"
)

// Config holds project configuration
type Config struct {
	ProjectName string
	Domain      string
	ProdServer  string
	ProdDir     string
	GHUser      string
	
	// Paths
	ProjectRoot   string
	FrameworkDir  string
}

// ProjectConfig represents CONFIG.yaml structure
type ProjectConfig struct {
	Project struct {
		Name    string `yaml:"name"`
		Version string `yaml:"version"`
	} `yaml:"project"`
	Stack struct {
		Backend  string `yaml:"backend"`
		Frontend string `yaml:"frontend"`
		Database string `yaml:"database"`
	} `yaml:"stack"`
}

// Load loads configuration from .env and CONFIG.yaml
func Load(projectRoot string) (*Config, error) {
	cfg := &Config{
		ProjectRoot: projectRoot,
	}

	// Find ai-framework directory
	cfg.FrameworkDir = filepath.Join(projectRoot, "ai-framework")
	if _, err := os.Stat(cfg.FrameworkDir); os.IsNotExist(err) {
		// Maybe we're running from within ai-framework
		cfg.FrameworkDir = projectRoot
		cfg.ProjectRoot = filepath.Dir(projectRoot)
	}

	// Load .env if exists
	envPath := filepath.Join(cfg.ProjectRoot, ".env")
	if _, err := os.Stat(envPath); err == nil {
		if err := godotenv.Load(envPath); err != nil {
			return nil, err
		}
	}

	// Read from environment
	cfg.ProjectName = os.Getenv("PROJECT_NAME")
	cfg.Domain = os.Getenv("DOMAIN")
	cfg.ProdServer = os.Getenv("PROD_SERVER")
	cfg.ProdDir = os.Getenv("PROD_DIR")

	return cfg, nil
}

// LoadProjectConfig loads CONFIG.yaml
func LoadProjectConfig(projectRoot string) (*ProjectConfig, error) {
	configPath := filepath.Join(projectRoot, "project", "CONFIG.yaml")
	
	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, err
	}

	var cfg ProjectConfig
	if err := yaml.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}

	return &cfg, nil
}

// GetProjectName returns project name from config or folder name
func GetProjectName(projectRoot string) string {
	// Try from .env
	if name := os.Getenv("PROJECT_NAME"); name != "" {
		return name
	}

	// Try from CONFIG.yaml
	if cfg, err := LoadProjectConfig(projectRoot); err == nil && cfg.Project.Name != "" {
		return cfg.Project.Name
	}

	// Fallback to folder name
	return filepath.Base(projectRoot)
}
