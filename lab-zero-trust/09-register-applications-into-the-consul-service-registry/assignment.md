---
slug: register-applications-into-the-consul-service-registry
id: q51qvkf94i8u
type: challenge
title: Register applications into the Consul Service Registry
teaser: In this challenge we are going to register the dataview and postgres-db services
  with the Consul server.
notes:
- type: text
  contents: Consul Connect enables secure service-to-service communication with automatic
    TLS encryption and identity-based authorization. Consul Connect can be used with
    or without service discovery. When used with service discovery, Consul Connect
    enables secure service-to-service communication with automatic TLS encryption
    and identity-based authorization. When used without service discovery, Consul
    Connect enables secure service-to-service communication with automatic TLS encryption
    and identity-based authorization.
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
  path: /etc/consul.ds
difficulty: basic
timelimit: 800
---

Let's start by registering the dataview service with the Consul server.

```bash
export DOMAIN="opengov.co"
export NODENAME="app-server"
export DATACENTER="dc1"
export CONSUL_CONFIG_DIR="/etc/consul.d"
export CONSUL_CERT_DIR="${CONSUL_CONFIG_DIR}/certs"
```

Before we define the service, run the following commands:

```bash
consul members
consul catalog services
```

* Let's define the dataview service.

```bash
cat << EOF > ${CONSUL_CONFIG_DIR}/dataview.hcl
service {
  name = "dataview"
  id = "dataview"
  port = 8888
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "postgres-db"
            local_bind_port  = 5432
          }
        ]
      }
    }
  }
  check {
    name     = "dataview"
    tcp      = "app-server:8888"
    interval = "10s"
    timeout  = "1s"
  }
}
EOF
```

* Change permissions to the consul user.

```bash
chown -Rf consul:consul dataview.hcl
```

Reload the consul service.

```bash
consul reload
```

Now run that consul members and consul catalog services commands again.

```bash
consul members
consul catalog services
```

* Let's look at the Consul UI and see the differences.  Click ok the `Services tab.`
Change permissions on the dataview file.
You should see that the consul service catalog has two new services.  The problem is that it looks like the service is unhealthy.  That's because the postgres-db upstream service doesn't exist yet.  Let's fix that.

```bash
cat << EOF > ${CONSUL_CONFIG_DIR}/postgres-db.hcl
service {
  name = "postgres-db"
  id = "postgres-db"
  port = 5432
  connect {
    sidecar_service {}
  }
  check {
    name     = "postgres-db"
    tcp      = "app-server:5432"
    interval = "10s"
    timeout  = "1s"
  }
}
EOF
```

* Change permissions to the postgres service file.

```bash
chown -Rf consul:consul ${CONSUL_CONFIG_DIR}/postgres-db.hcl
```

* Run the consul validate script to ensure that all the consul configuration files are valid.

```bash
consul validate .
```

* Reload Consul:

```bash
consul reload
```

* Run the Consul catalog services commands.
Now you should see the new postgres applications.

```bash
consul catalog services
```

* Now, let's check the status of the Consul agent in the `Consul UI` tab.
You should see that the dataview and postgres-db services are still not healthy.

We need to start the consul envoy sidecars:

```bash
systemctl start consul-dataview-sidecar
systemctl start consul-postgres-sidecar
```

* Check the `Consul UI` tab one more time. You should now see 3 healthy services.