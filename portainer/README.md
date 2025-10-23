# 🛠️ Portainer

Portainer Community Edition web UI for managing local Docker resources.

## 🚀 Quick Start

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Logs
docker compose logs -f
```

First launch prompts you to set an admin password, then choose **Get Started** to manage the local Docker environment.

## 📡 Access

| Protocol | URL |
|----------|-----|
| HTTP | [http://localhost:9000](http://localhost:9000) |
| HTTPS | [https://localhost:9443](https://localhost:9443) |

## 🌐 Network & Volumes

- Container Name: `portainer`
- Network: `local-dev-network`
- Persistent data: `portainer-data` volume
- Binds `/var/run/docker.sock` for Docker daemon access

## 🔧 Useful commands

```bash
# Restart
docker compose restart

# Upgrade to latest image
docker compose pull
docker compose up -d

# Inspect data volume
docker volume inspect portainer-data
```
