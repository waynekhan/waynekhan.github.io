---
layout: default
title: GitLab Runner (Docker executor) SSL certificate problem (self-signed certificate)
---

# GitLab Runner (Docker executor) SSL certificate problem (self-signed certificate)

Recently I've been working w/ [GitLab runners](https://docs.gitlab.com/runner/), starting with Shell Executor before moving on w/ Docker. As you know, this website is containerized on Docker Hub, hence the interest.

Anyway, my GitLab instance uses a self-signed certificate. This is not great as the entire toolchain needs to work around this. Here's a workaround if you're using the Docker executor, and running into seemingly random job failures due to this.

In your `config.toml`, introduce GIT_SSL_NO_VERIFY=true in your environment attribute; e.g.,

```
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

Check out https://gitlab.com/gitlab-org/gitlab-runner/issues/2795 for more details.
