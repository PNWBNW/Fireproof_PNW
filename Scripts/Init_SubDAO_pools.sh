#!/bin/bash

#  Fireproof-256 SubDAO Payroll Reserve Initialization
echo "Initializing SubDAO Payroll Pools..."

#  Set Environment Variables
ALEO_NETWORK="https://aleo.network/"
AZTEC_NETWORK="https://aztec.network/"
DEPLOYER_WALLET="wallet_address_here"

#  Initialize Payroll Reserves on Aleo
echo "🔹 Setting up AleoUSDC Payroll Pools..."
aleo execute payroll_pools.leo --function deposit_aleo_usdc --args "wa001_payroll.pnw.ans" 1000000 --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo execute payroll_pools.leo --function deposit_aleo_usdc --args "tx001_payroll.pnw.ans" 750000 --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET

#  Initialize Payroll Reserves on Aztec
echo "🔹 Setting up CircleUSDC Payroll Pools..."
aztec execute payroll_pools.noir --function deposit_circle_usdc --args "wa001_payroll.pnw.ans" 1000000 --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET
aztec execute payroll_pools.noir --function deposit_circle_usdc --args "tx001_payroll.pnw.ans" 750000 --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET

#  Verify Payroll Reserve Setup
echo "🔹 Verifying SubDAO Payroll Balances..."
aleo execute payroll_pools.leo --function get_subdao_payroll_balance --args "wa001_payroll.pnw.ans" --url $ALEO_NETWORK
aleo execute payroll_pools.leo --function get_subdao_payroll_balance --args "tx001_payroll.pnw.ans" --url $ALEO_NETWORK
aztec execute payroll_pools.noir --function get_subdao_payroll_balance --args "wa001_payroll.pnw.ans" --url $AZTEC_NETWORK
aztec execute payroll_pools.noir --function get_subdao_payroll_balance --args "tx001_payroll.pnw.ans" --url $AZTEC_NETWORK

#  Final Output
echo " SubDAO Payroll Reserves Initialized Successfully! "
