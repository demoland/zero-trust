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
timelimit: 600
---

Let's start by registering the dataview service with the Consul server.

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
  check {
    name     = "dataview"
    type     = "tcp"
    interval = "10s"
    timeout  = "1s"
  }
}
EOF
```

Now, let's register the postgres-db service with the Consul server.

```bash
cat << EOF > ${CONSUL_CONFIG_DIR}/postgres-db.hcl
service {
  name = "postgres-db"
  id = "postgres-db"
  port = 5432
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
  check {
    name     = "postgres-db"
    type     = "tcp"
    interval = "10s"
    timeout  = "1s"
  }
}
EOF
```

Now, let's restart the Consul agent.

```bash
systemctl restart consul
```

Now, let's check the status of the Consul agent in the `Consul UI` tab.
