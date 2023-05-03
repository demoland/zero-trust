---
slug: enable-aws-auth-backend-in-vault
id: kozci6glywpy
type: challenge
title: Enable AWS Auth Backend in Vault
teaser: Enable the AWS auth backend in Vault to simplify access control for your applications
  running on AWS. By mapping AWS IAM principals to Vault roles, you can use existing
  AWS access keys to authenticate and authorize access to secrets in Vault
notes:
- type: text
  contents: |-
    Enabling the AWS auth backend in Vault allows you to authenticate and authorize AWS IAM users and roles to access secrets in Vault. When you enable the AWS auth backend, you can create roles that map to AWS IAM principals, such as IAM users and roles. Vault then uses the AWS access key ID and secret access key associated with the IAM principal to authenticate and authorize access to secrets.

    By setting up the AWS auth backend in Vault, you can simplify access control for your applications running on AWS. Instead of having to manage separate credentials for accessing secrets in Vault, your applications can use their existing IAM credentials to access Vault. This reduces the risk of credentials leakage and makes it easier to manage access control policies.
tabs:
- title: Shell
  type: terminal
  hostname: vault-server
- title: Vault UI
  type: service
  hostname: vault-server
  port: 8200
difficulty: basic
timelimit: 600
---
First thing we want to do is enable the AWS auth backend in Vault. This will allow us to authenticate and authorize AWS IAM users and roles to access secrets in Vault. When we enable the AWS auth backend, we can create roles that map to AWS IAM principals, such as IAM users and roles. Vault then uses the AWS access key ID and secret access key associated with the IAM principal to authenticate and authorize access to secrets.

```bash
vault auth enable aws
```

Next, we need to configure the AWS auth backend. We need to provide the AWS access key ID and secret access key of an IAM user or role that has permission to call the `AWS STS GetCallerIdentity API.` This is required for Vault to validate the AWS IAM credentials of the IAM principal that is trying to authenticate.

```bash
vault write auth/aws/config/client \
 access_key="$AWS_ACCESS_KEY_ID" \
 secret_key="$AWS_SECRET_ACCESS_KEY" \
 region=us-west-2
```

Check to see if the AWS auth backend is enabled:

```bash
vault auth list
```

Look for `aws/` in the output.

## In the UI

In the **Vault-UI** tab, login to the Vault UI using the root token.  Click on the **Access** tab and then click on **Auth Methods**.  You should see `aws/` in the list of auth methods.

The AWS authentication backend is enabled.  In the next challenge, we'll create a web server and a database that will interact with eachother and depend on Vault for dynamic secrets. We will use the AWS auth backend to authenticate and authorize the web server and database to access secrets in Vault.
