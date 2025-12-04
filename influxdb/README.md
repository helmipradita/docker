# 📊 InfluxDB

InfluxDB 2.7 time series database for storing and analyzing time-stamped data.

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
docker exec -it influxdb bash
```

## 📡 Connection Details

| Property | Value |
|----------|-------|
| **Host** | `localhost` |
| **Port** | `8086` |
| **Username** | `admin` |
| **Password** | `password123` |
| **Organization** | `local-dev` |
| **Bucket** | `default` |
| **Token** | `influxdb-admin-token-123` |
| **URL** | `http://localhost:8086` |

## 🔧 Tools

### InfluxDB CLI
```bash
# Enter container
docker exec -it influxdb bash

# Use CLI
influx auth list
influx bucket list
influx org list
```

### From Application
```env
INFLUX_URL=http://localhost:8086
INFLUX_TOKEN=influxdb-admin-token-123
INFLUX_ORG=local-dev
INFLUX_BUCKET=default
```

### Python Example
```python
from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS

client = InfluxDBClient(
    url="http://localhost:8086",
    token="influxdb-admin-token-123",
    org="local-dev"
)

write_api = client.write_api(write_options=SYNCHRONOUS)

# Write data
point = Point("measurement") \
    .tag("location", "server-room") \
    .field("temperature", 25.5)

write_api.write(bucket="default", record=point)
```

### JavaScript Example
```javascript
import { InfluxDB } from '@influxdata/influxdb-client'

const url = 'http://localhost:8086'
const token = 'influxdb-admin-token-123'
const org = 'local-dev'
const bucket = 'default'

const client = new InfluxDB({ url, token })

const writeApi = client.getWriteApi(org, bucket)
writeApi.writeRecord('temperature,location=server-room value=25.5')
writeApi.flush()
```

## 🌐 Network

Container Name: `influxdb`  
Network: `local-dev-network`

**From other containers:**
```
Host: influxdb
Port: 8086
```

**Example from Grafana container:**
```
URL: http://influxdb:8086
Token: influxdb-admin-token-123
Org: local-dev
Bucket: default
```

## 📊 Data Management

### Create New Bucket
```bash
docker exec -it influxdb influx bucket create \
  --name my-new-bucket \
  --org local-dev \
  --retention 7d
```

### Create New Token
```bash
docker exec -it influxdb influx auth create \
  --org local-dev \
  --all-access \
  --description "My App Token"
```

### Query Data
```bash
# Using Flux
docker exec -it influxdb influx query \
  'from(bucket:"default") |> range(start:-1h)'

# Using InfluxQL (if enabled)
docker exec -it influxdb influx query 'query "SELECT * FROM measurement"'
```

## 🔐 Security

**⚠️ Important:** Change default credentials in production!

### Update Admin Password
1. Open http://localhost:8086 in browser
2. Login with current credentials
3. Go to Data > Tokens > Generate Token
4. Update docker-compose.yml with new token

### Environment Variables
- `DOCKER_INFLUXDB_INIT_USERNAME` - Admin username
- `DOCKER_INFLUXDB_INIT_PASSWORD` - Admin password  
- `DOCKER_INFLUXDB_INIT_ORG` - Default organization
- `DOCKER_INFLUXDB_INIT_BUCKET` - Default bucket
- `DOCKER_INFLUXDB_INIT_ADMIN_TOKEN` - Admin token
- `DOCKER_INFLUXDB_INIT_RETENTION` - Data retention period

## 📈 Grafana Integration

This InfluxDB instance is pre-configured to work with Grafana. See [../grafana/README.md](../grafana/README.md) for Grafana setup instructions.

**Grafana Data Source Configuration:**
- URL: `http://influxdb:8086`
- Token: `influxdb-admin-token-123`
- Organization: `local-dev`
- Default Bucket: `default`

## 🛠️ Troubleshooting

### Check Container Status
```bash
docker ps | grep influxdb
docker compose logs influxdb
```

### Reset Data
```bash
docker compose down -v
docker compose up -d
```

### Access InfluxDB UI
Open http://localhost:8086 in your browser and login with:
- Username: `admin`
- Password: `password123`

## 📚 Useful Links

- [InfluxDB Documentation](https://docs.influxdata.com/influxdb/v2/)
- [Flux Query Language](https://docs.influxdata.com/influxdb/v2/query-data/flux/)
- [InfluxDB Client Libraries](https://docs.influxdata.com/influxdb/v2/tools/client-libraries/)