#!/bin/bash

# RedisInsight Quick Start Script

echo "🚀 Starting RedisInsight..."
echo ""

# Check if main .env exists
if [ ! -f ../../.env ]; then
    echo "❌ Error: .env file not found in project root!"
    echo "   Please copy .env.example to .env in the project root folder:"
    echo "   cd ../.. && cp .env.example .env"
    exit 1
fi

# Start container
echo "🐳 Starting Docker container..."
docker compose up -d

# Check status
echo ""
echo "📊 Container status:"
docker compose ps

echo ""
echo "✅ RedisInsight is starting!"
echo ""
echo "📍 Access RedisInsight at: http://localhost:5540"
echo ""
echo "🔗 To connect to your Redis:"
echo "   Host: 172.17.0.1 (Linux) or host.docker.internal (Mac/Win)"
echo "   Port: 6379"
echo "   Password: assa_redis_password"
echo ""
echo "📋 Useful commands:"
echo "   View logs:    docker compose logs -f"
echo "   Stop:         docker compose down"
echo "   Restart:      docker compose restart"
echo ""
