# Flyway Base

Manages flyway migrations for postgres.

## Migration Script Info

The convention for versioned SQL migration scripts:

* Must start with a **_capital_** letter **V** and version number.
* The version is immediately followed by two dashes ` _ _ `.
* End with a brief description of the database changes.

example
```
V1.0.1__AddExampleTable.sql
```

Best coding practices for flyway migration scripts include:

* Write SQL database changes in a way that migration errors won't cause errors in data.
* Keep SQL database changes to a focused change.

## Extended Actions

In addition to Flyway migrations, this image extends Actions including:

* Creating databases
* Migrating databases
* Dropping databases
* Checking if a database exists
* Checking if a table exists in database 

The base image defines and entrypoint script that expects parameters to determine which Action to execute.  Each run of the Docker container will run one specified Action.  Running multiple Actions will require running multiple Docker containers in order.

### Running Actions with Docker Image extending ***bct-flyway-base***


```console

root@pc:~$ docker run [docker-flags] <flyway-base-image> [args]

```

#### [docker-flags]
|Variable name|Description|Possible values
|--|--|--|
|[docker-flags]|
|--network=\<network\>|The docker network name, used often with docker-compose.
|--many others--|Any docker flags you would like to pass into the executor|[Read more](https://docs.docker.com/engine/reference/run/)|

#### [args]
|Variable name|Short|Description|Possible values
|--|--|--|--|
|**--type=\<type\>**|-t|The name of supported database engine|*PostgreSQL*, *SQLServer*|
|**--action=\<action\>**|-a|The Action to run in the container|*CreateDb*, *DropDb*, *MigrateDb*, *ExistsDb*, *ExistsTbl*|
|**--port=\<port\>**|-r|The port to connect to database engine|N/A|
|**--database=\<database\>**|-d|The name of the target database|N/A|
|**--username=\<username\>**|-u|The username to authenticate with|N/A|
|**--password=\<password\>**|-p|The password to authenticate with|N/A|


## Building your own image

We recommend this file structure.  Any changes to this structure must be considered when copying migration scripts and custom Action files into your Docker image.

* At the root level of your image solution, create the following directories:
	* 📁 db
		* 📁 migration-scripts 
			* 📝 V001__Initial_Database_Migration.sql
			* 📝 V002__Changed_Database_Migration.sql

* Create a **_Dockerfile_** with at least these steps

```docker
FROM terumobct/bct-flyway-base
COPY db/migration-scripts /flyway/sql
RUN chmod 777 -R /scripts
```
  
* Build your docker image and use it as defined in the section above ***Running Actions with Docker Image extending bct-flyway-base***

## Example

From the project root, there is a `test` directory with an example of how to use bct-flyway-base.  This example project demonstrates options for customization.  The folder structure does not follow the recommended structure above and demonstrates how the Dockerfile can be customizated.

* **scripts**:
Here are the migration files used by flyway.  Migration files are sql script files and follow the convention `{ datestamp | R }__<description>.sql`.  In this example, PostgreSQL and SQLServer are populated with one semantic versioned script and one repeatable script. (in a real project there may be many scripts).

| Update: A migration example version with a gap was added for testing if flyway handles migration version gaps.
 
* **init-scripts**:
Init scripts are used to overwrite the default scripts.  In this example `example/init-scripts/SQLServer/CreateDb.sql` will overwrite the `CreateDb.sql` script used by `Create.sh`.  The bash scripts that implement the actions can also be replaced as needed.

* **test-scripts**: 
Additional actions can be added.  Here is a query script that is used to verify if flyway migrations were successful

### How to run the example

1) In the dev-tools folder, run the run-example.ps1 script

 ```powershell
 .\dev-tools\run-example.ps1
 ```
 
