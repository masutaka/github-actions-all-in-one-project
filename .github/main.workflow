# For issues

workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

action "Add an issue to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["GITHUB_TOKEN"]
  args    = ["issue"]

  env = {
    PROJECT_URL         = "https://github.com/masutaka/github-actions-all-in-one-project/projects/1"
    INITIAL_COLUMN_NAME = "To do"
  }
}

# For pull requests

workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Add a pull_request to project"]
}

action "Add a pull_request to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["GITHUB_TOKEN"]
  args    = ["pull_request"]

  env = {
    PROJECT_URL         = "https://github.com/masutaka/github-actions-all-in-one-project/projects/1"
    INITIAL_COLUMN_NAME = "In progress"
  }
}

# Linters

workflow "Lints" {
  on       = "push"
  resolves = ["Docker Lint", "Shell Lint"]
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Shell Lint" {
  uses = "actions/bin/shellcheck@master"
  args = ["entrypoint.sh"]
}
