---
layout: default
title: Getting an ASUS USB-AC53 Nano working on Ubuntu 20.04
---

## Getting an ASUS USB-AC53 Nano working on Ubuntu 20.04

I recently [built a PC for myself](https://waynekhan.github.io/2020/05/19/pc-builder.html), but refused to pay the $200 or so to get a Windows 10 Pro license.

Instead, I've I've been using Ubuntu 20.04 as my daily driver and it's worked well for me, up until I ordered a [Asus USB-AC53 Nano](https://www.asus.com/sg/Networking/USB-AC53-Nano/specifications/).

So what is it, anyway?

```text
$ lsusb | grep -i asus
Bus 005 Device 002: ID 0b05:184c ASUSTek Computer, Inc. 802.11ac NIC
```

I searched for the device ID (`0b05:184c`), and managed to successfully build and install the driver on `5.4.0-33-generic`.

The following thread was most helpful, albeit slightly outdated:

* [https://askubuntu.com/questions/1079377/how-do-i-install-drivers-for-realtek-rtl8812bu](https://askubuntu.com/questions/1079377/how-do-i-install-drivers-for-realtek-rtl8812bu)

And of course, the repo (and author) itself:

* [https://github.com/cilynx/rtl88x2bu](https://github.com/cilynx/rtl88x2bu)

And as a note-to-self:

```text
sudo apt-get update
sudo apt-get install build-essential dkms git
git clone https://github.com/cilynx/rtl88x2bu
cd rtl88x2bu
VER=$(sed -n 's/\PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)
sudo rsync -rvhP ./ /usr/src/rtl88x2bu-${VER}
sudo dkms add -m rtl88x2bu -v ${VER}
sudo dkms build -m rtl88x2bu -v ${VER}
sudo dkms install -m rtl88x2bu -v ${VER}
sudo modprobe 88x2bu
```

