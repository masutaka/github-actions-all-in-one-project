FROM alpine:3.9

LABEL "com.github.actions.name"="All in one project"
LABEL "com.github.actions.description"="Add an issue or pull_request to one GitHub Project"
LABEL "com.github.actions.icon"="github"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/masutaka/sandbox-github-actions"
LABEL "homepage"="https://github.com/masutaka/sandbox-github-actions"
LABEL "maintainer"="Takashi Masuda <masutaka.net@gmail.com>"

RUN apk add --no-cache --no-progress curl=7.63.0-r0 jq=1.6-r0

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
