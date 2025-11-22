#!/bin/bash

# Script to push the backup branch and tag to remote repository
# This preserves the original state of the main branch before major changes

echo "================================================"
echo "  Pushing Backup Branch and Tag to Remote"
echo "================================================"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Get repository URL for display
REPO_URL=$(git remote get-url origin 2>/dev/null | sed 's/\.git$//' | sed 's|git@github.com:|https://github.com/|')

# Verify backup branch exists locally
if ! git rev-parse --verify main-original-backup > /dev/null 2>&1; then
    echo "✗ Error: Branch 'main-original-backup' does not exist locally"
    echo "  Please create the branch first"
    exit 1
fi

# Verify backup tag exists locally
if ! git rev-parse --verify v1.0-original > /dev/null 2>&1; then
    echo "✗ Error: Tag 'v1.0-original' does not exist locally"
    echo "  Please create the tag first"
    exit 1
fi

# Push the backup branch
echo "Pushing backup branch 'main-original-backup'..."
if git push origin main-original-backup; then
    echo "✓ Backup branch pushed successfully"
else
    echo "✗ Failed to push backup branch"
    exit 1
fi

echo ""

# Push the backup tag
echo "Pushing backup tag 'v1.0-original'..."
if git push origin v1.0-original; then
    echo "✓ Backup tag pushed successfully"
else
    echo "✗ Failed to push backup tag"
    exit 1
fi

echo ""
echo "================================================"
echo "  Backup Complete!"
echo "================================================"
echo ""
if [ -n "$REPO_URL" ]; then
    echo "The original version is now safely backed up and accessible at:"
    echo "  Branch: ${REPO_URL}/tree/main-original-backup"
    echo "  Tag: ${REPO_URL}/releases/tag/v1.0-original"
else
    echo "The original version is now safely backed up."
    echo "Check your repository for:"
    echo "  Branch: main-original-backup"
    echo "  Tag: v1.0-original"
fi
echo ""
echo "These backups should NOT be modified to preserve the original state."