2) Once the text interface appears, use the numbers 1-8 to run bct-flyway-base action scripts. 1-4 for MsSql actions, and 5-8 for PostgreSQL actions.
 
	* **SQLServer Actions**
	
	 * 1: CreateDb
		 * This runs the default `CreateDb.sh` script which runs the `CreateDb.sql` script.  
		 * For this example, the SQL script was replaced by the SQL script in `example\init-scripts\CreateDb.sql`
		 * Creates a database with name `mssql-db`.
		 * Will print that the database already exists if the database `mssql-db` exists.
		 
	 * 2: DropDb
		 * This runs the default `DropDb.sh` script which runs the default `DropDb.sql` script. 
		 * Drops the database with name `mssql-db`.
		 * Will print the database doesn't exist if the database `mssql-db` doesn't exist.
		  
	 * 3: MigrateDb
		 * This runs the default `MigrateDb.sh` script which runs the default `MigrateDb.sql` script. 
		 * This will fail if the database `mssql-db` doesn't exist.
		 
	 * 4: QueryDb
		 * This runs a custom `QueryDb.sh` script which runs `QueryDb.sql` script.
		 * Prints a list of databases in SQLServer.
		 * Prints all `mssql-db` tables if database exists.
	 
	 * **PostgreSQL Actions**
	 
	 * 5: CreateDb
		 * This runs the default `CreateDb.sh` script which runs the default `CreateDb.sql` script.  
		 * Creates a database with name `psql-db`.
		 * Will print that the database already exists if the database `mssql-db` exists.
		 
	 * 6: DropDb
		 * This runs the default `DropDb.sh` script which runs the default `DropDb.sql` script. 
		 * Drops the database with name `psql-db`.
		 * Will print the database doesn't exist if the database `psql-db` doesn't exist.
		  
	 * 7: MigrateDb
		 * This runs the default `MigrateDb.sh` script which runs the default `MigrateDb.sql` script. 
		 * This will fail if the database `psql-db` doesn't exist.
		 
	 * 8: QueryDb
		 * This runs a custom `QueryDb.sh` script which runs `QueryDb.sql` script.
		 * Prints a list of databases in PostgreSQL Server.
		 * Prints all `psql-db` tables if database exists.

## Custom Actions

Follow these actions to create your custom actions.

1) Create a new `<your-action>.sh` script in your project and include the `#!/bin/bash` header.  `<your-action>` is now the action name you must provide with arguement option `--action=<your-action>`. 

2) Next add the action contract to your script.

```
#!/bin/bash

DatabaseType=""
Action=""
Server=""
Port=""
Database=""
Username=""
Password=""
Table=""
SslMode="disable"

while [ $# -gt 0 ]; do
  case "$1" in
    -t | --type)
      shift
      DatabaseType=$1
      ;;
    --type=*)
      DatabaseType="${1#*=}"
      ;;
    -a | --action)
      shift
      Action=$1
      ;;
    --action=*)
      Action="${1#*=}"
      ;;
    -s | --server)
      shift
      Server=$1
      ;;
    --server=*)
      Server="${1#*=}"
      ;;
    -r | --port)
      shift
      Port=$1
      ;;
    --port=*)
      Port="${1#*=}"
      ;;
    -d | --database)
      shift
      Database=$1
      ;;
    --database=*)
      Database="${1#*=}"
      ;;
    -u | --username)
      shift
      Username=$1
      ;;
    --username=*)
      Username="${1#*=}"
      ;;
    -p | --password)
      shift
      Password=$1
      ;;
    --password=*)
      Password="${1#*=}"
      ;;
    -b | --table)
      shift
      Table=$1
      ;;
    --table=*)
      Table="${1#*=}"
      ;;
    -s | --sslmode)
      shift
      SslMode=$1
      ;;
    --sslmode=*)
      SslMode="${1#*=}"
      ;;
  esac
  shift
done
```

3) Implement your new action.

4) In the Dockerfile, ensure the action is copied into the `/scripts/<databaseType>` docker container directory.

```docker
COPY ./your/custom/scripts/<databaseType> /scripts/<databaseType>
```

5) Build the Dockerfile and run your custom action.

```console
docker run <your-docker-image> <your-action> [contract-options]
```

> Example: `docker run barcodeflyway SpecialQueryDb --server 1.1.1.1 --port 8080 --database myDb --table myTbl --username user --password pass`
