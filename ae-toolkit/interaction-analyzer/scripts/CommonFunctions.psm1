# Common PowerShell Functions for Interaction Analyzer
# Shared utilities for all PowerShell scripts in the interaction-analyzer module

# Add required assemblies for URL encoding/decoding
Add-Type -AssemblyName System.Web

# Color output functions
function Write-Success { 
    param([string]$Message) 
    Write-Host $Message -ForegroundColor Green 
}

function Write-Error { 
    param([string]$Message) 
    Write-Host $Message -ForegroundColor Red 
}

function Write-Warning { 
    param([string]$Message) 
    Write-Host $Message -ForegroundColor Yellow 
}

function Write-Info { 
    param([string]$Message) 
    Write-Host $Message -ForegroundColor Cyan 
}

function Write-Debug { 
    param([string]$Message, [switch]$DebugMode) 
    if ($DebugMode) { 
        Write-Host $Message -ForegroundColor Magenta 
    } 
}

# URL encoding/decoding functions
function ConvertTo-UrlEncoded {
    param([string]$Text)
    return [System.Web.HttpUtility]::UrlEncode($Text)
}

function ConvertFrom-UrlEncoded {
    param([string]$Text)
    return [System.Web.HttpUtility]::UrlDecode($Text)
}

# File system utilities
function New-DirectoryIfNotExists {
    param([string]$Path)
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        return $true
    }
    return $false
}

# Workspace utilities
function Get-VSCodeWorkspaceStoragePath {
    return "$env:APPDATA\Code\User\workspaceStorage"
}

function Test-VSCodeInstallation {
    $VSCodeStorage = Get-VSCodeWorkspaceStoragePath
    return Test-Path $VSCodeStorage
}

# Export functions for use in other scripts
Export-ModuleMember -Function @(
    'Write-Success',
    'Write-Error', 
    'Write-Warning',
    'Write-Info',
    'Write-Debug',
    'ConvertTo-UrlEncoded',
    'ConvertFrom-UrlEncoded',
    'New-DirectoryIfNotExists',
    'Get-VSCodeWorkspaceStoragePath',
    'Test-VSCodeInstallation'
)
