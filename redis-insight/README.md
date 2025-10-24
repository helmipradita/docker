# RedisInsight Docker Setup

RedisInsight adalah Redis GUI official dari Redis Labs untuk monitoring dan managing Redis databases.

## 🚀 Quick Start

Run `../create-network.sh` from the repository root once to prepare the shared Docker network.

### Start RedisInsight
```bash
# Start container
docker compose up -d

# Check logs
docker compose logs -f

# Check status
docker compose ps
```

### Access RedisInsight
```
Open browser: http://localhost:5540
```

### Connect to Your Redis

**First Time Setup:**
1. Open RedisInsight (http://localhost:5540)
2. Click "Add Redis Database"
3. Choose "Add Database Manually"
4. Enter connection details:
   ```
   Host: redis (container name - same Docker network)
   Port: 6379
   Password: Password123!
   Database Alias: Local Redis Development
   Username: (leave empty)
   ```
5. Click "Test Connection"
6. Click "Add Database"

**Note:**
- RedisInsight and Redis are in the same Docker network (`local-dev-network`)
- Use Redis container name: `redis`
- Both containers can communicate directly

---

## 📊 Features

### ✅ What You Can Do:
- 🔍 Browse all Redis keys (`sc-api:session:*`, `sc-api:users:*`, etc)
- ✏️ View and edit key values
- 📈 Monitor real-time metrics (memory, CPU, connections)
- 🔎 Search keys with patterns
- 🗑️ Delete keys (bulk operations)
- 📊 Analyze memory usage
- 🖥️ Built-in Redis CLI
- 🤖 AI-powered Redis Copilot (query using natural language)
- 📉 Slowlog analysis

### 🎯 Use Cases for Your Project:
1. **Debug Sessions** - View `sc-api:session:*` keys
2. **Check Cache** - Inspect `sc-api:users:*` cache
3. **Monitor Performance** - Real-time metrics
4. **Clean Up** - Delete expired/test keys
5. **Analyze Memory** - Find memory leaks

---

## 🛠️ Commands

### Start/Stop
```bash
# Start
docker compose up -d

# Stop
docker compose down

# Restart
docker compose restart

# View logs
docker compose logs -f redis-insight
```

### Update RedisInsight
```bash
# Pull latest image
docker compose pull

# Restart with new image
docker compose up -d
```

### Backup Data
```bash
# Data is stored in named volume: redis-insight-data
docker volume inspect redis-insight-data

# Backup volume
docker run --rm -v redis-insight-data:/data -v $(pwd):/backup alpine tar czf /backup/redis-insight-backup.tar.gz -C /data .

# Restore volume
docker run --rm -v redis-insight-data:/data -v $(pwd):/backup alpine tar xzf /backup/redis-insight-backup.tar.gz -C /data
```

---

## 🔧 Configuration

All configuration is hardcoded in `docker-compose.yml`:

| Setting | Value | Description |
|---------|-------|-------------|
| Port | 5540 | Web UI port |
| Container Name | redis-insight | Container name |
| Trusted Origins | http://localhost:5540 | CORS origins |

### Custom Port
Edit `docker-compose.yml`:
```yaml
ports:
  - "8080:5540"  # Change 8080 to your preferred port
```

Then restart: `docker compose down && docker compose up -d`

---

## 🐛 Troubleshooting

### 1. Cannot connect to Redis from RedisInsight

**Symptoms:** "Connection refused" or "Cannot connect to Redis"

**Solutions:**

**Use Container Name (Recommended):**
```
Host: redis
Port: 6379
Password: Password123!
```
Both RedisInsight and Redis are in the same `local-dev-network`.

**Alternative - Using Host IP:**

For Mac/Windows Docker Desktop:
```
Host: host.docker.internal
Port: 6379
Password: Password123!
```

For Linux/WSL:
```
Host: 172.17.0.1
Port: 6379
Password: Password123!
```

### 2. Port 5540 already in use

**Solution:**
```bash
# Check what's using port
sudo lsof -i :5540

# Change port in docker-compose.yml
# Edit ports section: "8080:5540"

# Restart
docker compose down && docker compose up -d
```

### 3. Data not persisting

**Check volume:**
```bash
docker volume ls | grep redis-insight
docker volume inspect redis-insight-data
```

### 4. UI not loading

**Check logs:**
```bash
docker compose logs redis-insight

# Check health
docker compose ps
```

---

## 📦 Uninstall

```bash
# Stop and remove container
docker compose down

# Remove volume (deletes all data)
docker compose down -v

# Or manually
docker volume rm redis-insight-data
```

---

## 🔗 Useful Links

- [RedisInsight Official Docs](https://redis.io/docs/latest/develop/tools/insight/)
- [RedisInsight GitHub](https://github.com/RedisInsight/RedisInsight)
- [Redis Docker Hub](https://hub.docker.com/r/redis/redisinsight)

---

## 💡 Tips

1. **Keyboard Shortcuts:**
   - `Ctrl + K` - Quick command palette
   - `Ctrl + /` - Toggle CLI
   - `Ctrl + B` - Browse keys

2. **Search Keys:**
   ```
   Pattern: sc-api:session:*
   Pattern: sc-api:users:admin:*
   ```

3. **Export Keys:**
   - Select keys → Right click → Export

4. **Memory Analysis:**
   - Go to "Analysis Tools" → "Database Analysis"
   - See which keys consume most memory

5. **Slowlog:**
   - Go to "Analysis Tools" → "Slowlog"
   - Find slow commands affecting performance

---

## 🎓 Example Session

```bash
# 1. Start RedisInsight
cd docker/redis-insight
docker compose up -d

# 2. Open browser
open http://localhost:5540

# 3. Add database (first time)
# Host: host.docker.internal (Mac/Win) or 172.17.0.1 (Linux)
# Port: 6379
# Password: assa_redis_password

# 4. Browse your sessions
# Search pattern: sc-api:session:*

# 5. View session data
# Click any key to see JSON content

# 6. Monitor in real-time
# Click "Browser" → See live updates
```

---

## ⚙️ Integration with Project

Redis connection details for your application:
```
Host: localhost
Port: 6379
Password: Password123!
```

Example application configuration:
```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=Password123!
```

---

## 🎯 Quick Reference

### Connection Details
```
Host: redis (from Docker network) or localhost (from host)
Port: 6379
Password: Password123!
Database: 0
Alias: Local Redis Development
```

### Useful Redis Commands (CLI in RedisInsight)
```bash
# List all keys
KEYS *

# Get key value
GET mykey

# Check TTL
TTL mykey

# Delete key
DEL mykey

# Clear all data
FLUSHDB
```

---

## 🚀 Next Steps

1. ✅ Run `docker compose up -d`
2. ✅ Open http://localhost:5540
3. ✅ Add your Redis connection (host: redis, password: Password123!)
4. ✅ Start exploring your data!
