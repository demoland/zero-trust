---
slug: data-load
id: pol8netencvp
type: challenge
title: Load User Data
teaser: In this challenge, we will review the database information and load data into
  the database.
notes:
- type: text
  contents: |+
    In this example, OpenGovCo has a Postgres database with a list of their users.

    The following variables will be helpful when trying to interact with the database.

    The database is located at `$HOSTNAME:$PGPORT`

    The username can be accessed by the `$PGUSER` username

    The password can also be accessed by the `$PGPASSWORD` variable.

    The database can be accessed by the `$PGDB` variable.

    **Challenge  Objectives:**

    In this challenge we will load user data into the Postgres Database.

    The data is located in the file: `/tmp/users.json`

    We will load data into the database using the `dataload` command

    Then we will query the database to see the data with unencrypted PII.

tabs:
- title: Shell
  type: terminal
  hostname: app-server
difficulty: basic
timelimit: 800
---

For the purposes of this lab, we've setup a Postgres database and a user/password.

```bash
sudo -u postgres -i psql
```

Now list the databases:

```bash
\list
```

You are looking  for the `users` database.

Now connect to the `users` database:

```bash
\connect users
```

List the databases:

```bash
\list
```

Exit the database:

```bash
\q
```

## Load Data

Now that you have reviewed the database, you will load data into the database.

The data is located in the file: `/tmp/users.json`

Read the /tmp/users.json file to see the data:

```bash
cat /tmp/users.json | jq -r .
```

Check the database to ensure it is empty:

```bash
psql -U $PGUSER -d $PGDB -h $PGHOST -p $PGPORT -c "select * from users;"
```

You should get the following response:

```sql,nocopy
ERROR:  relation "users" does not exist
LINE 1: select * from users;
```

Load the data into the database using the dataload command:

```bash
dataload -hostname $HOSTNAME -database $PGDB  -port $PGPORT -file /tmp/users.json -password $PGPASSWORD
```

Connect to the database:

View the name, email, socialsecurity, and creditcard colums to view from the database:

```bash
psql -h app-server -p 5432 -U postgres -d users -c "select name, email, socialsecurity, creditcard from users;"
```

Awesome!  We now have data in the database. In the next challenge we'll startup a web server to query the database.
