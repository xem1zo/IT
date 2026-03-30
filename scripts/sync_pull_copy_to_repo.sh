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

