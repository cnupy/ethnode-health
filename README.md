# Overview

Docker Compose project for monitoring Ethereum node sync status over HTTP

Useful if you want to deploy Traefik in failover mode to monitor service health

# How to run

`cp .env.example .env`, then `nano .env` and set the consensus and execution layer client URLs. 

`nano network.yaml` to set external network

Start the container:

`docker compose build && docker compose up -d`

To check sync status execute: 

`curl http://localhost:9000/hooks/cc` for the consensus layer client and

`curl http://localhost:9000/hooks/ec` for the execution layer client

Returns HTTP 200 if node is synced and has enough peers, otherwise HTTP 500

# Credits

https://github.com/CryptoManufaktur-io

https://github.com/adnanh/webhook
