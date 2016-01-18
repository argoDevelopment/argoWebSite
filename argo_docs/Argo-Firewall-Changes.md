# **Argo Firewall Changes**

In order to use the Argo protocol, there are some changes that you need to make to the firewall of the hosts that run the Argo Responder.  You may need to make some changes to any other firewalls that separate traffic which you'd like Argo messages to traverse.

These changes are not hard and usually won't freak out your network admin people.

___NOTE:  If anyone can tell me the BSD `pfctl` commands, I would appreciate it___

### Argo Responder Host Firewall Changes

For CENTOS 7, the following are the commands that you should execute:

```
firewall-cmd --permanent --zone=public --add-port=4003/udp
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p igmp -j ACCEPT
```

For CENTOS 6.x or any OS that uses IPTABLES, the following are the commands that you should execute:

```
iptables -I INPUT 1 -p udp --dport 4003 -j ACCEPT
iptables -I INPUT -p igmp -j ACCEPT
service iptables save
```

### Argo VPN Multicast Gateway Host Firewall Changes

The VPN Multicast Gateway requires one more port to be opened.  That is the unicast port to send the tunneled multcast traffic.  The standard port is 4018.

For CENTOS 7, the following are the commands that you should execute:


```
firewall-cmd --permanent --zone=public --add-port=4018/tcp
```

For CENTOS 6.x or any OS that uses IPTABLES, the following are the commands that you should execute:

```
iptables -I INPUT 1 -p tcp -m tcp --dport 4018 -j ACCEPT
```

