---
title: Up and running in 5 minutes
tags: [publishing, single_sourcing, content-types]
keywords: startup, quick start, tutorial
last_updated: November 30, 2015
summary: "Get up and running in about 5 minutes with an Argo Responder and the Argo command line client."
---

Argo is not that difficult to get installed an running in its simplest configuration.

***NOTE:  The 0.4.x release has a RPM package for easy installation***

There are two ways to install Argo.  The first, and easiest, is to use the RPM packages and use `rpm` or `yum` to install.  The second method uses a `zip` file or `tar.gz` tarball file.  This second method requires some manual changes to the installed files to get them working. 

This page provides the steps to get an Argo Responder up and running in 5 minutes.  In order to see what this freshly installed Responder is advertising (and to make sure it's actually working), you'll need to install the Argo command-line client as well and probe for services.  However, this is where to get started.

There are two parts of Argo to install, depending on what you are doing.  The first step is to [install the Argo Responder](#argo-responder).  The second step, if required, is to [install the Argo command-line client](#argo-client).  This page walks you through both.

<a name=“argo-responder”></a>
##Argo Responder

> * [Click here for RPM Package Installation](#rpm-package-installation)  
> * [Click here for `.zip` or `.tar.gz` Package Installation](#zip-or-targz-package-installation)

---

<a name=“rpm-package-installation”></a>
###RPM Package Installation

Installing the Responder is actually pretty easy.  In a nutshell, the steps are:

* Download the RPM package from argo.ws.
* [Install the RPM package on the target host](#installing-the-responder-rpm-package).
* Edit the `.sh` or `.bat` files (only for installation from zip or tar.gz).
* [Edit the Service List configuration file](#editing-the-service-list-file).
* [Start the Argo Responder daemon](#start-the-responder-daemon).

####Installing the Responder RPM package

Assuming you have downloaded the RPM package from the Argo Github release page, you should have a file called `argo-responder-0.4.0-BETA_1.noarch.rpm` (or something close to that with the latest version).  Make sure that you are logged in with an account that has privileges to execute the installation command.  Then execute the following command:

```
yum localinstall argo-responder-0.4.0-BETA_1.noarch.rpm
```
This will install the Argo Responder into `/opt/argo/responder` on linux-based systems.  Ok, installation complete.  Now do a little configuration to get going.  [Click here](#basic-responder-configuration) to jump to the configuration section.

---

###`.zip` or `.tar.gz` Package Installation
On some operating system, like Windows and MAC OS, rpm and yum are not available.  Pity.

In a nutshell, the steps are:

* Download the Argo Responder zip file (or tar.gz) from the argo.ws web site
* Unzip in a directory of your choosing (e.g. /opt/argo or C:\argo)
* `set` or `export` the ARGO_HOME environment variable
* [Modify a couple of the configuration files](#modify-responder-configuration-files) (more on that in a minute - and you *have* to do this)
* [Edit the Service List configuration file](#editing-the-service-list-file).
* Start the Argo Responder daemon with the appropriate `responder` shell script for your OS.

However, to just get up and running, you can leave the editing of the `configFileProbeHandlerServiceList.xml` till later and just leave the notional services configured.

#### Responder Zip Structure

```java
bin
  +- responder.sh
  +- responder.bat
config
  +- configFileProbeHandlerConfig.prop
  +- configFileProbeHandlerServiceList.xml
  +- responderConfig.prop
lib
  +- ResponderDaemon-<version>.jar
doc
  +- Responder Configuration.md
```


####Modify Responder Configuration Files

There are some configuration files that need to be manually edited to point to the installation directory of Argo.  This includes the `responderConfig.prop` and the `configFileProbeHandlerConfig.prop` files.

In each file replace the `@INSTALL_DIR@` text with the path of the Argo install directory.  Sorry about this.  The RPM install is easier as it makes an assumption about installation location.  I can’t do that in Windows with a zip file.

---

####Basic Responder Configuration

The Responder can be a complex animal when you get into all of the potential functionality that is provided by its [plugin architecture](https://github.com/di2e/Argo/wiki/Argo-plugin-architecture).  However, for this tutorial, we’ll keep things simple.

The Argo Responder uses two different sets of plugins for its operation - the *Transport Plugins* and the *Probe Handler Plugins.*

The Argo Responder uses things called *Transport Plugins* to listen for probes (Argo protocol probe messages) that come in across publish/subscribe channels.  The default Transport Plugin is the Multicast Transport.  This plugin will listen for probes on a particular multicast group address and port.  The default Argo multicast address is 230.0.0.1:4003.  This is configurable, of course.  Don’t worry about this for now, we have no need to change any of this for the moment.

The Argo Responder also uses things called *Probe Handler Plugins.*  When a probe is picked up by one of its configured *Transport Plugins*, it’s handed off to be processed by all of the configured probe handlers.  The default Probe Handler Plugin is the Configuration File handler.  This handler has a configuration file that has all of the services that it will respond with listed in that file.  There are several other Probe Handler plugins, but for how all we need to worry about is this handler.  Which means we need to worry about the configuration file it uses.

The Configuration File handler keeps its configuration file in `/opt/argo/responder/config`.  The default service list file is the obviously named `configFileProbeHandlerServiceList.xml`.  This is the file we’ll be editing.

####Editing the Service List file

> BTW, you can edit this file while the responder is actually running.  The Configuration File Plugin will scan for changes to this file every 10 seconds or so.  If it sees that the file changed it will automatically reload it.  If there is an error in the configuration file, then it will just keep the last good one and tell you there was an error.

The Configuration File Probe Handler Plugins reads this XML file to load up the services that it will use to respond to a probe.  The Service List file should capture the list of service metadata that you want to advertise to Argo clients who are probing for a file.  As a matter of convention the host that the Responder in running on should also host any services in this file (but that is not strictly true - but let’s not digress).

First, let’s take a quick look at the structure of the file before we start hacking away at it.

```xml
<servicesConfiguration>
<!-- 
  <resolveIP name="internalIP" type="ni"></resolveIP>
  <resolveIP name="externalIP" type="uri"></resolveIP>
 -->
  <service id="YOUR SERVICE ID HERE" contractID="YOUR CONTRACT ID HERE">
    … service meta data here …
  </service>
  … perhaps many other services listed …
  <service id="YOUR SERVICE ID HERE n” contractID="YOUR CONTRACT ID HERE n”>
    … service meta data here …
  </service>
</servicesConfiguration>
```
Basically, there are a couple things in the file structurally.  There is a list of `<resolveIP>` items (we’ll get to those [in a minute](#notes-on-replacement-variables-in-argo-xml-files)) and there is a list of `<service>` items.  You can have as many services as you like in the file - the limit is purely practical.

There are two attributes of the `<service>` item that **NEED** to be filled out.  These are `id` and `contractID`.  This is what really drives the Argo protocol.

`service contractId` - this is a globally unique identifier of the **_type_** of service.  It denotes the [service contract](https://en.wikipedia.org/wiki/Service-oriented_architecture#Programmatic_service_contract).  Argo doesn’t care what format you use for the unique ID (e.g. UUID, URI, etc), just make sure it doesn’t collide with others types of services.

`service id` - this is the globally unique identifier of the **_instance_** of the service.  Each and every service id will be different and you’ll need to generate one when you edit the service list file.  I usually use and recommend UUIDs and use [this tool](https://www.uuidgenerator.net/). 

Here are some [service record examples](https://github.com/di2e/Argo/wiki/Service-Record-Examples).

The following is the basic structure of the service list configuration file.

```xml
  <serviceName>Some short human readable name</serviceName>
  <description>Some short human readable description</description>
  <contractDescription>Read description of this field below</contractDescription>
  <consumability>Read description of this field below</consumability>
  <ttl>Read description of this field below</ttl>

  <!-- access points -->
  <accessPoints>
    <accessPoint label=“any label that makes sense - like internal network“>
      <ipAddress></ipAddress>
      <port></port>
      <url></url>
      <data><![CDATA[This is some CDATA text]]></data>
    </accessPoint>
    … more access points if you need them …
    <accessPoint label="external network - NAT address">
      <ipAddress></ipAddress>
      <port></port>
      <url>https://1.1.1.1:443/MyAwesomeService/index.jsp</url>
      <data><![CDATA[This is some CDATA text]]></data>
    </accessPoint>
  </accessPoints>
```
#####A quick description of the fields describing a service:

######Basic Service Metadata

`serviceName` - This is a short name that is expected to be human readable, perhaps for an operator to make a decision to use it or not.

`description ` - This is a short name that is expected to be human readable, perhaps for an operator to make a decision to use it or not.

`contractDescription` - this is a brief description of the *_type_* of services this is.  Again, for use by an operator who would be discovering this service.  This string should be specified by the service contract itself.  It could, perhaps, included a link to where the full contract is located (e.g. if its an OpenSearch service you might include http://www.opensearch.org/Specifications/OpenSearch/1.1/Draft_5).  Your full `contractDescription` then might look like:
> ```<contractDescription>OpenSearch 1.1 Service Contract - http://www.opensearch.org/Specifications/OpenSearch/1.1/Draft_5</contractDescription>```

`consumability` - This is an Argo protocol specific consumability indicator.  Its value can be:

* `HUMAN_CONSUMABLE` - meaning that the access points are intended to be consumed by a human and are likely HTTP end points that ca be used by a web browser
* `MACHINE_CONSUMABLE` - meaning that the access points are intended to be consumed by a client programmed specifically to consume this type of service - OpenSearch or Amazon/Facebook/Google services, etc.

`ttl` - this is the “time to live” associated with the service entry.  When a client discovers this service, this number tells the client how long they should expect this service record to be valid.  The unit is in minutes.  Services move or have a finite lifetime and this values captures that scenario.  So, if you ignore that value and the access points no longer work after the “time to live” has expired (from the time you discovered the service in the first place), then you only have yourself to blame.  For example:
> ```<ttl>10</ttl>``` means that this service record is only reasonably valid for 10 minutes.  The service provider may move or end the service after that time.  Either way, you should “rediscover” that service by sending out a probe for that particular service instance to get the freshest service record data.

######Access Points

Access points are where the rubber meets the road, as it where.  This is where you can enter the actual IP address, port, url or whatever to communicate to the client where to find the service.  Now, it doesn’t mean that the client as access to the service.  It just means they know where it is on the network.

`label attribute` - The `label` attribute on the access point is some human-readable label that gives the client a hint about what kind of access point this is.  The meaning should be spelled out in the service contract or in the SOPs and TTPs of your network.

`ipAddress`, `port` and `url` - This get lumped together for explanation.  These values are used at the convenience of the service contract.  If you only have an IP address and the service contract has a well-known port, then you’ll likely only see an IP address in the access point.  If it’s a `HUMAN_CONSUMABLE` service or some REST-based service that only has a URL, then you’ll likely only see an IP address in the access point.

`data` - this is a free-for-all metadata holder.  You can put anything here.  If it’s really complex, then you might want to BASE64 encode it (especially if the response format of the probe is JSON).  But you can do anything here.  In fact,  you might just skip the `ipAddress`, `port` and `url` values and just jam everything in the `data` item.  It’s up to the service contract to figure that out.  The consuming client should know what’s in there and consume accordingly.

> You might be wondering, “do I have to modify this configuration file on every host that has a service?”.  Good question.  The answer is no.  There are other ways to “register” services and several legitimate topologies as to where you install an Argo Responder.
> The Argo Plugin architecture makes is possible to do all sorts of things.  For example, if you have a local UDDI that you keep all of your applications service endpoints in, then you can use the UDDI plugin.  The UDDI Plugin will take the Argo probe and translate it into a UDDI query and then return the result. 
> This technique is also useful when you use an API Management tool.  For example, if you use Layer 7 as your API Gateway, you can use the Argo Layer 7 plugin to translate Argo probes into queries that talk to the Layer 7 API gateway.  This means that you don’t need to “double” your work when using other “registry” type technologies.  However, you may have to build your own Argo Responder plugin to do that.  But that is actually pretty easy to do.
> 

---


<a name="notes-on-replacement-variables-in-argo-xml-files"></a>
##### Notes on replacement variables in Argo XML files
> The XML processing in Argo XML files allows for replacement variables.  For example, if you have an item named `<installDir>/opt/argo</installDir>` defined in the file, if you use the replacement variable syntax in the file, the value defined in the item will be inserted.  For example, `<configuration>${installDir}/myconfig/config.xml</configuration>` would resolve to `<configuration>/opt/argo/myconfig/config.xml</configuration>`.  It’s a well understood and convenient way to parameterize a configuration file.

> The `<resolveIP>` items are a special kind of replacement variable that can be used in the file to help facilitate a configuration that can be used on hosts without direct editing of this configuration file but still get all the IP address and URLs correct in the defined services. There are two types of resolveIP items:
>
>  * ni - meaning a network interface type
>  * uri - meaning a URI type
> 
> A resolveIP item that looks like:
>   `<resolveIP name="internalIP" type="ni">eth0:ipv4</resolveIP>`
> will resolve to the first IPv4 address associated with network interface named `eth0`.  The full syntax and usage can be found [here]().
> A resolveIP item that looks like:
>   `<resolveIP name="internalIP" type=“uri”>https://api.ipify.org</resolveIP>`
> will perform a `HTTP GET` on the URL and use that response as the replacement.  This is particularly useful for NATed addresses and usage on AWS EC2 instance.  The full usage model can be found [here]().

---

###Start the Responder Daemon

Once these changes are made you can start the Responder by using the OS appropriate startup command in the `$ARGO_HOME/bin` directory.  If you are on linux you can run it in the background with the following recommended command `./responder.sh &> ../logs/responder.log &`

Also, the RPM installer will but a link into `/usr/local/bin`.  If that is on your path, then just type `responder`.

If everything goes well, the you will see the following line on the screen or in the log file:

	Argo 0.4.0-BETA :: Responder started  [d9790f64-68fb-41d6-89e2-4a94ae1b634a]

This line tells you the version and the instance number of the Responder.  Each instance launch will have a unique identifier that is useful for attribution traces should such a trace be necessary for security reasons.

A control-c or a `kill` command will cleanly exit the Responder and is the preferred method for terminating the Responder.
The only errors you might see could be from errors reading the XML file for the services.
Also, if the responder does not seem to be responding to probes, try rebooting the host.

That's it.  You should be up and running and now your services are discoverable.  

---

<a name=“argo-client”></a>
##Argo Client

> * [Click here for RPM Package Installation](#argo-client-rpm-package-installation)  
> * [Click here for `.zip` or `.tar.gz` Package Installation](#argo-client-zip-or-targz-package-installation)

---

###Argo Client RPM Package Installation

Installing the Argo command-line client is actually pretty easy.  In a nutshell, the steps are:

* Download the RPM package from argo.ws.
* [Install the RPM package on the target host](#installing-the-argo-client-rpm-package).
* [Start the Argo Client](#start-the-argo-client).

####Installing the Argo Client RPM package

Assuming you have downloaded the RPM package from the Argo Github release page, you should have a file called `argo-client-0.4.0-BETA_1.noarch.rpm` (or something close to that with the latest version).  Make sure that you are logged in with an account that has privileges to execute the installation command.  Then execute the following command:

```
yum localinstall argo-client-0.4.0-BETA_1.noarch.rpm
```
This will install the Argo Responder into `/opt/argo/client` on linux-based systems.  Ok, installation complete.  Now do a little configuration to get going.  [Click here](#basic-client-configuration) to jump to the configuration section.

###Argo Client `.zip` or `.tar.gz` Package Installation
On some operating system, like Windows and MAC OS, rpm and yum are not available.  Pity.

In a nutshell, the steps are:

* Download the Argo Client zip file (or tar.gz) from the argo.ws web site
* Unzip in a directory of your choosing (e.g. /opt/argo or C:\argo)
* `set` or `export` the ARGO_HOME environment variable
* [Modify a couple of the configuration files](#modify-client-configuration-files) (more on that in a minute - and you *have* to do this) *[yes, you could just have an environment var encoded and just change the configuration in just one place - why did Windows and Linux HAVE to be different? Plus I really didn’t want a separate Linux and Windows build]*.
* Start the Argo Client with the appropriate `argo` shell script for your OS.

However, to just get up and running, you can leave the editing of the `configFileProbeHandlerServiceList.xml` till later and just leave the notional services configured.

#### Client Zip Structure

```java
bin
  +- argo.sh
  +- argo.bat
config
  +- clientConfig.xml
  +- multicastTransport.prop
  +- amazonSNSTransport.prop
lib
  +- CLClient-<version>.jar
```
---

####Modify Client Configuration Files

There are some files that need to be manually edited to point to the installation directory of Argo.  This includes the `argo.sh`, `argo.bat`, `argoConfig.prop` and the `configFileProbeHandlerConfig.prop` files.

In each file replace the `@INSTALL_DIR@` text with the path of the Argo install directory.  Sorry about this.  The RPM install is easier as it makes an assumption about installation location.  I can’t do that in Windows with a zip file.

---

####Basic Client Configuration

You shouldn’t need to modify any of the OOTB configuration if you are using the Multicast transport on a local network (or your main network interface as a routable address).  However, networks can be complex.

The configuration of the Argo Client can be complex if you decide that you need to use one or more other transport plugins provided by its [plugin architecture](https://github.com/di2e/Argo/wiki/Argo-plugin-architecture).  However, for this tutorial, we’ll keep things simple.

Further, the Argo client runs an in-process HTTP server that it uses as a listener for responses from the Argo responders.  You have to set these parameters correctly for messages to be received by the client.

The main client configuration file in `/opt/argo/client/config/clientConf.xml`.  Again, if your just getting things up and running on a local network, you don’t need to modify this file.  However, if you are running this in the real world, there are two configuration items you will need to change.

`listenerURL` - this is the address the client will use to launch its internal HTTP server.  An example is:

	http://localhost:8080

You should just include the scheme (HTTP or HTTPS), the IP address or domain name and the port.  Nothing else.  

`respondToURL` - this is the URL that is used by the Responder when it send the response back to this client.  The respondToURL *may* be different than the `listenerURL`.  This happens in NATed networks (like a home network).  If it’s empty, the it defaults to the value of the `listenerURL`.

*__NOTE ON USE IN AWS__* - You can’t use internal addresses for either of these items.  You need to use the public DNS name (not the public IP).  I would recommend that you use the `resolveIP` functionality to configure this automatically.  Here is the config:

```
	<resolveIP name=“externalDNS” type=“uri”>http://169.254.169.254/latest/meta-data/hostname</resolveIP>
	
	<listenerURL>http://$(resolveIP:externalDNS}:80</listnenerURL>
	<respondToURL>http://$(resolveIP:externalDNS}:80</respondToURL>
```

---
###Start the Argo Client

Once these changes are made you can start the Argo Client by using the OS appropriate startup command in the `bin` directory. 

Also, the RPM installer will but a link into `/usr/local/bin`.  If that is on your path, then just type `argo`.

If everything goes well, the you will see the following:

	Starting Argo Client ...
	Argo >
	
You can type `help` to see a list of command.  The Argo Client commands are hierarchical, so the real commands are nested. To see the sub-command for example, type `config --help` or `config export --help`.

To discovery services, you need to the following:

 * Create a probe - use `probe new` to do this.  You can name it and keep a list of several of them, but just one `UNNAMED` one will do for right now.
 * Send the probe - use `probe send` for this.  This command actually sends ALL the probe setup in the client, but since we only have one, this command will do for now.

At this point you should see the following output:

```
Starting Argo Client ...
Argo >probe new
Created new probe named UNNAMED
Argo >probe send
Empty list of probe names - sending all probes
Sent probe UNNAMED on ProbeSender for Multicast Transport -  mcast group [230.0.0.1] - port [4003] on NI [eth0]

Successfully cached 2 services
Argo >
```

This means that the client has received two responses and stored them in it’s local cache.  To view the cache type the following `cache list`.

```
1: A very short name for the Service Instance 2 [This is another awesome service. The scope of its awesomeness is eclipsed only by the other awesome service] : d21ddd0d-d0cb-43db-9605-088660ad57a1
2: A very short name for the Service Instance 1231232313 [This is an awesome service. The scope of its awesomeness is hard to describe] : 23023a86-51f1-4b89-a32f-4e0a76804ce9
```

Your list might look different, but if you have one at all, then you are up and running.  

If you want to see the nitty-gritty details on the cached responses, type `cache list -p -pretty` which will show the full payload and make it pretty printed.

