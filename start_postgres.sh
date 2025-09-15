#!/bin/bash
set -e
# --- Шаг 1. Создаем директории данных ---
mkdir -p ./master/master-data ./replica/replica-data

# --- Шаг 2. Фиксим права на хосте ---
echo "Исправляю права на хостовых папках..."
sudo chown -R 999:999 ./master/master-data || true
sudo chown -R 999:999 ./replica/replica-data || true

# --- Шаг 3. Поднимаем контейнеры ---
echo "Запускаю docker-compose..."
docker-compose up -d

# --- Шаг 4. Фиксим права внутри контейнеров ---
echo "Исправляю права внутри контейнеров..."
docker exec -u root pg_master chown -R postgres:postgres /var/lib/postgresql/data
docker exec -u root pg_replica chown -R postgres:postgres /var/lib/postgresql/data
