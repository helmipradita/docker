# RedisInsight Docker Setup

RedisInsight adalah Redis GUI official dari Redis Labs untuk monitoring dan managing Redis databases.

## 🚀 Quick Start

Run `./create-network.sh` from the repository root once to prepare the shared Docker network.

### 1. Setup Environment
```bash
# Environment variables are loaded from main .env file (../../.env)
# Make sure you have .env in project root:
cd /path/to/project
cp .env.example .env

# RedisInsight configuration is in main .env:
# REDIS_INSIGHT_PORT=5540
# REDIS_INSIGHT_CONTAINER_NAME=redis-insight
# REDIS_INSIGHT_TRUSTED_ORIGINS=http://localhost:5540,http://localhost:2001
```

### 2. Start RedisInsight
```bash
# Start container
docker compose up -d

# Check logs
docker compose logs -f

# Check status
docker compose ps
```

### 3. Access RedisInsight
```
Open browser: http://localhost:5540
```

### 4. Connect to Your Redis

**First Time Setup:**
1. Open RedisInsight (http://localhost:5540)
2. Click "Add Redis Database"
3. Choose "Add Database Manually"
4. Enter connection details:
   ```
   Host: redis (container name - same Docker network)
        OR
        172.17.0.1 (Linux/WSL) or host.docker.internal (Mac/Windows)
   
   Port: 6379
   Password: Password123!
   Database Alias: Contact API Development
   Username: (leave empty if no ACL)
   Password: assa_redis_password (from your .env)
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

### Environment Variables

All configuration is in the main `.env` file (project root):

| Variable | Default | Description |
|----------|---------|-------------|
| `REDIS_INSIGHT_PORT` | 5540 | Port untuk akses web UI |
| `REDIS_INSIGHT_CONTAINER_NAME` | redis-insight | Container name |
| `REDIS_INSIGHT_TRUSTED_ORIGINS` | http://localhost:5540 | CORS trusted origins |

### Custom Port
```env
# Edit main .env file (project root)
REDIS_INSIGHT_PORT=8080
```

Then access at: http://localhost:8080

---

## 🐛 Troubleshooting

### 1. Cannot connect to Redis from RedisInsight

**Symptoms:** "Connection refused" or "Cannot connect to Redis"

**Solutions:**

**For Mac/Windows Docker Desktop:**
```
Host: host.docker.internal
Port: 6379
Password: assa_redis_password
```

**For Linux Native Docker:**
```bash
# Find Docker bridge IP
docker network inspect bridge | grep Gateway

# Use that IP (usually 172.17.0.1)
Host: 172.17.0.1
Port: 6379
Password: assa_redis_password
```

**If Redis is also in Docker:**
```bash
# Create shared network
docker network create redis-network

# Add network to both containers
# In redis docker-compose:
networks:
  - redis-network

# In redis-insight docker-compose:
networks:
  - redis-network

# Then use container name as host
Host: assa_redis_container
Port: 6379
Password: assa_redis_password
```

### 2. Port 5540 already in use

**Solution:**
```bash
# Check what's using port
sudo lsof -i :5540

# Change port in .env
REDIS_INSIGHT_PORT=8080

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

Your Redis configuration (from .env):
```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=assa_redis_password
REDIS_KEY_PREFIX=sc-api:
```

In RedisInsight, you'll see keys like:
- `sc-api:session:{userId}:{sessionId}` - User sessions
- `sc-api:users:admin:list` - Cached admin list
- `sc-api:users:admin:detail:{id}` - Cached admin details
- `sc-api:users:user:list` - Cached user list
- `sc-api:users:pic:list` - Cached PIC list

---

## 🎯 Quick Reference

### Connection Details (Linux - WSL2)
```
Host: 172.17.0.1
Port: 6379
Password: assa_redis_password
Database: 0
Alias: SC-API Development
```

### Common Key Patterns
```
sc-api:session:*                    # All sessions
sc-api:session:636:*                # Sessions for user 636
sc-api:users:admin:list             # Admin list cache
sc-api:users:admin:detail:*         # Admin details cache
```

### Useful Redis Commands (CLI in RedisInsight)
```bash
# Count sessions for user
KEYS sc-api:session:636:*

# Get session data
GET sc-api:session:636:abc-123-xyz

# Check TTL
TTL sc-api:session:636:abc-123-xyz

# Delete all sessions for user
DEL sc-api:session:636:*

# Clear all cache
FLUSHDB
```

---

## 🚀 Next Steps

1. ✅ Copy `.env.example` to `.env`
2. ✅ Run `docker compose up -d`
3. ✅ Open http://localhost:5540
4. ✅ Add your Redis connection
5. ✅ Start exploring your data!
