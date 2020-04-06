---
layout: default
title: GitLab Runner certificate signed by unknown authority
---

## GitLab Runner certificate signed by unknown authority

Recently I've been working w/ [runners](https://docs.gitlab.com/runner/), starting with Shell Executor before moving on to Docker.

Anyway, my GitLab instance uses a self-signed certificate. This is not great as our tooling essentially needs to work around errors like this:

```bash
ERROR: Registering runner... failed                 runner=EfnphyLc status=couldn't execute POST against https://example.com/api/v4/runners: Post https://example.com/api/v4/runners: x509: certificate signed by unknown authority
PANIC: Failed to register this runner. Perhaps you are having network problems
```

In your `config.toml`, introduce GIT_SSL_NO_VERIFY=true in your list of environment variables; e.g.,

```yaml
concurrent = 1
check_interval = 0

[[runners]]
  name = "f6705c062106"
  url = "FIXME"
  token = "FIXME"
  executor = "docker"
  environment = ["GIT_SSL_NO_VERIFY=true"]
  [runners.docker]
    tls_verify = false
    image = "FIXME"
    privileged = false
    disable_cache = false
    volumes = ["/cache"]
    pull_policy = "if-not-present"
    shm_size = 0
  [runners.cache]
```

Check out [https://gitlab.com/gitlab-org/gitlab-runner/issues/2795](https://gitlab.com/gitlab-org/gitlab-runner/issues/2795) for more details.
