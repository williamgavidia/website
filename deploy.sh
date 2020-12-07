#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Prepare submodules.
git submodule init
git submodule update

# Build.
${HUGO:-"hugo"}

# Publish.
cd public
echo "gitdir: ../.git/modules/public" > .git
git add .

msg="Deploy site"
if [ -n "$*" ]; then
	msg="$*"
fi

git commit -m "$msg"
git push -f origin master
