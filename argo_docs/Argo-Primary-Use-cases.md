---
title: Primary Use-Cases
tags:
    - plugin
keywords: plugins
last_updated: November 30, 2015
summary: "There are a few primary use-cases for Argo.  This article describes them in a fairly high level of detail."
---

There are a number of basic use-cases or requirements that Argo was developed to satisfy.  All of these use-cases deal with the realization of Service-Oriented Architecture in a practical sense.  Further, Argo is considered a primary component in cyber-security as well as a major player in military and intelligence networks that can - and will - be attacked in any future Cyber-war conflict.

## Distribute Remote Client Configuration Information

As with any service discovery protocol, the primary function is to easily and quickly distribute configuration information to remote client software.  The basic information that is transmitted will include the IP Address (or addresses), the Port number and perhaps the URL (for a web service) or other service-contract-specific information such as textual information used to further configure RDBMS or MOM connections.

The client software will use this information to configure the remote service connection software.  This should be done automatically by the software.  However, the protocol does not require software to be programmed with Argo client code and Argo browsers will be available so that a human can perform the discovery and then manually configure the client software.

## Long-range Discovery

Argo is a little different than many other discovery protocols in that it is intended to operate over a wide-area network.  The prerequisite for this wide-area network is that it allow the transmission of UDP multicast freely across the network for the Argo protocol (which only needs traffic on 1 specific multicast group).  Further, this multicast traffic can be arbitrarily limited to protect operational bandwidth.  Argo does not have particular bandwidth requirements - therefore it's considered to be inherently unreliable and slow.

Providing a long-range protocol is important in the context of military operations and intelligence scenarios.  Warfighters using relatively local systems need to share intelligence and operational data with others that have their computers on totally separate networks.  However, they need to share remote system configuration information between them.  For example, one military unit needs to share ground tracking information with others who will be using their local "Command & Control" software to visualize the tracks.  The consumer unit will need the network address of the track server of the other unit.  This will happen in ad hoc mobile networks (MANETS) and that configuration needs to happen in a very short period of time, perhaps seconds.  If the phrase "call the system administrator" comes up in a kinetic battle, things have gone horribly wrong.

There are many other protocols that do service discovery.  These include mDNS, SSDP, SLP, WS-Discovery, etc.  However, all of these protocols are designed to operate _only_ on a link-local network.  Enabling them to operate over a long-range (multiple router hops) is difficult or practically impossible to do for a number of reasons (one is to use a gateway that performs NAT with port-forwarding, making services on one network operate on non-standard ports on another network - this violates fundamental network security policies).

## No Reliance on Intermediate or Tertiary Services -  the _"2 Node Requirement"_

Argo is designed to work when there are no other services available on the network - such as DNS.  Argo should work regardless of any other network service operating on the network.  Its only prerequisite is that multicast traffic can reach across the network and that nodes are unicast routable.  Other then that, even if there were only 2 computers left operating on a network, with Argo, they should be able to discovery each other.

## Rapid System Setup

Argo is specifically designed with the intent to allow the rapid configuration of systems when remote systems move or new systems become averrable on line.  When setting up a collection of systems that need to interoperate with each other over the network, manual configuration is a notoriously time-consuming and frustrating process.  With Argo, whether the systems are programmed to use Argo or not, the amount of time to successfully configure complex network connections can be dramatically reduced.

## Moving Target Cyber-Defense

A significant and non-trivial use-case that Argo can be used for is the Moving Target Defense for adaptive cyber security.  I could make an argument that this actually be its main use-case.  A Moving Target Defense is one where legitimate systems and services on a network will periodically or on-demand (such as when responding to an attack) change their location on the network - e.g. change their IP address and/or Port.  This is an excellent technique for rendering network-borne attacks impotent, but it also disconnects any legitimate clients.  Argo is designed to allow client to easily and efficiently discover the new IP address (and any other connections information) they might need to reconnect.  This is a rich and active area of research in the cyber-security realm.

## Orthogonal Security

Most services discovery protocols do not provide any type of security (with the possible exception of WS-Discovery).  Argo was mindful of the fact that a certain amount of inherent security was necessary to protect not only the protocol itself, but because of the fact that it transmits IP address information of perhaps critical networked systems, also protect the service provider systems that it serves.

## Adapt other discovery protocols

As there are many different discovery protocols operating in the wild (dozens, actually), a secondary goal of Argo was to provide a way to adapt some of these other protocols, such as mDNS (aka Bonjour, Android NSD) through Argo, if possible.  This is done through a plug-in architecture for the Argo Responder.  New Responder plug-ins can easily be created and included into the Argo ecosystem to adapt other special service registry implementations for long-range discovery (such as UDDI or OSGi).