#!/bin/bash

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%md_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}"

echo "💾 Iniciando backup: $BACKUP_NAME"

mkdir -p $BACKUP_DIR/$BACKUP_NAME

# Backup PostgresSQL
echo "🗄️  Backup do PostgreSQL..."
docker-compose exex -T postgres pg_dumpall -U admin > $BACKUP_DIR/$BACKUP_NAME/postgres_backup.sql

# Backup Redis
echo "🔴 Backup do Redis..."
docker-compose exex -T redis redis-cli --raw --no-auth-warnings -a redis123 SAVE
docker cp ${PROJECT_NAME}-redis:/data/dump.rdb $BACKUP_DIR/$BACKUP_NAME/redis_dump.rdb

# BAckup volumes data
echo "📦 Backup de volumes..."
docker run --rm -v ${PROJECT_NAME}-postgres-data:/source -v ${pwd}/$BACKUP_DIR/$BACKUP_NAME:/backup apline tar czf /backups/postgres_data.tar.gz -C /source .

# Create a backup manifest
echo "📝 Criando manifesto..."
cat > $BACKUP_DIR/$BACKUP_NAME/manifest.json << EOF
{
    "backup_name" : "$BACKUP_NAME",
    "timestamp" : "$(date -Isseconds)"
    "services" : [
        "postgres",
        "redis",
        "volumes",
    ],
    "size" : "$(du -sh $BACKUP_DIR/$BACKUP_NAME | cut -f1)"
}
EOF

# Compress backup
echo "📦 Compactando backup..."
tar -czf $BACKUP_DIR/$BACKUP_NAME.targ.gz -C $BACKUP_DIR $BACKUP_NAME
rm -rf $BACKUP_DIR/$BACKUP_NAME

echo "✅ Backup completo: $BACKUP_DIR/$BACKUP_NAME.tar.gz"