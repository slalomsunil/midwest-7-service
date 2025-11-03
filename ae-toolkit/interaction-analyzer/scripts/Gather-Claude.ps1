# Claude Code Chat Collection Orchestrator (PowerShell)
# Orchestrates the collection of Claude Code chat sessions across projects
#
# For detailed documentation, see: claude-support/README.md
#
# FUNCTIONALITY:
# - Auto-detects current workspace and processes it (preserves existing UX)
# - -AllProjects mode discovers and processes all Claude projects
# - Delegates actual processing to Gather-ClaudeProject.ps1
# - Generates consolidated summaries across projects

param(
    [Parameter(Position=0)]
    [ValidateSet("list", "collect")]
    [string]$Action = "collect",
    
    [Alias("a")]
    [switch]$AllProjects,
    
    [Alias("p")]
    [string]$ProjectPath,
    
    [Alias("n")]
    [int]$Number,
    
    [Alias("s")]
    [string]$SessionId,
    
    [Alias("f")]
    [switch]$Force,
    
    [switch]$DebugMode,
    
    [Alias("h")]
    [switch]$Help
)

# Show usage information
function Show-Usage {
    Write-Host "Usage: .\Gather-Claude.ps1 [ACTION] [OPTIONS]"
    Write-Host ""
    Write-Host "Orchestrates Claude Code chat collection across projects."
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  list                  List all available Claude projects"
    Write-Host "  collect               Collect and process chat data (default)"
    Write-Host ""
    Write-Host "Options (for collect action):"
    Write-Host "  -AllProjects          Process all Claude projects"
    Write-Host "  -ProjectPath PATH     Process specific Claude project"
    Write-Host "  -Number NUM           Process only the NUM most recent chats from each project"
    Write-Host "  -SessionId ID         Process only the chat with the specified session ID"
    Write-Host "  -Force                Force reprocessing of all files"
    Write-Host "  -DebugMode            Keep intermediate files for debugging"
    Write-Host "  -Help                 Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Gather-Claude.ps1 list"
    Write-Host "  .\Gather-Claude.ps1"
    Write-Host "  .\Gather-Claude.ps1 collect -ProjectPath '-Users-allenh-projects-my-app'"
    Write-Host "  .\Gather-Claude.ps1 collect -AllProjects"
    Write-Host "  .\Gather-Claude.ps1 collect -AllProjects -Number 5"
    Write-Host "  .\Gather-Claude.ps1 collect -SessionId abc123"
    Write-Host ""
    Write-Host "Requirements:"
    Write-Host "  - PowerShell 5.1 or later"
    Write-Host "  - ConvertFrom-Json cmdlet"
    Write-Host "  - claude-support/Gather-ClaudeProject.ps1 script"
}

if ($Help) {
    Show-Usage
    exit 0
}

# Validate parameter combinations
if ($Number -and $SessionId) {
    Write-Host "Error: -Number and -SessionId options are mutually exclusive" -ForegroundColor Red
    Show-Usage
    exit 1
}

if ($AllProjects -and $ProjectPath) {
    Write-Host "Error: -AllProjects and -ProjectPath options are mutually exclusive" -ForegroundColor Red
    Show-Usage
    exit 1
}

# Script directory and build output path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModuleDir = Split-Path -Parent $ScriptDir
$BuildDir = Join-Path $ModuleDir "build"
$OutputDir = Join-Path $BuildDir "claude-chats"

# Import common functions
Import-Module (Join-Path $ScriptDir "CommonFunctions.psm1") -Force

# Import Claude project discovery functions
. (Join-Path $ScriptDir "claude-support\ClaudeProjectDiscovery.ps1")

# Ensure build directory exists
New-DirectoryIfNotExists $BuildDir | Out-Null
New-DirectoryIfNotExists $OutputDir | Out-Null

# Build arguments for Gather-ClaudeProject.ps1
function Build-ProjectArgs {
    $args = @()
    
    if ($Number) {
        $args += "-Number", $Number
    }
    
    if ($SessionId) {
        $args += "-SessionId", $SessionId
    }
    
    if ($Force) {
        $args += "-Force"
    }
    
    if ($DebugMode) {
        $args += "-DebugMode"
    }
    
    return $args
}

