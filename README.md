# Redis Sentinel Docker Example

This repo is a demo of a simple Redis high availability setup on Docker,
with a few tests.

## Prerequisites

* docker
* docker-compose
* /bin/bash

## Usage

1. Read [docker-compose.yml](./docker-compose.yml)
1. Read [sentinel.conf](./sentinel.conf)

### Starting
1. Read [start.sh](./start.sh)
1. Start Redis: `./start.sh`

### Redis Commander
1. Launch browser at http://localhost:8081/

### Stopping
1. Read [stop.sh](./stop.sh)
1. Stop Redis: `./stop.sh`

### Tests (currently broken - see commit 9675cb7276c21c9b24db17bc1386713d27344685)
1. Read [test.sh](./test.sh)
1. Run the tests: `./test.sh`:

    ```
    Master: 172.22.1.10
    all 3 only write to master tests passed in 25.000s.
    Stopping sentinel_redis1_1 ... done
    New master: 172.22.1.20
    all 3 election works tests passed in 17.000s.
    ```
## Notes

* `sentinel.conf` must be writeable and not shared between Sentinel instances. It constantly gets updated by the Sentinel process which writes IPs, ports, and other info to it.
