# 🔴 Redis

In-memory data store for BullMQ job queues and caching.

## 🚀 Quick Start

Run `./create-network.sh` from the repository root once to prepare the shared Docker network.

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Logs
docker compose logs -f

# CLI
docker exec -it redis redis-cli -a Password123!
```

## 📡 Connection Details

| Property | Value |
|----------|-------|
| **Host** | `localhost` |
| **Port** | `6379` |
| **Password** | `Password123!` |
| **Database** | `0` |

## 🔧 Tools

### Redis CLI
```bash
# Connect
docker exec -it redis redis-cli -a Password123!

# Commands
> PING
PONG

> KEYS *
1) "bull:upgrade-user-role:wait"
2) "bull:send-email-simulation:completed"

> LLEN bull:upgrade-user-role:wait
(integer) 3
```

### Redis Insight
See [redis-insight/README.md](../redis-insight/README.md)

### From Application
```typescript
// src/shared/infrastructure/redis/connection.ts
export const redisConnection = new Redis({
  host: 'localhost',
  port: 6379,
  password: 'Password123!'
});
```

## 🌐 Network

Container Name: `redis`  
Network: `local-dev-network`

**From other containers:**
```
Host: redis
Port: 6379
Password: Password123!
```

## 📊 BullMQ Queues

```bash
# View queues
docker exec -it redis redis-cli -a Password123! KEYS "bull:*"

# Queue stats
docker exec -it redis redis-cli -a Password123!
> LLEN bull:upgrade-user-role:wait
> LLEN bull:upgrade-user-role:active
> LLEN bull:upgrade-user-role:completed
> LLEN bull:upgrade-user-role:failed
```
