# 🐘 PostgreSQL Automatic Replication

Automatic **Master-Replica** PostgreSQL replication setup using **Docker Compose**.

## 📘 Project Description

This project quickly sets up replication between two PostgreSQL nodes (**Master** and **Replica**) using **Docker Compose** and custom Docker images.

Before starting, the user must select the server role (**Master** or **Replica**). Default passwords can also be customized in the configuration.

### Node Roles

| Node | Description |
| :--- | :--- |
| **Master** | The main database node. |
| **Replica** | The secondary node copying data from **Master**. |

---

## ⚙️ Setup Steps

### 1️⃣ Install Docker 

Use the official repository method to install Docker Engine for better stability and integration (recommended for production on Ubuntu/Debian OR... just use 'sudo snap install docker' ._.):

```bash
# 1. Update packages and install dependencies
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y

# 2. Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 3. Add the Docker repository to APT sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. Install Docker Engine and related tools (including Compose plugin)
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# 5. Add current user to the 'docker' group to run commands without sudo (requires re-login)
sudo usermod -aG docker $USER

# 6. Verify installation
docker run hello-world
```

### 2️⃣ Clone the Project

Clone the repository and navigate to the project folder:

```bash
git clone https://github.com/<your_username>/postgresql-auto-replication.git
cd postgresql-auto-replication
```

### 3️⃣ Decide the Role

Determine the server's role:

* **Master** → Main node
* **Replica** → Secondary node

### 4️⃣ Edit Configuration (Optional)

For the Replica node, you *must* replace `MASTER_IP` with the Master's actual IP address.

**File path:** `postgresql-auto-replication/replica/docker-compose.replica.yml`

**Example (Configuration Snippet):**

```yaml
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
```

### 5️⃣ Navigate to the Correct Directory

* **Master:**

    ```bash
    cd postgresql-auto-replication 
    ```

* **Replica:**

    ```bash
    cd postgresql-auto-replication/replica 
    ```

### 6️⃣ Start Container with Build

Start the service using the appropriate configuration file:

* **Master:**

    ```bash
    docker-compose -f docker-compose.master.yml up -d --build 
    ```

* **Replica:**

    ```bash
    docker-compose -f docker-compose.replica.yml up -d --build 
    ```

### 7️⃣ Verify Replication

Check the **Replica** node logs to ensure it successfully connects to the **Master**:

```bash
docker-compose -f docker-compose.replica.yml logs -f 
```

---

## 🔧 Notes & Tips

* Each server must be *either* **Master** *or* **Replica**, *never both* simultaneously.
* The **`MASTER_IP`** variable *must* be correctly specified for replication to work.
* Passwords and credentials can be easily **customized**.
* Ensure **network connectivity** if servers are on different machines.

### Container Management

Stop and remove containers:

```bash
docker-compose -f docker-compose.master.yml down
docker-compose -f docker-compose.replica.yml down 
```

Reset volumes if needed (start with a clean slate):

```bash
docker volume prune
