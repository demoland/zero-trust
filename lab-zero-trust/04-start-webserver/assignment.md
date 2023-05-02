---
slug: start-webserver
id: ceexva7kgc78
type: challenge
title: Start WebServer
teaser: Start a webserver that interacts with the postgres database and queries and
  displays a random user.
notes:
- type: text
  contents: |
    In this challenge, you will start the Data Viewer web server. This web server
    will interact with the postgres database and query and display a random user.

    The Data Viewer web server is a Go application that is already installed on the
    app-server. The web server is located at `/usr/local/bin/dataviewer`.
tabs:
- title: App Server
  type: terminal
  hostname: app-server
- title: Vault Server
  type: terminal
  hostname: vault-server
- title: Vault UI
  type: service
  hostname: vault-server
  port: 8200
difficulty: basic
timelimit: 600
---

Let's start the Data Viewer web server.

```bash
systemctl start dataview
```

Query the Dataviewer web server to get a random user.

Using curl, we can run the following command to query the Dataviewer web server.

```bash
curl -s http://app-server:8888
```
