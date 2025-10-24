# 🐳 Docker Development Stack

Koleksi Docker Compose setups untuk local development environment. Semua services terhubung via shared Docker network untuk memudahkan komunikasi antar container.

## 📦 Services Available

| Service | Port | Container Name | Description |
|---------|------|---------------|-------------|
| **PostgreSQL** | 5432 | postgres | PostgreSQL 15 database server |
| **pgAdmin 4** | 5050 | pgadmin4 | PostgreSQL web admin UI |
| **Redis** | 6379 | redis | Redis 7 in-memory data store |
| **Redis Insight** | 5540 | redis-insight | Redis web GUI |
| **Kafka** | 9092, 9093 | kafka | Apache Kafka message broker |
| **Zookeeper** | 2181 | zookeeper | Kafka coordination service |
| **Kafka UI** | 8080 | kafka-ui | Kafka web management UI |
| **Portainer** | 9000, 9443 | portainer | Docker management UI |

## 🚀 Quick Start

### 1. Install Docker (jika belum)
```bash
./install-docker.sh
```

### 2. Create Shared Network
```bash
./create-network.sh
```
Ini akan membuat network `local-dev-network` yang digunakan oleh semua containers.

### 3. Start Services
Masuk ke folder service yang dibutuhkan dan jalankan:
```bash
cd postgresql
docker compose up -d

cd ../redis
docker compose up -d

cd ../redis-insight
docker compose up -d
```

## 📁 Project Structure

```
DOCKER/
├── README.md                    # This file
├── .gitignore                   # Git ignore patterns
├── install-docker.sh            # Docker installation script
├── create-network.sh            # Network setup script
│
├── postgresql/                  # PostgreSQL Database
│   ├── docker-compose.yml
│   ├── README.md
│   ├── create-db.sh             # Create new database
│   ├── delete-db.sh             # Delete database
│   └── init/
│       └── 01-init.sql          # Initialization scripts
│
├── pgadmin4/                    # PostgreSQL Admin UI
│   ├── docker-compose.yml
│   ├── README.md
│   └── servers.json             # Pre-configured servers
│
├── redis/                       # Redis Server
│   ├── docker-compose.yml
│   └── README.md
│
├── redis-insight/               # Redis Management UI
│   ├── docker-compose.yml
│   ├── README.md
│   ├── SETUP.md
│   ├── CONNECTION_GUIDE.md
│   ├── start.sh
│   └── .gitignore
│
├── kafka/                       # Kafka + Zookeeper + UI
│   ├── docker-compose.yml
│   └── README.md
│
└── portainer/                   # Docker Management UI
    ├── docker-compose.yml
    └── README.md
```

## 🔗 Connection Details

### PostgreSQL
```
Host: localhost (from host) or postgres (from containers)
Port: 5432
Database: belajar_typescript_restful_api
Username: helmipradita
Password: Password123!
```

### pgAdmin 4
```
URL: http://localhost:5050
Email: admin@example.com
Password: ChangeMe123!
```

### Redis
```
Host: localhost (from host) or redis (from containers)
Port: 6379
Password: Password123!
```

### Redis Insight
```
URL: http://localhost:5540

Connection to Redis:
  Host: redis
  Port: 6379
  Password: Password123!
```

### Kafka
```
Bootstrap Server: localhost:9092 (from host)
Bootstrap Server: kafka:9093 (from containers)

Kafka UI: http://localhost:8080
Zookeeper: localhost:2181
```

### Portainer
```
HTTP: http://localhost:9000
HTTPS: https://localhost:9443
```

## 🌐 Network Architecture

Semua containers terhubung ke network `local-dev-network`:

```
┌──────────────────────────────────────────────────────┐
│              local-dev-network                       │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │ postgres │  │  redis   │  │  kafka   │          │
│  │  :5432   │  │  :6379   │  │  :9093   │          │
│  └──────────┘  └──────────┘  └──────────┘          │
│       ▲             ▲             ▲                 │
│       │             │             │                 │
│  ┌────┴───┐    ┌───┴─────┐  ┌───┴─────┐           │
│  │pgadmin4│    │redis-   │  │kafka-ui │           │
│  │ :5050  │    │insight  │  │ :8080   │           │
│  └────────┘    │ :5540   │  └─────────┘           │
│                └─────────┘                         │
│                                                     │
│  ┌──────────┐  ┌──────────┐                       │
│  │zookeeper│  │portainer │                        │
│  │  :2181  │  │:9000/9443│                        │
│  └──────────┘  └──────────┘                       │
└──────────────────────────────────────────────────────┘
           │
      (port mapping)
           │
           ▼
      Docker Host
    localhost:ports
```

