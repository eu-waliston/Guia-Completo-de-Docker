#!/bin/bash

set -e

ENVIRONMENT=${1:=-production}
COMPOSE_FILE="dokcer-compose.yml"

if [ "$ENVIRONMENT" = "development" ]; then
    COMPOSE_FILE="docker-compose.env.yml"
fi

echo "🚀 Deploying in $ENVIRONMENT environment..."

# Pull latest images
docker-compose -f $COMPOSE_FILE pull

# Rebuild if needed
if  [ "$ENVIRONMENT" = "development"]; then
    docker-compose -f $COMPOSE_FILE build
fi

# Stop and remove old containers
docker-compose -f $COMPOSE_FILE down

# Start new containers
docker-compose -f $COMPOSE_FILE up -d

# Run migrations if needed
if  [ "$ENVIRONMENT" = "production" ]; then
    docker-compose -f $COMPOSE_FILE exec users-service alembic upgrade head
fi

echo "✅ Deploy completed successfully!"

# Show service status
docker-compose -f $COMPOSE_FILE ps