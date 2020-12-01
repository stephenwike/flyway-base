#!/usr/bin/env pwsh

$ErrorActionPreference = "stop"

docker build -t bct-flyway-base -f ./src/Dockerfile .
docker build -t testing -f ./test/Dockerfile .

###### TESTS FOR POSTGRESQL ############################################################################################

# Test: Does database not exist after DropDb is called.
docker run --network=dev-tools_default testing --type PostgreSQL --action DropDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action ExistsDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
if ($?) { Write-Error "Database psql-db exists after DropDb was called." }

# Test: Does database exist after CreateDb is called.
docker run --network=dev-tools_default testing --type PostgreSQL --action DropDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action CreateDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action ExistsDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
if (!$?) { Write-Error "Database psql-db doesn't exist after CreateDb was called." }

# Test: Does database not have account and facility table before migration.
docker run --network=dev-tools_default testing --type PostgreSQL --action DropDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action CreateDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action ExistsTbl --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!" --table "account"
if ($?) { Write-Error "The 'account' table exists before MigrateDb called." }
docker run --network=dev-tools_default testing --type PostgreSQL --action ExistsTbl --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!" --table "facility"
if ($?) { Write-Error "The 'facility' table exists before MigrateDb called." }

# Test: Does database have account and facility tables after migration.
docker run --network=dev-tools_default testing --type PostgreSQL --action DropDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action CreateDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action MigrateDb --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
docker run --network=dev-tools_default testing --type PostgreSQL --action ExistsTbl --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!" --table "account"
if (!$?) { Write-Error "The 'account' table does not exists after MigrateDb called." }
docker run --network=dev-tools_default testing --type PostgreSQL --action ExistsTbl --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!" --table "facility"
if (!$?) { Write-Error "The 'facility' table does not exists after MigrateDb called." }


###### TESTS FOR SQLSERVER ############################################################################################

# Test: Does database not exist after DropDb is called. 
docker run --network=dev-tools_default testing --type SQLServer --action DropDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action ExistsDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
if ($?) { Write-Error "Database sql-server-db exists after DropDb was called." }

# Test: Does database exist after CreateDb is called.
docker run --network=dev-tools_default testing --type SQLServer --action DropDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action CreateDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action ExistsDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
if (!$?) { Write-Error "Database sql-server-db doesn't exist after CreateDb was called." }

# Test: Does database not have account and facility table before migration.
docker run --network=dev-tools_default testing --type SQLServer --action DropDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action CreateDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action ExistsTbl --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*" --table "account"
if ($?) { Write-Error "The 'account' table exists before MigrateDb called." }
docker run --network=dev-tools_default testing --type SQLServer --action ExistsTbl --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*" --table "facility"
if ($?) { Write-Error "The 'facility' table exists before MigrateDb called." }

# Test: Does database have account and facility tables after migration.
docker run --network=dev-tools_default testing --type SQLServer --action DropDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action CreateDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action MigrateDb --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
docker run --network=dev-tools_default testing --type SQLServer --action ExistsTbl --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*" --table "account"
if (!$?) { Write-Error "The 'account' table does not exists after MigrateDb called." }
docker run --network=dev-tools_default testing --type SQLServer --action ExistsTbl --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*" --table "facility"
if (!$?) { Write-Error "The 'facility' table does not exists after MigrateDb called." }
