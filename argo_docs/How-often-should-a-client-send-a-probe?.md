---
title: How often should a client send a probe?
tags: [roadmap, security, architecture]
keywords: plugin, components, deployment, installation, security
last_updated: January 15, 2015
summary: "Probes take network resources.  Send wisely."
---


How often should a client send a probe?. Good question.  The answer is: _not that often_.

In a nutshell, Argo is used to get service configuration information when a client would normally configure in a new remote service.  How often does that happen?

There are some clients that want to constantly "search" the network for new services.  Like an application looking for new "sensors" that pop up on the net - when a new "sensor" is discovered, the applciation can then connect to it, collect its data and then exploit that data.

However, most applications don't scan the network for new services to integrate with.  The times that application do a discovery operation are:

*  when an application starts up for the first time
*  when the operator/application wants to discover and integrate more services
*  when the network changes

Pretty much that's it.  Remember that Argo is meant for long-haul discovery and not short-range or local-network discovery.  If you want that kind of discovery, you can use Argo, but you might be better off with something like mDNS.

## Initial system set-up

This important thing to remember about service integration on application or system startup is that the services in question ___are remote and owned by someone else___.  If the application owns all of the services and they are local, just use a configuraiton file and call it a day.  You don't need something like Argo.

So, an application starts up and wants to find a set of remote services to integrate with.  For example, it needs to connect to a set of databases, some remote search service, a map server and a couple of other services.  If the appliation own all of th

## Operator/Application driven integration


## The Network Changes

Why would the network change?  For a lot of reasons.  And if the network changes, 