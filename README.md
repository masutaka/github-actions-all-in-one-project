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

### For issues

```hcl
workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

action "Add an issue to project" {
  uses = "docker://masutaka/github-actions-all-in-one-project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"     # required. For https://github.com/masutaka/sandbox-github-actions/projects/2
    INITIAL_COLUMN_NAME = "To do" # required. It is added to this column.
  }

  args = ["issue"]
}
```

### For pull requests

```hcl
workflow "pull_requests" {
  on       = "pull_request"
  resolves = ["Add a pull_request to project"]
}

action "Add a pull_request to project" {
  uses = "docker://masutaka/github-actions-all-in-one-project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"     # required. For https://github.com/masutaka/sandbox-github-actions/projects/2
    INITIAL_COLUMN_NAME = "To do" # required. It is added to this column.
  }

  args = ["pull_request"]
}
```

### Organization-wide project

If your project is Organization-wide, you should set `ORG_NAME` to the actions as follows:

```hcl
action "Add an issue to project" {
  uses = "docker://masutaka/github-actions-all-in-one-project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    ORG_NAME            = "example"
    PROJECT_NUMBER      = "2"       # required. For https://github.com/masutaka/sandbox-github-actions/projects/2
    INITIAL_COLUMN_NAME = "To do"   # required. It is added to this column.
  }

  args = ["issue"]
}

action "Add a pull_request to project" {
  uses = "docker://masutaka/github-actions-all-in-one-project"

  secrets = ["GITHUB_TOKEN"]

  env = {
    ORG_NAME            = "example"
    PROJECT_NUMBER      = "2"       # required. For https://github.com/masutaka/sandbox-github-actions/projects/2
    INITIAL_COLUMN_NAME = "To do"   # required. It is added to this column.
  }

  args = ["pull_request"]
}
```
