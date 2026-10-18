#!/usr/bin/env bash
# Usage: ./test-traffic.sh [number_of_requests]
# Sends requests through Nginx and counts how many each version answered.
set -euo pipefail

N="${1:-100}"
URL="${URL:-http://localhost:8080}"
v1=0
v2=0

for _ in $(seq 1 "$N"); do
  body="$(curl -s "$URL/")"
  case "$body" in
    *v1*) v1=$((v1 + 1)) ;;
    *v2*) v2=$((v2 + 1)) ;;
  esac
done

echo "Sent $N requests to $URL"
echo "v1 (Blue):         $v1"
echo "v2 (Green/Canary): $v2"