## 🔧 Common Operations

### Start All Services
```bash
# Create network first (one time only)
./create-network.sh

# Start each service
for dir in postgresql redis redis-insight kafka portainer pgadmin4; do
    cd $dir && docker compose up -d && cd ..
done
```

### Stop All Services
```bash
for dir in postgresql redis redis-insight kafka portainer pgadmin4; do
    cd $dir && docker compose down && cd ..
done
```

### View Logs
```bash
cd <service-folder>
docker compose logs -f
```

### Restart Service
```bash
cd <service-folder>
docker compose restart
```

### Update Service
```bash
cd <service-folder>
docker compose pull
docker compose up -d
```

## 📊 Service-Specific Features

### PostgreSQL
- Auto-run init scripts from `init/` folder
- Helper scripts for database management
- Healthcheck enabled
- Persistent storage

### Redis
- AOF persistence enabled
- Password protected
- Healthcheck enabled
- Optimized for local development

### Kafka
- Auto-create topics enabled
- Web UI for monitoring
- 7-day log retention
- Single broker setup (development)

### Portainer
- Docker socket access for full control
- HTTPS support
- Security hardening enabled

## 🛠️ Troubleshooting

### Network Issues
```bash
# Check if network exists
docker network ls | grep local-dev-network

# Recreate network if needed
docker network rm local-dev-network
./create-network.sh
```

### Container Not Starting
```bash
# Check logs
docker compose logs -f

# Check status
docker compose ps

# Restart container
docker compose restart
```

### Port Already in Use
```bash
# Check what's using the port
sudo lsof -i :<port>

# Change port in docker-compose.yml
# Edit the ports section, then restart
docker compose down && docker compose up -d
```

### Cannot Connect Between Containers
```bash
# Verify both containers are in same network
docker network inspect local-dev-network

# Check container names
docker ps --format "table {{.Names}}\t{{.Networks}}"
```

## 📝 Configuration

Semua konfigurasi **hardcoded** di file `docker-compose.yml` masing-masing service. Tidak ada file `.env` yang digunakan.

Untuk mengubah konfigurasi:
1. Edit file `docker-compose.yml` di folder service
2. Restart service: `docker compose down && docker compose up -d`

## 🔒 Security Notes

**⚠️ PENTING:** Setup ini untuk **local development only**!

Default credentials yang digunakan:
- PostgreSQL: `helmipradita` / `Password123!`
- Redis: `Password123!`
- pgAdmin: `admin@example.com` / `ChangeMe123!`

**Jangan gunakan credentials ini di production!**

## 📚 Documentation

Setiap service memiliki `README.md` sendiri dengan dokumentasi lengkap:
- [PostgreSQL](postgresql/README.md) - Database setup & management
- [pgAdmin 4](pgadmin4/README.md) - Admin UI setup
- [Redis](redis/README.md) - Redis configuration
- [Redis Insight](redis-insight/README.md) - Redis GUI setup
- [Kafka](kafka/README.md) - Kafka configuration
- [Portainer](portainer/README.md) - Docker UI setup

## 🎯 Use Cases

### Web Application Stack
```bash
# Start database + cache
cd postgresql && docker compose up -d
cd ../redis && docker compose up -d
```

### Message Queue Development
```bash
# Start Kafka ecosystem
cd kafka && docker compose up -d
```

### Database Management
```bash
# Start DB + Admin UI
cd postgresql && docker compose up -d
cd ../pgadmin4 && docker compose up -d
```

### Redis Development
```bash
# Start Redis + GUI
cd redis && docker compose up -d
cd ../redis-insight && docker compose up -d
```

## 🤝 Contributing

Ini adalah private repository untuk personal development. Silakan modifikasi sesuai kebutuhan.

## 📄 License

Private repository - for personal use only.

---

**Happy Coding! 🚀**
