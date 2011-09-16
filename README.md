Trek
====

Assists you on your journy through the mountainous areas of Database
Scheme Managment.

Trek works for now *only in MySQL*, though the basic foundation
is there for supporting other Database Systems. SQLite support is
already planned.

Install
-------

Just clone the git repo somewhere and add the `bin` directory to your `$PATH`.

Usage
-----

    trek [-C|--chdir <path>] [-c|--config <file>] [-m|--migrations <path>] <command> [options]

Arguments:

 * `command`: Trek Subcommand

Options:

 * `-C|--chdir`: Change the working directory to this directory
   before executing the Trek Command
 * `-c|--config`: File to read the Database Config from, defaults to
   `dbconfig` in the current working directory.
 * `-m|--migrations`: Directory where migrations are located, defaults
   to the current working directory.

Project Setup
-------------

All `trek` commands operate by default on the current Working Directory.
Trek takes the Database credentials by default from a file named
`dbconfig`.

The following settings are supported:

 * `database` (required)
 * `socket`
 * `hostname`
 * `port`
 * `username`
 * `password`

A sample `dbconfig` could look like this:

    hostname=localhost
    database=my_database
    username=root
    password=toor

`trek` also accepts a `--config` option to specify which `dbconfig` you
want to use. This is useful for separate configs for development (local
MySQL) and production (usually remote MySQL server).

After you've a working `dbconfig` you must run `trek init` to setup your
database for Trek.

Important Commands
------------------

### trek-commands

Shows all subcommands of `trek`.

Usage:

    trek commands

### trek-help

Shows help for the given command, show's Trek's usage message if no
command is given.

Usage:

    trek help [<command>]

### trek-new

Usage:
    
    trek new <migration-name>

Creates files for a new migration. All arguments given are concatenated
with dashes and form the migration's file name.

Example:

    $ trek new create users
    Created 20110913204758-create-users.up
    Created 20110913204758-create-users.down

The `.up` file contains all code which should be executed when the
database's version is increased. The `.down` file is executed when
the database is migrated to a previous version. The `.down` file
should do the exact opposite of the `.up` file.

For more information on migrations see the [Readme about migrations](docs/migrations.md).

### trek-migrations

Usage:

    trek migrations

Lists all migrations and marks the most recently applied migration
with a star.

Example:

    $ trek migrations
      20110913195207-create-users
      20110913200524-add-birthday-to-user
    * 20110913204621-add-enabled-to-user

### trek-migrate

Usage:

    trek migrate [<version>]

Probably the most important command. Invoked with no arguments
`trek-migrate` applies all migrations up to and including the latest.

It also takes an optional second argument, which specifies a version
to migrate to. If this version is lower as the current database version
then the scheme changes are reverted up to the given version. If the
given version is higher as the current Database version then the `.up`
migrations are applied until the given version is reached.

Example:

We start with an empty database at version `0`.

    $ trek version
    0

Migrate up to the latest version:

    $ trek migrate
    Executing 20110913195207-create-users.up
    Executing 20110913200524-add-birthday-to-user.up
    Executing 20110913204621-add-enabled-to-user.up
    Database is now at version 20110913204621

Just pass a version number lower than every other (for example Zero) to 
purge the whole database:

    $ trek migrate 0
    Executing 20110913204621-add-enabled-to-user.down
    Executing 20110913200524-add-birthday-to-user.down
    Executing 20110913195207-create-users.down
    Database is now at version 0

Here we pass a version number to migrate up to that version:

    $ trek migrate 20110913200524
    Executing 20110913195207-create-users.up
    Executing 20110913200524-add-birthday-to-user.up
    Database is now at version 20110913200524

## License

The MIT License

Copyright (c) 2011 Christoph Hochstrasser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
