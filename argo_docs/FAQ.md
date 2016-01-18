---
title: Frequently Asked Questions
tags: [FAQ]
keywords: FAQ
last_updated: November 30, 2015
summary: "You ask 'em.  We answer 'em"
---

# Frequently Asked Questions




### _Really, what is the primary use-case - when can I use Argo?_

* If you ever need a priori information about where a network resources is (like a service or a web site), then you can use Argo.
* If you ever have to type in an IP address to make your application work, then you can use Argo.
* If you ever have to pause and "call the sys admin" to help you configure your network configuration of your system, then you can use Argo.

As a result, Argo is very complementary to a large number of other technologies.  There are many technologies that want to be configured to connect to a network-reachable service.

### _How is Argo different than a DNS lookup?_

Argo is fundamentally different than DNS.

DNS does not do "look up" - it does "name translation."  You give DNS a name and it gives you an IP address back.  (_For more info on how DNS actually works, [click here](http://dyn.com/blog/dns-why-its-important-how-it-works/)_)  However,  With DNS you administratively have to know a couple of things for DNS to work at all.  First, in order to do a DNS lookup, you have to know the IP Address of your DNS servers.  Usually, you don't have to worry about that because your host gets that information through [DHCP](http://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol), however, your administrators need to know that IP address and provide it to your DHCP server.  

Argo does and actual, look up.  The protocol actually "looks across" your network to find what you are looking for.  It does not depend on anything other than the network itself. (see [here](https://github.com/di2e/Argo/wiki/Argo-Primary-Use-cases#no-reliance-on-intermediate-or-tertiary-services----the-2-node-requirement))  

For example, let's say you have a central, enterprise service that needs to know the network location for a large number of network clients/agents.  These network client provide the  enterprise service with critical data (e.g. log scanning (Splunk), service cataloging (UDDI), API management (Apigee, WSO2 and Layer 7), or perhaps mission-critical control systems (SCADA, etc).  In order for this to work, you either have to tell the central service _all_ the IP addresses (or DNS names - really the same thing) of the network devices _manually_ or you have to tell the network clients/agents the IP address of the central enterprise service.  All of this has to be done manually and if any of the IP addresses (or DNS names) change, then all of the configuration had to be done _again_, manually.  With Argo all of this configuration can be done automatically, securely and instantly.

### _But I can do all this with a central registration server?_

Yes you can.  And that works great.  Right up until the central registration server goes away (perhaps through cyber attack).  This is how much of the "Internet of things" works now and is certainly how many of the "magical" mobile apps work to share data.  All of this is great, right up until the central services and/or the networks themselves are compromised.  

### _Can I use Argo with other Service Discovery/Location protocols?_

Yes you can.

### _There are other service discovery protocols.  Why make another one?_

Good question.  This is fully explored in the wiki page: ["Why not some other SLP?"](./Why-Argo-and-not-some-other-SLP.html).  However, in a nutshell, the wireline protocol needed to be far more compact than existing protocols (consistently under 600 bytes for a probe), we need to handle really odd network description challenges (like strange NAT-based networks) and we need to have to expansive control over security, which is utterly lacking in other protocols.