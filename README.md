# Overview

Docker Compose file for monitoring Ethereum node shync status over HTTP

# How to run:

`cp .env.example .env`, then `nano .env` and adjust values for CL, EL addresses. 

`nano network.yaml` to set external network

Start the container:

`docker compose build && docker compose up -d`

Check sync status: `curl http://localhost:9000/hooks/cc` and `curl http://localhost:9000/hooks/ec`

Returns HTTP 200 if node is synced and has enough peers, otherwise HTTP 500

# Credits:

https://github.com/CryptoManufaktur-io

https://github.com/adnanh/webhook