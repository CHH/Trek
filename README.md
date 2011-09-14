
Trek
========

Assists you on your journy through the mountainous areas of Database
Scheme Managment.

Trek works for now *only in MySQL*, though the basic foundation
is there for supporting other Database Systems. SQLite support is
already planned.

Install
-------

Just clone the git repo somewhere and point your `PATH` to
the `bin` directory.

Usage
-----

The `trek` command delegates to subcommands depending on the
first argument.

Project Setup
-------------

All `trek` commands operate by default on the current Working Directory.
Trek takes the Database credentials by default from a file named
`dbconfig`. A sample `dbconfig` could look like this:

```sh
# Provide a Unix socket
socket=
# or simply use a hostname
hostname=localhost
# Override standard port
port=
database=my_database
username=root
password=toor
```

`trek` also accepts a `--config` option to specify which `dbconfig` you
want to use. This is useful for separate configs for development (local
MySQL) and production (usually remote MySQL server).

After you've a working `dbconfig` you must run `trek init` to setup your
database for Trek.

Migration DSL
-------------

Each Migration is a Shell script. Trek provides quite a few functions
to ease the writing of these scripts.

### create_table

#### Usage

```
create_table <table> [column <column_name> [<options,...>],...]
```

Example:

```sh
create_table users\
    column id int unsigned primary key auto_increment\
    column username text
# Executes:
CREATE TABLE users (id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, username TEXT);

Important Commands
------------------

### trek-new

Creates files for a new migration. All arguments given are concatenated
with dashes and form the migration's file name.

Example:

```
$ trek new create users
Created 20110913204758-create-users.up
Created 20110913204758-create-users.down
```

The `.up` file contains all code which should be executed when the
database's version is increased. The `.down` file is executed when
the database is migrated to a previous version. The `.down` file
should do the exact opposite of the `.up` file.

### trek-migrations

Lists all migrations and marks the most recently applied migration
with a star.

Example:

```
$ trek migrations
  20110913195207-create-users
  20110913200524-add-birthday-to-user
* 20110913204621-add-enabled-to-user
```

### trek-migrate

Probably the most important command. Invoked with no arguments
`trek-migrate` applies all migrations which are not applied.

It also takes an optional second argument, which specifies a version
to migrate to. If this version is lower as the current database version
then the scheme changes are reverted up to the given version. If the
given version is higher as the current Database version then the `.up`
migrations are applied until the given version is reached.

Example:

We start with an empty database at version `0`.

```
$ trek version
0
```

Migrate up to the latest version:

```
$ trek migrate
Executing 20110913195207-create-users.up
Executing 20110913200524-add-birthday-to-user.up
Executing 20110913204621-add-enabled-to-user.up
Database is now at version 20110913204621
```

Just pass a version number lower than every other to 
migrate the Database all down.

```
$ trek migrate 0
Executing 20110913204621-add-enabled-to-user.down
Executing 20110913200524-add-birthday-to-user.down
Executing 20110913195207-create-users.down
Database is now at version 0
```

Here we pass a version number to migrate up:

```
$ trek migrate 20110913200524
Executing 20110913195207-create-users.up
Executing 20110913200524-add-birthday-to-user.up
Database is now at version 20110913200524
```
