#Настройка

$sourceDir = "C:\Users\Никита\mfua"
$destDir   = "C:\Users\Никита\Desktop\izotov\Izotov"
$enablePush = $true

Write-Host ">>> Starting synchronization..." -ForegroundColor Cyan
Write-Host ">>> Source: $sourceDir"
Write-Host ">>> Destination: $destDir"
Write-Host ""
# Check directories exist
if (-not (Test-Path -Path $sourceDir -PathType Container)) {
    Write-Host "ERROR: Source directory not found: $sourceDir" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path -Path $destDir -PathType Container)) {
    Write-Host "ERROR: Destination directory not found: $destDir" -ForegroundColor Red
    exit 1
}
# CRITICAL: Backup destination's .git folder before copying
$destGitPath = Join-Path $destDir ".git"
$tempGitPath = Join-Path $env:TEMP "temp_git_backup_$(Get-Random)"
if (Test-Path $destGitPath) {
    Write-Host "PROTECTING: Backing up destination .git folder..." -ForegroundColor Yellow
    Copy-Item -Path $destGitPath -Destination $tempGitPath -Recurse -Force
    Write-Host "Backup saved to: $tempGitPath" -ForegroundColor Green
}
# Step 1: Git pull in source
Write-Host "Step 1: Updating source repository (git pull)..." -ForegroundColor Yellow
Set-Location $sourceDir
git pull
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: git pull failed. Continuing anyway..." -ForegroundColor Yellow
}
Write-Host ""
# Step 2: Copy files EXCLUDING .git (SAFE METHOD)
Write-Host "Step 2: Copying files (.git folder EXCLUDED)..." -ForegroundColor Yellow
# Use robocopy with proper exclusion
robocopy "$sourceDir" "$destDir" /E /XD ".git" /XF ".git*" /NFL /NDL /NJH /NJS /nc /ns /np
if ($LASTEXITCODE -ge 8) {
    Write-Host "ERROR: File copy failed." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Files copied successfully." -ForegroundColor Green
}
# CRITICAL: Restore destination's .git folder
if (Test-Path $tempGitPath) {
    Write-Host "RESTORING: Putting back destination's original .git folder..." -ForegroundColor Yellow
    if (Test-Path $destGitPath) {
        Remove-Item -Path $destGitPath -Recurse -Force
    }
    Copy-Item -Path $tempGitPath -Destination $destGitPath -Recurse
    Remove-Item -Path $tempGitPath -Recurse -Force
    Write-Host "Original .git folder restored successfully!" -ForegroundColor Green
}
Write-Host ""
# Step 3: Verify and push to correct repository
if ($enablePush) {
    Write-Host "Step 3: Pushing changes to destination repo..." -ForegroundColor Yellow
    Set-Location $destDir
    
    # Show current remote to confirm it's correct
    $remoteUrl = git remote get-url origin 2>$null
    Write-Host "Destination repository URL: $remoteUrl" -ForegroundColor Cyan
    
    # SAFETY CHECK: Prevent pushing to wrong repo
    if ($remoteUrl -like "*rurewa/mfua*") {
        Write-Host "CRITICAL ERROR: This is the SOURCE repository! Aborting push!" -ForegroundColor Red
        Write-Host "Your .git folder was corrupted. Please restore from backup." -ForegroundColor Red
        exit 1
    }
    
    git add .
    $status = git status --porcelain
    
    if ($status) {
        Write-Host "Changes detected. Committing..." -ForegroundColor Gray
        git commit -m "Auto-sync from source repository"
        
        Write-Host "Pushing to remote..." -ForegroundColor Gray
        git push
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Push successful!" -ForegroundColor Green
        } else {
            Write-Host "Push failed (check credentials/connection)." -ForegroundColor Yellow
        }
    } else {
        Write-Host "No changes to commit." -ForegroundColor Gray
    }
} else {
    Write-Host "Git push is disabled (enablePush = false)." -ForegroundColor Gray
}
Write-Host ""
Write-Host "Synchronization completed!" -ForegroundColor Cyan
Write-Host ""
Set-Location -Path (Get-Location).Path