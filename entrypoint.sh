#!/bin/sh -eu

# echo "$@"
# env | sort
# jq < "$GITHUB_EVENT_PATH"

CONTENT_TYPE="$1"
ACTION=$(jq -r '.action' < "$GITHUB_EVENT_PATH")

if [ "$ACTION" != opened ]; then
  echo "This action was ignored. (ACTION: $ACTION)"
  exit 0
fi

get_org_name() {
  _PROJECT_URL="$1"

  if echo "$_PROJECT_URL" | grep -qF 'https://github.com/orgs/'; then
    echo "$_PROJECT_URL" | sed -e 's@https://github.com/orgs/\([^/]\+\)/projects/[0-9]\+@\1@'
  fi
}

find_project_id() {
  _ORG_NAME="$1"
  _PROJECT_URL="$2"

  if [ "$_ORG_NAME" ]; then
    _ENDPOINT="https://api.github.com/orgs/$_ORG_NAME/projects"
  else
    _ENDPOINT="https://api.github.com/repos/$GITHUB_REPOSITORY/projects"
  fi

  _PROJECTS=$(curl -s -X GET -u "$GITHUB_ACTOR:$TOKEN" --retry 3 \
		   -H 'Accept: application/vnd.github.inertia-preview+json' \
		   "$_ENDPOINT")
  echo "$_PROJECTS" | jq -r ".[] | select(.html_url == \"$_PROJECT_URL\").id"
  unset _PROJECT_URL _ORG_NAME _ENDPOINT _PROJECTS
}

find_column_id() {
  _PROJECT_ID="$1"
  _INITIAL_COLUMN_NAME="$2"
  _COLUMNS=$(curl -s -X GET -u "$GITHUB_ACTOR:$TOKEN" --retry 3 \
		  -H 'Accept: application/vnd.github.inertia-preview+json' \
		  "https://api.github.com/projects/$_PROJECT_ID/columns")
  echo "$_COLUMNS" | jq -r ".[] | select(.name == \"$_INITIAL_COLUMN_NAME\").id"
  unset _PROJECT_ID _INITIAL_COLUMN_NAME _COLUMNS
}

ORG_NAME=$(get_org_name "${PROJECT_URL:?<Error> required this environment variable}")

if [ "$ORG_NAME" ]; then
  TOKEN="$MY_GITHUB_TOKEN" # It's User's personal access token. It should be secret.
else
  TOKEN="$GITHUB_TOKEN"    # GitHub sets. The scope in only the repository containing the workflow file.
fi

PROJECT_ID=$(find_project_id "$ORG_NAME" "$PROJECT_URL")
INITIAL_COLUMN_ID=$(find_column_id "$PROJECT_ID" "${INITIAL_COLUMN_NAME:?<Error> required this environment variable}")

case "$CONTENT_TYPE" in
  issue)
    ISSUE_ID=$(jq -r '.issue.id' < "$GITHUB_EVENT_PATH")

    # Add this issue to the project column
    curl -s -X POST -u "$GITHUB_ACTOR:$TOKEN" --retry 3 \
	 -H 'Accept: application/vnd.github.inertia-preview+json' \
	 -d "{\"content_type\": \"Issue\", \"content_id\": $ISSUE_ID}" \
	 "https://api.github.com/projects/columns/$INITIAL_COLUMN_ID/cards"
    ;;
  pull_request)
    PULL_REQUEST_ID=$(jq -r '.pull_request.id' < "$GITHUB_EVENT_PATH")

    # Add this pull_request to the project column
    curl -s -X POST -u "$GITHUB_ACTOR:$TOKEN" --retry 3 \
	 -H 'Accept: application/vnd.github.inertia-preview+json' \
	 -d "{\"content_type\": \"PullRequest\", \"content_id\": $PULL_REQUEST_ID}" \
	 "https://api.github.com/projects/columns/$INITIAL_COLUMN_ID/cards"
    ;;
  *)
    echo "Invalid arg $CONTENT_TYPE" >&2
    exit 1
    ;;
esac
