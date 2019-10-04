---
layout: default
title: Alternate tabbing on VirtualBox
---

# Alternate tabbing on VirtualBox

I've been a long-time VirtualBox user. Typically, I use Cygwin to SSH to my guest OS (e.g., Ubuntu) so there never was a problem with using using the Alt+Tab keyboard shortcut to switch between windows.

However, on a work trip I realized that for whatever reason, bridged mode simply wouldn't work with my wireless network card, so I was forced to install a Linux Desktop Environment, something that I've long resisted to reduce my guest resource requirements. But in doing so, I quickly realized that Alt-Tab no longer worked as my web browser ran in the host OS (i.e., Windows), whilst Terminal was in the guest OS. All this to say that my productivity went down since switching windows now required an additional mouse movement/click.

Back in my regular office, I'm still on Xubuntu (guest OS) and Brave (host OS) and today I learned that there is a VirtualBox option so that Alt-Tab now works as I'd expect. I extracted this awesome answer from [Ask Ubuntu](https://askubuntu.com/a/551608):

> VirtualBox: File -> Preferences -> Input -> uncheck "Auto Capture Keyboard"

I mean, what sorcery is this?!?