# Generate consolidated summary
function New-ConsolidatedSummary {
    param([int]$ProjectCount)
    
    $summaryFile = Join-Path $OutputDir "all-projects-summary.md"
    
    $content = @"
# Claude Code Chat Collection - All Projects Summary

**Generated:** $(Get-Date)
**Total Projects Processed:** $ProjectCount

## Project Summaries

"@
    
    # List each project's summary
    Get-ChildItem $OutputDir -Directory | ForEach-Object {
        $projectDir = $_.FullName
        $projectName = $_.Name
        $projectSummaryFile = Join-Path $projectDir "project-summary.md"
        
        if (Test-Path $projectSummaryFile) {
            $summaryContent = Get-Content $projectSummaryFile -Raw
            $chatCount = if ($summaryContent -match "Total Chats Found:\s*(\d+)") { $matches[1] } else { "0" }
            $processedCount = if ($summaryContent -match "Chats Processed:\s*(\d+)") { $matches[1] } else { "0" }
            
            $content += @"

### $projectName
- **Total Chats:** $chatCount
- **Processed:** $processedCount
- **Details:** [project-summary.md]($projectName/project-summary.md)

"@
        }
    }
    
    $content | Out-File -FilePath $summaryFile -Encoding UTF8
    Write-Success "✓ Consolidated summary: $summaryFile"
}

# Main execution
function Main {
    # Handle list action
    if ($Action -eq "list") {
        Show-AvailableProjects
        return 0
    }
    
    # Handle collect action
    Write-Info "Claude Code Chat Collection Orchestrator"
    Write-Host "==========================================" -ForegroundColor Cyan
    
    # Check if Claude directory exists
    if (!(Test-ClaudeInstallation)) {
        Write-Error "Claude Code projects directory not found. Please ensure Claude Code is installed."
        exit 1
    }
    
    $projectScript = Join-Path $ScriptDir "claude-support\Gather-ClaudeProject.ps1"
    
    # Check if the project script exists
    if (!(Test-Path $projectScript)) {
        Write-Error "Error: Gather-ClaudeProject.ps1 not found at: $projectScript"
        exit 1
    }
    
    $projectArgs = Build-ProjectArgs
    
    if ($AllProjects) {
        # Clean entire claude-chats directory when using -AllProjects with -Force
        if ($Force) {
            Write-Warning "Force reprocessing enabled - cleaning entire claude-chats directory"
            if (Test-Path $OutputDir) {
                Remove-Item $OutputDir -Recurse -Force
            }
            New-DirectoryIfNotExists $OutputDir | Out-Null
        }
        
        Write-Info "Processing all Claude projects..."
        Write-Host ""
        
        $projects = Get-AvailableProjectDirs
        $projectCount = 0
        
        if (-not $projects) {
            Write-Warning "No Claude projects found"
            exit 0
        }
        
        # Process each project
        foreach ($projectPath in $projects) {
            if ($projectPath) {
                $projectName = $projectPath
                $projectCount++
                
                Write-Info "Processing project: $projectName"
                
                # Call Gather-ClaudeProject.ps1 with -ProjectPath flag
                $allArgs = @("-ProjectPath", $projectName) + $projectArgs
                try {
                    & $projectScript @allArgs
                    if ($LASTEXITCODE -ne 0) {
                        Write-Error "✗ Failed: $projectName"
                    }
                } catch {
                    Write-Error "✗ Failed: $projectName - $($_.Exception.Message)"
                }
                Write-Host ""
            }
        }
        
        # Generate consolidated summary
        New-ConsolidatedSummary $projectCount
        
    } else {
        # Determine project path (provided or auto-detect)
        $targetProjectPath = $ProjectPath
        
        if (-not $targetProjectPath) {
            Write-Info "Auto detecting project..."
            $detectedProjectDir = Find-ClaudeProjectDir
            $targetProjectPath = Split-Path $detectedProjectDir -Leaf
            Write-Host ""
        }
        
        Write-Info "Processing project: $targetProjectPath"
        Write-Host ""
        
        # Call Gather-ClaudeProject.ps1 with project path
        $allArgs = @("-ProjectPath", $targetProjectPath) + $projectArgs
        try {
            & $projectScript @allArgs
            if ($LASTEXITCODE -ne 0) {
                Write-Error "✗ Processing failed"
                exit 1
            }
        } catch {
            Write-Error "✗ Processing failed - $($_.Exception.Message)"
            exit 1
        }
    }
}

# Run main function
Main
