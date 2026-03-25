#!/bin/bash

# Настройка:

SOURCE_DIR="C:\Users\Никита\mfua"
DEST_DIR="C:\Users\Никита\Desktop\izotov\Izotov"
ENABLE_PUSH=true

echo ">>> Starting synchronization..."
echo ">>> Source: $SOURCE_DIR"
echo ">>> Destination: $DEST_DIR"
echo ""

# Check if directories exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo "ERROR: Destination directory not found: $DEST_DIR"
    exit 1
fi

# Backup destination's .git folder
DEST_GIT_PATH="$DEST_DIR/.git"
TEMP_GIT_PATH="/tmp/temp_git_backup_$$"

if [ -d "$DEST_GIT_PATH" ]; then
    echo "PROTECTING: Backing up destination .git folder..."
    cp -rf "$DEST_GIT_PATH" "$TEMP_GIT_PATH"
    echo "Backup saved to: $TEMP_GIT_PATH"
fi

# Step 1: Git pull in source
echo "Step 1: Updating source repository (git pull)..."
cd "$SOURCE_DIR" || exit 1
git pull

if [ $? -ne 0 ]; then
    echo "WARNING: git pull failed. Continuing anyway..."
fi

echo ""

echo "Step 2: Copying files (.git folder EXCLUDED)..."

cd "$SOURCE_DIR" || exit 1
for item in * .*; do
    if [ "$item" = "." ] || [ "$item" = ".." ]; then
        continue
    fi
    
    if [ "$item" = ".git" ]; then
        continue
    fi
    
    if [ -e "$item" ]; then
        cp -rf "$item" "$DEST_DIR/"
    fi
done

echo "Files copied successfully."

if [ -d "$TEMP_GIT_PATH" ]; then
    echo "RESTORING: Putting back destination's original .git folder..."
    if [ -d "$DEST_GIT_PATH" ]; then
        rm -rf "$DEST_GIT_PATH"
    fi
    cp -rf "$TEMP_GIT_PATH" "$DEST_GIT_PATH"
    rm -rf "$TEMP_GIT_PATH"
    echo "Original .git folder restored successfully!"
fi

echo ""

if [ "$ENABLE_PUSH" = true ]; then
    echo "Step 3: Pushing changes to destination repo..."
    cd "$DEST_DIR" || exit 1
    
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    echo "Destination repository URL: $REMOTE_URL"
    
    if [[ "$REMOTE_URL" == *"rurewa/mfua"* ]]; then
        echo "CRITICAL ERROR: This is the SOURCE repository! Aborting push!"
        exit 1
    fi
    
    git add .
    
    if ! git diff --cached --quiet; then
        echo "Changes detected. Committing..."
        git commit -m "Auto-sync from source repository"
        
        echo "Pushing to remote..."
        git push
        
        if [ $? -eq 0 ]; then
            echo "Push successful!"
        else
            echo "Push failed (check credentials/connection)."
        fi
    else
        echo "No changes to commit."
    fi
else
    echo "Git push is disabled (ENABLE_PUSH=false)."
fi

echo ""
echo "Synchronization completed!"
echo ""

cd - > /dev/null