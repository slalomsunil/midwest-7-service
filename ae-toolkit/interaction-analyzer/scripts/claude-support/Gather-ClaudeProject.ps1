# Claude Code Project Chat Processor (PowerShell)
# Processes Claude Code chat sessions from a specified project directory
#
# For detailed documentation, see: README.md
#
# FUNCTIONALITY:
# - Processes .jsonl chat files from specified Claude project directory into structured markdown output
# - Creates individual chat folders with detailed.md and tool_results/ subdirectory
# - Skips already processed files unless they're newer than output
# - Generates consolidated summary report
# - Supports filtering by recent chats or session ID

param(
    [Parameter(Mandatory=$true)]
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
    Write-Host "Usage: .\Gather-ClaudeProject.ps1 -ProjectPath PROJECT_PATH [OPTIONS]"
    Write-Host ""
    Write-Host "Processes Claude Code chat sessions from a specified project directory."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -ProjectPath PATH     Required: Claude project directory path"
    Write-Host "  -Number NUM           Process only the NUM most recent chats"
    Write-Host "  -SessionId ID         Process only the chat with the specified session ID"
    Write-Host "  -Force                Force reprocessing of all files (ignores skip logic)"
    Write-Host "  -DebugMode            Keep intermediate files for debugging"
    Write-Host "  -Help                 Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Gather-ClaudeProject.ps1 -ProjectPath '-Users-allenh-projects-ai-accelerator'"
    Write-Host "  .\Gather-ClaudeProject.ps1 -ProjectPath '-Users-allenh-projects-ai-accelerator' -Number 5"
    Write-Host "  .\Gather-ClaudeProject.ps1 -ProjectPath '-Users-allenh-projects-ai-accelerator' -SessionId abc123 -Force"
    Write-Host ""
    Write-Host "Requirements:"
    Write-Host "  - PowerShell 5.1 or later"
    Write-Host "  - ConvertFrom-Json cmdlet"
    Write-Host "  - Valid Claude project directory path"
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

# Script directory and build output path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptsDir = Split-Path -Parent $ScriptDir
$ModuleDir = Split-Path -Parent $ScriptsDir
$BuildDir = Join-Path $ModuleDir "build"
$BaseOutputDir = Join-Path $BuildDir "claude-chats"

# Import required modules
Import-Module (Join-Path $ScriptsDir "CommonFunctions.psm1") -Force
. (Join-Path $ScriptDir "ClaudeProjectDiscovery.ps1")

# Configuration
$TOOL_RESULT_TRUNCATION_LENGTH = 500

# Validate project directory
$projectDir = Test-ProjectDir $ProjectPath
$outputDir = Join-Path $BaseOutputDir $ProjectPath

    # Create output directories
    New-DirectoryIfNotExists $BaseOutputDir | Out-Null
    New-DirectoryIfNotExists $outputDir | Out-Null
    New-DirectoryIfNotExists (Join-Path $outputDir "processed-chats") | Out-Null

# Extract useful information from Claude Code JSONL
function ConvertFrom-ClaudeJsonl {
    param(
        [string]$ChatFile,
        [string]$ChatDir,
        [string]$ChatId
    )
    
    Write-Debug "Processing chat file: $ChatFile" -DebugMode:$DebugMode
    
    try {
        # Read and parse JSONL file
        $jsonlContent = Get-Content $ChatFile -Raw
        $lines = $jsonlContent -split "`n" | Where-Object { $_.Trim() -ne "" }
        $jsonObjects = @()
        
        foreach ($line in $lines) {
            try {
                $jsonObjects += ConvertFrom-Json $line
            } catch {
                Write-Warning "Failed to parse JSON line in $ChatFile`: $line"
                continue
            }
        }
        
        if ($jsonObjects.Count -eq 0) {
            Write-Warning "No valid JSON objects found in $ChatFile"
            return $false
        }
        
        # Process the conversation
        $conversation = @()
        $toolResults = @{}
        $metadata = @{
            chatId = $ChatId
            totalMessages = $jsonObjects.Count
            timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        
        foreach ($obj in $jsonObjects) {
            if ($obj.type -eq "conversation_turn") {
                $turn = @{
                    role = $obj.role
                    content = $obj.content
                    timestamp = $obj.timestamp
                }
                
                # Extract tool use information if present
                if ($obj.content -match "tool_use") {
                    $turn.hasToolUse = $true
                }
                
                $conversation += $turn
            } elseif ($obj.type -eq "tool_result") {
                $toolResults[$obj.tool_use_id] = $obj
            }
        }
        
        # Generate detailed markdown
        $detailedContent = New-DetailedMarkdown $conversation $toolResults $metadata $ChatDir
        $detailedFile = Join-Path $ChatDir "detailed.md"
        $detailedContent | Out-File -FilePath $detailedFile -Encoding UTF8
        
        # Generate abbreviated markdown
        $abbreviatedContent = New-AbbreviatedMarkdown $conversation $metadata
        $abbreviatedFile = Join-Path $ChatDir "abbreviated.md"
        $abbreviatedContent | Out-File -FilePath $abbreviatedFile -Encoding UTF8
        
        Write-Success "✓ Processed: $ChatId"
        return $true
        
    } catch {
        Write-Error "Failed to process $ChatFile`: $($_.Exception.Message)"
        return $false
    }
}

# Generate detailed markdown content
function New-DetailedMarkdown {
    param(
        [array]$Conversation,
        [hashtable]$ToolResults,
        [hashtable]$Metadata,
        [string]$ChatDir
    )
    
    $content = @"
# Claude Code Chat - Detailed View

**Chat ID:** $($Metadata.chatId)
**Total Messages:** $($Metadata.totalMessages)
**Processed:** $($Metadata.timestamp)

## Conversation

"@
    
    $messageIndex = 1
    foreach ($turn in $Conversation) {
        $role = $turn.role.ToUpper()
        $timestamp = if ($turn.timestamp) { " - $($turn.timestamp)" } else { "" }
        
        $content += @"

### Message $messageIndex - $role$timestamp

$($turn.content)

"@
        
        # Check for tool results
        if ($turn.hasToolUse -and $ToolResults.Count -gt 0) {
            $content += @"

#### Tool Results

"@
            # This is a simplified approach - in a full implementation,
            # we'd need to parse the tool_use blocks and match them with results
            foreach ($toolResult in $ToolResults.Values) {
                $truncatedResult = if ($toolResult.content.Length -gt $TOOL_RESULT_TRUNCATION_LENGTH) {
                    $toolResult.content.Substring(0, $TOOL_RESULT_TRUNCATION_LENGTH) + "... [truncated]"
                } else {
                    $toolResult.content
                }
                
                $content += @"

**Tool:** $($toolResult.tool_name)
```
$truncatedResult
```

"@
            }
        }
        
        $messageIndex++
    }
    
    return $content
}

# Generate abbreviated markdown content
function New-AbbreviatedMarkdown {
    param(
        [array]$Conversation,
        [hashtable]$Metadata
    )
    
    $content = @"
# Claude Code Chat - Summary

**Chat ID:** $($Metadata.chatId)
**Total Messages:** $($Metadata.totalMessages)
**Processed:** $($Metadata.timestamp)

## Quick Overview

"@
    
    $userMessages = ($Conversation | Where-Object { $_.role -eq "user" }).Count
    $assistantMessages = ($Conversation | Where-Object { $_.role -eq "assistant" }).Count
    $toolUseCount = ($Conversation | Where-Object { $_.hasToolUse }).Count
    
    $content += @"

- **User Messages:** $userMessages
- **Assistant Messages:** $assistantMessages
- **Tool Uses:** $toolUseCount

## First User Message

"@
    
    $firstUserMessage = $Conversation | Where-Object { $_.role -eq "user" } | Select-Object -First 1
    if ($firstUserMessage) {
        $preview = if ($firstUserMessage.content.Length -gt 200) {
            $firstUserMessage.content.Substring(0, 200) + "..."
        } else {
            $firstUserMessage.content
        }
        $content += "`n$preview`n"
    }
    
    return $content
}

# Generate project summary
function New-ProjectSummary {
    param(
        [array]$ProcessedChats,
        [int]$TotalChats,
        [string]$ProjectPath
    )
    
    $summaryFile = Join-Path $outputDir "project-summary.md"
    $processedCount = $ProcessedChats.Count
    
    $content = @"
# Claude Code Chat Collection - Project Summary

**Project:** $ProjectPath
**Generated:** $(Get-Date)
**Total Chats Found:** $TotalChats
**Chats Processed:** $processedCount

## Processing Details

"@
    
    if ($processedCount -gt 0) {
        $content += @"

### Successfully Processed Chats

"@
        foreach ($chat in $ProcessedChats) {
            $content += "- [$($chat.id)]($($chat.relativePath))`n"
        }
    }
    
    if ($TotalChats -gt $processedCount) {
        $skippedCount = $TotalChats - $processedCount
        $content += @"

### Skipped Chats

$skippedCount chat(s) were skipped (already processed or errors occurred).

"@
    }
    
    $content | Out-File -FilePath $summaryFile -Encoding UTF8
    Write-Success "✓ Project summary: $summaryFile"
}

# Main processing function
function Invoke-ProcessProject {
    Write-Info "Claude Code Project Chat Processor"
    Write-Host "==================================" -ForegroundColor Cyan
    Write-Info "Project: $ProjectPath"
    Write-Info "Output: $outputDir"
    Write-Host ""
    
    # Find chat files
    $chatFiles = Get-ChildItem $projectDir -Filter "*.jsonl" | Sort-Object LastWriteTime -Descending
    
    if (-not $chatFiles) {
        Write-Warning "No .jsonl chat files found in project directory: $projectDir"
        return
    }
    
    Write-Info "Found $($chatFiles.Count) chat file(s)"
    
    # Apply filters
    if ($SessionId) {
        $chatFiles = $chatFiles | Where-Object { $_.BaseName -match $SessionId }
        Write-Info "Filtered to $($chatFiles.Count) file(s) matching session ID: $SessionId"
    }
    
    if ($Number -and $chatFiles.Count -gt $Number) {
        $chatFiles = $chatFiles | Select-Object -First $Number
        Write-Info "Limited to $Number most recent chat(s)"
    }
    
    if (-not $chatFiles) {
        Write-Warning "No chat files to process after applying filters"
        return
    }
    
    Write-Host ""
    
    # Process each chat file
    $processedChats = @()
    $successCount = 0
    
    foreach ($chatFile in $chatFiles) {
        $chatId = $chatFile.BaseName
        $chatDirName = "chat-$chatId"
        $chatDir = Join-Path $outputDir "processed-chats" | Join-Path -ChildPath $chatDirName
        
        # Check if already processed (unless Force is specified)
        $detailedFile = Join-Path $chatDir "detailed.md"
        if ((Test-Path $detailedFile) -and !$Force) {
            $outputModified = (Get-Item $detailedFile).LastWriteTime
            $sourceModified = $chatFile.LastWriteTime
            
            if ($outputModified -gt $sourceModified) {
                Write-Info "⏭️  Skipping: $chatId (already processed)"
                $processedChats += @{
                    id = $chatId
                    relativePath = Join-Path "processed-chats" "$chatDirName" | Join-Path -ChildPath "detailed.md"
                }
                continue
            }
        }
        
        # Create chat directory
        New-DirectoryIfNotExists $chatDir | Out-Null
        New-DirectoryIfNotExists (Join-Path $chatDir "tool_results") | Out-Null
        
        # Process the chat
        if (ConvertFrom-ClaudeJsonl $chatFile.FullName $chatDir $chatId) {
            $successCount++
            $processedChats += @{
                id = $chatId
                relativePath = Join-Path "processed-chats" "$chatDirName" | Join-Path -ChildPath "detailed.md"
            }
        }
    }
    
    Write-Host ""
    Write-Success "✅ Processing complete: $successCount/$($chatFiles.Count) files processed successfully"
    
    # Generate project summary
    New-ProjectSummary $processedChats $chatFiles.Count $ProjectPath
}

# Main execution
Invoke-ProcessProject
