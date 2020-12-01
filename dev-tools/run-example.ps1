#!/usr/bin/env pwsh

docker build -t bct-flyway-base -f .\src\Dockerfile .
docker build -t example-migration -f .\test\Dockerfile .

Push-Location -Path "./dev-tools"
    docker-compose up -d
Pop-Location

function Run-Action($DBType, $Action)
{
    Write-Host "----| $DBType | Running $Action..."
    Write-Host ""

    switch($DBType) {
    "SQLServer" {
        docker run --network=dev-tools_default example-migration --type $DBType --action $Action --server sql-server-db --port 1433 --database "mssql-db" --username "sa" --password "c3kgC5#Adfl*"
        break
    }
    "PostgreSQL" {
        docker run --network=dev-tools_default example-migration --type $DBType --action $Action --server postgres-db --port 5432 --database "psql-db" --username "devtools_user" --password "DevTools1!"
        break
    }
    default { 
        Write-Host "Database Type Not Supported." 
    }}
}

function Prompt([ref]$run) 
{
    Write-Host ""
    Write-Host "        --------------------------------------"
    Write-Host "        |      -CHOOSE AN OPTION (1-8)-      |"
    Write-Host "        --------------------------------------"
    Write-Host "        |  -SQLServer-    |   -PostgreSQL-   |"
    Write-Host "        --------------------------------------"
    Write-Host "        |  1) createdb    |   5) createdb    |"
    Write-Host "        |  2) dropdb      |   6) dropdb      |"
    Write-Host "        |  3) migratedb   |   7) migratedb   |"
    Write-Host "        |  4) querydb     |   8) querydb     |"
    Write-Host "        --------------------------------------"
    Write-Host ""

    $option = $Host.UI.RawUI.ReadKey();
    switch ($option.Character)
    {
        1 {  
            Run-Action -DBType "SQLServer" -Action "CreateDb"
            break
        }
        2 {  
            Run-Action -DBType "SQLServer" -Action "DropDb"
            break
        }
        3 {  
            Run-Action -DBType "SQLServer" -Action "MigrateDb"
            break
        }
        4 {  
            Run-Action -DBType "SQLServer" -Action "QueryDb"
            break
        }
        5 {  
            Run-Action -DBType "PostgreSQL" -Action "CreateDb"
            break
        }
        6 {  
            Run-Action -DBType "PostgreSQL" -Action "DropDb"
            break
        }
        7 {  
            Run-Action -DBType "PostgreSQL" -Action "MigrateDb"
            break
        }
        8 {  
            Run-Action -DBType "PostgreSQL" -Action "QueryDb"
            break
        }
        9 {
            Run-Action -DBType "SQLServer" -Action "SecondMigrate"
        }
        default { $run.Value=$false }
    }
}

$run = $true

while($run)
{
    Prompt -run ([ref]$run)
}

Push-Location -Path "./dev-tools"    
    docker-compose down -v
Pop-Location