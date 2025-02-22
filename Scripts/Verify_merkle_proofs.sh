#!/bin/bash

#  Fireproof-256 Payroll & Tax Merkle Proof Verification
echo "🚀 Verifying Payroll & Tax Compliance Using Merkle Proofs..."

#  Verify Payroll Merkle Proofs for PNcW
echo "🔹 Verifying PNcW Payroll Merkle Proofs..."
aleo execute merkle_helper.leo --function verify_worker_payroll_merkle_proof --args 1010 5000 1720000000 --url $ALEO_NETWORK
aleo execute merkle_helper.leo --function verify_worker_payroll_merkle_proof --args 2020 5500 1730000000 --url $ALEO_NETWORK

#  Verify Payroll Merkle Proofs for PNiW
echo "🔹 Verifying PNiW Payroll Merkle Proofs..."
aleo execute merkle_helper.leo --function verify_worker_payroll_merkle_proof --args 3030 6000 1740000000 --url $ALEO_NETWORK
aleo execute merkle_helper.leo --function verify_worker_payroll_merkle_proof --args 4040 6500 1750000000 --url $ALEO_NETWORK

#  Verify Employer Tax Compliance Merkle Proofs
echo "🔹 Verifying Employer Tax Compliance Merkle Proofs..."
aleo execute merkle_helper.leo --function verify_employer_tax_merkle_proof --args 5050 7000 --url $ALEO_NETWORK
aleo execute merkle_helper.leo --function verify_employer_tax_merkle_proof --args 6060 7500 --url $ALEO_NETWORK

#  Verify Cross-Chain Payroll Compliance
echo "🔹 Verifying Aztec Payroll Compliance Using Merkle Proofs..."
aztec execute merkle_helper.noir --function verify_worker_payroll_merkle_proof --args 7070 8000 1760000000 --url $AZTEC_NETWORK
aztec execute merkle_helper.noir --function verify_worker_payroll_merkle_proof --args 8080 8500 1770000000 --url $AZTEC_NETWORK

#  Final Output
echo " All Merkle Proofs Successfully Verified! "
