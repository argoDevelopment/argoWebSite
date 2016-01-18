_For the response format look [here](https://github.com/di2e/Argo/wiki/Argo-Response-Format)._
# Argo Probe Format

The Argo protocol is a multicast request (or probe) and a unicast response.  Client will send a UDP Multicast request packet called a probe.  The notion of a probe is consistent with other similar protocols such as WS-Discovery.  The probe should attempt to fit under the 576 byte IPv4 limit minimum datagram packet size, therefore the probe wire-line format is fairly terse.  Currently, a probe can be in XML.  The format is shown below:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<probe id="urn:uuid:7ea60f23-7072-4113-aff8-194f906d83d1" contractID="urn:uuid:55f1fecc-bfed-4be0-926b-b36a138a9943">     
    <respondTo>http://7.7.7.12:8181/services/probeResponse</respondTo>
    <respondToPayloadType>XML or JSON</respondToPayloadType>
    <serviceContractID>uuid:03d55093-a954-4667-b682-8116c417925d</serviceContractID>
</probe>
```

An Argo probe has two attributes that include the contractID, which is effectively the version number of the Argo protocol specification, and the probeID, which is some unique ID (e.g. UUID) for each probe payload sent.

The operative part of the payload for a probe includes the respondTo address, which is the address where a protocol responder will send the TCP Unicast response.  The pattern used is a REST pattern where the HTTP operation is POST.  There is no other requirement of response receivers.  The payload also contains the responsePayloadType, which will be either XML or JSON.  This tells the responder what type of response payload is desired.

The probe may contain zero or more serviceContractIDs.  A probe with zero serviceContractIDs is semantically equivalent to a “probe for all services” which is useful for service SA browser on a subnet where the probe scope is controlled by the UDP packet “time to live” (TTL).  However, a responder is not necessarily required to respond to such probes.  Further, the “probe for all services across the entire reachable network” can be a heavyweight request considering that Argo is a long-range protocol with potentially thousands of service instances responses that it might receive.

The idea is that a service client will send out a probe for a small number of services for which it has been built to be interoperable with (e.g. some REST/SOAP service, a database connection or a messaging service).  A reasonable number serviceContractIDs could be perhaps 1 to 4 – if your client needs to discover services for a couple dozen contracts, you might want to revisit your system design. The specification of the serviceContractID is a part of the Design-time Service Discovery ecosystem governance where a particular service protocol definition (perhaps including artifacts) is registered into a well-known location for use by client and server developers at design-time.  The Design-time ecosystem governance and format of the serviceContractIDs, which is a global unique string (e.g. UUID), is beyond the scope of this paper.