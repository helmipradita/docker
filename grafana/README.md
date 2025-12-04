# 📊 Grafana

Grafana 11.1.0 visualization and monitoring platform with InfluxDB integration.

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
docker exec -it grafana bash
```

## 📡 Connection Details

| Property | Value |
|----------|-------|
| **URL** | `http://localhost:3000` |
| **Username** | `admin` |
| **Password** | `password123` |

## 🔧 Data Sources

### Add InfluxDB Data Source (Manual Setup)

To connect Grafana with InfluxDB:

1. Go to **Configuration** > **Data Sources**
2. Click **Add data source**
3. Select **InfluxDB**
4. Configure with these settings:

| Property | Value |
|----------|-------|
| **Name** | `InfluxDB` (or your preferred name) |
| **Query Language** | `Flux` |
| **URL** | `http://influxdb:8086` |
| **Organization** | `local-dev` |
| **Default Bucket** | `default` |
| **Token** | `influxdb-admin-token-123` |

5. Click **Save & Test** to verify connection

### Add Other Data Sources

1. Go to **Configuration** > **Data Sources**
2. Click **Add data source**
3. Select your desired data source type
4. Configure connection details

## 🌐 Network

Container Name: `grafana`  
Network: `local-dev-network`

**From other containers:**
```
Host: grafana
Port: 3000
```

## 📊 Dashboard Creation

### Create InfluxDB Dashboard

1. Go to **Dashboards** > **New Dashboard**
2. Click **Add visualization**
3. Select **InfluxDB** as data source
4. Use Flux query language:

```flux
from(bucket: "default")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "temperature")
  |> aggregateWindow(every: 5m, fn: mean, createEmpty: false)
```

### Sample Dashboard Templates

#### System Metrics Dashboard
```flux
# CPU Usage
from(bucket: "default")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "system" and r._field == "cpu_usage")
  |> last()

# Memory Usage  
from(bucket: "default")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "system" and r._field == "memory_usage")
  |> last()
```

#### Temperature Monitoring
```flux
from(bucket: "default")
  |> range(start: -24h)
  |> filter(fn: (r) => r._measurement == "temperature")
  |> aggregateWindow(every: 10m, fn: mean, createEmpty: false)
  |> yield(name: "avg_temperature")
```

## 🔌 InfluxDB Integration

### Writing Data to InfluxDB

Use the InfluxDB connection details from [../influxdb/README.md](../influxdb/README.md) to write data that will be available in Grafana.

### Query Examples

#### Basic Time Series Query
```flux
from(bucket: "default")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "your_measurement")
```

#### Aggregation Query
```flux
from(bucket: "default")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "temperature")
  |> aggregateWindow(every: 5m, fn: mean, createEmpty: false)
  |> yield(name: "avg_temp")
```

#### Multiple Fields Query
```flux
from(bucket: "default")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "sensors")
  |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
```

## 🎨 Visualization Types

### Supported Panel Types
- **Time Series** - Line charts, area charts
- **Stat** - Single value displays
- **Gauge** - Progress indicators
- **Table** - Tabular data display
- **Heatmap** - Density visualization
- **Histogram** - Distribution charts

### Panel Configuration

#### Time Series Panel
1. Select **Time series** visualization
2. Choose InfluxDB data source
3. Enter your Flux query
4. Customize axes, legends, and colors

#### Stat Panel
1. Select **Stat** visualization
2. Use aggregation functions in Flux:
```flux
from(bucket: "default")
  |> range(start: -5m)
  |> filter(fn: (r) => r._measurement == "temperature")
  |> last()
```

## 🔐 Security

**⚠️ Important:** Change default credentials in production!

### Update Admin Password
1. Login to Grafana at http://localhost:3000
2. Go to **Administration** > **Users**
3. Click on admin user and update password

### User Management
```bash
# Create new user
docker exec -it grafana grafana-cli admin user-create \
  --username=newuser \
  --password=newpassword \
  --email=user@example.com \
  --name="New User"

# Reset password
docker exec -it grafana grafana-cli admin reset-admin-password newpassword
```

## 🛠️ Configuration

### Environment Variables
- `GF_SECURITY_ADMIN_USER` - Admin username
- `GF_SECURITY_ADMIN_PASSWORD` - Admin password

## 📚 Useful Links

- [Grafana Documentation](https://grafana.com/docs/)
- [InfluxDB Data Source](https://grafana.com/docs/grafana/latest/datasources/influxdb/)
- [Flux Query Language](https://docs.influxdata.com/influxdb/v2/query-data/flux/)
- [Grafana Panels](https://grafana.com/docs/grafana/latest/panels-visualizations/)

## 🔗 Related Services

- **InfluxDB**: Time series database - [../influxdb/README.md](../influxdb/README.md)
- **PostgreSQL**: Relational database - [../postgresql/README.md](../postgresql/README.md)
- **Redis**: In-memory cache - [../redis/README.md](../redis/README.md)