---
layout: default
title: How to create a bootable USB drive for macOS X El Capitan
---

Following [How to create a bootable USB drive for macOS X El Capitan](https://www.ifixit.com/Guide/How+to+create+a+bootable+USB+drive/66371):

```text
$ sudo /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/Resources/createinstallmedia --volume /Volumes/UBUNTU\ 20_0 --applicationpath /Applications/Install\ OS\ X\ El\ Capitan.app
Password:
Ready to start.
To continue we need to erase the disk at /Volumes/UBUNTU 20_0.
If you wish to continue type (Y) then press return: y
Erasing Disk: 0%... 10%... 20%... 30%...100%...
Copying installer files to disk...
Copy complete.
Making disk bootable...
Copying boot files...
Copy complete.
Done.
```

To boot off this USB, first make sure the Mac is off and then press and hold the [option] key when you hear the chime/turn it on.
