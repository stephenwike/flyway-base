#!/bin/bash

Usage() {
    echo ""
    echo "USAGE: run.sh [Options]"
    echo ""
    echo "Option               Name            Description"
    echo "------------------------------------------------------------------"
    echo "-t | --type[=]       DatabaseType    The type of database supported server."
    echo "                                     e.g. PostgreSQL, SQLServer"
    echo "-a | --action[=]     Action          The name of the action script to be"
    echo "                                     executed."
    echo "-s | --server[=]     Server          The Server IP or Server Hostname for the" 
    echo "                                     supported database server."
    echo "-r | --port[=]       Port            The Port Address for the supported" 
    echo "                                     database server."
    echo "-d | --database[=]   Database        The name of the target database."
    echo "-u | --username[=]   Username        The username to be used when interacting" 
    echo "                                     with the target database."
    echo "-p | --password[=]   Password        The password of the user specified with"
    echo "                                     the Username option."
    echo "-b | --table[=]      Table           (Optional) The name of a table within a" 
    echo "                                     target database.  Used with ExistsTbl"
    echo "                                     action only."
    echo "-m | --sslmode[=]    SslMode         (Optional) Determines how database"
    echo "                                     encryption is handled."
    echo "-h | --help          Help            Prints the command usage."
}

initArgs=$@
DatabaseType="PostgreSQL"
Action=""
Server=""
Port="5432"
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
    -h | --help)
      Usage
      exit 0
      ;;
    *)
      echo ""
      echo "ERROR: INVALID USAGE: run.sh"
      echo "Unrecognized Option: $1"
      Usage
      exit 1
      ;;
  esac
  shift
done

echo "Run: DatabaseType ${DatabaseType} Action ${Action} Server ${Server} Port ${Port} Database ${Database} Username ${Username} Password ${Password} Table ${Table}" 
./${DatabaseType}/${Action}.sh $initArgs