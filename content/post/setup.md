---
title: "My Setup"
date: 2023-08-27T18:09:49-07:00
description: Hello again
draft: false
---


# Hello Once Again
Welcome to my ~~third~~, first iteration of hyang.xyz. Now that my hosting stuff is stable again, I hope that I can finally stop messing around with Linux and start doing things that I can look back on years later. And what better way to do that than start writing blog posting? 

(I also need an excuse to get better at writing…)

# The Setup
My adventures with hosting things on the online has been quite a wild ride for me. Until now, it has mostly been more of a learning experience thing. I had mostly focused on hosting stuff like SearX, Nitter, and Fediverse instances, with it lasting two weeks at most, before I got bored and just nuke it all. I also distro-hopped a lot, from Debian → Arch → OpenBSD → FreeBSD → NixOS. 

Now that I have gotten old, now I just want things to just work! 

So, I've decided to start over again. This time, I had to devise a set of goals that made operating this mess as “comfy” as possible. I settled on the following:
- Sane, easy to use backups
- No Cloudflare, (various reasons: mostly just want to host other stuff like email)
- Affordable (am broke)
- Make deploying stuff repetitive, and easy to maintain

Here's my setup:

![My setup as a diagram](/images/diagram.svg)  

In essence:
- Small BuyVM VPS for connecting to the big Internet without revealing my residential address.
    - Also runs my email server. 
- Docker for running/managing services
- Loads of storage:
    - 1TB NVME for running NixOS
    - 3x 4 TB Hard Drives on ZFS RAID1 (mirror)
- 1x 4 TB Hard Drives (Backups)
    - Using rsnapshot 
    - Backups for both my NVME and HDD. 
        - (Might be a problem in the future… Might move it to my 3x 4 TB drives)

My small VPS contains a WireGuard server, which allows my home PC to securely communicate with my VPS. Along with that, it also contains Certbot for managing HTTPS certificates, and Nginx for reverse proxying. It also contains my Email server too.

Originally, everything was managed via Nginx. However, logging into my VPS and reconfiguring Nginx every time I wanted to deploy something new was just cumbersome. I decided to try out Traefik, which works alongside Docker to handle most of the routing configurations. Thus, my Nginx now simply reverse proxies everything on port 80 and 443… to another reverse proxy!