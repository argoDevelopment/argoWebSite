---
title: Creating an Argo Client
tags: [publishing, single_sourcing, content-types]
keywords: client software programming
last_updated: November 30, 2015
summary: "Write the code necessary to get your application ready to operate with Argo."
---

The way many things work today, in order to connect a client to a remote server, you have to manually configure the client with the IP address and port of the remote server.  Generally, this is not that big of a pain, as long as the IP address is readily available and you don't have to configure the client often - or quickly.

You can use Argo with the Argo Browser to hunt down advertised services that conform to the service contract that your client conforms.  Then you can just copy-and-paste or fat-finger in the configuration in information into the client.  That sounds like a drag to me.

If you would like your client application (such as a web app), to natively use Argo so you can directly and automatically consume remote services configuration information, you can add a little bit of code to your application to do this.

You will also need an asynchronous listener to field replies from the network for your service probes.  Argo is not a synchronous protocol where you can wait for an answer from a request, like you do with a plain RPC call like a HTTP REST service invocation. _[**NOTE:** That being said, it is possible to create what looks like a synchronous call from your application's perspective, but I really don't suggest it ... bad things can happen.]_

### Argo Client Architecture

![](https://cloud.githubusercontent.com/assets/1844785/6732170/4a79a72e-ce20-11e4-84f6-27b25fcacdd9.png)

In the above picture, you will see that a browser client consists of two components.  The client itself, which sends out an Argo probe via the Probe Generator, and the Asynchronous Listener component.  

### Probe Generator

A client will send out a probe that looks for services that it can consume.  It will construct a Probe that will included a number (zero or more) service contract IDs.  How do you get this service contract IDs?  The service providers will give them to you with you develop your client code.  At runtime, these will be effectively magic numbers and should never change for the operational lifecycle of the client.

Here is some sample code that your client application will likely use to send out a probe:

```java
	public String launchProbe() throws IOException {
		
		Properties pgProps = getPropeGeneratorProps();
		
		String multicastGroupAddr = << The Argo Multicast group is 230.0.0.1 >>
		String multicastPortString = << The Argo port is 4003 >>
		String listenerIPAddress = pgProps.getProperty("listenerIPAddress");
		String listenerPort = pgProps.getProperty("listenerPort");
		String listenerURLPath = pgProps.getProperty("listenerProbeResponseURLPath", DEFAULT_PROBE_RESPONSE_URL_PATH);
		
		Integer multicastPort = Integer.parseInt(multicastPortString);
		
		ProbeGenerator gen = new ProbeGenerator(multicastGroupAddr, multicastPort);
		
		Probe probe = new Probe("http://"+listenerIPAddress+":"+listenerPort+listenerURLPath, Probe.JSON);
		
		// No specified service contract IDs implies "all"

		// But if you are looking for specific service contract ID's then you'll have the following code:

		probe.addServiceContractID("urn:uuid:03d55093-a954-4667-b682-8116c417925d");	
		probe.addServiceContractID("urn:uuid:4ad2d350-334b-473a-806e-f08ff568dc46");

		// add more if you need them
	
		
		gen.sendProbe(probe);
		gen.close();
		
		return "Probe launched successfully on "+multicastGroupAddr+":"+ multicastPort;

	}
```

That's it.  Fire and forget.  Responders will pick up this probe and then check of they have services that match the service contract ID specified in the probe.  That means that it's likely to work with your client.  The Responder will send a response payload (in either XML or JSON - depending on what you chose in the probe) to the listener URL specified in the Probe constructor.

The next step is to get and answer and do something with that answer.

### Asynchronous Listener

An Asynchronous Listener, in a nutshell, is just a RESTful endpoint that Argo responses will be send to.  Argo probes can wander the wide-area network and you just don't know when a response from a probe might show up.  The architectural idea is that the Asynchronous Listener will collect responses and can then notify the application with responses come in or the application an poll a local Asynchronous Listener to see what its got.  

The design of an Asynchronous Listener is really up to you and the needs of your application.  So there is no normative Asynchronous Listener that comes with Argo.  There is a sample Asynchronous Listener that comes with the sample Browser client, but I would only use that as a starting point.

An Asynchronous Listener will likely need to do a couple of things.  Firstly, it will likely need to cache responses.  The other thing it likely needs to do is figure out if it will be active or passive when it receives probe responses.  Active Asynchronous Listeners will immediate fire off a message to somewhere telling the application that it received probe responses.  The application should then use that response information to configure itself with the service configuration payload information.  Passive Asynchronous Listeners will provide and API and a cache so that your application can periodically poll the cache to see if probe responses have come in.

The sample Asynchronous Listener is a caching, passive listener that operates as a companion REST web app to the Browser client.  You can use that as a starting place.

#### REST API Asynchronous Listener Requirements

There are only two specific REST API requirements for the Asynchronous Listener.  The first is the definition of a `POST` service that consumes `application/json`.  Here is an example using JAX-RS annotations:

```java
	@POST
	@Path("/probeResponse")
	@Consumes("application/json")
	public String handleJSONProbeResponse(String probeResponseJSON) throws SAXException, IOException {
		System.out.println("handling JSON probe response: "+probeResponseJSON);
		
		ArrayList<ServiceInfoBean> serviceList = parseProbeResponseJSON(probeResponseJSON);
		
		cache.cacheAll(serviceList);
		
		return "Asynch Listener Cached "+serviceList.size()+" services from probe response\n";
	}
```

The second is the definition of a `POST` service that consumes `application/json`.  Here is an example using JAX-RS annotations:

```java
	@POST
	@Path("/probeResponse")
	@Consumes("application/xml")
	public String handleXMLProbeResponse(String probeResponseXML) throws SAXException, IOException {
		System.out.println("handling XML probe response: "+probeResponseXML);
		
		ArrayList<ServiceInfoBean> serviceList = parseProbeResponseXML(probeResponseXML);
		
		cache.cacheAll(serviceList);
		
		return "Asynch Listener Cached "+serviceList.size()+" services from probe response\n";
	}
```