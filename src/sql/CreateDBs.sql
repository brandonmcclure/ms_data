if (DB_ID('dba') is null)
begin
    CREATE DATABASE [dba]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dba', FILENAME = N'/var/opt/mssql/data/dba.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dba_log', FILENAME = N'/var/opt/mssql/data/dba_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )

end