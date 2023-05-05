---
slug: use-vault-agent-for-dynamic-credential-management
id: v2gs9es6dmmw
type: challenge
title: Use Vault Agent for Dynamic credential Management
teaser: Manage dynamic database credentials for your application with the Vault agent.
notes:
- type: text
  contents: |-
    The Vault Agent can be used to inject dynamic database credentials into an application server configuration. This allows for hands-off management of credentials, as the Vault Agent will automatically update the credentials when they are rotated.

    To use the Vault Agent to inject dynamic database credentials, you will need to do the following:

    * Install the Vault Agent on the application server.
    * Configure the Vault Agent to connect to Vault.
    * Create a secret in Vault that contains the database credentials.
    * Configure the Vault Agent to inject the secret into the application server configuration.

    Once you have completed these steps, the Vault Agent will automatically inject the database credentials into the application server configuration whenever the credentials are rotated. This allows you to manage the database credentials in a central location and ensures that the application server is always using the latest credentials.
tabs:
- title: App-Server
  type: terminal
  hostname: app-server
- title: App-Code
  type: code
  hostname: app-server
  path: /root/dataview
difficulty: basic
timelimit: 600
---
In this exercise we are replacing the `dataview.yml` static credentials with a new file called `dataview-dynamic.yml`.

In order to do this there are 3 key files.  Two are already created and the third are dynamically generated.  Let's review them.

The `App-Code` tab has the following files:

* `vault-agent-config.hcl` - This is the configuration file for the Vault agent. It will be used to configure the Vault agent to generate the `dataview-dynamic.yml` file.

* `dataview-dynamic.tpl` - This is a template file that will be used by the Vault agent to generate the `dataview-dynamic.yml` file.

This file is automatically generated when the vault agent is started:

* `dataview-dynamic.yml` - This is the new configuration file for the application. It will be used to configure the application to use the Vault agent.

As a refresher, let's read the database credentials from the dynamic path:

```bash
vault read database/creds/dataview
```

Now, let's review the vault agent start script:

```bash
cat /etc/systemd/system/dataview.service
```

The Vault agent is started with the following command:

```bash
systemctl start vault-agent
```

Now we should see a new file generated in the `App-Code` tab:
It will be called `dataview-dynamic.yml`

Tail the vault-agent logs:

```bash
tail -f /var/log/vault-agent/*.log
```

Let's review the dataview service script:

```bash
cat /etc/systemd/system/dataview.service
```

You can see that we've changed the configuration file away from the `/etc/dataview.yml` to the new file: `/root/dataview/dataview-dynamic.yml`

Old dataview config file:

```bash
cat /etc/dataview.yml
```

New dataview config file:

```bash
cat /root/dataview/dataview-dynamic.yml
```

Let's start the dataview service now that it's configured to use the dynamic credentials:

```bash
systemctl start dataview
```

Now let's test the application:

```bash
curl -s http://app-server:8888 |jq -r .
```

Let's check the /root/dataview directory to see the new files created:

The `vault-token-via-agent` file contains the Vault token that was used to generate the dynamic credentials.

This token was dynamically generated by using the AWS authentication method.

The `dataview-dynamic.yml` file that was generated by the Vault agent.