#!/usr/bin/env bash
#
# @author deexkajo
#
# This hook should go into .git/hooks/prepare-commit-msg (remember to add exec rights).
# It adds a branch ID at the beginning of the commit message.
# The branch ID is supposed to be the same as the related Polarion ID.
# The sign-off is also being suggested automatically.

branchName=$(git rev-parse --abbrev-ref HEAD)
polarionID=""
signOff=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p')
commitmsgFile="$1"
commitmsg=$(cat "$1")

if [[ "$branchName" == */* ]]; then
  polarionID=$(echo $branchName | cut -d "/" -f2)
fi

if [ -z "$polarionID" ]; then
  warning="No Polarion ID. Are you working on the right branch?"
fi
echo -e "[$polarionID] $warning $commitmsg\n\n$signOff" > $commitmsgFile
