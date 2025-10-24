# RedisInsight Connection Guide

## 🎯 Problem Solved: Container Network Isolation

### ❌ Previous Issue
```
Error: Could not connect to assa_redis_container:6379
```

**Root Cause:**
- Containers in different networks cannot communicate

### ✅ Solution Applied
- **Both containers are in `local-dev-network`**
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
│ Host:     redis                         │
│ Port:     6379                          │
│ Username: (leave empty)                 │
│ Password: Password123!                  │
│ Database: 0                             │
│ Alias:    Local Redis Development      │
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
│  │        local-dev-network                          │  │
│  │                                                    │  │
│  │  ┌──────────────────────┐  ┌──────────────────┐  │  │
│  │  │  Redis Container     │  │  RedisInsight    │  │  │
│  │  │                      │  │  Container       │  │  │
│  │  │  Name: redis         │  │  Name:           │  │  │
│  │  │                      │  │  redis-insight   │  │  │
│  │  │  Port: 6379          │◄─┤  Port: 5540      │  │  │
│  │  │  Password:           │  │                  │  │  │
│  │  │  Password123!        │  │                  │  │  │
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
redis                    redis:7-alpine              Up X minutes   0.0.0.0:6379->6379/tcp
redis-insight            redis/redisinsight:latest   Up X minutes   0.0.0.0:5540->5540/tcp
```

### Check Network Configuration
```bash
# Check both containers are in local-dev-network
docker network inspect local-dev-network --format='{{range .Containers}}{{.Name}}{{"\n"}}{{end}}' | grep -E "(redis|redis-insight)"
```

Should show both containers.

### Test Redis Connection
```bash
docker exec redis redis-cli -a Password123! ping
```

Expected output:
```
PONG
```

---

## 🐛 Troubleshooting

### Issue 1: Still Cannot Connect

**Check 1: Verify same network**
```bash
docker network inspect local-dev-network --format='{{range .Containers}}{{.Name}}{{"\n"}}{{end}}' | grep -E "(redis|redis-insight)"
```

Both should be listed.

**Check 2: Check Redis password**
```bash
docker exec redis redis-cli -a Password123! ping
```

Should return: `PONG`

**Check 3: Restart both containers**
```bash
cd redis && docker compose restart
cd ../redis-insight && docker compose restart
```

### Issue 2: Wrong Password Error

**The password is hardcoded in redis/docker-compose.yml:**
```bash
grep "requirepass" redis/docker-compose.yml
```

Should show: `Password123!`

### Issue 3: Connection Timeout

**Check if Redis is listening:**
```bash
docker exec redis redis-cli -a Password123! info server | grep tcp_port
```

Should show: `tcp_port:6379`

---

## 📝 Connection Options Explained

### Option 1: Container Name (✅ RECOMMENDED)
```
Host: redis
```
- **Pros:** Easy to remember, survives IP changes
- **Cons:** Only works within same Docker network
- **Use Case:** Recommended for container-to-container communication

### Option 2: localhost (❌ DOESN'T WORK from RedisInsight)
```
Host: localhost
```
- **Why it fails:** localhost inside RedisInsight container = RedisInsight itself
- **Not the Redis container!**
- **Only works:** From host machine applications

---

## 🎯 Quick Reference Card

### For RedisInsight UI:
```
┌────────────────────────────────┐
│ Redis Connection               │
├────────────────────────────────┤
│ Host:     redis                │
│ Port:     6379                 │
│ Password: Password123!         │
│ Database: 0                    │
└────────────────────────────────┘
```

### For Your Application:
```env
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=Password123!
```

**Why different?**
- Application runs on **host** → uses `localhost`
- RedisInsight runs in **Docker** → uses container name `redis`

---

## ✅ Success Checklist

- [ ] RedisInsight accessible at http://localhost:5540
- [ ] Both containers in `local-dev-network`
- [ ] Connection test shows "Successfully connected"
- [ ] Can browse keys
- [ ] Can view key values
- [ ] Can execute commands in CLI

---

## 🚀 Next Steps

After successful connection:

1. **Browse Keys**
   ```
   Pattern: *  (all keys)
   ```

2. **Try Redis CLI** (in RedisInsight)
   ```redis
   KEYS *
   GET mykey
   TTL mykey
   SET newkey "value"
   ```

3. **Analyze Memory**
   - Go to "Analysis Tools" → "Database Analysis"
   - See memory usage by key pattern

4. **Use AI Copilot**
   - Ask natural language questions
   - Get Redis command suggestions

---

**Connection guide complete! You should now be able to connect RedisInsight to your Redis container! 🎉**
