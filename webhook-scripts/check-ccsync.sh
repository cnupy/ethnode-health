#!/bin/sh
SYNC=$(curl -s -m2 -N "${CC_ADDRESS}/eth/v1/node/syncing")
echo "${SYNC}" | grep -q "data"
if [ $? -ne 0 ]; then
  echo "ERROR: Can't get sync status"
  exit 1
fi
SYNCING=$(echo "${SYNC}" | jq .data.is_syncing)
OPTIMISTIC=$(echo "${SYNC}" | jq .data.is_optimistic)
EL_OFFLINE=$(echo "${SYNC}" | jq .data.el_offline)
PEERS=$(curl -s -m2 -N "${CC_ADDRESS}/eth/v1/node/peer_count")
echo "${PEERS}" | grep -q "data"
if [ $? -ne 0 ]; then
  echo "ERROR: Can't get peers data"
  exit 1
fi
PEERS=$(echo "${PEERS}" | jq -r .data.connected)
if [ "${SYNCING}" = "false" -a "${OPTIMISTIC}" = "false" -a "${EL_OFFLINE}" = "false" -a "${PEERS}" -ge "$CC_MIN_PEERS" ]; then
  echo "OK"
  exit 0
else
  echo "ERROR: Node syncing or not enough peers"
  exit 1
fi
