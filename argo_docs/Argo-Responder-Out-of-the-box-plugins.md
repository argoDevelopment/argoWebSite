---
title: Argo Responder Out-of-the-box plugins
tags: [plugin]
keywords: plugin, components, deployment, installation
last_updated: January 15, 2015
summary: "Overview of the protocol, architecture and components of Argo"
---

The Argo Responder has a number of out-of-the-box plug-ins that can be included and configured to handle Argo probes.  Remember that the Argo Responder can be configured with multiple plug-ins simultaneously so that you can get multiple response effects from a single running responder.

There isn't any artificial limitation on what you can do with a plug in.


As of Argo v0.2.3, the out-of-the-box plug-ins include:

* Configuration file
* mDNS (Bonjour) adaptor

Future plugins will can be found at the [Argo Plugins Github repository](https://github.com/argoPlugins).

## Plug-in Interface

The Argo Responder plug-in interface is really simple.

```java
package ws.argo.Responder.plugin;

import java.io.IOException;

import ws.argo.Responder.ProbePayloadBean;
import ws.argo.Responder.ResponsePayloadBean;

public interface ProbeHandlerPluginIntf {

	public ResponsePayloadBean probeEvent(ProbePayloadBean payload);
	public void setPropertiesFilename(String filename) throws IOException;
}
```
### Thread Safe `probeEvent`

The only caveat is that the `probeEvent(ProbePayloadBean payload)` method be thread safe.  The Argo Responder instantiates just one handler for the Responder instance.  This keeps the probe processing overhead far lower.

## Adding a Plug-in to a Responder

In order to add a plugin to a Responder, you need to declare it in the responder configuration file

```
probeHandlerClassname.1=ws.argo.Responder.plugin.ConfigFileProbeHandlerPluginImpl
probeHandlerConfigFilename.1=/opt/argo/config/configFileProbeHandlerConfig.prop
```
You can have multiple probe handler classes specified.  Just repeat the above lines and change the number to the next higher number.

You also must make sure your specified classname is on the classpath.

The `probeHandlerConfigFilename` value will be send into the `setPropertiesFilename(String filename)` method with the probe handler is initialized.

## Configuration File Plug-in

The most basic plug-in is the Configuration File plug in.  This will allow the responder to read a local configuration `xml` file with declared service instances.  More on the Configuration File plug-in [here]().

## The mDNS Plug-in

A more complex plug-in is the mDNS plug-in.  It will respond with link-local DNS-SD entries.  There is no configuration necessary for this plug-in at the moment.  More information about the mDNS plug-in can be found [here]().
