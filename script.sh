#!/bin/bash

# Check if the necessary arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <old_email> <new_email>"
    exit 1
fi

OLD_EMAIL="$1"
NEW_EMAIL="$2"

# Check if we are in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be executed in a Git repository."
    exit 1
fi

# Execute the git filter-branch command
git filter-branch --env-filter '
if [ "$GIT_COMMITTER_EMAIL" = "'"$OLD_EMAIL"'" ]
then
    export GIT_COMMITTER_EMAIL="'"$NEW_EMAIL"'"
fi
if [ "$GIT_AUTHOR_EMAIL" = "'"$OLD_EMAIL"'" ]
then
    export GIT_AUTHOR_EMAIL="'"$NEW_EMAIL"'"
fi
' --tag-name-filter cat -- --branches --tags

echo "The email address has been changed from $OLD_EMAIL to $NEW_EMAIL in all commits."
echo "Please verify the changes and push the modifications if everything is correct."