---
title: Why Argo and not some other SLP?
tags: [FAQ]
keywords: FAQ
last_updated: November 30, 2015
summary: "There are lots other Service Location Protocol - why Argo?"
---

## _To boldly go where hundreds have gone before!_

The motto of Argo is: _"to boldly go where hundreds have gone before!"_

The idea of a Service Location Protocol (SLP) is not new.  Argo isn't inventing some new kind of internet awesomeness that hasn't been seen before.  However, Argo is providing a new SLP that is trying to solve a couple of issues other protocols don't.  Argo wasn't build just for grins as creating a new protocol in a saturated area, let alone an open source project, is a massive amount of work - it should be worth it.

The first thing to understand is that Argo is _not a central service registry_.  Software like jUDDI, IBM's Web Service Registry/Repository (WSRR - pronounced "wizzer"), ebXML, etc., are not in the same class.  So if you were expecting a comparison to central repositories, you won't find it here.  To see why Argo avoids the central repository, click here for comprehensive explanation of the problem Argo is trying to solve.

Fundamentally, Argo, like the rest of the protocols discussed here, is based in IP Multicast.  Specifically, multicast is used to send a query out on the network to ask for a set of matching services (i.e. client configuration information).  For the bulk of the existing SLPs, the similarity with Argo ends there.

For Argo, it's architecture and implementation is geared toward the following things (and by implication, other SLPs don't do these things):

_You can click on the links to dive into the detail_

* **Open Source** - "None of us is a smart as all of us."  Plus free helps adoption ... just sayin'.
* **Long-range** (wide-area network routable) - Avoid protocol-specific gateways if at all possible.
* **Staged adoption** - Don't ask apps to write code right away.
* **Flexible topological location of the Responder** for service advertisement
* **Flexible topological location of the Response Listener** for SLP clients
* **Network efficient** - Argo is unreliable and slow ... and that's a good thing ... especially for a long-range protocol.
* **Service Query payloads as simple as possible** - Provide the ability to query for any application protocols
* **Service Description payloads as simple as possible** - Provide wide adoption potential for the universe of application protocols
* **Expandable** - Just because Argo is awesome out-of-the-box, your version of discovery awesomeness should be able to be plugged in right away.
* and ... **Security** - It's hard to understate this one - Argo was built for Cyber-war.

## Comparable Service Discovery/Location Protocols 

There are a number of "standard" Service Location Protocols.  These include:

* **mDNS and DNS-SD** (aka Apple Bonjour, AirPrint and Android Network Service Discovery (NSD))
* **WS-Discovery** - a WS-* standard that uses SOAP over UDP.  Not as common as mDNS, but a very good protocol. 
* **SSLP** - Simple Service Discovery Protocol.  This is very common on local networks and is the basis for Universal Plug-n-Play (UPnP).
* **AllJoyn** - a consortium-driven "Internet of Things" protocol for local devices.

There are actually many, many more "discovery" protocols.  Some are more complex, some use a registry and some are more application-specific rather than general purpose.  

The most important thing about Argo's architecture is the fact that it uses a multicast request - unicast response protocol paradigm.  This is critical for the goals of Argo and partially what makes it possible to operate over wide-area networks.  Central registries utilize a unicast request - unicast response paradigm.  Of the other SLPs listed above, mDNS, SSLP and AllJoyn (and others) utilize the multicast request - multicast response paradigm.  WS-Discovery utilizes the multicast request - unicast response protocol paradigm similarly to Argo.

## Responders

These comparable protocols, like Argo, are all multicast based protocols.  All of these protocols have a "responder" in their architecture.  Argo is no exception.  The Responder is the program that listens for the actual multicast packet and then do something with it.  For example SSDP on Windows has a process called "SSDPSRV" and all iOS and MacOS devices have a process called "discoveryd" (before Yosemite it used to be called mDNSResponder - kind of obvious).  WS-Discovery introduces the concept of a Discovery Proxy (DP) or Agent which operates as a Responder (but the DP has more baggage than just responding to multicast packets).

Each Responder is a "registry" of sorts.  This is a good thing, actually.  It makes for an extremely resilient and agile service discovery ecosystem that can show the clarity of the statement "_the network itself is the registry_."  What this means is that a service discovery ecosystem is an extremely distributed "registry", where each host has its little registry that keeps track of its local services.  However, with mDNS (Bonjour, Android NSD, AirPrint, etc.), SSPD, AllJoyn, etc., your application has to write some code to "register" its discovery record to the local registry.  To be fair, it is possible to configure the mDNS responder via command line using the [dns-sd](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/dns-sd.1.html) command line.  However, using it is not for the faint-of-heart and really requires some non-trivial DNS knowledge.

