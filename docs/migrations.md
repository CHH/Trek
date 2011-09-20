
How to write Migrations
=======================

In this example we will use Trek to create a `users` table and then do
some schema changes, the same way they would occur through the emergent
design of a real project.

First we will start with the creation of the `users` table. To create a
new migration just call `trek new` with a descriptive migration name.

We want to create a table users, so let's name the migration "create
users":

    $ trek new create users
    Created 20110913204758-create-users.up
    Created 20110913204758-create-users.down

This created two files for us in the our current working directory:

 * a `.up` file, which gets called if the schema's version should be
   incremented
 * and a `.down` file, which should exactly revert the changes done by
   the `.up` file

That means for our example:

 * The `.up` file should create the `users` table.
 * The `.down` file should drop the `users` table.

### Aside:

You noticed that the migrations contain a number as first part of the
file name. This number is a timestamp in the form
<YearMonthDayHourMinuteSecond> and, once migrated, is written into the
database as version number.

Now back to our example.

For now the generated migrations do exactly nothing (because they're
empty). We must throw some statements into them, so they do something
useful.

In the `.up` file write the following:

    create_table users\
        column id int unsigned primary key auto_increment\
        column username text

And in the `.down` file we drop the table:

    drop_table users

Now they actually do something!

Let's migrate our database and see what will happen! The `trek migrate`
command does exactly what we want:

    $ trek migrate
    Executing 20110913204758-create-users.up
    Database is now at version 20110913204758

Now let's take a look at our database:

    $ trek query <<< "describe users;"
    Field	Type	Null	Key	Default	Extra
    id	int(11) unsigned	NO	PRI	NULL	auto_increment
    username	text	YES		NULL	

Success!

But, hey wait! How can we tell if a user is who he pretends to be
once he logs into our service?

Oh my god, we forgot the `password` column! (/play drama)

Stay calm. It's very simple to fix. Just create a new migration, this
time we want to add the `password` column to the `users` table, so we call 
it "add password to users":

    $ trek new add password to users
    Created 20110913214603-add-password-to-users.up
    Created 20110913214603-add-password-to-users.down

In the `.up` file we write:

    add_column users password text

We drop the column in the `.down` file:

    remove_column users password

Then we migrate our database again:

    $ trek migrate
    Executing 20110913214603-add-password-to-users.up
    Database is now at version 20110913214603

Now the schema should be alright:

    $ trek query <<< "describe users;"
    Field	Type	Null	Key	Default	Extra
    id	int(11) unsigned	NO	PRI	NULL	auto_increment
    username	text	YES		NULL	
    password	text	YES		NULL	

Phew, that was close! Mission accomplished!

The example is finished now, so we will look a bit more in depth
at the language which Trek provides for writing migrations.

Trek's DSL
----------

The easiest command is the `execute` command. This command lets you run
raw SQL against the database. The `execute` command
takes exactly one argument: the SQL query.

Though, beware! If you have a golden hammer, everything looks like a
nail!
It has quite an important drawback: Your migrations will most probably
only work on one kind of Database.

So my suggestion is, to use this at your own risk, to plug the holes
left by higher-level commands.

Trek provides you with quite a few commands which automate common 
tasks in schema managment, without doing SQL.


