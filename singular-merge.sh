#!/bin/bash

# SETTINGS
source config.conf

# Ensure a repository URL is provided as an argument
if [ $# -eq 0 ]; then
    echo "Error: Please provide the URL of the repository to mirror."
    echo "Usage: bash singular-merge.sh <repository_url>"
    exit 1
fi

REPO_URL="$1" # Get repository URL from command-line argument

echo "Mirroring this repository: $REPO_URL"
echo "Press enter to continue..."
read user_input

# Clone the repository
echo "[START] Cloning... $REPO_URL"
REPO_NAME=$(basename "$REPO_URL" | sed 's/\.git$//')
git clone --mirror "$REPO_URL" || {
    echo "[ERROR] Cloning failed for $REPO_NAME"
    exit 1
}
cd "$REPO_NAME.git" || {
    echo "[ERROR] Directory not found: $REPO_NAME.git"
    exit 1
}

# Add GitHub as a remote
echo "[INFO] Adding GitHub as a remote"
git remote add github "https://$GITHUB_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME" || {
    echo "[ERROR] Failed to add GitHub as a remote"
    exit 1
}

# Push to GitHub
echo "[INFO] Pushing into GitHub"
git push --mirror github || (
    echo "[WARNING] Repository doesn't exist on GitHub. Creating a new repository..."
    if ! curl -f -H "Authorization: token $GITHUB_ACCESS_TOKEN" -d '{"name":"'"$REPO_NAME"'", "private": true}' https://api.github.com/user/repos; then
        echo "[ERROR] Failed to create repository on GitHub"
        exit 1
    fi
    git push --mirror github || {
        echo "[ERROR] Pushing to GitHub failed"
        exit 1
    }
)

# Navigate back to the previous directory
echo "[INFO] Navigating back to the previous directory"
cd ..
echo "[END]"