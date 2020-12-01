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
    -m | --sslmode)
      shift
      SslMode=$1
      ;;
    --sslmode=*)
      SslMode="${1#*=}"
      ;;
  esac
  shift
done

echo "${DatabaseType}: ${Action} --> Server: ${Server} Port: ${Port} Database: ${Database} Username: ${Username} Password: ${Password} SslMode: ${SslMode,,}"

sed "s/%%DATABASE%%/${Database}/g" /scripts/PostgreSQL/CreateDb.sql > /scripts/PostgreSQL/updated-createDb.sql

PGPASSWORD=${Password} psql "host=${Server} port=${Port} dbname=postgres user=${Username} sslmode=${SslMode,,}" -f /scripts/PostgreSQL/updated-createDb.sql