#!/bin/bash

#  Fireproof-256 Deployment Script for PNW Payroll
# Deploys Aleo & Aztec Contracts

echo "🚀 Deploying Fireproof-256 PNW Payroll Contracts..."

#  Set Environment Variables
ALEO_NETWORK="https://aleo.network/"
AZTEC_NETWORK="https://aztec.network/"
DEPLOYER_WALLET="wallet_address_here"

#  Deploy Aleo Contracts
echo "🔹 Deploying Aleo Contracts..."
aleo deploy pncw_payroll.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy pniw_payroll.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy payroll_pools.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy fireproof_mimc.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy fireproof_poseidon.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy fireproof_obfuscation.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy merkle_helper.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy government_api.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aleo deploy process_tax_compliance.leo --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET

#  Deploy Aztec Contracts
echo "🔹 Deploying Aztec Contracts..."
aztec deploy pncw_payroll.noir --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET
aztec deploy pniw_payroll.noir --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET
aztec deploy batch_payroll_executor.noir --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET
aztec deploy compliance_tracking.noir --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET

#  Register SubDAO Payroll Reserves
echo "🔹 Initializing SubDAO Payroll Reserves..."
aleo execute init_subdao_pools.sh --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET
aztec execute init_subdao_pools.sh --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET

#  Verify Deployment Success
echo "🔹 Verifying Contract Deployment..."
aleo verify pncw_payroll.leo --url $ALEO_NETWORK
aleo verify pniw_payroll.leo --url $ALEO_NETWORK
aztec verify pncw_payroll.noir --url $AZTEC_NETWORK
aztec verify pniw_payroll.noir --url $AZTEC_NETWORK

#  Final Check: Cross-Chain Readiness
echo "🔹 Preparing Cross-Chain Payroll Processing..."
aleo execute convert_aleo_to_aztec.sh --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET

echo " All contracts deployed successfully! 🚀🔥"
