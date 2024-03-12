#!/bin/bash
set -m

/opt/mssql/bin/sqlservr & \
 (/usr/bin/init.sh; rc=$?; if [[ $rc != 0 ]]; then echo "init.sh failed with code $rc" && kill $(ps aux | grep 'sqlservr' | awk '{print $2}'); fi)
fg %1

