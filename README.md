# GitHub Actions for all in one Project

[![Docker Automated buil](https://img.shields.io/docker/automated/masutaka/github-actions-all-in-one-project.svg?logo=docker&style=flat-square)][dockerhub]
[![Docker Stars](https://img.shields.io/docker/stars/masutaka/github-actions-all-in-one-project.svg?style=flat-square)][dockerhub]
[![Docker Pulls](https://img.shields.io/docker/pulls/masutaka/github-actions-all-in-one-project.svg?style=flat-square)][dockerhub]
[![License](https://img.shields.io/github/license/masutaka/github-actions-all-in-one-project.svg?style=flat-square)][license]

[dockerhub]: https://hub.docker.com/r/masutaka/github-actions-all-in-one-project/
[license]: https://github.com/masutaka/github-actions-all-in-one-project/blob/master/LICENSE.txt

When you create an issue or pull request, these GitHub Actions always add it to specific GitHub Project.

## Usage

Add the following settings to .github/main.workflow in your repository.

In addition you should probably use [Automation for GitHub Projects](https://help.github.com/articles/about-automation-for-project-boards/).

### Repository project

1. Set the URL of repository project to `PROJECT_URL`
1. Set column name you want issue/pull_request at the beginning to `INITIAL_COLUMN_NAME`

#### For issues

```hcl
workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

action "Add an issue to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["GITHUB_TOKEN"]
  args    = ["issue"]

  env = {
    PROJECT_URL         = "https://github.com/masutaka/sandbox-github-actions/projects/2"
    INITIAL_COLUMN_NAME = "To do"
  }
}
```

#### For pull requests

```hcl
workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Add a pull_request to project"]
}

action "Add a pull_request to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["GITHUB_TOKEN"]
  args    = ["pull_request"]

  env = {
    PROJECT_URL         = "https://github.com/masutaka/sandbox-github-actions/projects/2"
    INITIAL_COLUMN_NAME = "In progress"
  }
}
```

### Organization-wide project

1. Set the URL of Organization-wide project to `PROJECT_URL`
1. Set column name you want issue/pull_request at the beginning to `INITIAL_COLUMN_NAME`
1. Set secrets `MY_GITHUB_TOKEN`
    1. Create personal access token on https://github.com/settings/tokens
    1. Create secret `MY_GITHUB_TOKEN` on https://github.com/USER/REPO_NAME/settings/secrets. The value is same to personal access token you created the above
    1. Set `MY_GITHUB_TOKEN` to `secrets` as follows:

#### For issues

```hcl
workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

action "Add an issue to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["MY_GITHUB_TOKEN"]
  args    = ["issue"]

  env = {
    PROJECT_URL         = "https://github.com/orgs/example/projects/2"
    INITIAL_COLUMN_NAME = "To do"
  }
}
```

#### For pull requests

```hcl
workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Add a pull_request to project"]
}

action "Add a pull_request to project" {
  uses    = "docker://masutaka/github-actions-all-in-one-project"
  secrets = ["MY_GITHUB_TOKEN"]
  args    = ["pull_request"]

  env = {
    PROJECT_URL         = "https://github.com/orgs/example/projects/2"
    INITIAL_COLUMN_NAME = "In progress"
  }
}
```
