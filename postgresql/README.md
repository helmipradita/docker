# 🗄️ PostgreSQL Database

PostgreSQL 16 database for Contact Management API.

## 🚀 Quick Start

Run `./create-network.sh` from the repository root once to prepare the shared Docker network.

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

## 🛠️ Database Management Scripts

### Interactive Database Creator (Recommended)

`./create-db-interactive.sh` - Interactive script dengan menu untuk membuat database dan user PostgreSQL.

**Features:**
- ✨ Interactive menu dengan validasi lengkap
- 👥 List dan pilih existing user ATAU create user baru
- 🔒 Password validation (min 8 chars, uppercase, lowercase, number)
- 🎯 Advanced permissions untuk user (SUPERUSER, CREATEDB, LOGIN, Custom)
- 🗄️ Advanced privileges untuk database (ALL, CONNECT, CREATE, TEMPORARY)
- 📋 Output Prisma DATABASE_URL format
- ✅ Error handling dan safety checks

**Usage:**
```bash
./create-db-interactive.sh
```

Script akan memandu Anda melalui process:
1. Pilih antara create new user atau use existing user
2. Jika create user baru: set username, password, dan permissions
3. Jika use existing user: pilih dari list user yang ada
4. Create database dengan validation
5. Set database privileges
6. Tampilkan Prisma DATABASE_URL untuk copy ke .env

**Example Output:**
```
DATABASE_URL=postgresql://myuser:MyPass123@localhost:5432/mydb?schema=public
```

### Simple Database Creator

`./create-db.sh <database_name> <user_name> <password>` - Quick create database dan user (non-interactive).

**Example:**
```bash
./create-db.sh my_new_db my_user my_password
```

### Delete Database

`./delete-db.sh <database_name> <user_name>` - Delete database dan user dengan confirmation.

**Example:**
```bash
./delete-db.sh my_old_db my_user
```

## 🔄 Migrations

Init scripts in `./init/` run automatically on first startup.
