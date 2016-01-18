---
title: Argo Security
tags: [roadmap, security, architecture]
keywords: plugin, components, deployment, installation, security
last_updated: January 15, 2015
summary: "Security, security ... got to go, got to go."
---

The Argo protocol and implementation can have security applied to it in a number of ways. 

_Why do you need to secure Argo protocol traffic on the network?_

Argo carries network location and configuration information between computers.  It does this for a number of reasons.  Sometime, this network conveyance of this information is in potentially or definitely hostile networks.  There are many parts of the Argo protocol that may be considered sensitive such as the IP Address/Ports or URLs of the services (why give hackers clear access to all the important network topology information).  Argo Probes carry the URL of the probing application's "respondTo" address which, if exposed to through a packet sniffer, could now be a target of a DDoS attack.  Also, the actual Service Contract IDs and/or Service IDs themselves may be sensitive and transmitting them in the clear is not desirable.  

Argo was built with scenarios like Cyberwar in mind.  Many of the operational scenarios require that Argo can be used in such as military, intelligence, finance, energy and transportation are targets for cyberwar attacks.  

_Does the entire Argo ecosystem need to be encrypted the same way?_

No.  Any particular network (or networks) that allow Argo traffic nor individual applications that use the Argo discovery protocol need to be configured the same with respect to security.  The amount and type of security that you need for your operational use-case dictates the kind of security configuration you will apply to Argo. 

For example, some applications might use no security at all.  Probing in the clear and unencrypted responses back to probing clients.  And some applications might require that the protocol be locked down to ridiculous levels.  Probes are payload-encrypted, responses are payload-encrypted and use 2-way SSL to protect the network connection itself and verify identities of the senders and the receivers of the traffic.  In the later case, network packet sniffers and port scanners can detect that there is __some__ Argo traffic, but the only way the bad guys would compromise it is if they had access to the PKI keys used in the encryption - and that is a risk in any security scheme.

But all manner of schemes can co-exist in a network that uses Argo.

## Network communications

The wireline payload can be encrypted in several ways.  All methods can be applied independently depending on the security needs of the Argo protocol and the security needs of the discovered services.  All security can be usually applied using only configuring changes to various parts of the Argo architecture and deployment containers.  There shouldn't be any requirement to include code changes to any component to implement a high level of security.

### No security profile

It is possible to run the Argo discovery protocol with no security whatsoever.  In this profile, the UDP payloads and the response payloads are not encrypted and the network channels are not protected with SSL.  This will make all Argo discovery communication open and readable to network packet sniffers.  This is the default behavior for the majority of other Service Location Protocols (mDNS, SSDP, etc.).  This is also probably not a bad place to start.  The big difference between Argo and other discovery protocols is that

### Places to apply security in the Argo protocol

There are several places that the Argo protocol can have security applied.  They include:
* The UDP Probe payload
* The TCP Network link to the respondTo: address specified in the probe.
* The response payload


### Protecting the respondTo: SSL/TLS TCP unicast channel

#### One-way SSL

The most common way to apply communications security is to use SSL/TLS.  Argo can easily use the One-way varient of this network connection encryption scheme ver easily.

The idea behind the one way SSL is that the client trusts the server.  In the Argo protocol, when a Repsonder decides to respond to a probe, the probe will specify the URL of the place to send the response.  If the response uses HTTPS, then the Argo Respsonder will try to use SSL/TLS to encrypt the TCP network channel.

This protection mechanism makes it hard for a hacker to launch probes and get important IP address or URL information for services on the network by placing a non-authorized Argo client on the network to probe for services.  This is a type of Man-in-the-middle attack.

The way to make this work with Argo is to include the Trust CA certificates of the server certificate that will be presented to the Argo Responder as it attempts to send a response.  Please see your security and network administrator for those certificates. Once you have the certificates in a "jks" (Java Key Store) file, include this information in the command line that launches the Argo Responder.

NOTE:  This Argo responder will now only send responses to "respondTo:" addresses that it trusts that use a HTTPS transport.  Of course, it will still send a regular HTTP message to anyone to if the "respondTo:" address in the probe specifies a non-secure protocol, it will just send it along.

#### 2-way SSL

If you really want to secure the interaction between an Argo Responder and a probe response listener (the Argo client), then you can use 2-way SSL.  In this model, both sides of the connection need to trust each other.

In this case, not only does the Argo client (the server hosting the respondTo address) need to be trusted as in the above example, but the Argo client needs to explicitly trust the Argo Responder.  This mode of security will not only mitigate Man-in-the-middle attacks but will prevent probe responses from unauthorized Responders.  For example, a hacker could launch an Argo Responder that responds with erroneous or non-authorized services to confuse clients and perhaps direct them to fake services.

The Argo client Response Listener will need to be configured to deal with 2-way SSL.  Further, that Response Listener will need to either have the identity of the Responder configured in some authorization/authentication scheme or, perhaps a better plan with something like Argo, is to build a custom authentication module (such as a JAAS module in a JEE Server) that just checks the Responders certificate to see if it's signed by a trusted CA.  The former is strong two-way authentication and the later is trusted CA two-way authorization.

