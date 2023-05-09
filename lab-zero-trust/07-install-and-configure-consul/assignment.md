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
  path: /etc/consul.d
difficulty: basic
timelimit: 600
---

 In this challenge we will configure a consul server as the service registry for our application.

### Create the gossip encryption key

Gossip is used to maintain a cluster membership list, to propagate health checks, and to disseminate configuration changes.  This data is encrypted using a gossip encryption key.  Let's create the gossip encryption key and generate the `consul-gossip-encryption.hcl` file.

Set environment variables to use in the rest of the workflow:

```bash
export DOMAIN="opengov.co"
export NODENAME="consul-server"
export DATACENTER="dc1"
export CONSUL_CONFIG_DIR="/etc/consul.d"
export CONSUL_CERT_DIR="/etc/consul.d/certs"
```

```bash
export CONSUL_GOSSIP_KEY=$(consul keygen)
cat << EOF > ${CONSUL_CONFIG_DIR}/consul-gossip-encryption.hcl
encrypt = "$CONSUL_GOSSIP_KEY"
EOF
```

* Write the Gossip key to the Vault cluster for the App server to use later

```hcl
vault kv put secret/consul/gossip key=$CONSUL_GOSSIP_KEY
```

### Configure Consul Encryption

* Generate the TLS certificates for RPC encryption

Consul uses TLS to encrypt the RPC communication between consul servers. The RPC communication is for updating the service data between nodes.   Let's generate the TLS certificates.

* We have to first, create the Certificate Authority (CA)

Create the Certs directory:

```bash
mkdir -p ${CONSUL_CERT_DIR}
cd ${CONSUL_CERT_DIR}
```

Create the CA:

```bash
consul tls ca create -domain ${DOMAIN}
```

* Now, Create the certificates for the consul server (This would be done multiple times if you had multiple consul servers)

```bash
consul tls cert create -server -dc ${DATACENTER} -domain ${DOMAIN} -server -node ${NODENAME}
```

You should now have 4 files:
**Example:**

```bash,nocopy
-rw------- 1 root root  227 May  6 10:33 ${DOMAIN}-agent-ca.pem
-rw-r--r-- 1 root root 1074 May  6 10:33 ${DOMAIN}-agent-ca-key.pem
-rw------- 1 root root  227 May  6 10:33 ${DATACENTER}-server-${DOMAIN}-0.pem
-rw-r--r-- 1 root root  964 May  6 10:33 ${DATACENTER}-server-${DOMAIN}-0-key.pem
```

* Write the root CA certificate that you generated so the consul clients can use it to verify the server certificate.

```bash
vault kv put secret/consul/ca_file  key=@${CONSUL_CERT_DIR}/${DOMAIN}-agent-ca.pem
vault kv put secret/consul/cert_file key=@${CONSUL_CERT_DIR}/${DATACENTER}-server-${DOMAIN}-0.pem
vault kv put secret/consul/key_file key=@${CONSUL_CERT_DIR}/${DATACENTER}-server-${DOMAIN}-0-key.pem
```

### Configure the consul server

* Create the consul server configuration file

```bash
touch ${CONSUL_CONFIG_DIR}/server.hcl
chown --recursive consul:consul ${CONSUL_CERT_DIR}
chmod 640 ${CONSUL_CONFIG_DIR}/server.hcl
```

* Create the Consul Server configuration file:

```bash
cat << EOF > ${CONSUL_CONFIG_DIR}/server.hcl
node_name = "consul-server"
server = true
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
domain = "${DOMAIN}"
datacenter = "${DATACENTER}"
data_dir = "${CONSUL_CONFIG_DIR}/data"
bootstrap_expect = 1
pid_file = "${CONSUL_CONFIG_DIR}/consul.pid"

connect {
  enabled = true
}

addresses {
  grpc = "0.0.0.0"
}

ports {
  grpc_tls  = 8503
}

tls {
   defaults {
      ca_file = "${CONSUL_CERT_DIR}/${DOMAIN}-agent-ca.pem"
      cert_file = "${CONSUL_CERT_DIR}/${DATACENTER}-server-${DOMAIN}-0.pem"
      key_file = "${CONSUL_CERT_DIR}/${DATACENTER}-server-${DOMAIN}-0-key.pem"
      verify_incoming = true
      verify_outgoing = true
   }
   internal_rpc {
      verify_server_hostname = true
   }
}

auto_encrypt {
  allow_tls = true
}

ui_config {
  enabled = true
}

EOF
```

### Start the Consul Server

When consul starts, it will read all the files in the `/etc/consul.d` directory.
Let's review the files in this directory:

* Open the `Consul-Code` tab and review the files in the `/etc/consul.d` directory.

* Now, let's start the consul server:

```bash
chown -R consul:consul ${CONSUL_CONFIG_DIR}
systemctl start consul
```

* Verify the consul server is running

```bash
systemctl status consul
```

* Review the Consul UI.

Open the `Consul-UI` tab and login to the Consul UI using the bootstrap token.

* Login to the Consul server, click on `Tokens` in the left-hand pane of the Consul-UI.  You can now see the bootstrap token there.

* Click on `Services` in the left-hand pane of the Consul-UI.  You can now see the consul service running.

* Click on `Nodes` in the left-hand pane of the Consul-UI.  You can now see the consul server node running.

* Click on `Key/Value` in the left-hand pane of the Consul-UI.  You can now see the consul key/value store.

* Click on `Intentions` in the left-hand pane of the Consul-UI.  You can now see the consul intentions.

**Congratulations!** You've configured and started the Consul server!  You've setup the gossip encryption key, the TLS certificates, and the consul server configuration.  You've also bootstrapped the ACL system and can now interact with the Consul server.

Next, we'll register our `dataview` service with the Consul Server.
