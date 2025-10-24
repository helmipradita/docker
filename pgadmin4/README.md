# 🐘 pgAdmin 4

Web-based administration UI for PostgreSQL running alongside the local development stack.

## 🚀 Quick Start

Run `../create-network.sh` from the repository root once to ensure the shared Docker network exists.

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Logs
docker compose logs -f
```

## 📡 Access

| Protocol | URL | Notes |
|----------|-----|-------|
| HTTP | http://localhost:5050 | default port, change in `docker-compose.yml` |
| HTTPS | not enabled | enable by supplying custom certificates |

### Default login

- **Email:** `admin@example.com`
- **Password:** `ChangeMe123!`

To change these credentials, edit the values in `docker-compose.yml` and restart the container.

## 🔌 Connecting to PostgreSQL

A starter `servers.json` is mounted read-only and preconfigures a connection named **Local PostgreSQL** pointing at the `postgres` container on the shared network. After logging in:

1. Open "Servers" → "Local PostgreSQL".
2. When prompted, enter the database password (e.g. `Password123!` for the bundled dev database) and optionally save it in the browser.

To add more servers, use the pgAdmin UI or edit `servers.json` and redeploy.

## 🌐 Network & Volumes

- Container Name: `pgadmin4`
- Network: `local-dev-network` (created via `./create-network.sh`)
- Persistent data: `pgadmin4_pgadmin-data`

## 🔧 Useful Commands

```bash
# Restart the container without stopping
docker compose restart

# Update to the latest image
docker compose pull
docker compose up -d

# Inspect the persistent volume
docker volume inspect pgadmin4_pgadmin-data
```
