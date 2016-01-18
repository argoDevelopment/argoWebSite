# Argo Response Format

An Argo service response is a very simple and general-purpose mechanism to communicate remote service configuration information to service clients.  It’s expected that a client will use that configuration information to automatically configure itself with the appropriate parameters without the use or support of a system administrator or other tertiary support staff.

***Service Connection Metadata Block***

The following items in the `connection metadata block` are the operative data elements for a service record.

```xml
<service id="the unique ID of the service instance">
    <ipAddress>Some IP Address</ipAddress>
    <port>some port</port>
    <url>some URL to a REST/SOAP or other access location</url>
    <data><![CDATA[This is some CDATA text]]></data>
</service>
```

The Argo protocol does not care which element holds data.  You do not need to put any information in the `ipAddress` or `port` elements if the service contract doesn't support it.  Further, if all you need is some really esoteric information that is interpreted and perhaps further resolved by the client, the only element used might be the data block.

Examples of `connection metadata block` can be found here.

***Argo XML Response Format***

Each response encapsulates one or more `service record`.  A service record encapsulates whatever service configuration information is called for by the services contract for a client to connect to a remote service.  This configuration information is known as the `connection metadata block` in the service record.  The rest of the data in the service record is nice to have for humans to look at (and was really put in to support service browsers), but is really not all that necessary. 

```xml
<?xml version="1.0" encoding="UTF-8"?>
    <services
        responseID=”the unique response ID”
        probeID=”the probeID that instigated this response”>
 
        <service
            id="the unique ID of the service instance"
            contractID="the contract ID that will match the probe">
                <ipAddress>Some IP Address</ipAddress>
                <port>some port</port>
                <url>some URL to a REST/SOAP or other access location</url>
                <description>The human readable description</description>
                <serviceName>The human readable short name of the service</serviceName>
                <contractDescription>human readable desc of the contract</contractDescription>
                <data><![CDATA[This is some CDATA text]]></data>
                <ttl>expected valid lifetime of this response</ttl>
                <consumability>HUMAN_CONSUMABLE or MACHINE_CONSUMABLE </consumability>
        </service>
         
        <!-- more services -->
 
    </services>
```

***Argo JSON Response Format***

```json
{
    "responseID": "the unique response ID",
    "probeID": "the probeID that instigated this response",
    "responses": [
        {
            "id": "the unique ID of the service instance",
            "serviceContractID": "the contract ID that will match the probe",
            "ipAddress": "Some IP Address",
            "port": "Some port",
            "url": "some URL to a REST/SOAP or other access location",
            "data": "This is some CDATA text",
            "ttl": "expected valid lifetime of this response in minutes",
            "contractDescription": "human readable desc of the contract",
            "serviceName": "The human readable short name of the service",
            "description": "The human readable description of the service instance",
            "consumability": "HUMAN_CONSUMABLE or MACHINE_CONSUMABLE "
        },
         
        … more services …
    ]
}
```

The response payload has a unique identifier for the specific response and the corresponding probeID for which the response was generated.  This is useful for various correlation checks in a client as well as one mechanism to help safeguard against MITM and replay attacks.

The response protocol has two classes of values: the operative configuration values and human consumable descriptive values.  The human consumable descriptive values are nice to have but not prescriptive in the protocol.  There are only 4 operative configuration values in the payload.  They are the ipAddress, port, url and data.  The values of which should be generally obvious.  However, not all of the values are necessarily always prescriptive.  The actual values in the payload and any formats of those values are a function of the service contract, not the Argo protocol.  For example, if the Argo response was providing configuration for a database connection, perhaps only the ipAddress and port would be used and the url would be blank.  Conversely, if the response was providing configuration for a REST API, the ipAddress and port could be blank and the url would have a value (as a URL typically has an IP address and port).  Also, the data value is completely free form and is wholly dependent on the service contract being communicated. 

Each response can contain one or more service value sets.  The response is sent via TCP Unicast and is capable of being sent via SSL/TLS and/or encrypted.  Further, the size of the response is not limited, per se, to any network-level packet size limit.  The data value could be arbitrarily large to communicate complex or verbose configuration information back to the client.


## No Negative Responses and No Announcement (Hello/Goodbye) Protocol

The Argo protocol normatively does not allow any negative response.  Also, there is no announcement protocol associated with it.  A long-range discovery protocol cannot add this burden to the network and its expected that all such protocol sources would broadcast such traffic across the entire reachable network.  This is a main reason to depart from other discovery protocols that are designed to operate in local area network such as mDNS, SSDP and WS-Discovery.  However, Argo is not mutually exclusive with other discovery protocols.  There is no reason why an application or system couldn’t use both Argo and mDNS (Bonjour) for other zeroconf purposes.[i][1]

[1]: http://en.wikipedia.org/wiki/Zero-configuration_networking

## MACHINE\_CONSUMABLE and HUMAN\_CONSUMABLE

The idea behind this value is twofold.  Of course, a primary function of the discovery protocol is to locate machine (client software) consumable services such as REST/SOAP and the like.  However, it is also a cue to services discovery browsers to provide a clickable hyperlink anchor tag to URLs in HUMAN_CONSUMABLE service responses.  There is no reason why the discovery protocol cannot provide a mechanism to discover links to web sites and other human consumable content.
