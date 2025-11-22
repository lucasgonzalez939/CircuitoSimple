# Backup Branch Setup

## Overview
This repository includes a backup branch system to maintain a mirror copy of the project.

## Current Status
- ✅ A local `backup` branch has been created
- ✅ GitHub Actions workflow is configured to maintain the backup branch
- ⏳ The backup branch needs to be pushed to the remote repository

## How to Create the Backup Branch

### Option 1: Using the Helper Script (Easiest)
Run the provided script to push the backup branch:

```bash
./push-backup-branch.sh
```

### Option 2: Manual Push
Run the following command to push the backup branch to the remote repository:

```bash
git push origin backup
```

### Option 3: GitHub Actions (Automatic)
The backup branch will be automatically created/updated when:
- You manually trigger the "Create Backup Branch" workflow from the Actions tab
- You push commits to the `main` or `master` branch

To manually trigger the workflow:
1. Go to the "Actions" tab in GitHub
2. Select "Create Backup Branch" workflow
3. Click "Run workflow"

## What is the Backup Branch?
The `backup` branch is a mirror of the current project state. It serves as a backup copy that can be used to restore the project if needed.

## Maintenance
The GitHub Actions workflow (`.github/workflows/create-backup-branch.yml`) will automatically keep the backup branch synchronized with the main branch whenever you push changes.
