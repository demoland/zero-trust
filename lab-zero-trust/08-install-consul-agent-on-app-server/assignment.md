---
slug: install-consul-agent-on-app-server
type: challenge
title: Install Consul agent on App-Server
teaser: A short description of the challenge.
notes:
- type: text
  contents: Replace this text with your own text
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
  path: /etc/consul.d
difficulty: basic
timelimit: 600
---
