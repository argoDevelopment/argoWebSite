---
title: Multicast Plan
tags: [roadmap, security, architecture]
keywords: plugin, components, deployment, installation, security
last_updated: January 15, 2015
summary: "When multicasting, you'll have to have a comprehensive plan for that in your network"
---

# Multicast Plan

The Argo protocol requires that UDP multicast packets traverse the network.  All of the other major multicast-based discovery mechanisms limit their multicast packets, but specification, to the local network.  This is incredibly limiting for discovery across networks.  To really get the bang out of Argo, the network should be configured, the greatest extent possible, to allow multicast traffic for the Argo protocol to move from one network to another.  This should be true especially for Mobile Adhoc Networks (MANETs).

## Allowing for traffic

The multicast plan is something that the network and system administrators need to worry about.  So, as an application developer, if you really need something like Argo (or even some other multicast-based SLP - and there's a lot of them) then you'll need UDP multicast packets to wander.  Your network admin should know how to do this.  If they say there is a policy to not allow multicast, it means that they worry about clients abusing the network with real-time video feeds or other such abuse.  This is not what Argo needs.  Argo uses very little bandwidth and if there is some bad-actor client using too much bandwidth, you can hunt it down and stop it.  Further, the network admins should limit the amount of available bandwidth for Argo to something like 10% of total bandwidth - so it will never crowd out other applications.

### Firewall changes

There are a few firewall changes that need to occur in order to use Argo.  They are no more exciting than the changes required to host a HTTP server or application server.  For a particular host, these changes are [listed here](https://github.com/di2e/Argo/wiki/Argo-Firewall-Changes).

However, there does need to be some changes to ASA firewalls and perhaps on routers.  These are simple changes and should be part of a consistent Argo multicast plan.

### Limiting Argo Protocol Bandwidth

It's recommended that you limit the about of bandwidth the Argo protocol is allowed over a particular router.  This Quality of Service (QoS) setting can easily be done.  Argo is a slow and unreliable protocol and should a particular packet fail to reach it's destination, a client will likely send another one.  So, don't worry too much about dropping UDP packets if the network channel gets overloaded with Argo protocol packets.


***

## Using the VPN Multicast Gateway as part of the Multicast Plan

Sometimes, there are parts of the network that you're just not going to get multicast traffic to traverse.  This could be for a number of reasons - usually, because your organization does not have administrative control over that domain (like parts of the open internet), you can't convince the network administrators to get around to it (there are ways to fix that) or, the most likely (and my experience), you can't get the network admins to correctly configure the network to traverse the Argo protocol multicast packets.

In these circumstances, you may need to use a bridge to get multicast to traverse across the section of network.  This is where the VPN Multicast Gateway comes in.

It's not hard to use and instructions can be found [here](https://github.com/di2e/Argo/wiki/VPN-Multicast-Gateway).

However, you really don't want this if you can help it.