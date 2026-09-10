# sync-between-repos.ps1 - Fixed version with pull before push

param(
    [string]$Repo1Path = "C:\Users\111\work-13-01-26",
    [string]$Repo2Path = "C:\Users\111\pcsys",
    [string]$CommitMessage = "Sync from first repository $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    [switch]$CleanMode,
    [switch]$DryRun,
    [switch]$ForcePush  # Add force push option as fallback
)

# Function for logging with color
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor $Color
}

# Function to execute Git commands
function Invoke-GitCommand {
    param(
        [string]$Command,
        [string[]]$Arguments,
        [string]$WorkingDirectory,
        [switch]$ShowOutput = $true
    )
    
    try {
        Push-Location $WorkingDirectory
        
        # Build command string for display
        $cmdString = "git $Command"
        if ($Arguments -and $Arguments.Count -gt 0) {
            $cmdString += " " + ($Arguments -join " ")
        }
        
        if ($ShowOutput) {
            Write-Log "Executing: $cmdString" "Cyan"
        }
        
        if ($DryRun) {
            Write-Log "[DRY RUN] $cmdString" "Yellow"
            return $true
        }
        
        # Execute git command with arguments
        $output = & git $Command @Arguments 2>&1
        $exitCode = $LASTEXITCODE
        
        if ($exitCode -ne 0) {
            Write-Log "Error executing: $cmdString" "Red"
            Write-Log $output "Red"
            return $false
        }
        
        if ($ShowOutput -and $output) {
            Write-Log $output "Gray"
        }
        
        return $true
        
    } catch {
        Write-Log "Exception: $_" "Red"
        return $false
    } finally {
        Pop-Location
    }
}

# Function to copy files between repositories
function Copy-FilesBetweenRepos {
    param(
        [string]$SourcePath,
        [string]$DestPath,
        [switch]$Clean
    )
    
    Write-Log "Starting file copy..." "Green"
    
    $excludeItems = @(
        ".git",
        ".gitignore",
        ".gitattributes",
        "*.log",
        "*.tmp",
        ".DS_Store",
        "Thumbs.db"
    )
    
    if ($Clean -and -not $DryRun) {
        Write-Log "Cleaning target folder (excluding .git)..." "Yellow"
        
        Get-ChildItem -Path $DestPath -Force | 
        Where-Object { $_.Name -ne ".git" } | 
        ForEach-Object {
            if ($DryRun) {
                Write-Log "[DRY RUN] Deleting: $($_.FullName)" "Yellow"
            } else {
                Remove-Item -Path $_.FullName -Recurse -Force
                Write-Log "Deleted: $($_.Name)" "Gray"
            }
        }
    }
    
    Write-Log "Copying files from $SourcePath to $DestPath..." "Cyan"
    
    $sourceItems = Get-ChildItem -Path $SourcePath -Force | 
                   Where-Object { $_.Name -ne ".git" }
    
    foreach ($item in $sourceItems) {
        $destItemPath = Join-Path $DestPath $item.Name
        
        $shouldExclude = $false
        foreach ($exclude in $excludeItems) {
            if ($item.Name -like $exclude) {
                $shouldExclude = $true
                break
            }
        }
        
        if ($shouldExclude) {
            Write-Log "Excluded: $($item.Name)" "DarkYellow"
            continue
        }
        
        if ($DryRun) {
            Write-Log "[DRY RUN] Copying: $($item.Name) -> $destItemPath" "Yellow"
            continue
        }
        
        try {
            if ($item.PSIsContainer) {
                Copy-Item -Path $item.FullName -Destination $destItemPath -Recurse -Force
                Write-Log "Copied folder: $($item.Name)" "Green"
            } else {
                Copy-Item -Path $item.FullName -Destination $destItemPath -Force
                Write-Log "Copied file: $($item.Name)" "Green"
            }
        } catch {
            Write-Log "Error copying $($item.Name): $_" "Red"
            return $false
        }
    }
    
    Write-Log "Copy completed" "Green"
    return $true
}

