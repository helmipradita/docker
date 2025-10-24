#!/bin/bash

# RedisInsight Quick Start Script

echo "🚀 Starting RedisInsight..."
echo ""

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
echo "   Host: redis (from same Docker network)"
echo "   Port: 6379"
echo "   Password: Password123!"
echo ""
echo "📋 Useful commands:"
echo "   View logs:    docker compose logs -f"
echo "   Stop:         docker compose down"
echo "   Restart:      docker compose restart"
echo ""
