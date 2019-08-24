#!/usr/bin/env bash

dapp build

. ~/load_mainnet

export MOLOCH_KEY=0xcd16CBdA54af2556EBB6df4FBFd178e63c33FD89
export MOLOCH_DELEGATE_KEY=0x72BA1965320ab5352FD6D68235Cc3C5306a6FFA2


DAPP_TEST_TIMESTAMP=$(seth block latest timestamp)
DAPP_TEST_NUMBER=$(seth block latest number)
DAPP_TEST_ADDRESS=$MOLOCH_KEY

export DAPP_TEST_TIMESTAMP DAPP_TEST_NUMBER DAPP_TEST_ADDRESS

hevm dapp-test --rpc="$ETH_RPC_URL" --json-file=out/dapp.sol.json
