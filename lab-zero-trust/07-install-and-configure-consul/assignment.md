---
slug: install-and-configure-consul
id: gmv2umlf5rnp
type: challenge
title: Install and Configure Consul
teaser: In this challenge we will install and configure a consul-server as the service
  registry for our application.
notes:
- type: text
  contents: Consul is at the heart of our Zero Trust machine-to-machine communication.  Consul
    affords us PKI infrastructure to secure our communications and service discovery
    to allow our applications to find each other.  Consul also provides a mechanism
    for our applications to register their health and for Consul to monitor the health
    of our applications.  Consul is a critical component of our Zero Trust architecture.
tabs:
- title: Consul-Server
  type: terminal
  hostname: consul-server
- title: Consul UI
  type: service
  hostname: consul-server
  path: /ui/
  port: 8500
- title: Consul-Code
  type: code
  hostname: consul-server
  path: /etc/consul/config
difficulty: basic
timelimit: 600
---

 In this challenge we will install and configure a consul serveer as the service registry for our application.

In the `Consul-Code` tab, let's look at the consul configuration used in this challenge.

All of the `*.hcl` files in this directory are concatenated at runtime to create the consul configuration file.
