---
layout: default
title: Fun with Vagrant
permalink: /vagrant-fun
---

## Fun with Vagrant

Vagrant version:

```bash
$ vagrant -version
Vagrant 2.2.7
```

To create a `Vagrantfile` in the project directory using [HashiCorp's official "box"](https://www.vagrantup.com/docs/boxes.html#official-boxes):

```bash
cd /path/to/the/project/directory/; vagrant init hashicorp/bionic64
```

In case of any edits, use `vagrant reload`.

Getting into your Ubuntu box (i.e., a VM):

```bash
vagrant up; vagrant ssh
```

And there is `suspend`, `resume`, `halt <--force>`, and `destroy`, among [many other CLI commands](https://www.vagrantup.com/docs/cli/) to manage the entire lifecycle of a box.

### Provisioning

If defined, `vagrant up` will use the [configured provisioner](https://www.vagrantup.com/docs/provisioning/) to bootstrap your VM to its desired state; e.g.,

```bash
$ cat Vagrantfile
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y php
    php -v
  SHELL
```
