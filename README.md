# 🐘 PostgreSQL Automatic Replication

**Description**  
This project sets up **PostgreSQL master–replica replication** using Docker Compose with custom Docker images.

| Node       | Description                                 |
|-----------|---------------------------------------------|
| ✅ **Master**  | Main database node                          |
| ⚡ **Replica** | Secondary node replicating data from master |

> Before starting, **choose the role** of the server. You can also change *default passwords* in the configuration.

---

## ⚙️ Setup Steps

### 1️⃣ Install Docker
```bash
sudo snap install docker
