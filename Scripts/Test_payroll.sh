#!/bin/bash

#  Fireproof-256 Payroll Test Script
echo " Running Payroll Execution & zk-Proof Tests..."

# Run PNcW Payroll Execution Test
echo "🔹 Testing PNcW Payroll Execution..."
aleo test payroll_tests.leo --test test_pncw_payroll_execution

#  Run PNiW Payroll Execution Test
echo "🔹 Testing PNiW Payroll Execution..."
aleo test payroll_tests.leo --test test_pniw_payroll_execution

#  Run Payroll zk-Proof Verification for PNcW
echo "🔹 Testing zk-Proof for PNcW Payroll..."
aleo test payroll_tests.leo --test test_pncw_payroll_zk_proof

#  Run Payroll zk-Proof Verification for PNiW
echo "🔹 Testing zk-Proof for PNiW Payroll..."
aleo test payroll_tests.leo --test test_pniw_payroll_zk_proof

#  Run Multi-Hop Transfer Obfuscation for PNcW
echo "🔹 Testing PNcW Multi-Hop Transfer Security..."
aleo test payroll_tests.leo --test test_pncw_multi_hop_transfer

#  Run Multi-Hop Transfer Obfuscation for PNiW
echo "🔹 Testing PNiW Multi-Hop Transfer Security..."
aleo test payroll_tests.leo --test test_pniw_multi_hop_transfer

#  Run Payroll Merkle Proof Validation for PNcW
echo "🔹 Testing PNcW Payroll Merkle Proofs..."
aleo test payroll_tests.leo --test test_pncw_merkle_payroll_proof

#  Run Payroll Merkle Proof Validation for PNiW
echo "🔹 Testing PNiW Payroll Merkle Proofs..."
aleo test payroll_tests.leo --test test_pniw_merkle_payroll_proof

#  Final Output
echo " Fireproof-256 Payroll Tests Completed Successfully! "
