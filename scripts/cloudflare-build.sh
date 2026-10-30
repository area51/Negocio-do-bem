#!/bin/sh
# Deploy Cloudflare: migra o banco do ambiente antes do build do Worker.
set -e

case "$DEPLOY_ENV" in
  production | preview)
    DATABASE_URL="${DATABASE_URL_UNPOOLED:-$DATABASE_URL}" npx prisma migrate deploy
    ;;
esac

if [ "$DEPLOY_ENV" = "preview" ]; then
  npx prisma db seed
fi

npx opennextjs-cloudflare build
