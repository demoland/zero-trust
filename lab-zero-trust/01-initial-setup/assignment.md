---
slug: initial-setup
id: 1i58f6vimvfi
type: challenge
title: Vault Initial Setup
teaser: Setup a Vault server in development mode.  Development mode allows us to easily
  explore and experiment with Vault's features without the need for a full production
  setup.
notes:
- type: text
  contents: |-
    In this challenge, we will be setting up a Vault server in development mode to securely manage our sensitive information, such as passwords. The Vault server is a powerful tool designed to provide a centralized location for storing and accessing secrets while maintaining high levels of security and encryption.

    Development mode allows us to easily explore and experiment with Vault's features without the need for a full production setup. Please note that this mode is not recommended for production environments, as it uses a simplified, in-memory storage system and automatically unseals the Vault.
- type: image
  url: ../assets/images/intro-vault.png
tabs:
- title: Vault CLI
  type: terminal
  hostname: vault-server
- title: Vault UI
  type: service
  hostname: vault-server
  path: /ui/
  port: 8200
difficulty: basic
timelimit: 600
---

## This is the first line

Check to see what version of Vault is installed on your system.

```bash
vault version
```

Check to see if Vault is running.

```bash
vault status
```

Check the set Vault variables, used to connect to the local Vault server:

```bash
echo $VAULT_ADDR
echo $VAULT_TOKEN
```

Check which secrets mounts are enabled

```bash
vault secrets list
```

Write static information to the  `secret/info` path on your Vault server:

Set variables for your name and age:

```bash
user="<username>"
age="<age>"
```

Write your name and age to the secret/info path:

```bash
vault kv put secret/info name="${user}" age="${age}"
```

Retrieve the entered information from the secret/info path:

```bash
vault kv get secret/info
```

Switch to the `Vault UI` tab and login with the root token.
The root token can be found by running the following command:

```bash
echo $VAULT_TOKEN
```

Once logged in, navigate to the `secret/info` path and verify that the information you entered is displayed.
