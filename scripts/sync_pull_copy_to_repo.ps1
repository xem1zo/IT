param(
  [Parameter(Mandatory = $false)]
  [string]$SourcePath = "",

  [Parameter(Mandatory = $false)]
  [string]$DestPath = "",

  [Parameter(Mandatory = $false)]
  [string]$Remote = "",

  [Parameter(Mandatory = $false)]
  [string]$Branch = "",

  [Parameter(Mandatory = $false)]
  [switch]$Push,

  [Parameter(Mandatory = $false)]
  [switch]$NoGitCheck,

  [Parameter(Mandatory = $false)]
  [switch]$Wait
)

function Show-Usage {
  @"
Usage:
  .\sync_pull_copy_to_repo.ps1 -SourcePath <path> -DestPath <path> [-Remote origin] [-Branch main] [-Push] [-NoGitCheck] [-Wait]

Description:
  1) git pull in SOURCE repository
  2) copy SOURCE contents (excluding .git) to DEST, replacing matching top-level names
  3) optionally git push from DEST
"@
}

if ([string]::IsNullOrWhiteSpace($SourcePath) -or [string]::IsNullOrWhiteSpace($DestPath)) {
  Write-Error "SourcePath and DestPath are required."
  Show-Usage
  exit 1
}

if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
  Write-Error "SOURCE path does not exist or is not a directory: $SourcePath"
  exit 1
}
if (-not (Test-Path -LiteralPath $DestPath -PathType Container)) {
  Write-Error "DEST path does not exist or is not a directory: $DestPath"
  exit 1
}

$srcFull = (Resolve-Path -LiteralPath $SourcePath).Path
$dstFull = (Resolve-Path -LiteralPath $DestPath).Path
if ($srcFull -ieq $dstFull) {
  Write-Error "SOURCE and DEST must be different directories."
  exit 1
}

if (-not $NoGitCheck.IsPresent) {
  if (-not (Test-Path -LiteralPath (Join-Path $SourcePath ".git") -PathType Container)) {
    Write-Error "SOURCE/.git directory not found. Is SourcePath a git repository?"
    exit 1
  }
  if (-not (Test-Path -LiteralPath (Join-Path $DestPath ".git") -PathType Container)) {
    Write-Error "DEST/.git directory not found. Is DestPath a git repository?"
    exit 1
  }
}

Write-Host "[1/3] git pull in SOURCE: $srcFull"
if (-not [string]::IsNullOrWhiteSpace($Remote) -and -not [string]::IsNullOrWhiteSpace($Branch)) {
  & git -C $srcFull pull $Remote $Branch
} else {
  & git -C $srcFull pull
}

Write-Host "[2/3] Copy SOURCE -> DEST (excluding .git)"
$items = Get-ChildItem -LiteralPath $srcFull -Force

foreach ($item in $items) {
  if ($item.Name -eq ".git") {
    continue
  }

  $target = Join-Path $dstFull $item.Name

  # Replace by name: delete destination entry if present, then copy.
  if (Test-Path -LiteralPath $target) {
    Remove-Item -LiteralPath $target -Recurse -Force
  }

  if ($item.PSIsContainer) {
    Copy-Item -LiteralPath $item.FullName -Destination $dstFull -Recurse -Force
  } else {
    Copy-Item -LiteralPath $item.FullName -Destination $dstFull -Force
  }
}

Write-Host "Copy completed."

if ($Push.IsPresent) {
  Write-Host "[3/3] git push from DEST: $dstFull"
  if (-not [string]::IsNullOrWhiteSpace($Remote) -and -not [string]::IsNullOrWhiteSpace($Branch)) {
    & git -C $dstFull push $Remote $Branch
  } else {
    & git -C $dstFull push
  }
}

if ($Wait.IsPresent) {
  Read-Host "Done. Press Enter to exit..."
}

