#!/usr/bin/env bash
set -euo pipefail

./stop.sh

for i in $(seq 1 3); do
  cp -f sentinel$i.conf .sentinel$i.conf
done

docker-compose up -d && sleep 20
echo

docker ps
echo
