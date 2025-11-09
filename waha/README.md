# WAHA - WhatsApp HTTP API

WAHA (WhatsApp HTTP API) adalah solusi berbasis Docker untuk mengotomasi pengiriman pesan WhatsApp menggunakan REST API.

## 📋 Prerequisites

- Docker dan Docker Compose terinstall
- Network `local-dev-network` sudah dibuat (jalankan `../create-network.sh` jika belum)

## 🚀 Quick Start

### 1. Konfigurasi (Opsional)

WAHA bisa langsung dijalankan **tanpa konfigurasi tambahan**.

Jika ingin set custom credentials untuk production, edit `docker-compose.yml` dan uncomment bagian environment:

```yaml
environment:
  - WAHA_API_KEY=your-secret-api-key-here
  - WAHA_DASHBOARD_USERNAME=admin
  - WAHA_DASHBOARD_PASSWORD=admin123
```

**CATATAN**: Tanpa setting ini, WAHA akan jalan dengan mode terbuka (tanpa autentikasi API key).

### 2. Jalankan Container

```bash
docker compose up -d
```

### 3. Cek Status

```bash
docker compose ps
docker compose logs -f
```

### 4. Akses Dashboard

Buka browser dan akses: http://localhost:3232/dashboard

Login menggunakan kredensial dari `docker-compose.yml` (jika sudah dikonfigurasi)

## 📱 Cara Menggunakan

### Step 1: Buat Session WhatsApp

Buat session baru melalui API atau Dashboard.

**Opsi A: Via API**

```bash
curl -X POST http://localhost:3232/api/sessions \
  -H "Content-Type: application/json" \
  -d '{
    "name": "default"
  }'
```

**Opsi B: Via Dashboard** (Lebih mudah)

Akses http://localhost:3232/dashboard dan ikuti wizard untuk membuat session.

### Step 2: Scan QR Code

**Opsi A: Via API**

```bash
curl http://localhost:3232/api/sessions/default/qr
```

**Opsi B: Via Dashboard**

Akses http://localhost:3232/dashboard - QR code akan muncul otomatis

Scan QR code menggunakan WhatsApp di HP Anda:
1. Buka WhatsApp
2. Tap menu (3 titik) → Linked Devices
3. Tap "Link a Device"
4. Scan QR code yang muncul

### Step 3: Kirim Pesan

Setelah tersambung, kirim pesan via API:

```bash
curl -X POST http://localhost:3232/api/sendText \
  -H "Content-Type: application/json" \
  -d '{
    "session": "default",
    "chatId": "6281234567890@c.us",
    "text": "Hello from WAHA!"
  }'
```

**CATATAN**: Jika Anda set `WAHA_API_KEY` di docker-compose.yml, tambahkan header:
```bash
-H "X-Api-Key: your-secret-api-key-here"
```

**Format nomor**: `[kode negara][nomor]@c.us` (tanpa tanda +)
- Indonesia: `62812345678@c.us`
- Group: `[group-id]@g.us`

## 🔧 Perintah Berguna

```bash
# Start service
docker compose up -d

# Stop service
docker compose down

# View logs
docker compose logs -f

# Restart service
docker compose restart

# Remove containers and volumes (hapus semua data)
docker compose down -v
```

## 📡 API Endpoints

Base URL: `http://localhost:3232/api`

**Authentication**:
- Jika `WAHA_API_KEY` tidak diset di docker-compose.yml → **Tidak perlu** header autentikasi
- Jika sudah diset → Tambahkan header `X-Api-Key: your-api-key-here`

### Endpoints Utama:

- `POST /api/sessions` - Buat session baru
- `GET /api/sessions` - List semua session
- `GET /api/sessions/{name}/qr` - Dapatkan QR code
- `POST /api/sendText` - Kirim pesan teks
- `POST /api/sendImage` - Kirim gambar
- `POST /api/sendFile` - Kirim file
- `DELETE /api/sessions/{name}` - Hapus session

Dokumentasi lengkap: https://waha.devlike.pro/docs/

## 🔒 Keamanan

⚠️ **PENTING untuk Production**:

1. **Set API Key**: Uncomment dan set `WAHA_API_KEY` di docker-compose.yml
2. **Set Dashboard Password**: Uncomment dan set `WAHA_DASHBOARD_USERNAME` & `WAHA_DASHBOARD_PASSWORD`
3. **Gunakan HTTPS**: Setup reverse proxy (nginx/traefik) dengan SSL
4. **Firewall**: Batasi akses ke port 3232 (jangan expose ke internet langsung)
5. **Backup Session**: Volume `waha-sessions` berisi data autentikasi WhatsApp

⚠️ **Default config tanpa API key hanya untuk testing/development!**

## 💾 Data Persistence

Session WhatsApp disimpan di volume Docker `waha-sessions`. Data ini berisi:
- Token autentikasi WhatsApp
- Chat history (tergantung konfigurasi)
- Media cache

**Backup**:
```bash
docker run --rm -v waha-sessions:/data -v $(pwd):/backup alpine tar czf /backup/waha-sessions-backup.tar.gz -C /data .
```

**Restore**:
```bash
docker run --rm -v waha-sessions:/data -v $(pwd):/backup alpine tar xzf /backup/waha-sessions-backup.tar.gz -C /data
```

## 🐛 Troubleshooting

### Container tidak bisa start
```bash
docker compose logs
```

### QR Code tidak muncul
Tunggu beberapa detik setelah membuat session, lalu coba lagi.

### Session terputus
WhatsApp memutus koneksi setelah 14 hari tidak aktif. Scan ulang QR code.

### Error "Network not found"
Jalankan script untuk membuat network:
```bash
../create-network.sh
```

## 📚 Resources

- [WAHA Documentation](https://waha.devlike.pro/docs/)
- [WAHA GitHub](https://github.com/devlikeapro/waha)
- [API Reference](https://waha.devlike.pro/docs/how-to/send-messages)

## ⚖️ License

WAHA adalah free untuk penggunaan personal. Untuk penggunaan komersial, cek [license WAHA](https://waha.devlike.pro/docs/overview/license).

## 🆘 Support

Jika ada masalah:
1. Cek logs: `docker compose logs -f`
2. Baca dokumentasi: https://waha.devlike.pro/docs/
3. GitHub Issues: https://github.com/devlikeapro/waha/issues
