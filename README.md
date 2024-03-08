# Overview

HTTP service for monitoring Ethereum node sync status and peer count

that can be used to deploy HA Ethereum nodes with Traefik in failover mode.

See: https://github.com/cnupy/traefik-eth-node-ha

# How to run

`cp .env.example .env` and edit `.env` to set the consensus and execution layer client URLs, 

network name and whether the network is internal or external. If the Ethereum node is deployed in Docker on 

the same host set `NETWORK_NAME` to the same network as the node and `NETWORK_IS_EXTERNAL` to true.     

To start the container execute:

`docker compose build && docker compose up -d`

To check sync status execute: 

`curl http://localhost:9000/hooks/cc` for the consensus layer client and

`curl http://localhost:9000/hooks/ec` for the execution layer client

Returns HTTP 200 if node is synced and has enough peers, otherwise HTTP 500

# Credits

https://github.com/CryptoManufaktur-io

https://github.com/adnanh/webhook
