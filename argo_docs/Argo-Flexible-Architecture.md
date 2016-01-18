---
title: Argo Flexible Architecture
tags: [architecure]
keywords: architecture, components, host, deployment, installation
last_updated: January 15, 2015
summary: "Overview of the protocol, architecture and components of Argo"
---


There are a couple of operational components in the Argo architecture. These are similar to other components that you'll find in other service location protocols. However, with Argo, you have a tremendous amount of flexibility in the implementation, deployment and operation of these components depending on the needs of your application.

##Argo Components

The full Argo architecture can be found here.  For review, there are just 3 operational Argo components:

* Probe Generator
* Responder
* Asynchronous Response Listener

Each of these components can be employed in a number of different and flexible ways.  Firstly, the components can be deployed in a flexible manner.  Depending on the needs of your application (scalability, security, deployment, etc.) you can employ the Argo components to suit your needs.  The two aspects regarding architecture flexibility is deployment and scaling requirements.

## Deployment Models

In classic service discovery models, the probe responder (or service location query processor) is deployed on each host.  Conversely, registry based service discovery models have a single centralized (or perhaps federated) model where there is a well-known URL for discovery queries.

The default or generic deployment for Argo is per host.  Where each host has its own Responder daemon process running and services probes for services that live on that host.  This classic model is, in fact, the most resilient model.  If a particular host goes down, then only that host's services are affected from a service discovery perspective.  Further, it prevents exposing a large-grained point of failure to cyber-attacks.

Argo gives you the flexibility to deploy a Responder anywhere along this spectrum that suits your application's needs.

Deployment models can be separated into two main sections

* The Argo Client (Probe sender and Response Listener)
* The Argo Responder

Let's look at the deployment of the Responder first

### One Responder On Every Host

![One Responder On Every Host](https://cloud.githubusercontent.com/assets/1844785/7235816/d5445564-e75e-11e4-8aed-ed1e012cb077.png)

One possible architecture is the `one Responder on every host`.  This is the classic multicast service discovery architecture.  However, you shouldn't be limited to that.  Especially in a long-distance or WAN model, this might not be the best way to go.

There is really nothing wrong with this model.  In fact, I generally recommend it. This deployment model truly helps realize the "2-node" requirement.

*Is it possible to put two Responders on a single host?*

Well, yes actually.  The question is: why would you want to?  I could actually see a couple of custom Responder implementations servicing probes while pulling service records from a number of different sources.  For example, you might have a [OSGi DDF Argo Responder] (https://github.com/di2e/Argo-DDF) as well as a regular Argo Responder on the same host.  They operate quite differently under the hood, but, in the end, just service probes and send responses to the `respondTo:` address.

The idea is that there are a vast number of possibilities.  As Argo is a WAN or long-range protocol, we have no idea how you want your service discovery to work for your application or infrastructure.

### A single Responder for an application deployment

![](https://cloud.githubusercontent.com/assets/1844785/7236533/8c4d2b24-e763-11e4-8e4f-61f19df8d0d9.png)

In the above scenario, you might want to have just a single Argo Responder up and running for a particular set of nodes that might comprise an application deployment context.

You could even have a backup running as a redundant responder should something happen to the main responder, but just remember that both responders will respond to the same probe with the same response.  This is usually not a problem as response listeners should ignore the second

Perhaps the best way to do it is by using something like a Nagios agent or some other monitoring process that will start up a new responder if the main one goes down.

_So why even bring this up?_

This one might make more sense if you are using some other service discovery or registry technology, like you are using Eureka, Curator, Zookeeper or even UDDI.

You might be using Argo for the long-range service discovery and the other technology for your short-range, data center or application specific reasons.

### A single Responder for a Data Center/Virtualization Infrastructure

![](https://cloud.githubusercontent.com/assets/1844785/7236892/d91323a8-e765-11e4-92e2-b1d338c02819.png)

This is similar to the above, except you are running only one Argo Responder for the entire data center.  Again, this is useful if you are using some other service discovery or registry technology, like you are using Eureka, Curator, Zookeeper or even UDDI.

### Mixing Contexts

_Can you have Argo Responders mixed in at multiple levels in  multiple contexts?_

Yup.  No problem.  The idea here is that there is no hierarchical structure or other artificially applied rules to where your responders go or how they relate to one another.

You could have a "Data Center" responder that is responsible for only a "Data Center" specific set of services mixed in with a bunch of "Application" specific responders responsible for their applications services that should be advertised to the network.  Further, this could be mixed in with Responders on hosts as well as Responders that front other registries like UDDI.  The sky is the limit, really.

If you have redundancy, then don't worry.  Sure, there will be a little more network overhead - if that's a problem, you can take care of that.  However, each Argo service instance has a unique identifier that will help you deconflict multiple responses for a particular service instance.  


## Scaling up the Response Listener

Some applications that need to discover services using Argo might end up getting a large number of responses - like thousands - all coming in very quickly.  

Usually, your average application will only get back a couple of services - maybe even a couple hundred.  The performance characteristics of such a Response Listener are usually quite modest.

Response Listeners are RESTful services.  These services can be easily deployed on application servers that can easily provide scalability to the Response Listener.  

There are circumstances where your Response Listener RESTful service might need to handle a large number of probe responses very quickly.  For example, you have built a "service browser" application that will probe for "all services."  Such an application will need to be able to handle a large number of service responses very quickly.  

Response Listeners do not need to "attached" to a particular application.  In fact, several applications can _share_ an Argo Response Listener.  Therefore, if you are expecting lots of services, deploy your Response Listener accordingly in an environement resourced appropriately for such volumes of traffic.