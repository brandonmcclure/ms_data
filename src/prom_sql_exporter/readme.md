# src/prom_sql_exporter

This is a service that will export data from our sql database. As it is, it is horribly insecure. It is using our default password which is saved in plain text in the git repo! 

## Journal

## 2024.03.12 - Start SQL exporter

The connection string in sql_exporter.yml file requires encoding the special characters with golangs' `net/url` module. For the default password which contains a `@`, we replace it with `%40`
