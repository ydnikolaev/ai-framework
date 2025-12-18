# DX Logger for Go

Beautiful logging utilities for better Developer Experience.

## Features

- 📨 **Request separators** - Visual separation between requests
- 🎨 **Colored output** - Terminal colors for better visibility
- ⏱️ **Timers** - Easy performance measurement
- 📊 **Tables** - Pretty-print key-value data
- ✅ **Status indicators** - Success/Fail/Step helpers

## Installation

Copy `dxlog/` folder to your project or import from a shared module.

## Usage

```go
import "yourproject/pkg/dxlog"

func HandleRequest(userID int) {
    // Start a new request with visual separator
    reqID := dxlog.NewRequest("📨", "NEW REQUEST", 
        "user_id", userID,
        "has_photo", true,
    )
    
    // Measure time
    defer dxlog.Timer("Request processing")()
    
    // Log steps
    dxlog.Step(1, 3, "Fetching data", "source", "api")
    dxlog.Step(2, 3, "Processing", "items", 42)
    dxlog.Step(3, 3, "Saving", "db", "postgres")
    
    // Sub-sections
    dxlog.Section("Vision API")
    
    // Status
    dxlog.Success("Movie found", "title", "Inception")
    dxlog.Fail("Enrichment failed", "error", err)
    
    // Highlight important data
    dxlog.Box("Server Started on :8080")
    
    // Pretty tables
    dxlog.Table("Config", map[string]any{
        "Port":     8080,
        "Debug":    true,
        "Database": "postgres",
    })
}
```

## Output Example

```
════════════════════════════════════════════════════════════
14:12:34 INF 📨 NEW REQUEST req_id=42 user_id=123 has_photo=true
14:12:34 INF ▸ [1/3] Fetching data source=api
────────────────────────────── Vision API
14:12:35 INF ✅ Movie found title=Inception
14:12:35 INF ⏱️ Request processing elapsed=1.234s
```
