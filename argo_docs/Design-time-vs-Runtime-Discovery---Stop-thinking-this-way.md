# "Design-time vs Runtime Discovery" - ***Stop thinking this way!!***

Ok.  The first thing I'd like to point out here is that there isn't really any "Design-time vs Runtime."  It's not a useful way of looking at things.  So, let's stop thinking this way.  It's not productive.

## What is "Runtime Service Discovery"

When we say "runtime," we mean that software that is actually running, will perform some configuration by sending out probes on the network (or queries to a central repository if you still want to think that way) to get the IP address of remote services.  There are a couple of use-cases where this can be done.  Here are a few examples.

* Administrative Setup or Recovery
* Operator-Driven Integration
* Moving Target Defense for a Cyber attack

The important thing to note here is that this is done in the context of software that has been deployed on some computer (laptop or data center server).  

The mechanics of Runtime Service Discovery runs the gamut from sophisticated and automatic service probes across the network, to querying some "central repository" to calling up the system administrator and asking "hey, what's the IP address again?"

### Machine Oriented

All these mechanisms accomplish the same thing; the get the IP address (or other runtime connection/configuration information) and plug that information into some running software.

## What is "Design-time Service Discovery"

This is what developers do when they are looking for "services or assets" to include or connect to while developing an application.  "Design-time Service Discovery" is far better described as "Locating and consuming Technical Profiles and service interface specifications during system development."

It's also a sub-set of what can be described as "Enterprise IT Asset Management."

However, mostly it's the process that developers go through to find technical specifications and documentation that allows them to write the software they are working on.  "Discovering" doesn't necessarily mean going to a single or centralized "list of approved stuff."  Practically, it means searching the internet (or intranet), finding stuff they already know about via professional engineering knowledge and/or re-using software libraries and interfaces from other systems.

Google gets used a lot in this process.  Plus developers will peruse various well-known sources of components such as Apache.org, SourceForge, Github, Bitbucket, etc. - the list is long.

### Human Oriented

All of this only ever happens when software is being written.  It will also only ever be done by humans - automating software development to this degree doesn't exist yet.  You'll never to "Design-time" anything when the software goes into "production" and is used in anger by real users.
