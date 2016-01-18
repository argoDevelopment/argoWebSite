---
title: Controlling the "distance" a probe can travel
tags: [roadmap, security, architecture]
keywords: plugin, components, deployment, installation, security
last_updated: January 15, 2015
summary: "Security, security ... got to go, got to go."
---

With network traffic, the "distance" a piece of data can travel is measured in how many "hops" it takes.  A ["hop"](http://en.wikipedia.org/wiki/Hop_%28networking%29) happens when that data packet traverses a router to another network.  When a data packet starts it's live, it's given a TTL (time to live) number.  The TTL represents the maximum number of network hops that packets is allowed to make in it's travels.  When a router encounters a packet with a TTL of zero, it just drops the packet and let's it die right there - it goes no further.

When sending multicast packets, you need to be cognizant of how the network will handle the traffic you just placed on it.  With Argo, you really want control how far - in "hops" - a probe will travel.  Sometimes you may want it to traverse the entire known network (assuming the network allows multicast to wander freely) and sometimes you only want it to wander your local networks.

Understanding this and effective usage of the Argo Probe TTL can dramatically increase the protocols efficiency and increase the chances of success when attempting to discover services in large, diverse and dynamic interconnected network.

## Argo Probes can set the TTL

When creating and sending an Argo Probe, you can set the TTL.  This effectively limits the range of that probe to the number

```java

ProbeGenerator gen = new ProbeGenerator("230.0.0.1", 4003);
Probe probe = new Probe(Probe.JSON);

probe.addRespondToURL("internal", "http://1.1.1.1:8080/AsynchListener/api/responseHandler/probeResponse");		
probe.addServiceContractID("uuid:03d55093-a954-4667-b682-8116c417925d");

// This sets the hop limit to only 3.  This should keep it close (in network distance)
probe.setHopLimit(3);  

gen.sendProbe(probe);
```
In the above example, a probe is created to find all the services of type `uuid:03d55093-a954-4667-b682-8116c417925d` that are within 3 network hops from the host that sends this probe.  From a geographic distance sense, this could be a big distance, but from a network sense, it's likely within your organization's administrative control.

## What happens if I always send to the maximum hop limit (255)?

Well, you certainly can.  But you'll likely get some attention from network monitors.  If you are constantly sending out probes across the universe, you might do two things: 1) get unwanted attention from security people and 2) if too many people do this, then it will eventually limit operational bandwidth on the network.

Which means - don't.  Understand what you are looking for.  If you want to locate services that you think are "close" to you, start with probes with a hop limit of 2 or 3.  If you really need to look far and wide, set the hop limit higher.  Setting it to 255 is a bit of a nuclear option, but that _should_ guarantee that it traverses the network to the maximum distance.  But if you do that, don't do it often and only if you really need to.
