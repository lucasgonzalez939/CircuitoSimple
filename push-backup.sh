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

# Push the backup branch
echo "Pushing backup branch 'main-original-backup'..."
if git push origin main-original-backup; then
    echo "✓ Backup branch pushed successfully"
else
    echo "✗ Failed to push backup branch"
    echo "  Make sure the branch exists locally: git branch -l | grep main-original-backup"
fi

echo ""

# Push the backup tag
echo "Pushing backup tag 'v1.0-original'..."
if git push origin v1.0-original; then
    echo "✓ Backup tag pushed successfully"
else
    echo "✗ Failed to push backup tag"
    echo "  Make sure the tag exists locally: git tag -l | grep v1.0-original"
fi

echo ""
echo "================================================"
echo "  Backup Complete!"
echo "================================================"
echo ""
echo "The original version is now safely backed up and accessible at:"
echo "  Branch: https://github.com/lucasgonzalez939/CircuitoSimple/tree/main-original-backup"
echo "  Tag: https://github.com/lucasgonzalez939/CircuitoSimple/releases/tag/v1.0-original"
echo ""
echo "These backups should NOT be modified to preserve the original state."
