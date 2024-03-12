# src/sql

Our base SQL instance


## Journal

## 2024.03.12 - Refining the init system of the image

While fiddling with this project last night, my SQL container stopped running. It would start, and I could see the SQL log entries like:

```
Database 'msdb' running the upgrade step from version 938 to version 939.
```

and then it would fail. I set the ms_sql service in the [docker-compose](../../docker-compose.yml) file to **not** restart on failure. This is so that I can more easily identify issues with my init and entrypoint scripts.

### entrypoint.sh

### init.sh

This script is responsible for deploying the `dba` database and then installing the latest first responder and maintenance scripts.

1. poll the instance to check that we can connect to the `master` database. This tells us when the instance is up
2. Execute the `CreateDBs.sql` file. This file will create the database with the setting we want
3. poll the instance to check that the `dba` database exists. I ran into race conditions if I proceeded without checking first
4. Install the Maintenance script
5. Install the first responder script

### Diving into my issues 

First off, I noticed that I had not set the shebang to ensure that the files are being executed with Bash and not Bourne shell. Not sure if that caused any problems, but that was a quick fix. 

Next, I know from experience that the issue was inside of my init.sh script because the entrypoint script just launches the sqlserver process, and then the init.sh script. It is difficult to view the logs from my script amongst the sql server logs. To help me track down my issue, I temporarloly routed stdout stream from `/opt/mssql/bin/sqlservr` to null by replaceing the following line in the dockerfile from this:

```
/opt/mssql/bin/sqlservr & \
```

to this:

```
/opt/mssql/bin/sqlservr 2>&1 1> /dev/null & \
```

This let me see my init script logs easier, which let me find the root problem quickly. The first part of the script that polled if the instance was ready was not looping and re-checking the status. This caused the script to barrel forward, and then fail on the further steps because the db did not exist so of course it could not log in.

I also changed my entrypoint script to use [bash job control](https://docs.docker.com/config/containers/multi-service_container/#use-bash-job-controls) so that we can launch the main sql server process, and then allow the init.sh process to run to completion before switching the sql server process back to the foreground
