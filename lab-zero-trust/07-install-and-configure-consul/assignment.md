---
slug: install-and-configure-consul
id: gmv2umlf5rnp
type: challenge
title: Install and Configure Consul
teaser: In this challenge we will install and configure a consul-server as the service registry for our application.
notes:
- type: text
  contents: Consul is at the heart of our Zero Trust machine-to-machine communication.  Consul affords us PKI infrastructure to secure our communications and service discovery to allow our applications to find each other.  Consul also provides a mechanism for our applications to register their health and for Consul to monitor the health of our applications.  Consul is a critical component of our Zero Trust architecture.
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

```bash
CONSUL_GOSSIP_KEY=$(consul keygen)
cat << EOF > /etc/consul.d/consul-gossip-encryption.hcl
encrypt = "$CONSUL_GOSSIP_KEY"
EOF
```

### Configure Consul Encryption

**Generate the TLS certificates for RPC encryption**
Consul uses TLS to encrypt the RPC communication between consul servers. The RPC communication is for updating the service data between nodes.   Let's generate the TLS certificates.

* We have to first, create the Certificate Authority (CA)

Create the Certs directory:

```bash
mkdir -p /etc/consul.d/certs
cd /etc/consul.d/certs
```

Create the CA:

```bash
consul tls ca create
```

* Now, Create the certificates for the consul server (This would be done multiple times if you had multiple consul servers)

```bash
consul tls cert create -server -dc dc1 -domain consul
```

You should now have 4 files:
**Example:**

```bash,nocopy
-rw------- 1 root root  227 May  6 10:33 consul-agent-ca-key.pem
-rw-r--r-- 1 root root 1074 May  6 10:33 consul-agent-ca.pem
-rw------- 1 root root  227 May  6 10:33 dc1-server-consul-0-key.pem
-rw-r--r-- 1 root root  964 May  6 10:33 dc1-server-consul-0.pem
```

### Configure the consul server

* Create the consul server configuration file

```bash
sudo touch /etc/consul.d/server.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/server.hcl
```

* Enable Consul Server and Bootstrap Expect

```bash
cat << EOF >> /etc/consul.d/server.hcl
server = true
bootstrap_expect = 1
EOF
```

* Setup Bind and client IP address to listen on the main IP interface:

```bash
cat << EOF >> /etc/consul.d/server.hcl
bind_addr = 0.0.0.0
client_addr = 0.0.0.0
EOF
```

* Enable Consul Connect:
Consul connect uses Envoy as the reverse proxy between services.  Consul connect also provides service segmentation, which allows us to control which services can communicate with each other.  This is a critical component of our Zero Trust architecture. This communication happens via GRPC.  We need to enable GRPC and set the port to 8502.

```bash
cat << EOF >> /etc/consul.d/server.hcl
connect {
  enabled = true
}

addresses {
  grpc = "127.0.0.1"
}

ports {
  grpc  = 8502
}
EOF
```

* Enable the Consul UI. This will allow us to view the Consul UI in the browser.

```bash
cat << EOF >> /etc/consul.d/server.hcl

ui_config {
  enabled = true
}
EOF
```

### Start the Consul Server:

When consul starts, it will read all the files in the `/etc/consul.d` directory.
Let's review the files in this directory:

* Open the `Consul-Code` tab and review the files in the `/etc/consul.d` directory.

* Now, let's start the consul server:

```bash
systemctl start consul
```

* Verify the consul server is running

```bash
systemctl status consul
```

### Bootstrap the ACL system

The last step before we can interact with the Consul server is to bootstrap the Consul ACLs.   This will create the initial token and policy that we will use to configure our consul server.

This bootstrap token should be stored in an encrypted vault. For the purposes of this lab, we will store it in a file.

```bash
consul acl bootstrap > /etc/consul.d/consul-bootstrap-token.out
```

The response normally looks like this but we are saving to a file for use later.

```bash,nocopy
AccessorID:       687969a7-a840-bfd9-4adb-43a447d4237c
SecretID:         13c2c45c-59c9-039d-cb25-89e0ea05e3b1
Description:      Bootstrap Token (Global Management)
Local:            false
Create Time:      2023-05-07 09:20:21.933822946 +0000 UTC
Policies:
   00000000-0000-0000-0000-000000000001 - global-management
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
