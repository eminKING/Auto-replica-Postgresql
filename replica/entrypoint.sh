#!/bin/bash
set -e

DATA_DIR="/var/lib/postgresql/data"
MASTER_HOST="pg_master"
MASTER_USER="replica_user"
MASTER_PASSWORD="replica_pass"

# Исправляем права на папку данных
if [ "$(stat -c %u $DATA_DIR)" != "999" ]; then
    echo "Fixing permissions on $DATA_DIR..."
    chown -R 999:999 $DATA_DIR
    chmod 700 $DATA_DIR
fi

export PGPASSWORD="$MASTER_PASSWORD"

# Ждём, пока мастер станет доступен
until pg_isready -h $MASTER_HOST -p 5432 -U $MASTER_USER; do
    echo "Waiting for master to start..."
    sleep 2
done

# Если data пустая — делаем базовый бэкап
if [ -z "$(ls -A $DATA_DIR)" ]; then
  pg_basebackup -h $MASTER_HOST -D $DATA_DIR -U $MASTER_USER -P -R --wal-method=stream
fi

# Запускаем PostgreSQL
exec postgres
