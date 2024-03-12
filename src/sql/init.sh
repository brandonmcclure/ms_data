#!/bin/bash

echo "Checking SQL Server"
failedCheckCount=0
STATUS=0

while [ "$STATUS" != 1 ]
do
    STATUS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d master -Q "SET NOCOUNT ON; SELECT 1" -W -h-1 )
    
    if [[ failedCheckCount -eq 12 ]] ; then
        echo 'Database initialization took longer than 120 seconds, aborting'
        exit 1
    fi
    failedCheckCount=$failedCheckCount+1
    sleep 10s
done

STATUS=0
failedCheckCount=0
echo "SQL UP, creating databases!"
while [ "$STATUS" != 1 ]
do
    /opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d master -i /usr/bin/CreateDBs.sql
    sleep 10s

    echo "Checking dba database"
    STATUS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -d dba -l 300 -Q "SET NOCOUNT ON; SELECT 1" -W -h-1 )
    if [[ failedCheckCount -eq 120 ]] ; then
        echo '[admin] database creation took longer than 120 seconds, aborting'
        exit 1
    fi
    failedCheckCount=$failedCheckCount+1
done

echo "DBS created, installing Ola Hallengren maintenance solution"

/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d dba -i /usr/bin/MaintenanceSolution.sql

echo "DBS created, installing Brent Ozar First Responder Kit"
/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d dba -i /usr/bin/Install-All-Scripts.sql
