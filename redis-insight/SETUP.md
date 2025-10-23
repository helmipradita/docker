# RedisInsight Setup Complete! ✅

## ✅ What Was Fixed

### 1. **Network Configuration Fixed**
- **Before:** Used default bridge network (isolated from Redis)
- **After:** Connected to `redis_default` network (same as Redis container)
- **Result:** ✅ RedisInsight can now connect to Redis container

### 2. **Environment Configuration Unified**
- **Before:** Separate `.env` file in `docker/redis-insight/`
- **After:** Uses main `.env` from project root
- **Result:** ✅ Single source of truth for all config

---

## 📁 Current Structure

```
project-root/
├── .env                          # Main config (used by RedisInsight)
├── .env.example                  # Template with RedisInsight vars
└── docker/
    └── redis-insight/
        ├── docker-compose.yml    # Loads ../../.env
        ├── start.sh             # Quick start script
        ├── README.md            # Full documentation
        ├── SETUP.md            # This file
        └── .gitignore
```

---

## 🚀 How to Use

### Quick Start
```bash
cd docker/redis-insight
./start.sh
```

### Manual Start
```bash
cd docker/redis-insight
docker compose up -d
```

### Access
```
Open: http://localhost:5540
```

---

## 🔧 Configuration (in main .env)

```env
# RedisInsight Configuration
REDIS_INSIGHT_PORT=5540
REDIS_INSIGHT_CONTAINER_NAME=redis-insight
REDIS_INSIGHT_TRUSTED_ORIGINS=http://localhost:5540,http://localhost:2001
```

---

## 🔗 Connect to Your Redis

When adding database in RedisInsight UI:

```
Host: default_redis_container
Port: 6379
Password: assa_redis_password
Database: 0
Alias: SC-API Development
```

**Why use container name?**
- RedisInsight and Redis are in the same Docker network (`redis_default`)
- Docker's internal DNS resolves container names to IPs
- Both containers can communicate directly

---

## 📊 What You'll See

### Keys in Redis:
- `sc-api:session:{userId}:{sessionId}` - User sessions
- `sc-api:users:admin:list` - Admin list cache
- `sc-api:users:admin:detail:{id}` - Admin detail cache
- `sc-api:users:user:list` - User list cache
- `sc-api:users:pic:list` - PIC list cache

### Search Patterns:
```
sc-api:session:*          # All sessions
sc-api:session:636:*      # Sessions for user ID 636
sc-api:users:*            # All cache keys
```

---

## 🛠️ Common Commands

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Restart
docker compose restart

# View logs
docker compose logs -f

# Check status
docker compose ps

# Update image
docker compose pull && docker compose up -d
```

---

## ✅ Verification

Check if RedisInsight is running:
```bash
# Check container
docker ps | grep redis-insight

# Check health
docker compose ps

# Check logs
docker compose logs redis-insight
```

Expected output:
```
NAME            STATUS
redis-insight   Up X seconds (healthy)
```

---

## 🎯 Next Steps

1. ✅ RedisInsight is running
2. ✅ Open http://localhost:5540
3. ✅ Add Redis database (172.17.0.1:6379)
4. ✅ Browse your session keys
5. ✅ Use AI Copilot for queries

---

## 💡 Tips

### Find Docker Bridge IP (if 172.17.0.1 doesn't work)
```bash
docker network inspect bridge | grep Gateway
```

### Check Redis Connection from Container
```bash
docker exec -it redis-insight sh
# Inside container:
ping 172.17.0.1
```

### View All Environment Variables
```bash
docker compose config
```

---

## 🐛 Troubleshooting

### Issue: Cannot connect to Redis

**Solution 1:** Use container name (both in same network)
```
Host: default_redis_container
Port: 6379
Password: assa_redis_password
```

**Solution 2:** Check Redis is running
```bash
docker ps | grep redis
# Should show both containers running
```

**Solution 3:** Test connectivity from RedisInsight container
```bash
docker exec -it redis-insight sh
# Inside container:
ping default_redis_container
# Should get response if network is correct
```

### Issue: Port 5540 already in use

**Solution:** Change port in main .env
```env
REDIS_INSIGHT_PORT=8080
```

Then restart:
```bash
docker compose down && docker compose up -d
```

---

## 📚 Documentation

- **Full Guide:** [README.md](README.md)
- **Docker Overview:** [../README.md](../README.md)
- **RedisInsight Docs:** https://redis.io/insight/

---

**Setup complete! RedisInsight ready to use! 🎉**
