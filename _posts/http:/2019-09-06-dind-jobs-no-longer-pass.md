---
layout: default
title: Docker In Docker (DinD) jobs no longer pass
---

# Docker In Docker (DinD) jobs no longer pass

Recently I noticed that my GitLab CI/CD jobs keep failing with an error `Cannot connect to the Docker daemon at tcp://localhost:2375 Is the docker daemon running?`.

I'm using the Docker in Docker (DinD) workflow, and there wasn't a change on my end. Ultimately, I spent too much time verifying that my GitLab Runner version was OK -- actually, it was pretty old (11.x) so I fixed that, checked for the `--privileged` flag, redid the RBAC authorization, Secrets, the Helm release, and finally, the docker client/server versions.

The solution is to specify `docker:18-dind` for your services (previously: `docker:dind`) so jobs don't randomly fail when new versions of Docker are released. There's also a post from the company about this same topic, see [https://about.gitlab.com/2019/07/31/docker-in-docker-with-docker-19-dot-03/](https://about.gitlab.com/2019/07/31/docker-in-docker-with-docker-19-dot-03/).
