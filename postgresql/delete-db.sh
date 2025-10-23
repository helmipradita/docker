#!/bin/bash

# Script untuk menghapus database dan user
# Usage: ./delete-db.sh database_name user_name

if [ $# -ne 2 ]; then
    echo "Usage: $0 <database_name> <user_name>"
    echo "Example: $0 my_db my_user"
    exit 1
fi

DB_NAME=$1
USER_NAME=$2
CONTAINER_NAME=${POSTGRES_CONTAINER_NAME:-postgres}

echo "⚠️  WARNING: This will permanently delete database '$DB_NAME' and user '$USER_NAME'"
read -p "Are you sure? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

echo "Deleting database: $DB_NAME"
echo "Deleting user: $USER_NAME"

# Drop database and user
docker exec "$CONTAINER_NAME" psql -U helmipradita -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
docker exec "$CONTAINER_NAME" psql -U helmipradita -d postgres -c "DROP USER IF EXISTS $USER_NAME;"

if [ $? -eq 0 ]; then
    echo "✅ Database '$DB_NAME' and user '$USER_NAME' deleted successfully!"
else
    echo "❌ Failed to delete database or user"
fi
