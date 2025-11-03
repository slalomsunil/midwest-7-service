# GitHub Copilot Chat Workspace Processor (PowerShell)
# Processes GitHub Copilot chat sessions from a specified VS Code workspace
#
# For detailed documentation, see: copilot-support/README.md
#
# FUNCTIONALITY:
# - Processes .json chat files from specified VS Code workspace directory into structured markdown output
# - Creates individual chat folders with detailed.md and abbreviated.md
# - Skips already processed files unless they're newer than output
# - Generates consolidated workspace summary report
# - Supports filtering by recent chats or session ID

param(
    [Parameter(Mandatory=$true)]
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
    Write-Host "Usage: .\Gather-CopilotWorkspace.ps1 -WorkspaceHash HASH [OPTIONS]"
    Write-Host ""
    Write-Host "Processes GitHub Copilot chat sessions from a specified VS Code workspace."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -WorkspaceHash HASH   Required: VS Code workspace hash"
    Write-Host "  -Number NUM           Process only the NUM most recent chats"
    Write-Host "  -SessionId ID         Process only the chat with the specified session ID"
    Write-Host "  -Force                Force reprocessing of all files (ignores skip logic)"
    Write-Host "  -DebugMode                Keep intermediate files for debugging"
    Write-Host "  -Help                 Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Gather-CopilotWorkspace.ps1 -WorkspaceHash 6586153aefd75ad1b35940bda0bc5d39"
    Write-Host "  .\Gather-CopilotWorkspace.ps1 -WorkspaceHash 6586153aefd75ad1b35940bda0bc5d39 -Number 5"
    Write-Host "  .\Gather-CopilotWorkspace.ps1 -WorkspaceHash 6586153aefd75ad1b35940bda0bc5d39 -SessionId abc123 -Force"
}

if ($Help) {
    Show-Usage
    exit 0
}

# Script directory and build output path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptsDir = Split-Path -Parent $ScriptDir
$ModuleDir = Split-Path -Parent $ScriptsDir
$BuildDir = Join-Path $ModuleDir "build"
$BaseOutputDir = Join-Path $BuildDir "copilot-chats"

# Import common functions
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CommonFunctionsPath = Join-Path (Split-Path -Parent $ScriptDir) "CommonFunctions.psm1"
Import-Module $CommonFunctionsPath -Force

