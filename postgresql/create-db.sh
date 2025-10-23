#!/bin/bash

# Script untuk membuat database baru tanpa restart container
# Usage: ./create-db.sh database_name user_name password

if [ $# -ne 3 ]; then
    echo "Usage: $0 <database_name> <user_name> <password>"
    echo "Example: $0 my_new_db my_user my_password"
    exit 1
fi

DB_NAME=$1
USER_NAME=$2
PASSWORD=$3
CONTAINER_NAME=${POSTGRES_CONTAINER_NAME:-postgres}

echo "Creating database: $DB_NAME"
echo "Creating user: $USER_NAME"

# Connect to postgres container and create database + user
echo "Creating database..."
docker exec "$CONTAINER_NAME" psql -U helmipradita -d postgres -c "CREATE DATABASE $DB_NAME;"

echo "Creating user..."
docker exec "$CONTAINER_NAME" psql -U helmipradita -d postgres -c "CREATE USER $USER_NAME WITH PASSWORD '$PASSWORD';"

echo "Granting privileges..."
docker exec "$CONTAINER_NAME" psql -U helmipradita -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $USER_NAME;"
docker exec "$CONTAINER_NAME" psql -U helmipradita -d postgres -c "ALTER USER $USER_NAME CREATEDB;"

if [ $? -eq 0 ]; then
    echo "✅ Database '$DB_NAME' and user '$USER_NAME' created successfully!"
    echo ""
    echo "Connection details:"
    echo "Host: localhost"
    echo "Port: 5432"
    echo "Database: $DB_NAME"
    echo "Username: $USER_NAME"
    echo "Password: $PASSWORD"
else
    echo "❌ Failed to create database or user"
fi
