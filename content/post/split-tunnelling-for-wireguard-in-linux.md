---
title: "Split Tunnelling for Wireguard in Linux"
date: 2023-09-08T17:18:39-07:00
draft: false
---

# How to split tunnel in Wireguard, running Linux

If you're under a VPN with WireGuard on Linux, as of writing this, there seems to be a surprising lack of documentation for selectively split tunneling certain applications. Fortunately, with Linux [network namespaces](https://en.wikipedia.org/wiki/Cgroups), we are able to do just that.

## TL;DR
[Use my script :)](https://github.com/yanghuaxuan/stun)

## How
Assuming that your WireGuard configuration is up and running, using something akin to what `wg-quick` does, it'll do the following to route all traffic to a WireGuard interface.
```
# wg set wg0 fwmark 1234
# ip route add default dev wg0 table 2468
# ip rule add not fwmark 1234 table 2468
# ip rule add table main suppress_prefixlength 0
```
Take note of the third command. The third command is a rule policy which routes all packets not marked with `fwmark` 1234. This means all packets, except for the packets used for communicating with the WireGuard endpoint, will be routed using WireGuard's routing tables.

Therefore, to split tunnel, all we have to do is create a separate Linux namespace, which allows us to make a new routing table isolated from the main namespace.

## Turn on IP forwarding
Before we get started, it is crucial that you have ipv4 forwarding set to 1
```
sysctl -w net.ipv4.conf.all.forwarding=1
```

## Setup Linux namespace
To add a new network namespace, using ip(8), where the name of the namespace will be called *split*
```
ip netns add split
```

Next, we're going to assign the loop back interface, set up a virtual Ethernet pair for communicating between the main and *split* namespace, and set the namespace routing table.
```
ip netns exec split ip link set lo up
ip link add veth0 type veth peer name veth1
ip addr add 10.1.1.1/24" dev veth0
ip link set veth0 up

ip link set veth1 netns split
ip netns exec split ip addr add 10.1.1.2/24" dev veth1
ip netns exec split ip link set veth1 up
ip -n split route add default dev veth1 via 10.1.1.1"
```

Now, back to the main namespace; we route all traffic coming from 10.1.1.2 (the IP assigned to the veth interface inside the namespace) using the main table the computer booted up with.
```
ip rule add from 10.1.1.2 table main priority 99
```

## Firewall setup
Finally, we will now access the Worldwide Series of Tubes on the split tunnel namespace. Using IPTables, we can forward packets coming from veth0 (remember, packets sent from one end of the pair will flow to the other end).
```
iptables -t nat -A POSTROUTING -s 10.1.1.1/24" -o $IF -j MASQUERADE
iptables -A FORWARD -i $IF -o veth0 -j ACCEPT
iptables -A FORWARD -o $IF -i veth0 -j ACCEPT
```
## DNS
You may need to manually configure the DNS server. We will use Cloudflare's 1.1.1.1 to resolve DNS queries inside the network namespace.
```
mkdir -p /etc/netns/split
echo "nameserver 1.1.1.1" > /etc/netns/split/resolv.conf
```

## Conclusion
That's it! Now to test it
```
ip netns exec split curl ifconfig.me
```
Your residential IP should now show up instead of your VPN's IP.

# Credits
- https://www.procustodibus.com/blog/2023/04/wireguard-netns-for-specific-apps/
- https://www.wireguard.com/netns/#the-new-namespace-solution
