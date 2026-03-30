# Repo Sync Copy (git pull + replace copy)

Этот мини-проект добавляет два скрипта (Bash и PowerShell), которые делают синхронизацию:

1. Делают `git pull` в *source* (исходном локальном репозитории).
2. Копируют содержимое *source* в *dest* (локальный репозиторий-приемник):
   - исключается папка `.git`
   - выполняется проверка существования путей
   - в `dest` удаляются файлы/папки с теми же именами, что есть в `source`, и затем копируются заново
3. Опционально выполняют `git push` из *dest*.

## Скрипты

- `sync_pull_copy_to_repo.sh` - Bash
- `sync_pull_copy_to_repo.ps1` - PowerShell

## Bash: запуск

```bash
./sync_pull_copy_to_repo.sh --source "/path/to/repoA" --dest "/path/to/repoB" [--remote origin] [--branch main] [--push] [--no-git-check] [--wait]
```

Пример:

```bash
./sync_pull_copy_to_repo.sh --source "./repoA" --dest "./repoB" --push
```

Если запускаете в Unix-окружении, может понадобиться:

```bash
chmod +x sync_pull_copy_to_repo.sh
```

## PowerShell: запуск

```powershell
.\sync_pull_copy_to_repo.ps1 -SourcePath "C:\path\repoA" -DestPath "C:\path\repoB" [-Remote origin] [-Branch main] [-Push] [-NoGitCheck] [-Wait]
```

Пример:

```powershell
.\sync_pull_copy_to_repo.ps1 -SourcePath "C:\repoA" -DestPath "C:\repoB" -Push
```

## Важные детали копирования

- Копируется только верхний уровень (top-level entries) из source-репозитория. Внутренности копируются вместе с папками/файлами.
- `.git` никогда не копируется.
- Дополнительные файлы, которые есть только в `dest`, не удаляются автоматически (т.к. по условию требуется замена по именам).

## Тестирование в Docker / WSL / VM

1. Установите `git`.
2. Склонируйте два репозитория (source и destination).
3. Укажите пути в командах запуска скрипта.
4. Запустите Bash/PowerShell скрипт и проверьте, что `dest` получил обновления.

## Исходники (полный текст)

### Bash (`sync_pull_copy_to_repo.sh`)

```bash
#!/usr/bin/env bash
set -euo pipefail

SOURCE=""
DEST=""
REMOTE=""
BRANCH=""
PUSH=false
NO_GIT_CHECK=false
WAIT=false

usage() {
  cat <<'EOF'
Usage:
  sync_pull_copy_to_repo.sh --source <path> --dest <path> [--remote <remote>] [--branch <branch>] [--push] [--no-git-check] [--wait]

Description:
  1) git pull in SOURCE repository
  2) copy SOURCE contents (excluding .git) to DEST, replacing matching top-level names
  3) optionally git push from DEST
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source|-s) SOURCE="${2:-}"; shift 2 ;;
    --dest|-d) DEST="${2:-}"; shift 2 ;;
    --remote|-r) REMOTE="${2:-}"; shift 2 ;;
    --branch|-b) BRANCH="${2:-}"; shift 2 ;;
    --push) PUSH=true; shift 1 ;;
    --no-git-check) NO_GIT_CHECK=true; shift 1 ;;
    --wait) WAIT=true; shift 1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$SOURCE" || -z "$DEST" ]]; then
  echo "Error: --source and --dest are required." >&2
  usage
  exit 1
fi

if [[ ! -d "$SOURCE" ]]; then
  echo "Error: SOURCE path does not exist or is not a directory: $SOURCE" >&2
  exit 1
fi
if [[ ! -d "$DEST" ]]; then
  echo "Error: DEST path does not exist or is not a directory: $DEST" >&2
  exit 1
fi

SOURCE_ABS="$(cd "$SOURCE" && pwd -P)"
DEST_ABS="$(cd "$DEST" && pwd -P)"
if [[ "$SOURCE_ABS" == "$DEST_ABS" ]]; then
  echo "Error: SOURCE and DEST must be different directories." >&2
  exit 1
fi

if [[ "$NO_GIT_CHECK" == false ]]; then
  if [[ ! -d "$SOURCE/.git" ]]; then
    echo "Error: SOURCE/.git directory not found. Is SOURCE a git repository?" >&2
    exit 1
  fi
  if [[ ! -d "$DEST/.git" ]]; then
    echo "Error: DEST/.git directory not found. Is DEST a git repository?" >&2
    exit 1
  fi
fi

echo "[1/3] git pull in SOURCE: $SOURCE_ABS"
if [[ -n "$REMOTE" && -n "$BRANCH" ]]; then
  git -C "$SOURCE_ABS" pull "$REMOTE" "$BRANCH"
else
  git -C "$SOURCE_ABS" pull
fi

echo "[2/3] Copy SOURCE -> DEST (excluding .git)"
shopt -s dotglob nullglob
for entry in "$SOURCE_ABS"/*; do
  base="$(basename "$entry")"
  if [[ "$base" == ".git" ]]; then
    continue
  fi

  target="$DEST_ABS/$base"

  # Replace by name: delete destination entry if present, then copy.
  rm -rf "$target"
  cp -a "$entry" "$DEST_ABS/"
done

echo "Copy completed."

if [[ "$PUSH" == true ]]; then
  echo "[3/3] git push from DEST: $DEST_ABS"
  if [[ -n "$REMOTE" && -n "$BRANCH" ]]; then
    git -C "$DEST_ABS" push "$REMOTE" "$BRANCH"
  else
    git -C "$DEST_ABS" push
  fi
fi

if [[ "$WAIT" == true ]]; then
  echo "Done. Press Enter to exit..."
  read -r _
fi
```

### PowerShell (`sync_pull_copy_to_repo.ps1`)

```powershell
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
```

