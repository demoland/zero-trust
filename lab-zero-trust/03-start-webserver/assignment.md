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
difficulty: basic
timelimit: 800
---

Let's start the Data Viewer web server.

```bash
systemctl start dataview
```

Let's check the status of the Data Viewer web server.

```bash
systemctl status dataview
```

You should get the following output.

```bash,nocopy
dataview.service - DataView Service for Getting Users
    Loaded: loaded (/etc/systemd/system/dataview.service, enabled)
    Active: active (running)
```

Let's query the Dataviewer web server to get a random user.

With `curl`, we can run the following command to query the Dataviewer web server.

```bash
curl -s http://app-server:8888
```

Try running the command multiple times.

You should get random users each time.

This is a very simple web server, giving us user information.

The configuration file for this web application can be found in /etc:

```bash
cat /etc/dataview.yml
```

Notice the static credentials in the `dataview.yml` file. We will be changing this in future challenges by injecting dynamic credentials from Vault.

Now we have a web server running, that can query the users in a database and display them in `json` format.
