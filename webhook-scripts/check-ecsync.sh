#!/bin/sh
SYNC=$(curl -s -m2 -N -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' "${EC_ADDRESS}")
echo "${SYNC}" | grep -q "result"
if [ $? -ne 0 ]; then
  echo "ERROR: Can't get sync status"
  exit 1
fi
SYNC=$(echo "${SYNC}" | jq .result)
PEERS_HEX=$(curl -s -m2 -N -X POST -H "Content-Type: application/json" -m 2 -d '{"jsonrpc":"2.0","method":"net_peerCount","params": [],"id":1}' "${EC_ADDRESS}")
echo "${PEERS_HEX}" | grep -q "result"
if [ $? -ne 0 ]; then
  echo "ERROR: Can't get peers data"
  exit 1
fi
PEERS_HEX=$(echo "${PEERS_HEX}" | jq -r .result)
PEERS=$(printf "%d" "${PEERS_HEX}")
if [ "${SYNC}" = "false" -a "${PEERS}" -ge "$EC_MIN_PEERS" ]; then
  echo "OK, PEERS: ${PEERS}"
  exit 0
else
  echo "ERROR: Node syncing or not enough peers"
  exit 1
fi
