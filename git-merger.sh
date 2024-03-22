#!/bin/bash

# SETTINGS
source config.conf

# GRABBING LIST OF REPOSITORIES
PAGE=1 # STARTING PAGE
REPO_LIST=""
# REPO_LIST=$(curl -s -H "Authorization: token $GITEA_ACCESS_TOKEN" "$GITEA_SERVICE_PROVIDER/api/v1/users/$GITEA_USERNAME/repos" | jq -r '.[].ssh_url')
fetch_repositories() {
    local PAGE=1
    while true; do
        RESPONSE=$(curl -s -H "Authorization: token $GITEA_ACCESS_TOKEN" "$GITEA_SERVICE_PROVIDER/api/v1/users/$GITEA_USERNAME/repos?page=$PAGE")
        if [ "$RESPONSE" == "[]" ]; then
            break
        fi
        REPO_LIST="$REPO_LIST $(echo "$RESPONSE" | jq -r '.[].ssh_url')"
        ((PAGE++))
    done
}
fetch_repositories

echo "List of repositories:"
echo "$REPO_LIST"
echo "Press enter to continue..."
read ans

# Looping through each repository and mirroring it to GitHub
for REPO_URL in $REPO_LIST; do
    echo "[START] Cloning... $REPO_URL"

    # Extract repository name using REGEX
    REPO_NAME=$(echo "$REPO_URL" | sed 's#.*/\([^/]\+\)\.git$#\1#')

    REBUILT_URL="$GITEA_SERVICE_PROVIDER/$GITEA_USERNAME/$REPO_NAME" # Rebuilding the URL

    git clone --mirror "$REBUILT_URL" || {
        echo "[ERROR] Cloning failed for $REPO_NAME"
        exit 1
    }                   # Clone the repository from Gitea as a mirror
    cd "$REPO_NAME.git" # Navigating in to the repository directory

    echo "[INFO] Adding GitHub as a remote"
    git remote add github "https://$GITHUB_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME"

    # Push to GitHub
    echo "[INFO] Pushing into GitHub"
    git push --mirror github || (
        echo "[WARNING] Repository doesn't exist on GitHub. Creating a new repository..."
        curl -f -H "Authorization: token $GITHUB_ACCESS_TOKEN" -d '{"name":"'"$REPO_NAME"'", "private": true}' https://api.github.com/user/repos || {
            echo "[ERROR] Failed to create repository on GitHub"
            exit 1
        }
        git push --mirror github || { echo "[ERROR] Pushing to GitHub failed"; exit 1; }
    )

    # Navigate back to the previous directory
    echo "[INFO] Navigating back to the previous directory"
    cd ..
    echo "[END]"
done
