#!/bin/bash

DatabaseType=""
Action=""
Server=""
Port=""
Database=""
Username=""
Password=""
Table=""

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
  esac
  shift
done

echo "${DatabaseType}: ${Action} --> Server: ${Server} Port: ${Port} Database: ${Database} Username: ${Username} Password: ${Password}"

cp /flyway/sql/SQLServer-Expand/V2020.01.02__AddColumnNameToAccount.sql /flyway/sql/SQLServer/

ls /flyway/sql/SQLServer/

/flyway/flyway -user=${Username} -password=${Password} -url="jdbc:sqlserver://$Server:$Port;databaseName=$Database" -locations="filesystem:/flyway/sql/SQLServer" -outOfOrder="true" migrate


