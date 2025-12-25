package ui

import "github.com/charmbracelet/lipgloss"

var (
	// Colors
	ColorPrimary   = lipgloss.Color("#7C3AED") // Purple
	ColorSecondary = lipgloss.Color("#06B6D4") // Cyan
	ColorSuccess   = lipgloss.Color("#10B981") // Green
	ColorWarning   = lipgloss.Color("#F59E0B") // Yellow
	ColorError     = lipgloss.Color("#EF4444") // Red
	ColorMuted     = lipgloss.Color("#6B7280") // Gray

	// Styles
	HeaderStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(ColorPrimary).
			BorderStyle(lipgloss.DoubleBorder()).
			BorderForeground(ColorPrimary).
			Padding(0, 2)

	TitleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(ColorSecondary)

	SuccessStyle = lipgloss.NewStyle().
			Foreground(ColorSuccess)

	WarningStyle = lipgloss.NewStyle().
			Foreground(ColorWarning)

	ErrorStyle = lipgloss.NewStyle().
			Foreground(ColorError)

	MutedStyle = lipgloss.NewStyle().
			Foreground(ColorMuted)

	CheckStyle = lipgloss.NewStyle().
			Foreground(ColorSuccess).
			SetString("✓")

	CrossStyle = lipgloss.NewStyle().
			Foreground(ColorError).
			SetString("✗")
)

// Header renders a styled header
func Header(text string) string {
	return HeaderStyle.Render(text)
}

// Title renders a styled title
func Title(text string) string {
	return TitleStyle.Render(text)
}

// Success renders success text
func Success(text string) string {
	return SuccessStyle.Render(text)
}

// Warning renders warning text
func Warning(text string) string {
	return WarningStyle.Render(text)
}

// Error renders error text
func ErrorText(text string) string {
	return ErrorStyle.Render(text)
}

// Muted renders muted text
func Muted(text string) string {
	return MutedStyle.Render(text)
}

// Check returns a green checkmark
func Check() string {
	return CheckStyle.String()
}

// Cross returns a red cross
func Cross() string {
	return CrossStyle.String()
}

// Step renders a step indicator
func Step(current, total int, text string) string {
	return TitleStyle.Render("  Step "+string(rune('0'+current))+"/"+string(rune('0'+total))+": ") + text
}
