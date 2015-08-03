#!/bin/sh

set -e
set -u

old_mail="$1"
new_mail="$2"
new_name="$3"
shift
shift
shift

git filter-branch --env-filter '

OLD_EMAIL="'"$old_mail"'"
CORRECT_NAME="'"$new_name"'"
CORRECT_EMAIL="'"$new_mail"'"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' "$@"
