---
slug: enable-vault-dynamic-database-credentials
id: mld9behelyks
type: challenge
title: Enable Vault Dynamic Database Credentials
teaser: Walk through the process of Vault Dynamic database credentials for Postgres.
notes:
- type: text
  contents: In this challenge, we will walk through the process of enabling Vault
    Dynamic database credentials for Postgres.
tabs:
- title: Vault Server
  type: terminal
  hostname: vault-server
- title: App Server
  type: terminal
  hostname: app-server
- title: Vault UI
  type: service
  hostname: vault-server
  port: 8200
difficulty: basic
timelimit: 600
---

In the last challenge, we started the Data View web server.  The Data View web server is a Go application that is already installed on the app-server. The web server is located at `/usr/local/bin/dataview`.  The `/etc/dataview.yml` file contains the configuration for the web server.  The dataview.yml file had static credentials in the file that allowed the web server to connect to the postgres database.

Most organizations have to change database passwords at least every 90 days.  Managing these passwords can be a challenge.  Vault can help us manage these passwords and automatically rotate them. Vault can also provide dynamic credentials that are only valid for a short period of time.  This is a great security feature.  If a password is compromised, it will only be valid for a short period of time.

Let's enable Vault Dynamic database credentials for Postgres.

The first step is to  enable the database secrets engine.

In the vault-server terminal, run the following command.

```bash
vault secrets enable database
```

Next, configure the database secrets engine.  We have to tell Vault how to connect to the database.  In this case, Vault becomes the broker of credentials and can manage the lifecycle of a database user/password.

```bash
vault write database/config/users \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="dataview" \
    connection_url="postgresql://{{username}}:{{password}}@app-server:5432/users" \
    username="postgres" \
    password="postgres"
```

A Vault Role is the Authorization Policy for a database user.  We can create a role that will create a database user with a password that is valid for 1 hour.  The role will also grant the user read access to the users table.

We are going to name the role "dataview". The role will be valid for 1 hour.  The role will grant the user read access to the users table.

```bash
vault write database/roles/dataview \
    db_name="users" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"
```

Let's test the role.  We can use the Vault CLI to generate a database credential.  The credential will be valid for 1 hour.

```bash
vault read database/creds/dataview
```

Run the command again to see that each time you query the creds endpoint, you get a new username and password.

```bash
vault read database/creds/dataview
```

Let's test the credentials.  We can use the `psql` command to connect to the database.

This time, let's query from the `App Server` terminal.

```bash
CREDZ=$(vault read -format=json database/creds/dataview)
```

Now we can use `jq` to parse the json and get the username and password.

```bash
PGUSER=$(echo $CREDZ | jq -r '.data.username')
PGPASSWORD=$(echo $CREDZ | jq -r '.data.password')
```

Show the values of the PGUSER and PGPASSWORD variables.

```bash
echo $PGUSER
echo $PGPASSWORD
```

Now that we have the variables set for user and password.  Let's test them by passing them into the `psql` command.

Copy the output from the following commands run in the `Vault Server` and paste them into the `App Server`

Switch to the app-server terminal.

```bash
psql -h app-server -U $PGUSER -d users -c "select Name from users limit 5;"
```

That's great!  But how would I use this in an application?
