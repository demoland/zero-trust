---
slug: install-consul-agent-on-app-server
id: 5jeh0ylkhrnc
type: challenge
title: Install Consul agent on App-Server
teaser: Install and configure the Consul client for the dataview and postgres-db services.  These  services
  to automatically register with the Consul server.
notes:
- type: text
  contents: By using Consul client to register your local services you benefit from
    automated service discovery and monitoring.  In a dynamic environment, having
    services easily discovered by other services, makes it simpler to establish connections
    and maintain communication between different parts of your system. Additionally,
    Consul provides a range of health checking capabilities that can help you quickly
    identify and resolve issues with your services, ensuring that your system remains
    highly available and reliable. By leveraging Consul's service registration capabilities,
    you can optimize the way you manage your distributed systems and improve the overall
    performance and reliability of your applications."
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

We're going to start the Consul agent on the `app-server` node.  Then we'll register the dataview and postgres-db services with the Consul server.

* Set Consul Environment variables:

```bash
export DOMAIN="opengov.co"
export NODENAME="app-server"
export DATACENTER="dc1"
export CONSUL_CONFIG_DIR="/etc/consul.d"
export CONSUL_CERT_DIR="${CONSUL_CONFIG_DIR}/certs"
```

* We'll start out by creating the Consul agent configuration file:

In the `app-server` terminal, create the Consul agent configuration file:

```bash
vault kv get -format=json secret/consul/ca_file | jq -r .data.data.key > ${CONSUL_CERT_DIR}/${DOMAIN}-agent-ca.pem
```

First, let's define the gossip encryption file.

```bash
cat << EOF > ${CONSUL_CONFIG_DIR}/consul-gossip-encryption.hcl
encrypt = "$(vault kv get -format=json secret/consul/gossip | jq -r .data.data.key)"
EOF
```

Next, let's define the Consul agent configuration file.

```bash
echo "Create Consul-agent configuration"
cat << EOF > ${CONSUL_CONFIG_DIR}/consul-agent.hcl

node_name = "${NODENAME}"
server = false
datacenter = "${DATACENTER}"
data_dir = "${CONSUL_CONFIG_DIR}/data"
domain = "${DOMAIN}"

log_level = "INFO"
log_file = "${CONSUL_CONFIG_DIR}/logs/consul.log"
retry_join = ["consul-server"]

tls {
   defaults {
      ca_file = "${CONSUL_CERT_DIR}/${DOMAIN}-agent-ca.pem"
      verify_incoming = true
      verify_outgoing = true
   }
   internal_rpc {
      verify_server_hostname = true
   }
}

auto_encrypt = {
  tls = true
}

EOF
```

* Start the Consul Server:

```bash
chown -R consul:consul ${CONSUL_CONFIG_DIR}
systemctl start consul
```
