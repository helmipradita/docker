# RedisInsight Connection Guide

## 🎯 Problem Solved: Container Network Isolation

### ❌ Previous Issue
```
Error: Could not connect to assa_redis_container:6379
```

**Root Cause:**
- Redis container was in `redis_default` network
- RedisInsight was in default `bridge` network
- Containers in different networks cannot communicate

### ✅ Solution Applied
- **Changed RedisInsight network to `redis_default`**
- Now both containers are in the same Docker network
- They can communicate using container names

---

## 🔗 How to Connect RedisInsight to Redis

### Step 1: Open RedisInsight
```
http://localhost:5540
```

### Step 2: Add Database
1. Click **"Add Redis Database"**
2. Choose **"Add Database Manually"**

### Step 3: Enter Connection Details

```
┌─────────────────────────────────────────┐
│ Connection Details                      │
├─────────────────────────────────────────┤
│ Host:     default_redis_container       │
│ Port:     6379                          │
│ Username: (leave empty)                 │
│ Password: assa_redis_password           │
│ Database: 0                             │
│ Alias:    SC-API Development            │
└─────────────────────────────────────────┘
```

### Step 4: Test Connection
- Click **"Test Connection"**
- Should see: ✅ **"Successfully connected"**

### Step 5: Add Database
- Click **"Add Database"**
- Start exploring your Redis data!

---

## 🌐 Network Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Docker Host                             │
│                                                          │
│  ┌───────────────────────────────────────────────────┐  │
│  │        redis_default network (172.23.0.0/16)      │  │
│  │                                                    │  │
│  │  ┌──────────────────────┐  ┌──────────────────┐  │  │
│  │  │  Redis Container     │  │  RedisInsight    │  │  │
│  │  │                      │  │  Container       │  │  │
│  │  │  Name:               │  │                  │  │  │
│  │  │  default_redis_      │  │  Name:           │  │  │
│  │  │  container           │  │  redis-insight   │  │  │
│  │  │                      │  │                  │  │  │
│  │  │  IP: 172.23.0.2      │◄─┤  IP: 172.23.0.3  │  │  │
│  │  │  Port: 6379          │  │  Port: 5540      │  │  │
│  │  └──────────────────────┘  └──────────────────┘  │  │
│  │         ▲                          ▲             │  │
│  └─────────┼──────────────────────────┼─────────────┘  │
│            │                          │                │
│            │ 0.0.0.0:6379            │ 0.0.0.0:5540  │
│            │ (mapped to host)         │ (mapped to    │
│            │                          │  host)        │
└────────────┼──────────────────────────┼────────────────┘
             │                          │
          localhost:6379            localhost:5540
          (from host)               (access UI)
```

---

## 🔍 Verification Commands

### Check Both Containers Running
```bash
docker ps | grep redis
```

Expected output:
```
default_redis_container   redis:7-alpine              Up X minutes   0.0.0.0:6379->6379/tcp
redis-insight            redis/redisinsight:latest   Up X minutes   0.0.0.0:5540->5540/tcp
```

### Check Network Configuration
```bash
# Check Redis network
docker inspect default_redis_container --format='{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}'

# Check RedisInsight network
docker inspect redis-insight --format='{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}'
```

Both should return the same Network ID (redis_default).

### List Containers in Network
```bash
docker network inspect redis_default --format='{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}'
```

Expected output:
```
default_redis_container: 172.23.0.2/16
redis-insight: 172.23.0.3/16
```

---

## 🐛 Troubleshooting

### Issue 1: Still Cannot Connect

**Check 1: Verify same network**
```bash
docker inspect default_redis_container -f '{{json .NetworkSettings.Networks}}' | grep redis_default
docker inspect redis-insight -f '{{json .NetworkSettings.Networks}}' | grep redis_default
```

Both should contain `redis_default`.

**Check 2: Check Redis password**
```bash
# From host
docker exec default_redis_container redis-cli -a assa_redis_password ping
```

Should return: `PONG`

**Check 3: Restart both containers**
```bash
# Restart Redis
cd docker/redis
docker compose restart

# Restart RedisInsight
cd docker/redis-insight
docker compose restart
```

### Issue 2: Wrong Password Error

**Verify password in .env:**
```bash
grep REDIS_PASSWORD .env
```

Should match what you enter in RedisInsight.

### Issue 3: Connection Timeout

**Check if Redis is listening:**
```bash
docker exec default_redis_container redis-cli -a assa_redis_password info server | grep tcp_port
```

Should show: `tcp_port:6379`

---

## 📝 Connection Options Explained

### Option 1: Container Name (✅ RECOMMENDED)
```
Host: default_redis_container
```
- **Pros:** Easy to remember, survives IP changes
- **Cons:** Only works within same Docker network
- **Use Case:** Production-ready, recommended

### Option 2: Container IP
```
Host: 172.23.0.2
```
- **Pros:** Direct connection
- **Cons:** IP might change on restart
- **Use Case:** Debugging

### Option 3: localhost (❌ DOESN'T WORK)
```
Host: localhost
```
- **Why it fails:** localhost inside container = container itself
- **Not the host machine!**

---

## 🎯 Quick Reference Card

### For RedisInsight UI:
```
┌────────────────────────────────┐
│ Redis Connection               │
├────────────────────────────────┤
│ Host:     default_redis_       │
│           container             │
│ Port:     6379                 │
│ Password: assa_redis_password  │
│ Database: 0                    │
└────────────────────────────────┘
```

### For Your Application (.env):
```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=assa_redis_password
```

**Why different?**
- Application runs on **host** → uses `localhost`
- RedisInsight runs in **Docker** → uses container name

---

## ✅ Success Checklist

- [ ] RedisInsight accessible at http://localhost:5540
- [ ] Both containers in `redis_default` network
- [ ] Connection test shows "Successfully connected"
- [ ] Can browse keys (try pattern: `sc-api:*`)
- [ ] Can view key values
- [ ] Can execute commands in CLI

---

## 🚀 Next Steps

After successful connection:

1. **Browse Session Keys**
   ```
   Pattern: sc-api:session:*
   ```

2. **View Cache Keys**
   ```
   Pattern: sc-api:users:*
   ```

3. **Try Redis CLI** (in RedisInsight)
   ```redis
   KEYS sc-api:*
   GET sc-api:session:636:abc-123-xyz
   TTL sc-api:session:636:abc-123-xyz
   ```

4. **Analyze Memory**
   - Go to "Analysis Tools" → "Database Analysis"
   - See memory usage by key pattern

5. **Use AI Copilot**
   - Ask: "Show me all sessions for user 636"
   - Get natural language to Redis command translation

---

**Connection guide complete! You should now be able to connect RedisInsight to your Redis container! 🎉**
