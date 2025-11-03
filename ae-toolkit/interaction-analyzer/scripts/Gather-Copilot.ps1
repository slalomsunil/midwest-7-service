# GitHub Copilot Chat Collector (PowerShell)
# Orchestrates collection and processing of GitHub Copilot chat sessions across VS Code workspaces
#
# For detailed documentation, see: copilot-support/README.md
#
# FUNCTIONALITY:
# - Auto-detects current workspace and processes it (default behavior)
# - -AllWorkspaces mode discovers and processes all VS Code workspaces
# - Delegates actual processing to Gather-CopilotWorkspace.ps1
# - Generates consolidated summaries when processing multiple workspaces
# - Supports list mode to discover available workspaces

param(
    [Parameter(Position=0)]
    [ValidateSet("list", "collect")]
    [string]$Action = "collect",
    
    [Alias("a")]
    [switch]$AllWorkspaces,
    
    [Alias("w")]
    [string]$WorkspaceHash,
    
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
    Write-Host "Usage: .\Gather-Copilot.ps1 [ACTION] [OPTIONS]"
    Write-Host ""
    Write-Host "Orchestrates GitHub Copilot chat collection across VS Code workspaces."
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  list                  List all available VS Code workspaces with Copilot chats"
    Write-Host "  collect               Collect and process chat data (default)"
    Write-Host ""
    Write-Host "Options (for collect action):"
    Write-Host "  -AllWorkspaces        Process all VS Code workspaces with Copilot chats"
    Write-Host "  -WorkspaceHash HASH   Process specific workspace by hash"
    Write-Host "  -Number NUM           Process only the NUM most recent chats per workspace"
    Write-Host "  -SessionId ID         Process only the chat with the specified session ID"
    Write-Host "  -Force                Force reprocessing of all files (ignores skip logic)"
    Write-Host "  -DebugMode                Keep intermediate files for debugging"
    Write-Host "  -Help                 Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Gather-Copilot.ps1 list"
    Write-Host "  .\Gather-Copilot.ps1"
    Write-Host "  .\Gather-Copilot.ps1 collect -Number 5"
    Write-Host "  .\Gather-Copilot.ps1 collect -AllWorkspaces"
    Write-Host "  .\Gather-Copilot.ps1 collect -AllWorkspaces -Number 3"
    Write-Host "  .\Gather-Copilot.ps1 collect -WorkspaceHash 6586153aefd75ad1b35940bda0bc5d39 -Number 5"
    Write-Host ""
    Write-Host "Requirements:"
    Write-Host "  - PowerShell 5.1 or later"
    Write-Host "  - VS Code with GitHub Copilot chats"
}

if ($Help) {
    Show-Usage
    exit 0
}

# Script directory and build output path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModuleDir = Split-Path -Parent $ScriptDir
$BuildDir = Join-Path $ModuleDir "build"
$OutputDir = Join-Path $BuildDir "copilot-chats"

