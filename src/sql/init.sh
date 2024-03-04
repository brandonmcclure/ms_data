echo "Checking SQL Server"
STATUS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d master -Q "SET NOCOUNT ON; SELECT 1" -W -h-1 )
while [ "$STATUS" != 1 ]
do
sleep 1s
 
echo "Checking SQL Server"
STATUS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -d master -l 300 -Q "SET NOCOUNT ON; SELECT 1" -W -h-1 )
done
 
echo "SQL UP, creating databases!"

/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d master -i /usr/bin/CreateDBs.sql
sleep 10s

echo "DBS created, installing Ola Hallengren maintenance solution"

/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d dba -i /usr/bin/MaintenanceSolution.sql

echo "DBS created, installing Brent Ozar First Responder Kit"
/opt/mssql-tools/bin/sqlcmd -S localhost -V16 -U sa -P $MSSQL_SA_PASSWORD -l 300 -d dba -i /usr/bin/Install-All-Scripts.sql