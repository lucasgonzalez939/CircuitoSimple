#!/usr/bin/env bash
# Make this file executable with: chmod +x push-backup-branch.sh

# Simple script to push the backup branch to remote
# This script can be run to immediately create the backup branch in the repository

set -e

echo "================================================"
echo "Pushing backup branch to remote repository..."
echo "================================================"

# Check if backup branch exists locally
if ! git rev-parse --verify backup >/dev/null 2>&1; then
    echo "Error: Local backup branch does not exist!"
    echo "Creating backup branch from current state..."
    git branch backup
fi

# Push the backup branch
echo "Pushing backup branch to origin..."
git push -u origin backup

echo "================================================"
echo "✅ Backup branch successfully pushed!"
echo "================================================"
echo ""
echo "You can verify the branch exists by running:"
echo "  git branch -a"
echo ""
echo "Or visit your repository on GitHub to see the backup branch."
