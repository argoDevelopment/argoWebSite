---
title: Argo Responder no_browser mode
tags: [architecure, components ]
keywords: responder, components, probe, browser, SA
last_updated: January 15, 2015
summary: "Overview of the protocol, architecture and components of Argo"
---


As of Argo 0.3.0 it's possible to run the Argo Responders in "no browser" mode.  This means that such Responders will not respond to probes that ask for ***all*** services.  Such probes have no service contract or service IDs in them (otherwise known as a naked probe).

Usually, responders will just return whatever they've got to a naked probe.  This could be a secuity concern.

In order to deal with this potential problem, the Argo Responders can be lanched in "no browser" mode.

To to this, the command line to launch the Responders should have the 

XXXXXX

switch set.