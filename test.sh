#!/usr/bin/env bash
set -euo pipefail

# # setup
. assert.sh

./start.sh

function set_vars () {
  MASTER_IP=$1
  MASTER_NAME=redis1
  echo "Master: $MASTER_NAME at $MASTER_IP"

  SLAVE1_IP=
  SLAVE1_NAME=redis2
  echo "Slave1: $SLAVE1_NAME at $SLAVE1_IP"

  SLAVE2_IP=
  SLAVE2_NAME=redis3
  echo "Slave2: $SLAVE2_NAME at $SLAVE2_IP"
}

# test suite 1

set_vars $(docker exec -t redis_sentinel1 redis-cli -h 127.0.0.1 -p 26379 SENTINEL get-master-addr-by-name redis1 | cut -d\" -f2 | head -n2 | paste -d ":" - -)
## cannot write to replica
assert "docker exec -t ${SLAVE1_NAME} redis-cli set 'foo' 123" "(error) READONLY You can't write against a read only replica."
## can write to master
assert "docker exec -t ${MASTER_NAME} redis-cli set 'foo' 123" "OK"
## can read from replica what got written to master
assert "docker exec -t ${SLAVE2_NAME} redis-cli get 'foo'" "\"123\""

assert_end only write to master
echo

# test suite 2

## stop master
docker-compose stop $MASTER_NAME && sleep 20
echo

set_vars $(docker exec -t ${SLAVE2_NAME} redis-cli -h 127.0.0.1 -p 26380 SENTINEL get-master-addr-by-name redis1 | cut -d\" -f2 | head -n1)

## can write to master
assert "docker exec -t ${MASTER_NAME} redis-cli set 'foo' 345" "OK"
## can read what got written
assert "docker exec -t ${MASTER_NAME} redis-cli get 'foo'" "\"345\""
## can read what got written
assert "docker exec -t ${SLAVE2_NAME} redis-cli get 'foo'" "\"345\""

assert_end election works

echo
./stop.sh
