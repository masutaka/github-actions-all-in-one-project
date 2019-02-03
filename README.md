# GitHub Actions for all in one Project

When you create an issue or pull request, these GitHub Actions always add it to specific GitHub Project.

## Usage

Add the following settings to .github/main.workflow in your repository.

### For issues

```hcl
workflow "issues" {
  on       = "issues"
  resolves = ["Add an issue to project"]
}

action "Add an issue to project" {
  uses = "masutaka/github-actions-all-in-one-project@master"

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
  uses = "masutaka/github-actions-all-in-one-project@master"

  secrets = ["GITHUB_TOKEN"]

  env = {
    PROJECT_NUMBER      = "2"     # required. For https://github.com/masutaka/sandbox-github-actions/projects/2
    INITIAL_COLUMN_NAME = "To do" # required. It is added to this column.
  }

  args = ["pull_request"]
}
```
