---
title: Creative uses of Argo Plug-ins
tags: [plugin]
keywords: plugins
last_updated: November 30, 2015
summary: "Write the code necessary to get your application ready to operate with Argo."
---

# Creative uses of Argo Plug-ins

## Using with other Service Discovery services

### Link-Local Multicast Service Discovery

*Examples:* `mDNS, SSDP, WS-Discovery, etc.`

With a Responder plug-in, an Argo responder can adapt other Link-Local Multicast Service Discovery protocols.  Out-of-the-box, Argo comes with an adapter for mDNS.  This mean that an Argo Responder can reply back with services based on the DNS-SD protocol.  This would allow service like Apple TV, Chromecast, AirPrint, afp and smb (network file servers) to be exposed via Argo. 

The mDNS plug-in will map all the relevant fields from the DNS records into the Argo response payload so there is no fidelity drop. 

_Why is that interesting?_

Primarily, this is interesting because you are adapting a short-range protocol with a long-range protocol.  This has some interesting implications.  First, it means that systems that are already built with Argo don't need to retrofit themselves with mDNS to find mDNS services.  Secondly, it means that it's possible to use services that are only meant for local consumption (local network only) over the WAN.

_How do you map link-local services over the WAN?_

This can be done by creating a mDNS plug-in that has a couple of special features.  These are not hard to do, but you have to know what you are doing.  Using the out-of-the-box plug-in as a guide, you can report back to WAN clients the WAN accessible/routable IP/port of a link-local service.  This is done by automatically performing a port-mapping of a local service through a gateway router using Port Control Protocol [1][PCP].

[PCP]: https://tools.ietf.org/html/rfc6887

You'll get non-standard ports for service, but at least you'll be able to use them over the WAN.

### Registry based discovery

*Examples:* `UDDI, OSGi, etc.`

Sometimes there exists a central (or federated) registry that houses a collection of service infomration.  Such registries include UDDI and OSGi (and there are a number of others both common and esoteric).

It's possible and actually rather easy to create a plug-ing for an Argo Responder to adapt a registry to use the Argo protocol for long-range discovery - and also not require Argo clients to know the IP address/URL of the UDDI (or other) registry.  This can be very handy.

Argo comes with a sample UDDI plug-in that can be used out-of-the-box for simple applications but can be adapted for use with more complex circumstances.

### Cluster Management

*Examples:* `Zookeeper, Curator, Eureka etc.`

There are a number of other `service discovery` systems that are actually used as cluster management technology.  Some major examples include Zookeeper, which is the cluster management service for Hadoop instances and Netflix Eureka, which is the cluster management technology used by Netflix to manage processing assets in Amazon Web Service (AWS) Elastic Compute Cloud (EC2).


## Integrate Health Checking

There are some use-cases where you do not want to advertise a service that is down or otherwise compromised.  Therefore, when a service discovery probe comes into a Responder, the Responder should check to see if the service is up before responding with the service.

Argo does not do this out-of-the-box.  Largely, it doesn't because it has not idea how to.  Health-checking a particular service is very specific to the service in question.

It's recommended that you build a plug-in or modify and exisiting one that will so any health-checking for the services that the plug-in services.

Because this is an open-source project, we recommend that you generalize your plug-in as much as possible and share it with the Argo community.  I would expect that Argo will come out with samples of how to do this in future releases.