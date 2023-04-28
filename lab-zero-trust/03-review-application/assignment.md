---
slug: review-application
id: pol8netencvp
type: challenge
title: Review Application
teaser: In this challenge, we will review the database information and load data into
  the database.
notes:
- type: text
  contents: |-
    In this example, OpenGovCo has a Postgres database with a list of their users.  
    The database is a Postgres database.
    The database is located at $PGHOST:$PGPORT
    The username can be accessed by the $PGUSER username
    The password can also be accessed by the $PGPASSWORD variable.
    The database can be accessed by the $PGDB variable.

    In this challenge we will load user data into the Postgres Database.
    The data is located in the file: `/tmp/users.json`
    The data can be loaded into the database using the dataloader command:
tabs:
- title: Shell
  type: terminal
  hostname: app-server
difficulty: basic
timelimit: 600
---

For the purposes of this lab, we've setup a Postgres database and a user/password.

Connect to the database with the following command:

```bash
sudo -u postgres -i
psql
```

Now list the databases:

```bash
\list
```

You are looking to see the `users` database.

Now connect to the `users` database:

```bash
\connect users
```

List the tables:

```bash
\list
```

Connect to the Database with `psql`:

```bash
psql -U $PGUSER -d $PGDB -h $PGHOST -p $PGPORT -W
```

When you are prompted for a password, use the password in the `$PGPASSWORD` variable.

List the tables:

```bash
\dt
```

Exit the database:

```bash
\q
```

## Load Data

Now that you have reviewed the database, you will load data into the database.

The data is located in the file: `/tmp/users.json`

Load the data into the database using the dataload command:

```bash
dataload -host $HOSTNAME -db $PGDB  -p $PGPORT -f /tmp/users.json -P $PGPASSWORD
```

