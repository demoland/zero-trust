---
slug: initial-setup
id: 1i58f6vimvfi
type: challenge
title: Vault Initial Setup
teaser: This first section will be for Setting up the Vault Server
notes:
- type: text
  contents: |-
    In this workshop, we will be setting up a Vault server in development mode to securely manage our sensitive information, such as passwords. The Vault server is a powerful tool designed to provide a centralized location for storing and accessing secrets while maintaining high levels of security and encryption.

    Development mode allows us to easily explore and experiment with Vault's features without the need for a full production setup. Please note that this mode is not recommended for production environments, as it uses a simplified, in-memory storage system and automatically unseals the Vault.

    During the workshop, we will guide you through the process of installing, configuring, and interacting with the Vault server in development mode. You will learn how to store and retrieve passwords securely, manage access control, and understand the core principles behind Vault's security model. By the end of this workshop, you will have a solid foundation for using Vault to manage your sensitive data in a more secure and efficient manner.
tabs:
- title: Shell
  type: terminal
  hostname: shell
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
vault status
```

If not running, the `vault status` command will give you the following error:

```bash
Error checking seal status: Get "https://127.0.0.1:8200/v1/sys/seal-status": dial tcp 127.0.0.1:8200: connect: connection refused
```
