# 🐘 PostgreSQL Automatic Replication

**Description**  
This project demonstrates **PostgreSQL master–replica replication** using **Docker Compose** with custom Docker images.

| Role       | Description                                 |
|-----------:|---------------------------------------------|
| ✅ **Master**  | Main (primary) PostgreSQL server            |
| ⚡ **Replica** | Secondary server that copies data from Master |

> **Important:** choose the role of the server you are configuring (Master or Replica).  
> The user must manually replace `MASTER_IP` in replica config files with the master's IP. You can also change *default passwords* in compose files.

---

## Prerequisites

- Docker installed on each host. Example (Linux, snap):
```bash
sudo snap install docker
