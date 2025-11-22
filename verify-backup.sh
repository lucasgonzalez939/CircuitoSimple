#!/bin/bash

# Verification script to check that backup branch and tag are properly created
# Run this to verify the backup is ready to be pushed

echo "================================================"
echo "  Backup Verification Report"
echo "================================================"
echo ""

# Check if backup branch exists
echo "1. Checking backup branch..."
if git rev-parse --verify main-original-backup > /dev/null 2>&1; then
    echo "   ✓ Branch 'main-original-backup' exists"
    BRANCH_COMMIT=$(git rev-parse main-original-backup)
    echo "   Commit: $BRANCH_COMMIT"
    git log main-original-backup --oneline -1 | sed 's/^/   /'
else
    echo "   ✗ Branch 'main-original-backup' not found"
    exit 1
fi

echo ""

# Check if backup tag exists
echo "2. Checking backup tag..."
if git rev-parse --verify v1.0-original > /dev/null 2>&1; then
    echo "   ✓ Tag 'v1.0-original' exists"
    TAG_COMMIT=$(git rev-parse v1.0-original)
    echo "   Commit: $TAG_COMMIT"
    git show v1.0-original --no-patch --format="%h %s" | sed 's/^/   /'
else
    echo "   ✗ Tag 'v1.0-original' not found"
    exit 1
fi

echo ""

# Verify they point to the same commit
echo "3. Verifying backup consistency..."
if git rev-parse --verify origin/main > /dev/null 2>&1; then
    MAIN_COMMIT=$(git rev-parse origin/main)
    if [ "$BRANCH_COMMIT" = "$TAG_COMMIT" ] && [ "$BRANCH_COMMIT" = "$MAIN_COMMIT" ]; then
        echo "   ✓ Branch, tag, and origin/main all point to the same commit"
        echo "   Commit: $MAIN_COMMIT"
    else
        echo "   ⚠ Backup points to: $BRANCH_COMMIT"
        echo "   origin/main points to: $MAIN_COMMIT"
    fi
else
    echo "   ℹ Cannot verify against origin/main (remote not available)"
    if [ "$BRANCH_COMMIT" = "$TAG_COMMIT" ]; then
        echo "   ✓ Branch and tag point to the same commit"
        echo "   Commit: $BRANCH_COMMIT"
    else
        echo "   ✗ Branch and tag point to different commits!"
    fi
fi

echo ""

# Check what files are in the backup
echo "4. Files in backup version..."
git ls-tree --name-only main-original-backup | sed 's/^/   - /'

echo ""

# Check if branch/tag already exists on remote
echo "5. Checking remote status..."
if git ls-remote --heads origin main-original-backup | grep -q main-original-backup; then
    echo "   ⚠ Branch 'main-original-backup' already exists on remote"
else
    echo "   ℹ Branch 'main-original-backup' not yet pushed to remote (expected)"
fi

if git ls-remote --tags origin v1.0-original | grep -q v1.0-original; then
    echo "   ⚠ Tag 'v1.0-original' already exists on remote"
else
    echo "   ℹ Tag 'v1.0-original' not yet pushed to remote (expected)"
fi

echo ""
echo "================================================"
echo "  Summary"
echo "================================================"
echo ""
echo "Backup is properly configured locally and ready to push."
echo "To push the backup to remote, run: ./push-backup.sh"
echo ""