Once a responder gets a multicast request - which is a discovery query message - it needs to do something with it.  In the case of mDNS, the query message is a just a DNS query, as DNS-SD just hijacked the DNS protocol (which made sense 20 years ago).  The other protocols have their own wire formats.  All of the other service discovery protocols _not_ listed, almost without exception, have specific application requirements built into the protocol which dramatically reduces its general purpose applicability.  However, each of the existing protocol responders have very specific and limited actions it can take.

For example, the mDNS protocol responders are a DNS service, much like BIND, and keep tables of DNS records.  mDNS and DNS-SD simply hijacked the DNS protocol for the purpose of service discovery, which works well for local services, but does not operate in a long-distance mode (e.g. outside the local network).  Further, the WS-Discovery protocol do not easily allow implementers/adopters to do anything other then what the protocol provides.  Making changes would, in fact, make you divergent from the protocol.  So, if you want to change anything, you'd might as well try to make your own standard (rather then trying to get involved cold into changing an existing standard).

The Argo "out-of-the-box" Responder has a plug-in design that allows implementers to decide the best way to integrate into their environment.  It also does not specify exactly where a Responder needs to be installed (although one on each host is a really good idea for a number of reasons).  By default, there is a XML configuration file (a file based "registry", if you will) that is really easy to edit by a novice operator.  However, this is just the beginning.  Using the plug-in architecture, you can use the Argo Responder to proxy pretty much any technology you want. For example, you can build an Argo Responder plug-in to adapt mDNS, UDDI, Netflix Eureka, ebXML and/or the OSGi Registry.  There is much more on how Argo Responder plug-ins can be built here.  All that being said, you can just build your own Responder against the simple Argo protocol and do whatever you want.  This is really hard to do with other protocols.

Argo, out of the box, comes with plug-ins for
* Configuration file
* mDNS - Argo clients can probably be for any AirPrint, Google cast, Apple TV or hundreds of other DNS-SD services without knowing anything about multicast DNS. 
* UDDI - drop in an Argo responder in front of your juddi or WSRR registry and you now have made it part of a multicast discovery ecosystem. 

## Listeners

Argo departs dramatically from other protocols with regards to how it looks at discovery responses.  Argo realized that the topological location of discovery response listeners needs to be very flexible to accommodate the varied application architecture, deployment and security concerns that will arise in mission-critical applications that can benefit from decentralized service discovery.

mDNS and Android NSD combines the responder and the listener.  Meaning, the mDNS responders also act as listeners to the discovery responses.  This architectural/design decision is reasonable because of the multicast request - multicast response paradigm.  A responder, when it found that it could provide and answer to the multicast request, would then fire the discovery response right back over the same multicast channel for requests.  There are a number of architectural reasons for this, but the main reason is that it was assumed that all of the responders on the local network would probably be interested in the answer to the discovery query because they would likely be asking the same question soon enough.  The answer was sent out to all other responders so they could cache the response to cut down on network traffic as their local responders (which actually send out the network request) could respond with a cached answer.  If you want more depth to this answer, I would suggest reading the [mDNS](http://tools.ietf.org/html/rfc6762#page-52) and [DNS-SD](http://dns-sd.org/) specifications.  To reduce network traffic and comply with some network security concerns, Argo assumes that a reply goes back to only the response address specified by the requestor.

So what happens if every client in the WAN decided to discovery your service? Wouldn't that require your responder to reply to every requestor? Yes, it would.  However, that scenario is very unlikely for a number of reasons.  The idea is that a particular discovery request is really not the business of the rest of the network.  This scheme dramatically keeps discovery responses secure. 

The Argo protocol allows discovery clients to query for more than one service type at a time.  The other protocols, specifically mDNS, only allows one service type per request.  Meaning that if there is a client want to find service configuration information for a number of service types at once (e.g. at client start-up or movement to a new segment of a mesh network), Argo can send one request for several services at once and get back a single response from a responder that will include all of the requested service configurations in a single network payload.  This scheme is just as network efficient, given the need for request-response propriety. 

## Custom Argo Implementations

The Argo protocol should be relatively easily implemented if you feel like you need to cook up a custom implementation of Argo components.  People have, in fact, done this.  The average time it takes to get a custom implementation of the Argo protocol, pretty much from scratch, is a long weekend for a programmer with average skills.  However, if what you are looking for is a custom Responder, I would recommend just building a plug-in rather then building a new one from scratch.  But, hey ... it's your call.


