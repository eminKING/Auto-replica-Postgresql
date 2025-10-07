🐘 PostgreSQL Automatic Replication — README
📘 Description

This project sets up PostgreSQL master–replica replication using Docker Compose with custom Docker images.

Node	Description
Master	Main database node
Replica	Secondary node copying data from Master

Before starting, the user must choose the role of the server (Master or Replica). You can also change default passwords in the configuration.

⚙️ Setup Steps
1️⃣ Install Docker
sudo snap install docker

2️⃣ Clone the project
git clone https://github.com/<your_username>/postgresql-auto-replication.git
cd postgresql-auto-replication

3️⃣ Decide the role

Master → main node

Replica → secondary node

4️⃣ Edit configuration (optional)

For replica, replace MASTER_IP with the master’s IP.

File path:

postgresql-auto-replication/replica/docker-compose.replica.yml

Example:
services:
  pg_replica_init:
    image: postgres:15
    container_name: pg_replica_init
    environment:
      PGPASSWORD: replica_pass
    entrypoint: >
      sh -c "
        echo 'Waiting for master...';
        rm -rf /var/lib/postgresql/data/*
        until pg_isready -h 10.1.1.1 -p 5432 -U postgres; do sleep 1; done;
        echo 'Starting basebackup...';
        pg_basebackup -h 10.1.1.1 -D /var/lib/postgresql/data -U replica_user -Fp -Xs -P -R;
      "
    volumes:
      - ./replica/replica-data:/var/lib/postgresql/data
    restart: no

  pg_replica:
    build: .
    container_name: pg_replica
    depends_on:
      - pg_replica_init
    volumes:
      - ./replica/replica-data:/var/lib/postgresql/data
    ports:
      - "5433:5432"
    restart: unless-stopped

volumes:
  replica-data:

5️⃣ Navigate to the correct directory

Master:

cd postgresql-auto-replication


Replica:

cd postgresql-auto-replication/replica

6️⃣ Start container with build

Master:

docker-compose -f docker-compose.master.yml up -d --build


Replica:

docker-compose -f docker-compose.replica.yml up -d --build

7️⃣ Verify replication
docker-compose -f docker-compose.replica.yml logs -f


Check that the replica connects to the master.

🔧 Notes & Tips

Each server is either Master or Replica, never both.

MASTER_IP must be correct for replication to work.

Passwords and credentials can be customized.

Ensure network connectivity if servers are on different machines.

Stop and remove containers:

docker-compose -f docker-compose.master.yml down
docker-compose -f docker-compose.replica.yml down


Reset volumes if needed:

docker volume prune
