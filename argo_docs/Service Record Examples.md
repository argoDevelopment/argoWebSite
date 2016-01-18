#Service Record Examples

Some examples of `connection metadata blocks` include:

###*Web Service*

```xml
<service id="the unique ID of the service instance">
    <url>some URL to a REST/SOAP or other access location</url>
</service>
```

With a Web Service, usually all you need is the URL to the service.  All the rest of the information to connect to a service is provided as part of the development of the client (perhaps through some design-time artifacts such as WSDL/WADL or some other documentation).

There is no need to include the IP address or port of the service in the `ipAddress` or `port` elements (as they are usually included in the URL).  However, if you like, you can cut up the URL however you like (assuming the clients know how the metadata is structured).  This is a function of the service contract.

###*Database*
```xml
<service id="the unique ID of the service instance">
    <url>jdbc:oracle:thin:@172.99.101.4:1521:AwesomeDatabase</url>
    <data>
        <![CDATA["User Id=scott;Password=tiger;
             Data Source=oracle;Min Pool Size=10;Connection Lifetime=120;
             Connection Timeout=60;Incr Pool Size=5; Decr Pool Size=2"]]>
     </data>
</service>
```

Here is a sample connection metadata block for an Oracle database.  I'm not sure I'd include the username and password here, but hey, it's your service.

Alternatively, if the service contract explicitly declared the use of a n Oracle driver, then you might want your service record to look like this:

```xml
<service id="the unique ID of the service instance">
    <ipAddress>172.99.101.4</ipAddress>
    <port>1521</port>
    <url>AwesomeDatabase</url>
    <data>
        <![CDATA["User Id=scott;Password=tiger;
             Data Source=oracle;Min Pool Size=10;Connection Lifetime=120;
             Connection Timeout=60;Incr Pool Size=5; Decr Pool Size=2"]]>
     </data>
</service>
```

###*Message-Oriented Middleware*

```xml
<service id="the unique ID of the service instance">
    <ipAddress>172.99.101.4</ipAddress>
    <port>7222</port>
    <url>AwesomeTopicName</url>
    <data>
        <![CDATA["topicName=AwesomeTopicName"]]>
     </data>
</service>
```

In the above example, which is connection metadata to a Tibco EMS instance, there are a couple ways you could go with this.  The way shown above uses the `ipAddress` and `port` for the obvious but uses the `url` element to hold the topic name.  I also include the topic name in the `data` element as well (perhaps for some backward compatibility reason).  

You certainly could have done this:

```xml
<service id="the unique ID of the service instance">
    <url>tcp://172.99.101.4:7222</url>
    <data>
        <![CDATA["topicName=AwesomeTopicName"]]>
     </data>
</service>
```

The idea here is that you have a choice about how you use the elements in the service record.  There is no convention.  In fact, you could put all your connection information in the `data` element is some Base64 encoded or encrypted format.  As long as the client receiving this service record in response to a probe knows what to do with the response payload, you're ok.  And all of the necessary instructions on how to parse and utilize the Argo response payload should be spelled out in detail in the design-time documentation for the developers when they build the client code.

###*A Regular Website*

The Argo discovery protocol allows the service record to provide connection information about human-consumable services as well.  There is no reason why service discovery should only be some sort of machine consumable service.  That kind of makes Argo a type of web site finder in an unstable network - especially one that has DNS disabled via cyberattack.

This is where Argo departs a bit from other service discovery protocols in that it can tell you when the URL you have is something that will operate well through a browser or when it's really a REST RPC call.  This is done with the `consumability` modifier in the service record.  For more on that look [here](https://github.com/di2e/Argo/wiki/Argo-Response-Format#machine_consumable-and-human_consumable).

```xml
<service
    id="the unique ID of the service instance"
    contractID="contract ID of HTTP websites or perhaps specifically for CNN websites">
    <url>https://www.cnn.com</url>
    <consumability>HUMAN_CONSUMABLE</consumability>
    <description>The human readable description</description>
    <serviceName>The human readable short name of the service</serviceName>
</service>
```

In the above example, I've selected `www.cnn.com` as a web site that I'd like to advertise with Argo.  I've included some more available metadata fields so that it makes a little more sense to the consumer.

First, all service records have a `contractID` associated with them.  For more on service contract and service instance IDs look [here]().

In this instance, I might be looking for all HTTP web sites or I might be looking for all CNN websites.  This will be defined by the `contractID` and will be known to potential consumers of the sites a priori.

The ancillary elements `consumability`, `description` and `serviceName` are nice-to-have elements if you want to provide a little more information to the user before they click on the discovered link to the website.  Further, you could put some rich HTML (or other markup) in the `data` element for rich description.  

The idea here, again, is that there really is no convention from the perspective of the Argo protocol.  There is only convention from the perspective of the service contract itself.  You can do whatever you want with the elements included in the protocol, however, it's assumed that clients discovering and using these service records will know what to do with the metadata when they get it.


##Dealing with Services that have a SSL and non-SSL end-point

This is a bit of a special case.  There is more discussion on this topic in the section on service contract and service instance IDs [here]().

> If you have two different methods to access the ostensibly same service, then you really should have two separate service records.

Sure, you could encode everything you like into the `data` element and call it a day.  For example:

```xml
<service id="the unique ID of the service instance">
    <data>
        <![CDATA["HTTP=http://172.99.101.4:8080; HTTPS=https://172.99.101.4:4443"]]>
     </data>
</service>
```

This is a bit of an anti-pattern due to how to correctly reconcile service contracts and service instance IDs.  The best way to do this is to have two service records with ***two service contracts***.  Meaning that the HTTP access is really a different service contract than the HTTPS access method.

The recommended practice is:

```xml
<service
	id="the unique ID of the HTTP service instance"
	contractID="the HTTP only access contract ID">
	<url>http://172.99.101.4:8080</url>
</service>

<service
	id="the unique ID of the HTTPS service instance"
	contractID="the HTTPS only access contract ID">
	<url>https://172.99.101.4:4443</url>
</service>
```