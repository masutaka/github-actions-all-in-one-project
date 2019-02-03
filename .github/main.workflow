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
