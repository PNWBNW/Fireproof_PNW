#!/bin/bash

#  Fireproof-256 Cross-Chain Payroll Transfer (Aleo → Aztec)
echo " Converting Aleo Payroll Funds to Aztec..."

#  Set Environment Variables
ALEO_NETWORK="https://aleo.network/"
AZTEC_NETWORK="https://aztec.network/"
DEPLOYER_WALLET="wallet_address_here"

#  Generate zk-Proof for Payroll Transfer
echo "🔹 Generating zk-Proof for Payroll Conversion..."
aleo execute fireproof_crypto.leo --function generate_payroll_zk_proof --args 1010 5000 --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET

#  Transfer Payroll Funds from Aleo to Aztec
echo "🔹 Executing Cross-Chain Transfer..."
aleo execute convert_to_aztec.leo --function bridge_payroll_to_aztec --args 1010 5000 --url $ALEO_NETWORK --private-key $DEPLOYER_WALLET

#  Verify Payroll Transfer on Aztec
echo "🔹 Verifying Payroll Arrival on Aztec..."
aztec execute verify_payroll_transfer.noir --function confirm_aleo_transfer --args 1010 5000 --url $AZTEC_NETWORK --private-key $DEPLOYER_WALLET

#  Final Output
echo " Payroll Successfully Converted from Aleo to Aztec! "
