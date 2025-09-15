#!/bin/bash
set -e

DATA_DIR="/var/lib/postgresql/data"

chmod 700 "$DATA_DIR"
chown postgres:postgres "$DATA_DIR"

exec postgres