# Function to get current branch
function Get-CurrentBranch {
    param([string]$RepoPath)
    
    Push-Location $RepoPath
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    Pop-Location
    
    return $branch
}

# Main synchronization function
function Sync-Repositories {
    Write-Log "========================================" "Magenta"
    Write-Log "Starting repository synchronization" "Magenta"
    Write-Log "========================================" "Magenta"
    
    if (-not $Repo1Path) {
        $script:Repo1Path = Read-Host "Enter path to first repository (source)"
    }
    
    if (-not $Repo2Path) {
        $script:Repo2Path = Read-Host "Enter path to second repository (destination)"
    }
    
    if (-not (Test-Path $Repo1Path)) {
        Write-Log "Error: Repository 1 not found at: $Repo1Path" "Red"
        return $false
    }
    
    if (-not (Test-Path $Repo2Path)) {
        Write-Log "Error: Repository 2 not found at: $Repo2Path" "Red"
        return $false
    }
    
    if (-not (Test-Path (Join-Path $Repo1Path ".git"))) {
        Write-Log "Error: Path $Repo1Path is not a Git repository" "Red"
        return $false
    }
    
    if (-not (Test-Path (Join-Path $Repo2Path ".git"))) {
        Write-Log "Error: Path $Repo2Path is not a Git repository" "Red"
        return $false
    }
    
    # Step 1: Update first repository (git pull)
    Write-Log "`nStep 1: Updating first repository (source)" "Yellow"
    $branch1 = Get-CurrentBranch -RepoPath $Repo1Path
    Write-Log "Current branch in first repository: $branch1" "Cyan"
    
    if (-not (Invoke-GitCommand -Command "pull" -WorkingDirectory $Repo1Path)) {
        Write-Log "Failed to execute git pull in first repository" "Red"
        return $false
    }
    
    # Step 2: Update second repository (git pull to sync with remote)
    Write-Log "`nStep 2: Updating second repository from remote" "Yellow"
    $branch2 = Get-CurrentBranch -RepoPath $Repo2Path
    Write-Log "Current branch in second repository: $branch2" "Cyan"
    
    # Check if there are local changes in second repository before pull
    Push-Location $Repo2Path
    $localChanges = git status --porcelain
    Pop-Location
    
    if ($localChanges) {
        Write-Log "Warning: Local changes detected in second repository" "Yellow"
        Write-Log "These changes will be merged with remote changes" "Yellow"
    }
    
    # Pull latest changes from remote to avoid conflicts
    if (-not (Invoke-GitCommand -Command "pull" -WorkingDirectory $Repo2Path)) {
        Write-Log "Warning: git pull failed. Will attempt to continue..." "Yellow"
        # Continue anyway, maybe there's no remote
    }
    
    # Step 3: Copy files from first repository to second
    Write-Log "`nStep 3: Copying files from first repository to second" "Yellow"
    if (-not (Copy-FilesBetweenRepos -SourcePath $Repo1Path -DestPath $Repo2Path -Clean:$CleanMode)) {
        Write-Log "Error copying files" "Red"
        return $false
    }
    
    if ($DryRun) {
        Write-Log "`n[DRY RUN] Stopping after copy step" "Yellow"
        return $true
    }
    
    # Step 4: In second repository, execute git add, commit and push
    Write-Log "`nStep 4: Sending changes to website from second repository" "Yellow"
    
    # Check for changes again after copying
    Push-Location $Repo2Path
    $hasChanges = git status --porcelain
    Pop-Location
    
    if ($hasChanges) {
        Write-Log "Changes found in second repository" "Green"
        
        # git add .
        if (-not (Invoke-GitCommand -Command "add" -Arguments @(".") -WorkingDirectory $Repo2Path)) {
            Write-Log "Error during git add" "Red"
            return $false
        }
        
        # git commit -m "message"
        Write-Log "Creating commit with message: $CommitMessage" "Cyan"
        if (-not (Invoke-GitCommand -Command "commit" -Arguments @("-m", $CommitMessage) -WorkingDirectory $Repo2Path)) {
            Write-Log "Error during commit" "Red"
            return $false
        }
        
        # First try regular push
        Write-Log "Pushing changes to remote server..." "Cyan"
        $pushResult = Invoke-GitCommand -Command "push" -WorkingDirectory $Repo2Path
        
        if (-not $pushResult) {
            # If push fails, try to pull and then push again
            Write-Log "Push failed. Attempting to pull remote changes first..." "Yellow"
            
            if (Invoke-GitCommand -Command "pull" -WorkingDirectory $Repo2Path) {
                Write-Log "Pull successful. Retrying push..." "Cyan"
                
                if (-not (Invoke-GitCommand -Command "push" -WorkingDirectory $Repo2Path)) {
                    if ($ForcePush) {
                        Write-Log "Regular push still fails. Attempting force push..." "Yellow"
                        if (-not (Invoke-GitCommand -Command "push" -Arguments @("--force") -WorkingDirectory $Repo2Path)) {
                            Write-Log "Error during git push --force" "Red"
                            return $false
                        }
                    } else {
                        Write-Log "Error during git push. Use -ForcePush to force push if necessary" "Red"
                        return $false
                    }
                }
            } else {
                if ($ForcePush) {
                    Write-Log "Pull failed. Attempting force push..." "Yellow"
                    if (-not (Invoke-GitCommand -Command "push" -Arguments @("--force") -WorkingDirectory $Repo2Path)) {
                        Write-Log "Error during git push --force" "Red"
                        return $false
                    }
                } else {
                    Write-Log "Error during git pull and push. Use -ForcePush to force push if necessary" "Red"
                    return $false
                }
            }
        }
        
        Write-Log "Successfully pushed changes to website" "Green"
    } else {
        Write-Log "No changes to push" "Yellow"
    }
    
    Write-Log "`n========================================" "Magenta"
    Write-Log "Synchronization completed successfully!" "Green"
    Write-Log "========================================" "Magenta"
    
    Write-Log "`nLast commit in second repository:" "Cyan"
    Push-Location $Repo2Path
    git log -1 --oneline
    Pop-Location
    
    return $true
}

