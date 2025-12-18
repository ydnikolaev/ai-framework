package dxlog

import (
	"fmt"
	"log/slog"
	"os"
	"strings"
	"sync/atomic"
	"time"
)

// ═══════════════════════════════════════════════════════════════
// DX Logger - Beautiful logging utilities for Go projects
// ═══════════════════════════════════════════════════════════════

var (
	// Request counter for tracking
	requestCounter uint64
	
	// Default separator character
	SeparatorChar = "═"
	SeparatorLen  = 60
)

// Colors for terminal output
const (
	ColorReset  = "\033[0m"
	ColorRed    = "\033[31m"
	ColorGreen  = "\033[32m"
	ColorYellow = "\033[33m"
	ColorBlue   = "\033[34m"
	ColorPurple = "\033[35m"
	ColorCyan   = "\033[36m"
	ColorGray   = "\033[90m"
)

// NewRequest prints a visual separator and logs a new request start.
// Returns request ID for correlation.
func NewRequest(emoji string, label string, attrs ...any) uint64 {
	id := atomic.AddUint64(&requestCounter, 1)
	
	separator := strings.Repeat(SeparatorChar, SeparatorLen)
	fmt.Fprintf(os.Stdout, "\n%s%s%s\n", ColorCyan, separator, ColorReset)
	
	// Add request ID to attrs
	allAttrs := append([]any{"req_id", id}, attrs...)
	slog.Info(fmt.Sprintf("%s %s", emoji, label), allAttrs...)
	
	return id
}

// Section prints a smaller separator for sub-sections
func Section(label string) {
	separator := strings.Repeat("─", 40)
	fmt.Fprintf(os.Stdout, "%s%s %s%s\n", ColorGray, separator, label, ColorReset)
}

// Success logs a success message with green checkmark
func Success(msg string, attrs ...any) {
	slog.Info(fmt.Sprintf("✅ %s", msg), attrs...)
}

// Fail logs a failure message with red X
func Fail(msg string, attrs ...any) {
	slog.Warn(fmt.Sprintf("❌ %s", msg), attrs...)
}

// Step logs a step in a process
func Step(step int, total int, msg string, attrs ...any) {
	slog.Info(fmt.Sprintf("▸ [%d/%d] %s", step, total, msg), attrs...)
}

// Timer returns a function that logs elapsed time when called
func Timer(label string) func() {
	start := time.Now()
	return func() {
		elapsed := time.Since(start)
		slog.Info(fmt.Sprintf("⏱️ %s", label), "elapsed", elapsed.Round(time.Millisecond))
	}
}

// Box prints text in a box for highlighting
func Box(text string) {
	width := len(text) + 4
	border := strings.Repeat("═", width)
	
	fmt.Printf("\n╔%s╗\n", border)
	fmt.Printf("║  %s  ║\n", text)
	fmt.Printf("╚%s╝\n\n", border)
}

// Table prints key-value pairs in a nice format
func Table(title string, data map[string]any) {
	fmt.Printf("\n%s%s:%s\n", ColorCyan, title, ColorReset)
	for k, v := range data {
		fmt.Printf("  %s%-15s%s %v\n", ColorGray, k, ColorReset, v)
	}
}
