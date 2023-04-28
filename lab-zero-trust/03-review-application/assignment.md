---
slug: review-application
id: pol8netencvp
type: challenge
title: Review Application
teaser: A short description of the challenge.
notes:
- type: text
  contents: Replace this text with your own text
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