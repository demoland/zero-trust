---
slug: initial-setup
id: 1i58f6vimvfi
type: challenge
title: Vault Initial Setup
teaser: This first section will be for Setting up the Vault Server
notes:
- type: text
  contents: |-
    In this challenge, we will be setting up a Vault server in development mode to securely manage our sensitive information, such as passwords. The Vault server is a powerful tool designed to provide a centralized location for storing and accessing secrets while maintaining high levels of security and encryption.

    Development mode allows us to easily explore and experiment with Vault's features without the need for a full production setup. Please note that this mode is not recommended for production environments, as it uses a simplified, in-memory storage system and automatically unseals the Vault.
tabs:
- title: Shell
  type: terminal
  hostname: vault-server
difficulty: basic
timelimit: 600
---

## This is the first line

Check to see what version of Vault is installed on your system.

```bash
which vault
vault version
```

Check to see if Vault is running.

```bash
ps -ef |grep vault
```

Set The Environment variables to connect to the local Vault server:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
vault status
```

Check which secrets mounts are enabled

```bash
vault  secrets list
```
