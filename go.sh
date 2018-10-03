#!/usr/bin/env bash

# Helper script to build, deploy and call
# Example usage: ./go.sh "multiCallTest(address,bytes4)" 0xe82ce3d6bf40f2f9414c8d01a35e3d9eb16a1761 0xddca3f43

export ETH_GAS=5000000
export ETH_RPC_ACCOUNTS=yes # Don't use ethsign
export ETH_RPC_URL=http://127.1:2000
# export ETH_FROM=$(seth rpc eth_coinbase)
export ETH_FROM=0x16fb96a5fa0427af0c8f7cf1eb4870231c8154b6

dapp build && NEWLY_DEPLOYED_SC=$(dapp create MultiCall) && echo "Calling: seth call $NEWLY_DEPLOYED_SC "'"'"$1"'"'" ${@:2}" && seth call $NEWLY_DEPLOYED_SC $@