However, going down this path with Argo will make it very secure - perhaps as much security as you would reasonably need - even without Probe payload encryption.

#### Argo Probe payload encryption

The Argo Probe is a XML document that is encoded in a UDP packet - actually a single UDP packet for network efficiency and reliability.  Probes are not big; just a few hundred bytes.  However, they contain some potentially sensitive and confidential information.  Specifically, a probe contains the "respondTo:" address a probe wants the Argo Responder to send answers to and it contains one or more Service Contract IDs and Service Instance IDs for which to query.  

One might want to keep this information confidential for the following reasons.  You want to protect the URL of the Argo client's respondTo address so that it does not become the target of hackers or other cyber-threats.  You want to protect the confidentiality of the Service Contract IDs and Service Instance IDs because without those, hackers cannot launch probes that will yield any results from the network. 

Argo can encrypt these portions of the XML probe payload to hide this information from snoopers and can protect this information from being molested in-flight from the client to the Responders.

#### Argo Response Payload encryption

Most likely, using SSL/TLS wiht the HTTPS protocol between an Argo Responder and an Argo client Response Listener is enough encryption to protect the Response payload.  However, there may be circumstances where it's not enough.

The crown jewels for hackers and other cyber-threats is the IP addresses and ports of critical services on the network.  Keeping these protected is paramount.  Argo can encrypt the actual payload contents of a response to protect the connection metadata blocks embedded in the response payloads.

With both payload encryption options, PKI keys will needs to be create, exchange and managed between both parties of this message pattern.  Probes encrypted by an Argo client will need to be de-encrypted by any number of Argo Responders on the network.  This is an exercise in coordinated key management

_Do all the Argo clients and Responder need to exchange key information?_

No.  This encryption can be targeted.  If you have super-sensitive payloads, you can setup your Argo payload encryption to apply to only those clients that need it.  For example, if there is a special service that can only be discovered by special clients, that can be setup with only those participants.  Even though the Argo Probe payloads may go out across the reachable network, they can only br process by the nodes that know how to encrypt and decrypt the messages.  The rest of the ecosystem just ignores the messages.



##Ancillary protection mechanisms

### No Central (or even federated) Registry

Why does this help security?  Argo does not present a single point of failure.  The only thing that needs to be working for Argo to work a minimally functional network.  Of course, if you don't have that, then Argo is probably not going to help you either way.  Argo is built to comply with the "2 Node" scenario, where the discovery function is available if if there is only 2 computers are left in the network.

### Classification

Classify or otherwise protect the Service Contract, Service Instance and Logical Service IDs.

The Argo protocol works by querying or probing a network using one or more of the Argo protocol keys.  These include the Service Contract ID and the Service Instance ID.

The Service Contract ID specifies a _type_ of service.  A probe that specifies a Service Contract ID should respond with all of the services instances on the reachable network of that type.  By keeping these Service Contract ID confidential, it would be extremely difficult to use Argo to discovery any critical services on the network.  The Argo Responders can be setup to deny "naked probes" that to a "select all" probe - this mean you have to have a service contract ID or service ID to discover the IP address/port/whatever to get to the service.

### Private Networks

VPNs and VLANs are common ways to protect network traffic from unwanted attention.  However, VPNs and most VLANs do not allow UDP or Multicast traffic.  Argo is based on multicast and, for it's long-range capability to be utilized, that traffic should be allowed to traverse the network in a controlled manner utilizing a well-implemented multicast plan by the network administrators.  However, that's not always possible.

Argo comes with a VPN Multicast Gateway as part of its open source release.  This Gateway is useful for moving Argo protocol multicast traffic across a VPN using a point-to-point connection.  It does this by taking the multicast UDP packets, converting them to a TCP unicast message, sending it to a peer gateway on the other side of the VPN, converts it back to a multicast message and sends it on the destination network.  If the VPN is based on IPsec, then you can be sure that prying eyes in the open internet can't see your Argo traffic at all.

The ideal way to do this is with a GRE tunnel (direct router configuration) and encrypted Argo probes and responses, but that capability is not always available.


## Cyber-security Benefits of Argo

There are two major cyber security benefits that you can get from using Argo.  They are:

* Rapid and reliable administrative configuration of distributed components
* Moving Target Defense

In the first scenario, you may need to install new or upgraded software/devices into a network that was attacked in the cyber and/or physical domain.  Or you may be responding to a natural disaster where you need to get an infrastructure capability (energy/transportation/communication) up as fast as possible.
In the second scenario, you want to keep the bad guys off balance and create uncertainly for the attackers.  Further, in cyberspace, if you don't know the IP address of a service to attack (e.g. in a DDoS attack) then it's really hard to execute the attack or have such an attack succeed.  Also, if the bad guys have installed a "backdoor" Remote Access Trojan (RAT), if you change up the IP Address of the machine they installed it on, then they can't get to it - which makes it useless.


## Byzantine Failure protection
