# Claude Code Project Discovery Functions (PowerShell)
# Provides functions for finding and listing Claude Code projects
#
# Functions provided:
# - Find-ClaudeProjectDir: Finds Claude project directory for current directory
# - Test-ProjectDir: Validates that a specific project path exists
# - Show-AvailableProjects: Lists all available Claude projects
# - Get-AvailableProjectDirs: Returns project directory paths
# - Test-ClaudeInstallation: Checks if Claude is installed
# - ConvertTo-ClaudeEscapedPath: Converts filesystem path to Claude's escaped format

# Import common functions
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CommonFunctionsPath = Join-Path (Split-Path -Parent $ScriptDir) "CommonFunctions.psm1"
if (Test-Path $CommonFunctionsPath) {
    Import-Module $CommonFunctionsPath -Force
}

# Get Claude projects directory
function Get-ClaudeProjectsDir {
    return "$env:USERPROFILE\.claude\projects"
}

# Test if Claude is installed
function Test-ClaudeInstallation {
    $claudeProjectsDir = Get-ClaudeProjectsDir
    return Test-Path $claudeProjectsDir
}

# Convert filesystem path to Claude's escaped format
function ConvertTo-ClaudeEscapedPath {
    param([string]$Path)
    
    # Claude uses a specific escaping format where path separators become dashes
    # and other special characters are encoded
    $escaped = $Path -replace '\\', '-' -replace '/', '-'
    $escaped = $escaped -replace ':', ''
    $escaped = $escaped -replace '\s', '-'
    
    # Ensure it starts with a dash (Claude's convention)
    if (-not $escaped.StartsWith('-')) {
        $escaped = "-$escaped"
    }
    
    return $escaped
}

# Find Claude Code project directory for current directory
function Find-ClaudeProjectDir {
    $currentDir = Get-Location
    Write-Info "Finding Claude Code project for: $currentDir"
    
    $claudeProjectsDir = Get-ClaudeProjectsDir
    
    if (!(Test-Path $claudeProjectsDir)) {
        Write-Error "Error: Claude Code projects directory not found"
        Write-Host "Expected: $claudeProjectsDir"
        exit 1
    }
    
    # Try current directory first, then walk up the tree
    $checkDir = $currentDir
    
    while ($checkDir -and $checkDir.Path -ne [System.IO.Path]::GetPathRoot($checkDir.Path)) {
        # Convert directory to escaped format
        $escapedPath = ConvertTo-ClaudeEscapedPath $checkDir.Path
        Write-Info "    Looking for Claude Code project: $escapedPath"
        $projectDir = Join-Path $claudeProjectsDir $escapedPath
        
        if (Test-Path $projectDir) {
            Write-Success "✓ Found project: $escapedPath"
            return $projectDir
        }
        
        # Move up one directory
        $checkDir = Split-Path $checkDir.Path -Parent
        if ($checkDir) {
            $checkDir = Get-Item $checkDir
        }
    }
    
    # No project found in any ancestor directory
    Write-Warning "Warning: Could not find Claude Code project directory for: $currentDir"
    Write-Warning "Checked all ancestor directories up to root"
    Write-Host ""
    Write-Host "Available Claude projects (escaped format):"
    Get-ChildItem $claudeProjectsDir -Directory | Select-Object -First 5 | ForEach-Object {
        Write-Host "  $($_.Name)"
    }
    exit 1
}

# Validate project directory exists (when provided via -ProjectPath flag)
function Test-ProjectDir {
    param([string]$ProjectPath)
    
    $claudeProjectsDir = Get-ClaudeProjectsDir
    $fullProjectPath = Join-Path $claudeProjectsDir $ProjectPath
    
    if (!(Test-Path $claudeProjectsDir)) {
        Write-Error "Error: Claude Code projects directory not found"
        Write-Host "Expected: $claudeProjectsDir"
        exit 1
    }
    
    if (!(Test-Path $fullProjectPath)) {
        Write-Error "Error: Project directory not found: $fullProjectPath"
        Write-Host ""
        Write-Host "Available Claude projects (escaped format):"
        Get-ChildItem $claudeProjectsDir -Directory | Select-Object -First 5 | ForEach-Object {
            Write-Host "  $($_.Name)"
        }
        exit 1
    }
    
    return $fullProjectPath
}

# Get all Claude projects
function Get-AvailableProjectDirs {
    $claudeProjectsDir = Get-ClaudeProjectsDir
    
    if (!(Test-Path $claudeProjectsDir)) {
        Write-Error "Error: Claude Code projects directory not found"
        Write-Host "Expected: $claudeProjectsDir"
        exit 1
    }
    
    return Get-ChildItem $claudeProjectsDir -Directory -Name | Where-Object { $_.StartsWith('-') } | Sort-Object
}

# List all available Claude projects (for list action)
function Show-AvailableProjects {
    Write-Info "Available Claude Projects:"
    Write-Host ""
    
    $projects = Get-AvailableProjectDirs
    
    if (-not $projects -or $projects.Count -eq 0) {
        Write-Warning "No Claude projects found"
        return 0
    }
    
    $count = 0
    foreach ($project in $projects) {
        $count++
        Write-Host "  $count. " -NoNewline -ForegroundColor Yellow
        Write-Host $project -ForegroundColor Cyan
        
        # Try to decode the path for user-friendly display
        $decodedPath = $project -replace '^-', '' -replace '-', '\'
        if ($decodedPath -ne $project) {
            Write-Host "      (likely: $decodedPath)" -ForegroundColor Gray
        }
    }
    
    Write-Host ""
    Write-Success "Total: $count project(s) found"
}
