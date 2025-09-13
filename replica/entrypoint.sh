#!/bin/bash
set -e

DATA_DIR="/var/lib/postgresql/data"

# Если data пустая — делаем базовый бэкап
if [ -z "$(ls -A $DATA_DIR)" ]; then
  
  pg_basebackup -h pg_master -D $DATA_DIR -U replica_user -P -R
  
fi
