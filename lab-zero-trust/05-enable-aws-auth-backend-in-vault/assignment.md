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
- title: Vault-Code
  type: code
  hostname: vault-server
  path: /root/dataview
difficulty: basic
timelimit: 600
---
First thing we want to do is enable the AWS auth backend in Vault. This will allow us to authenticate and authorize AWS IAM users and roles to access secrets in Vault. When we enable the AWS auth backend, we can create roles that map to AWS IAM principals, such as IAM users and roles. Vault then uses the AWS access key ID and secret access key associated with the IAM principal to authenticate and authorize access to secrets.

```bash
vault auth enable -description="AWS IAM user for Vault AWS auth backend" aws
```

Next, we need to configure the AWS auth backend. We need to provide the AWS access key ID and secret access key of an IAM user or role that has permission to call the `AWS STS GetCallerIdentity API.` This is required for Vault to validate the AWS IAM credentials of the IAM principal that is trying to authenticate.

```bash
vault write auth/aws/config/client  secret_key=$AWS_SECRET_ACCESS_KEY  access_key=$AWS_ACCESS_KEY_ID
```

Check to see if the AWS auth backend is enabled:

```bash
vault auth list
```

Look for `aws/` in the output.

## In the UI

In the **Vault-UI** tab, login to the Vault UI using the root token.  Click on the **Access** tab and then click on **Auth Methods**.  You should see `aws/` in the list of auth methods.

The AWS authentication backend is enabled.  In the next challenge, we'll create a web server and a database that will interact with eachother and depend on Vault for dynamic secrets. We will use the AWS auth backend to authenticate and authorize the web server and database to access secrets in Vault.

## In the `Shell` window, create a policy for the dataview role

The policy is the document that states what attributes the role has. In this case, we want to allow the role to read the `secret/data/dataview` path in Vault. We also want to allow the role to renew its own token.

Let's create the policy file:

```bash
cat << EOF > /root/dataview/dataview-policy.hcl
# Allow a token to renew itself
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Add list of leases presently applicable to any mount
path "sys/leases/lookup" {
  capabilities = ["list"]
}

# List accessor IDs of all generated tokens present in the Vault
path "auth/token/accesors" {
    capabilities = ["list"]
}

# Dataview Policy
path "database/creds/dataview" {
  capabilities = ["read", "list"]
}

EOF
```

Now write that policy to Vault:

```bash
vault policy write dataview /root/dataview/dataview-policy.hcl
```

Configure the dataview role. Tie to the dataview policy and set the max_ttl to 1h

```bash
vault write auth/aws/role/dataview \
  auth_type=iam \
  policies=dataview \
  max_ttl=1h \
  bound_iam_principal_arn="arn:aws:iam::$AWS_ACCOUNT_ID:*"
```

Try logging in to Vault with the AWS auth backend now. This authentication will use AWS credentials to authenticate to Vault. These AWS credentials are associated with an IAM principal that has permission to call the `AWS STS GetCallerIdentity API.`

```bash
vault login -method=aws role=dataview access_key=$AWS_ACCESS_KEY_ID secret_key=$AWS_SECRET_ACCESS_KEY
```

Last, run a `vault policy read` on the `dataview` policy to see what permissions it has.

```bash
vault policy read dataview
```

Now, access the credentials in `database/creds/dataview`:

```bash
vault read database/creds/dataview
```

In the next challenge we will use the Vault agent to manage these dynamic credentials and automatically renew them.
