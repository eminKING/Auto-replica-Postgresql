#!/bin/bash
set -e

# --- Шаг 1. Создаем директории данных ---
mkdir -p ./master/master-data ./replica/replica-data

# --- Шаг 2. Фиксим права на хосте ---
echo "Исправляю права на хостовых папках..."
sudo chown -R 999:999 ./master/master-data ./replica/replica-data || true
sudo chmod 700 ./master/master-data ./replica/replica-data || true

# --- Шаг 3. Поднимаем контейнеры ---
echo "Запускаю docker-compose..."
docker-compose up -d

# --- Шаг 4. Ждём, пока контейнеры станут Up ---
echo "⏳ Жду пока контейнеры pg_master и pg_replica станут Up..."
for c in pg_master pg_replica; do
  until [ "$(docker inspect -f '{{.State.Status}}' $c)" == "running" ]; do
    echo "Жду $c..."
    sleep 2
  done
done

# --- Шаг 5. Фиксим права внутри контейнеров ---
echo "Исправляю права внутри контейнеров..."
docker exec -u root pg_master chown -R postgres:postgres /var/lib/postgresql/data
docker exec -u root pg_master chmod 700 /var/lib/postgresql/data

docker exec -u root pg_replica chown -R postgres:postgres /var/lib/postgresql/data
docker exec -u root pg_replica chmod 700 /var/lib/postgresql/data

echo "✅ Готово! PostgreSQL master и replica запущены."

