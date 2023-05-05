---
slug: install-and-configure-consul
type: challenge
title: Install and Configure Consul
teaser: In this challenge we will install and configure a consul-server as the service registry for our application.
notes:
- type: text
  contents: Replace this text with your own text
tabs:
- title: Consul-Server
  type: terminal
  hostname: consul-server
#- title: App-Code
#  type: code
#  hostname: app-server
#  path: /root/dataview
difficulty: basic
timelimit: 600
---

Consul is at the heart of our Zero Trust Machine to Machine communication.  Consul offers a service registry mechanism that allows our applications to discover each other and communicate securely.  In this challenge we will install and configure a consul-server as the service registry for our application.

The Consul data directory is where Consul stores its state data, such as the list of registered services and their health checks.
