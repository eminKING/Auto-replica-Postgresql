#!/bin/bash
set -e

DATA_DIR_MASTER="./master/master-data"
DATA_DIR_REPLICA="./replica/replica-data"

mkdir -p "$DATA_DIR_MASTER" "$DATA_DIR_REPLICA"

# Владелец Postgres
sudo chown -R 999:999 "$DATA_DIR_MASTER" "$DATA_DIR_REPLICA"
sudo chmod 700 "$DATA_DIR_MASTER" "$DATA_DIR_REPLICA"

# Конфиги
sudo chmod 600 "$DATA_DIR_MASTER/postgresql.conf" "$DATA_DIR_MASTER/pg_hba.conf"

sudo docker-compose up -d
