# 🗄️ PostgreSQL Database

PostgreSQL 16 database for Contact Management API.

## 🚀 Quick Start

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Logs
docker compose logs -f

# Shell
docker exec -it postgres psql -U helmipradita -d belajar_typescript_restful_api
```

## 📡 Connection Details

| Property | Value |
|----------|-------|
| **Host** | `localhost` |
| **Port** | `5432` |
| **Database** | `belajar_typescript_restful_api` |
| **User** | `helmipradita` |
| **Password** | `Password123!` |

## 🔧 Tools

### DataGrip / DBeaver
Use connection details above.

### psql CLI
```bash
docker exec -it postgres psql -U helmipradita -d belajar_typescript_restful_api
```

### From Application
```env
DATABASE_URL=postgresql://helmipradita:Password123!@localhost:5432/belajar_typescript_restful_api
```

## 🌐 Network

Container Name: `postgres`  
Network: `local-dev-network`

**From other containers:**
```
Host: postgres
Port: 5432
```

## 🔄 Migrations

Init scripts in `./init/` run automatically on first startup.
