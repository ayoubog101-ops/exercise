#!/usr/bin/env bash
# Usage: ./switch.sh blue|green|canary
# Copies the chosen config into nginx/nginx.conf and reloads Nginx with no downtime.
set -euo pipefail

MODE="${1:-}"
DIR="$(cd "$(dirname "$0")" && pwd)"

case "$MODE" in
  blue|green|canary) ;;
  *) echo "Usage: $0 blue|green|canary"; exit 1 ;;
esac

cp "$DIR/nginx/conf/$MODE.conf" "$DIR/nginx/nginx.conf"
echo "Switched config to: $MODE"

cd "$DIR"
docker compose exec nginx nginx -t
docker compose exec nginx nginx -s reload
echo "Nginx reloaded."
