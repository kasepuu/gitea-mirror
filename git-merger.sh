#!/bin/bash

# SETTINGS
source config.conf
ARGUMENTPROVIDED=false
REPO_URL=""

# Check if repository URL is provided as an argument
if [ $# -eq 1 ]; then
    REPO_URL="$1" # Get repository URL from command-line argument
    echo "You are trying to mirror this repository: '$REPO_URL'"
    ARGUMENTPROVIDED=true
elif [ $# -gt 1 ]; then
    echo "Error: More than one argument provided. Please provide only one repository URL."
    exit 1
fi

REPO_LIST="$REPO_URL"

# If no argument provided, grab life of repositories
if [ "$ARGUMENTPROVIDED" == "false" ]; then
    fetch_repositories() {
        local PAGE=1
        while true; do
            echo "Scanning for repositories /repos@?page=$PAGE"
            RESPONSE=$(curl -s -H "Authorization: token $GITEA_ACCESS_TOKEN" "$GITEA_SERVICE_PROVIDER/api/v1/users/$GITEA_USERNAME/repos?page=$PAGE")
            if [[ "$RESPONSE" == "[]" || "$RESPONSE" == "" ]]; then
                echo "No repositories were found on page $PAGE"
                break
            fi
            REPO_LIST="$REPO_LIST $(echo "$RESPONSE" | jq -r '.[].ssh_url')"
            ((PAGE++))
        done
    }
    fetch_repositories
fi

echo "List of repositories:"
echo "$REPO_LIST"
echo "Press enter to continue..."
read ans

# Looping through each repository and mirroring it to GitHub
for REPO_URL in $REPO_LIST; do
    echo "[START] Cloning... $REPO_URL"

    REPO_NAME=$(echo "$REPO_URL" | sed 's#.*/\([^/]\+\)$#\1#')
    REBUILT_URL="$REPO_URL"
    if [ "$ARGUMENTPROVIDED" == "false" ]; then
        # Extract repository name using REGEX
        REPO_NAME=$(echo "$REPO_URL" | sed 's#.*/\([^/]\+\)\.git$#\1#')
        REBUILT_URL="$GITEA_SERVICE_PROVIDER/$GITEA_USERNAME/$REPO_NAME" # Rebuilding the URL
    fi

    git clone --mirror "$REBUILT_URL" || {
        echo "[ERROR] Cloning failed for $REPO_NAME"
        exit 1
    }                   # Clone the repository from Gitea as a mirror
    cd "$REPO_NAME.git" # Navigating in to the repository directory

    echo "[INFO] Adding GitHub as a remote"
    git remote add github "https://$GITHUB_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME" || {
        echo "[ERROR] Failed to add GitHub as a remote"
        exit 1
    }
    # Push to GitHub
    echo "[INFO] Pushing into GitHub"
    git push --mirror github || (
        echo "[WARNING] Repository doesn't exist on GitHub. Creating a new repository..."
        curl -f -H "Authorization: token $GITHUB_ACCESS_TOKEN" -d '{"name":"'"$REPO_NAME"'", "private": true}' https://api.github.com/user/repos || {
            echo "[ERROR] Failed to create repository on GitHub"
            exit 1
        }
        git push --mirror github || {
            echo "[ERROR] Pushing to GitHub failed"
            exit 1
        }
    )

    # Navigate back to the previous directory
    echo "[INFO] Navigating back to the previous directory"
    cd ..
    echo "[END]"
done
