---
title: Argo Roadmap
tags: [roadmap, architecture]
keywords: plugin, components, deployment, installation
last_updated: January 15, 2015
summary: "It's the map of the road, dummy"
---

## v1.0.x - In planning

* Create yum and apt-get/gem installers
* Include encryption for probe and response wireline payloads
* Handle 2-way SSL for probe responses to client
* Allow for gzip compression for wireline payloads
* Include a number of extra Responder plug-ins
 * Include CA Layer7 API management plug-in
 * Include SSDP Responder plug-in
 * Include a sample/basic plug-in that checks and reports the health of the services associated with the service records.
* Include more sophisticate network service browser for DevOps and NetOps support
* Re-architect to allow "protocol handlers" which will be per version.  This will allow multiple versions of the protocol to be wandering the network and still handled by Responders who have that protocol version "plug-in" installed in their responder/client.

## v0.3.x - Due around June 1, 2015.

* Handle non-flat and NATed networks.
* Allow for probes to declare multiple `respondTo` addresses
* Allow for probes to look for multiple service instance IDs as well as service contract IDs.
* The probe has an attribute to allow the client to provide and identifier
* Encode the XML wireline protocol in an XSD (greater resiliency).
* Encode the Responder ConfigFile plug-in XML configuration file in an XSD  (greater resiliency).
* Include generic UDDI Responder plug-in


## 0.2.x - [Released](https://github.com/di2e/Argo/releases/tag/v0.2.3-CR2)

* initial protocol release
* Handles one-way SSL
* Includes configFile Responder plug-in
* Includes DNS-SD (aka mDNS, Bonjour, Android NSD) Responder plug-in
* Includes Multicast Gateway for bridging networks
* Includes basic browser client
