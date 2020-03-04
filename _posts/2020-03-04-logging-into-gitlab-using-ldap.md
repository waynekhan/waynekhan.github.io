---
layout: default
title: Logging into GitLab using LDAP
---

# Logging into GitLab using LDAP

Recently, we deployed a GitLab instance, and my colleague discovered that when he logged in using our LDAP service account credentials, he ended up logging in as me; i.e., two different LDAP users with two pairs of usernames/passwords end up being the same user.

I didn't want that to be the case, so I dug into this a bit. Using `ldapsearch` with the `sAMAccountName` attribute resulted in two users (correct), and the `gitlab-rake gitlab:ldap:check` output proved similarly unhelpful, so [I filed an issue](https://gitlab.com/gitlab-org/gitlab/issues/208138).

Very quickly, I got a response that clued me to the problem. On our LDAP, we had two accounts bearing the same `email` attribute:

> GitLab assumes that LDAP users have unique email addresses, otherwise it is possible for LDAP users with the same email address to share the same GitLab account.

This from [https://docs.gitlab.com/ee/administration/auth/ldap.html#security](https://docs.gitlab.com/ee/administration/auth/ldap.html#security).

This gels with my experience with GitLab so far. The technical documentation is excellent, it just works. And now I can say that my personal support experience was similarly great.

TLDR: Correcting the email attributes resolved the issue I faced, not a bug.