# Ensure build directory exists
if (!(Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir -Force | Out-Null
}
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Import common functions
$CommonFunctionsPath = Join-Path $ScriptDir "CommonFunctions.psm1"
Import-Module $CommonFunctionsPath -Force

# Path to worker script
$WorkerScript = Join-Path $ScriptDir "copilot-support\Gather-CopilotWorkspace.ps1"

# Find all available VS Code workspaces
function Find-AllWorkspaces {
    $VSCodeStorageDir = Get-VSCodeWorkspaceStoragePath

    if (!(Test-Path $VSCodeStorageDir)) {
        Write-Error "Error: VS Code workspace storage directory not found"
        Write-Error "Expected: $VSCodeStorageDir"
        exit 1
    }
    
    $Workspaces = @()
    $WorkspaceDirs = Get-ChildItem $VSCodeStorageDir -Directory
    
    foreach ($WorkspaceDir in $WorkspaceDirs) {
        $WorkspaceHash = $WorkspaceDir.Name
        $WorkspaceJson = Join-Path $WorkspaceDir.FullName "workspace.json"
        $ChatSessionsDir = Join-Path $WorkspaceDir.FullName "chatSessions"
        
        # Only include workspaces that have:
        # 1. workspace.json file
        # 2. chatSessions directory with JSON files
        if ((Test-Path $WorkspaceJson) -and (Test-Path $ChatSessionsDir)) {
            $ChatFiles = Get-ChildItem $ChatSessionsDir -Filter "*.json" -File
            if ($ChatFiles.Count -gt 0) {
                try {
                    $WorkspaceData = Get-Content $WorkspaceJson | ConvertFrom-Json
                    $WorkspacePath = ""
                    
                    if ($WorkspaceData.folder) {
                        $WorkspacePath = $WorkspaceData.folder
                        
                        # Handle file:// URIs
                        if ($WorkspacePath -match '^file:///(.+)$') {
                            $WorkspacePath = $Matches[1]
                            $WorkspacePath = [System.Web.HttpUtility]::UrlDecode($WorkspacePath)
                            $WorkspacePath = $WorkspacePath.Replace('/', '\')
                            $WorkspacePath = $WorkspacePath -replace '^([A-Za-z])%3A', '$1:'
                        }
                    }
                    
                    $Workspaces += [PSCustomObject]@{
                        Hash = $WorkspaceHash
                        Path = $WorkspacePath
                        ChatCount = $ChatFiles.Count
                    }
                }
                catch {
                    # Skip workspaces with invalid JSON
                    continue
                }
            }
        }
    }
    
    return $Workspaces
}

# Find current workspace hash
function Find-CurrentWorkspaceHash {
    param([string]$CurrentPath = (Get-Location).Path)
    
    $AllWorkspaces = Find-AllWorkspaces
    $CurrentPath = $CurrentPath.Replace('\', '/').TrimEnd('/')
    
    foreach ($Workspace in $AllWorkspaces) {
        if ($Workspace.Path) {
            $WorkspacePath = $Workspace.Path.Replace('\', '/').TrimEnd('/')
            
            if ($CurrentPath -eq $WorkspacePath -or $CurrentPath.StartsWith("$WorkspacePath/")) {
                return $Workspace.Hash
            }
        }
    }
    
    return $null
}

# List available workspaces
function Invoke-ListWorkspaces {
    Write-Info "Scanning for VS Code workspaces with Copilot chats..."
    $Workspaces = Find-AllWorkspaces
    
    if ($Workspaces.Count -eq 0) {
        Write-Warning "No VS Code workspaces found with Copilot chat data."
        Write-Info "Make sure you have:"
        Write-Info "  1. VS Code installed"
        Write-Info "  2. GitHub Copilot extension active"
        Write-Info "  3. Some chat sessions created"
        return
    }
    
    Write-Success "Found $($Workspaces.Count) workspace(s) with Copilot chats:"
    Write-Host ""
    
    foreach ($Workspace in $Workspaces | Sort-Object ChatCount -Descending) {
        Write-Host "  Hash: $($Workspace.Hash)" -ForegroundColor Yellow
        Write-Host "  Path: $($Workspace.Path)" -ForegroundColor Gray
        Write-Host "  Chats: $($Workspace.ChatCount)" -ForegroundColor Green
        Write-Host ""
    }
    
    $CurrentHash = Find-CurrentWorkspaceHash
    if ($CurrentHash) {
        Write-Info "Current directory matches workspace: $CurrentHash"
    } else {
        Write-Warning "Current directory doesn't match any workspace with Copilot chats"
    }
}

# Process workspace(s)
function Invoke-CollectChats {
    if ($AllWorkspaces) {
        Write-Info "Processing all workspaces with Copilot chats..."
        $Workspaces = Find-AllWorkspaces
        
        if ($Workspaces.Count -eq 0) {
            Write-Warning "No workspaces found with Copilot chat data."
            return
        }
        
        $ProcessedWorkspaces = @()
        
        foreach ($Workspace in $Workspaces) {
            Write-Info "Processing workspace: $($Workspace.Hash)"
            if ($Workspace.Path) {
                Write-Info "  Path: $($Workspace.Path)"
            }
            Write-Info "  Chats: $($Workspace.ChatCount)"
            
            # Build parameters for worker script
            $WorkerParams = @{
                WorkspaceHash = $Workspace.Hash
            }
            if ($Number) { $WorkerParams.Number = $Number }
            if ($SessionId) { $WorkerParams.SessionId = $SessionId }
            if ($Force) { $WorkerParams.Force = $true }
            if ($DebugMode) { $WorkerParams.DebugMode = $true }
            
            try {
                & $WorkerScript @WorkerParams
                $ProcessedWorkspaces += $Workspace
                Write-Success "✓ Completed workspace: $($Workspace.Hash)"
            }
            catch {
                Write-Error "✗ Failed workspace: $($Workspace.Hash) - $($_.Exception.Message)"
            }
            
            Write-Host ""
        }
        
        # Generate consolidated summary
        Write-Info "Generating consolidated summary..."
        # TODO: Implement consolidated summary generation
        
    } else {
        # Process current workspace or specified workspace
        $TargetHash = $WorkspaceHash
        
        if (!$TargetHash) {
            $TargetHash = Find-CurrentWorkspaceHash
            if (!$TargetHash) {
                Write-Error "Could not detect current workspace with Copilot chats."
                Write-Info "Use -AllWorkspaces to see available workspaces or specify -WorkspaceHash"
                exit 1
            }
            Write-Info "Auto-detected current workspace: $TargetHash"
        }
        
        # Build parameters for worker script
        $WorkerParams = @{
            WorkspaceHash = $TargetHash
        }
        if ($Number) { $WorkerParams.Number = $Number }
        if ($SessionId) { $WorkerParams.SessionId = $SessionId }
        if ($Force) { $WorkerParams.Force = $true }
        if ($DebugMode) { $WorkerParams.DebugMode = $true }
        
        & $WorkerScript @WorkerParams
    }
}

# Main execution
switch ($Action) {
    "list" { Invoke-ListWorkspaces }
    "collect" { Invoke-CollectChats }
    default { 
        Write-Error "Unknown action: $Action"
        Show-Usage
        exit 1
    }
}
