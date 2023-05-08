---
slug: install-consul-agent-on-app-server
id: 5jeh0ylkhrnc
type: challenge
title: Install Consul agent on App-Server
teaser: Install and configure the Consul client for the dataview and postgres-db services.  These  services to automatically register with the Consul server. 
notes:
- type: text
  contents: By using Consul client to register your local services and benefit from automated service discovery and monitoring.  In a dynamic envisonment, having services easily discovered by other services, makes it simpler to establish connections and maintain communication between different parts of your system. Additionally, Consul provides a range of health checking capabilities that can help you quickly identify and resolve issues with your services, ensuring that your system remains highly available and reliable. By leveraging Consul's service registration capabilities, you can optimize the way you manage your distributed systems and improve the overall performance and reliability of your applications."
tabs:
- title: App-Server
  type: terminal
  hostname: app-server
- title: Consul UI
  type: service
  hostname: consul-server
  path: /ui/
  port: 8500
- title: App-Code
  type: code
  hostname: app-server
  path: /etc/consul.d
difficulty: basic
timelimit: 600

---
Install Consul on App-Server

We're going to start the Consul agent on the app-server node.  Then we'll register the dataview and postgres-db services with the Consul server.

* We'll start out by creating the Consul agent configuration file:

```bash

cat << EOF > /etc/consul.d/consul-agent.hcl

```hcl

```
