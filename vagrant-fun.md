---
layout: default
title: Fun with Vagrant
permalink: /vagrant-fun
---

## Fun with Vagrant

### Vagrant 101

Assuming [Vagrant](https://www.vagrantup.com/downloads.html) is installed and available on your host system:

```bash
$ vagrant -version
Vagrant 2.2.7
$ cd /path/to/the/project/directory/
$ vagrant init hashicorp/bionic64
```

This will create a `Vagrantfile` in the project directory, and should be committed to version control. In case of any edits, use `vagrant reload`.

Getting into your Ubuntu box (i.e., a VM):

```bash
vagrant up
vagrant ssh
```

And there is `suspend`, `resume`, `halt <--force>`, `destroy` to manage its lifecycle, too.

### Provisioning

If defined, `vagrant up` will use the [configured provisioner](https://www.vagrantup.com/docs/provisioning/) to bootstrap your VM to its desired state; e.g.,

```bash
$ cat Vagrantfile
  Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: <<-SHELL
      apt update
      apt install -y php
      php -v
    SHELL
  end
```
