# 📨 Kafka + Zookeeper + Kafka UI

Apache Kafka event streaming platform with web-based UI.

## 🚀 Quick Start

Run `./create-network.sh` from the repository root once to prepare the shared Docker network.

```bash
# Start (includes Zookeeper, Kafka, Kafka UI)
docker compose up -d

# Stop
docker compose down

# Logs
docker compose logs -f kafka
docker compose logs -f zookeeper
docker compose logs -f kafka-ui
```

## 📡 Connection Details

| Service | Port | URL |
|---------|------|-----|
| **Kafka** | 9092 | `localhost:9092` |
| **Kafka UI** | 8080 | http://localhost:8080 |
| **Zookeeper** | 2181 | `localhost:2181` |

## 🔧 Kafka UI

Access: **http://localhost:8080**

Features:
- 📋 View topics
- 📊 Monitor consumers
- 📝 Send/view messages
- ⚙️ Manage configurations

## 🌐 Network

Container Names:
 - `zookeeper`
 - `kafka`
 - `kafka-ui`

Network: `local-dev-network`

**From other containers:**
```
Kafka: kafka:9093
Zookeeper: zookeeper:2181
```

**From host (WSL/local):**
```
Kafka: localhost:9092
```

## 🔧 Application Config

```typescript
// src/shared/infrastructure/kafka/client.ts
export const kafka = new Kafka({
  clientId: 'contact-api',
  brokers: ['localhost:9092']
});
```

## 📊 CLI Commands

```bash
# List topics
docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --list

# Create topic
docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --create --topic test-topic --partitions 1 --replication-factor 1

# Describe topic
docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --describe --topic user.upgrade.payment_received
```