# Function to save configuration
function Save-Config {
    $configPath = Join-Path $PSScriptRoot "reposync.config.json"
    $config = @{
        Repo1Path = $Repo1Path
        Repo2Path = $Repo2Path
        LastSync = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    $config | ConvertTo-Json | Set-Content -Path $configPath -Encoding UTF8
    Write-Log "Configuration saved to $configPath" "Gray"
}

# Function to load configuration
function Load-Config {
    $configPath = Join-Path $PSScriptRoot "reposync.config.json"
    if (Test-Path $configPath) {
        $config = Get-Content $configPath -Encoding UTF8 | ConvertFrom-Json
        if ($config.Repo1Path) { $script:Repo1Path = $config.Repo1Path }
        if ($config.Repo2Path) { $script:Repo2Path = $config.Repo2Path }
        Write-Log "Loaded saved configuration" "Gray"
    }
}

# Check command line arguments
if ($args.Count -eq 0 -and -not $Repo1Path -and -not $Repo2Path) {
    Write-Log "Usage: .\sync-between-repos.ps1 [-Repo1Path path] [-Repo2Path path] [-CleanMode] [-DryRun] [-ForcePush]" "Cyan"
    Write-Log "Example: .\sync-between-repos.ps1 -Repo1Path C:\repo1 -Repo2Path C:\repo2" "Cyan"
    Write-Log "Example with cleanup: .\sync-between-repos.ps1 -Repo1Path C:\repo1 -Repo2Path C:\repo2 -CleanMode" "Cyan"
    Write-Log "Example with force push: .\sync-between-repos.ps1 -Repo1Path C:\repo1 -Repo2Path C:\repo2 -ForcePush" "Cyan"
}

# Load saved configuration
if (-not $Repo1Path -and -not $Repo2Path) {
    Load-Config
}

# Run synchronization
$result = Sync-Repositories

# If successful and not in Dry Run mode, save configuration
if ($result -and -not $DryRun -and $Repo1Path -and $Repo2Path) {
    Save-Config
}

if ($result) {
    exit 0
} else {
    exit 1
}