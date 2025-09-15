#!/bin/bash
set -e

mkdir -p ./master/master-data ./replica/replica-data

# Выставляем права для Postgres (uid:gid 999:999)
sudo chown -R 999:999 ./master/master-data ./replica/replica-data
sudo chmod 700 ./master/master-data ./replica/replica-data

sudo docker-compose up -d