# Validate workspace hash exists
function Test-WorkspaceHash {
    param([string]$WorkspaceHash)
    
    $VSCodeStorageDir = Get-VSCodeWorkspaceStoragePath
    $WorkspaceStorageDir = Join-Path $VSCodeStorageDir $WorkspaceHash
    
    if (!(Test-Path $VSCodeStorageDir)) {
        Write-Error "Error: VS Code workspace storage directory not found"
        Write-Error "Expected: $VSCodeStorageDir"
        exit 1
    }
    
    if (!(Test-Path $WorkspaceStorageDir)) {
        Write-Error "Error: Workspace directory not found: $WorkspaceStorageDir"
        Write-Host ""
        Write-Host "Available workspaces:" -ForegroundColor Yellow
        
        $WorkspaceDirs = Get-ChildItem $VSCodeStorageDir -Directory | Select-Object -First 5
        foreach ($WsDir in $WorkspaceDirs) {
            $WsHash = $WsDir.Name
            $WsJsonPath = Join-Path $WsDir.FullName "workspace.json"
            
            if (Test-Path $WsJsonPath) {
                try {
                    $WsData = Get-Content $WsJsonPath | ConvertFrom-Json
                    $WsPath = $WsData.folder
                    
                    if ($WsPath -match '^file:///(.+)$') {
                        $WsPath = $Matches[1]
                        $WsPath = ConvertFrom-UrlEncoded $WsPath
                        $WsPath = $WsPath.Replace('/', '\')
                        $WsPath = $WsPath -replace '^([A-Za-z])%3A', '$1:'
                    }
                    
                    Write-Host "  $WsHash`: $WsPath"
                }
                catch {
                    Write-Host "  $WsHash`: Invalid workspace.json"
                }
            } else {
                Write-Host "  $WsHash`: No workspace.json"
            }
        }
        exit 1
    }
    
    return $WorkspaceStorageDir
}

# Process a single Copilot JSON chat file
function ConvertTo-MarkdownChat {
    param(
        [string]$ChatFile,
        [string]$ChatDir,
        [string]$ChatId
    )
    
    Write-Info "Processing chat: $ChatId"
    
    try {
        # Read and parse the JSON file
        $ChatData = Get-Content $ChatFile -Raw | ConvertFrom-Json
        
        # Create detailed.md
        Write-Info "  ├── Writing detailed.md..."
        $EncodedPath = ConvertTo-UrlEncoded $ChatFile
        
        $DetailedContent = @"
# Copilot Chat: $ChatId

**Generated:** $(Get-Date)
**Source:** [$ChatFile](file://$EncodedPath)

## Chat Metadata

"@
        
        # Add creation date if present
        if ($ChatData.PSObject.Properties['creationDate']) {
            $DetailedContent += "- **Created:** $($ChatData.creationDate)`n"
        }
        
        # Add last message date if present  
        if ($ChatData.PSObject.Properties['lastMessageDate']) {
            $DetailedContent += "- **Last Message:** $($ChatData.lastMessageDate)`n"
        }
        
        # Add message count
        $MessageCount = if ($ChatData.requests) { $ChatData.requests.Count } else { 0 }
        $DetailedContent += "- **Message Count:** $MessageCount`n`n"
        
        # Add conversation flow
        $DetailedContent += "## Conversation Flow`n`n"
        
        if ($ChatData.requests) {
            foreach ($Request in $ChatData.requests) {
                # User message
                if ($Request.message) {
                    $DetailedContent += "### User`n"
                    $DetailedContent += "$($Request.message)`n`n"
                }
                
                # Assistant response
                if ($Request.response) {
                    $DetailedContent += "### Assistant`n"
                    
                    # Handle response chunks
                    if ($Request.response -is [array]) {
                        foreach ($Chunk in $Request.response) {
                            # Extract text from the value field
                            if ($Chunk.value) {
                                $DetailedContent += "$($Chunk.value)"
                            }
                            # Fallback to content field if value doesn't exist
                            elseif ($Chunk.content) {
                                $DetailedContent += "$($Chunk.content)"
                            }
                        }
                    } else {
                        # Handle non-array response
                        if ($Request.response.value) {
                            $DetailedContent += "$($Request.response.value)"
                        } else {
                            $DetailedContent += "$($Request.response)"
                        }
                    }
                    $DetailedContent += "`n`n"
                }
            }
        }
        
        # Write detailed.md
        $DetailedPath = Join-Path $ChatDir "detailed.md"
        $DetailedContent | Out-File -FilePath $DetailedPath -Encoding UTF8
        Write-Success "    ✓ detailed.md created"
        
        # Create abbreviated.md (conversation log style)
        Write-Info "  ├── Writing abbreviated.md..."
        
        $AbbreviatedContent = "# Chat Log: $ChatId`n`n"
        
        if ($ChatData.requests) {
            foreach ($Request in $ChatData.requests) {
                $Timestamp = if ($Request.timestamp) { 
                    (Get-Date $Request.timestamp).ToString("HH:mm:ss") 
                } else { 
                    (Get-Date).ToString("HH:mm:ss") 
                }
                
                # User message
                if ($Request.message) {
                    $UserMsg = $Request.message -replace "`n", " " -replace "`r", ""
                    if ($UserMsg.Length -gt 100) {
                        $UserMsg = $UserMsg.Substring(0, 97) + "..."
                    }
                    $AbbreviatedContent += "[$Timestamp] User: $UserMsg`n"
                }
                
                # Assistant response (summarized)
                if ($Request.response) {
                    $ResponseText = ""
                    if ($Request.response -is [array]) {
                        foreach ($Chunk in $Request.response) {
                            # Extract text from the value field
                            if ($Chunk.value) {
                                $ResponseText += $Chunk.value
                            }
                            # Fallback to content field if value doesn't exist
                            elseif ($Chunk.content) {
                                $ResponseText += $Chunk.content
                            }
                        }
                    } else {
                        # Handle non-array response
                        if ($Request.response.value) {
                            $ResponseText = $Request.response.value
                        } else {
                            $ResponseText = $Request.response
                        }
                    }
                    
                    $ResponseText = $ResponseText -replace "`n", " " -replace "`r", ""
                    if ($ResponseText.Length -gt 150) {
                        $ResponseText = $ResponseText.Substring(0, 147) + "..."
                    }
                    $AbbreviatedContent += "[$Timestamp] Assistant: $ResponseText`n"
                }
            }
        }
        
        # Write abbreviated.md
        $AbbreviatedPath = Join-Path $ChatDir "abbreviated.md"
        $AbbreviatedContent | Out-File -FilePath $AbbreviatedPath -Encoding UTF8
        Write-Success "    ✓ abbreviated.md created"
        
        Write-Success "✓ Completed chat: $ChatId"
        return $true
    }
    catch {
        Write-Error "✗ Failed to process chat: $ChatId - $($_.Exception.Message)"
        return $false
    }
}

# Get workspace information
function Get-WorkspaceInfo {
    param([string]$WorkspaceStorageDir)
    
    $WorkspaceJsonPath = Join-Path $WorkspaceStorageDir "workspace.json"
    
    if (Test-Path $WorkspaceJsonPath) {
        try {
            $WorkspaceData = Get-Content $WorkspaceJsonPath | ConvertFrom-Json
            $WorkspacePath = $WorkspaceData.folder
            
            if ($WorkspacePath -match '^file:///(.+)$') {
                $WorkspacePath = $Matches[1]
                $WorkspacePath = ConvertFrom-UrlEncoded $WorkspacePath
                $WorkspacePath = $WorkspacePath.Replace('/', '\')
                $WorkspacePath = $WorkspacePath -replace '^([A-Za-z])%3A', '$1:'
            }
            
            return [PSCustomObject]@{
                Path = $WorkspacePath
                Hash = $WorkspaceHash
            }
        }
        catch {
            return [PSCustomObject]@{
                Path = "Unknown"
                Hash = $WorkspaceHash
            }
        }
    }
    
    return [PSCustomObject]@{
        Path = "Unknown"
        Hash = $WorkspaceHash
    }
}

# Main processing function
function Invoke-ProcessWorkspace {
    Write-Info "GitHub Copilot Chat Workspace Processor"
    Write-Info "======================================="
    
    # Validate workspace
    $WorkspaceStorageDir = Test-WorkspaceHash $WorkspaceHash
    $WorkspaceInfo = Get-WorkspaceInfo $WorkspaceStorageDir
    
    Write-Info "Workspace: $($WorkspaceInfo.Hash)"
    if ($WorkspaceInfo.Path -ne "Unknown") {
        Write-Info "Path: $($WorkspaceInfo.Path)"
    }
    
    # Find chat sessions
    $ChatSessionsDir = Join-Path $WorkspaceStorageDir "chatSessions"
    
    if (!(Test-Path $ChatSessionsDir)) {
        Write-Warning "No chatSessions directory found in workspace"
        return
    }
    
    $ChatFiles = Get-ChildItem $ChatSessionsDir -Filter "*.json" -File
    
    if ($ChatFiles.Count -eq 0) {
        Write-Warning "No chat JSON files found in workspace"
        return
    }
    
    Write-Info "Found $($ChatFiles.Count) chat file(s)"
    
    # Filter by session ID if specified
    if ($SessionId) {
        $ChatFiles = $ChatFiles | Where-Object { $_.BaseName -eq $SessionId }
        if ($ChatFiles.Count -eq 0) {
            Write-Error "No chat file found with session ID: $SessionId"
            return
        }
        Write-Info "Filtered to 1 chat file matching session ID: $SessionId"
    }
    
    # Sort by last write time (newest first) and limit if specified
    $ChatFiles = $ChatFiles | Sort-Object LastWriteTime -Descending
    
    if ($Number -and $Number -lt $ChatFiles.Count) {
        $ChatFiles = $ChatFiles | Select-Object -First $Number
        Write-Info "Limited to $Number most recent chat file(s)"
    }
    
    # Create output directory
    $WorkspaceDirName = $WorkspaceInfo.Path.Replace('\', '-').Replace('/', '-').Replace(':', '')
    if ($WorkspaceDirName.StartsWith('-')) {
        $WorkspaceDirName = $WorkspaceDirName.Substring(1)
    }
    
    $OutputWorkspaceDir = Join-Path $BaseOutputDir $WorkspaceDirName
    $OutputChatsDir = Join-Path $OutputWorkspaceDir "chats"
    
    if (!(Test-Path $OutputChatsDir)) {
        New-Item -ItemType Directory -Path $OutputChatsDir -Force | Out-Null
    }
    
    # Process each chat file
    $ProcessedCount = 0
    $SuccessCount = 0
    
    foreach ($ChatFile in $ChatFiles) {
        $ChatId = $ChatFile.BaseName
        $ChatTimestamp = $ChatFile.LastWriteTime.ToString("yyyyMMdd-HHmmss")
        $ChatDirName = "chat-$ChatTimestamp-$ChatId"
        $ChatOutputDir = Join-Path $OutputChatsDir $ChatDirName
        
        # Check if already processed (unless Force is specified)
        if (!$Force -and (Test-Path $ChatOutputDir)) {
            $DetailedPath = Join-Path $ChatOutputDir "detailed.md"
            $AbbreviatedPath = Join-Path $ChatOutputDir "abbreviated.md"
            
            if ((Test-Path $DetailedPath) -and (Test-Path $AbbreviatedPath)) {
                $DetailedTime = (Get-Item $DetailedPath).LastWriteTime
                if ($DetailedTime -gt $ChatFile.LastWriteTime) {
                    Write-Info "Skipping $ChatId (already processed and up to date)"
                    continue
                }
            }
        }
        
        # Create chat output directory
        if (!(Test-Path $ChatOutputDir)) {
            New-Item -ItemType Directory -Path $ChatOutputDir -Force | Out-Null
        }
        
        # Process the chat file
        $Success = ConvertTo-MarkdownChat -ChatFile $ChatFile.FullName -ChatDir $ChatOutputDir -ChatId $ChatId
        
        $ProcessedCount++
        if ($Success) {
            $SuccessCount++
        }
    }
    
    # Generate workspace summary
    Write-Info "Generating workspace summary..."
    
    $SummaryContent = @"
# Workspace Summary: $($WorkspaceInfo.Hash)

**Generated:** $(Get-Date)
**Workspace Path:** $($WorkspaceInfo.Path)
**Total Chats Processed:** $ProcessedCount
**Successfully Processed:** $SuccessCount

## Chat Sessions

"@
    
    $ProcessedChats = Get-ChildItem $OutputChatsDir -Directory | Sort-Object Name -Descending
    
    foreach ($ChatDir in $ProcessedChats) {
        $DetailedPath = Join-Path $ChatDir.FullName "detailed.md"
        $AbbreviatedPath = Join-Path $ChatDir.FullName "abbreviated.md"
        
        if ((Test-Path $DetailedPath) -and (Test-Path $AbbreviatedPath)) {
            $ChatIdMatch = $ChatDir.Name -match 'chat-\d{8}-\d{6}-(.+)'
            $ChatId = if ($ChatIdMatch) { $Matches[1] } else { $ChatDir.Name }
            
            # Use platform-appropriate path separators in markdown links
            $DetailedLink = "$($ChatDir.Name)/detailed.md"
            $AbbreviatedLink = "$($ChatDir.Name)/abbreviated.md"
            $SummaryContent += "- [$ChatId]($DetailedLink) - [abbreviated]($AbbreviatedLink)`n"
        }
    }
    
    $SummaryPath = Join-Path $OutputWorkspaceDir "workspace-summary.md"
    $SummaryContent | Out-File -FilePath $SummaryPath -Encoding UTF8
    
    Write-Success "✓ Workspace summary created: $SummaryPath"
    Write-Success "✓ Processing complete: $SuccessCount/$ProcessedCount chats processed successfully"
    
    if (!$DebugMode) {
        # Clean up any debug files
        Get-ChildItem $OutputChatsDir -Recurse -Filter "*.tmp" | Remove-Item -Force
    }
}

# Execute main function
Invoke-ProcessWorkspace
