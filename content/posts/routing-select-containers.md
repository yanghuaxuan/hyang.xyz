---
title: "Routing Select Docker Containers Traffic Through WireGuard"
date: 2023-09-25T23:01:23-07:00
description: "Routing Select Docker Containers Traffic Through WireGuard"
draft: false
ShowToc: true
---

**TODO: Finish this article**

# Preface
This site, *hyang.xyz* is hosted using a small, cheap VPS which reverse proxies back to my home computer. WireGuard is used to securely communicate with each other. The VPS runs the WireGuard "server", which allows me to connect to the VPS without ever having to port forward. For various reasons, I also need certain container's outbound traffic routed to WireGuard. Originally, I just routed all traffic to the VPS. This mostly worked fine. However, for whatever reason this prevented me from SSH'ing into my computer using my network connection. 

My method will essentially create a WireGuard interface on the host, and do the routing with Iptables and routing policies. 

# Create user defined Docker Bridge
First, we'll make a user defined bridge for Docker. You can learn more about it [here](https://docs.docker.com/network/network-tutorial-standalone/#use-user-defined-bridge-networks).
```
# docker network create --subnet 172.22.0.0/24 wg
```
This bridge will be what the container will use to connect to the Internet, and we will use to forward container traffic to WG.

# Create WireGuard interface
**Do not use wg-quick for this!**. 

Wg-quick automatically sets routes in the main routing table depending on the *AllowedIP* field. For instance, if you set *AllowedIP* to 0.0.0.0/0, wg-quick will automatically setup a route which will route all outgoing traffic on the computer to the WG interface for you. Use something similar to the [WireGuard's quick start guide](https://www.wireguard.com/quickstart/), which I'll demonstrate below.

1. Create the interface
    ```
    # ip link add dev docker_wg0 type wireguard
    ```
2. Assign address
    ```
    # ip address add dev docker_wg0 10.0.0.2/24
    ```
3. Set WireGuard configuration (Assuming your WG configuration is at /etc/wireguard/wg0.conf)
    ```
    # wg setconf docker_wg0 /etc/wireguard/wg0.conf
    ```
4. Finally, activate the interface
    ```
    # ip link set up dev docker_wg0
    ```

# Routing the traffic
This is where we will actually route the traffic to WireGuard! 

Before we start, you'll also want to do this:
```
# ip route add 10.0.0.0/24 dev docker_wg0
```
This tells Linux to route everything in our VPN subnet 10.0.0.0/24 to the WireGuard interface. This is sort of what `wg-quick` does, assuming that the AllowedIP field is 10.0.0.0/24.

First, we need to find the name of the docker bridge we made [here](#create-user-defined-docker-bridge)

## Get our Docker bridge's name
To get the name of the bridge:
```
$ ip route show
```
This will list a bunch of routes configured on your computer, like this:
```
default via 192.168.1.254 dev eno1 proto dhcp src 192.168.1.90 metric 100
10.0.0.0/24 dev docker_wg0 proto kernel scope link src 10.0.0.2
172.22.0.0/24 dev br-b5a8e9e3afe4 proto kernel scope link src 172.22.0.1
...
```
The bridge we defined [here](#create-user-defined-docker-bridge) will have the same subnet as shown in this routing table. In this case, the name is **br-b5a8e9e3afe4**.
## Messing with Iptables
```
# iptables -A FORWARD -i docker_wg0 -j ACCEPT
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# iptables -t nat -A POSTROUTING -o docker_wg0 -j MASQUERADE
# iptables -t mangle -A PREROUTING -i br-b5a8e9e3afe4 -j MARK --set-mark 5102
```
We first let Iptables know to allow packets that are forwarded to docker_wg0. Next, we'll masquerade packets that are going to our router (interface name may be different). Then we'll also masquerade packets that are going to the docker_wg0 interface. Finally, we'll mark any packets coming from *br-b5a8e9e3afe4* with an arbitrary integer, such as 5102.

## Messing with Policy Rules

# Further Reading
- https://www.linuxserver.io/blog/routing-docker-host-and-container-traffic-through-wireguard

