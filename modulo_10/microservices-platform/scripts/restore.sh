#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "❌ Uso: $0 <arquivo_de_backup.tar.gz>"
    exit 1
fi

BACKUP_FILE=$1
BACKUP_DIR=$(basename "$BACKUP_FILE" .tar.gz)
TEMP_DIR="./temp_restore"

echo "🔄 Iniciando restauração de: $BACKUP_FILE"

# Extrair backup
mkdir -p $TEMP_DIR
tar -xzf $BACKUP_FILE -C $TEMP_DIR

# Verificar manifesto
if [ ! -f "$TEMP_DIR/$BACKUP_DIR/manifest.json" ]; then
    echo "❌ Arquivo de manifesto não encontrado!"
    exit 1
fi

echo "📋 Informações do backup:"
cat "$TEMP_DIR/$BACKUP_DIR/manifest.json"

# Restaurar PostgreSQL
echo "🗄️  Restaurando PostgreSQL..."
docker-compose exec -T postgres psql -U admin -d postgres < "$TEMP_DIR/$BACKUP_DIR/postgres_backup.sql"

# Restaurar Redis
echo "🔴 Restaurando Redis..."
docker-compose stop redis
docker cp "$TEMP_DIR/$BACKUP_DIR/redis_dump.rdb" ${PROJECT_NAME}-redis:/data/dump.rdb
docker-compose start redis

# Restaurar volumes
echo "📦 Restaurando volumes..."
docker run --rm \
  -v $(pwd)/$TEMP_DIR/$BACKUP_DIR:/backup \
  -v ${PROJECT_NAME}-postgres-data:/target \
  alpine sh -c "rm -rf /target/* && tar -xzf /backup/postgres_data.tar.gz -C /target"

# Limpar
rm -rf $TEMP_DIR

echo "✅ Restauração concluída com sucesso!"
echo "🚀 Reiniciando serviços..."
docker-compose restart

echo "🎉 Sistema restaurado. Verifique o status:"
docker-compose ps