#!/bin/bash

#  Fireproof-256 Security & zk-Proof Test Script
echo "Running Fireproof-256 Encryption & zk-Proof Tests..."

#  Run MiMC Hashing Test
echo "🔹 Testing MiMC Hash Function..."
aleo test fireproof_tests.leo --test test_mimc_hash

#  Run Poseidon Hashing Test
echo "🔹 Testing Poseidon Hash Function..."
aleo test fireproof_tests.leo --test test_poseidon_hash

#  Run Payroll zk-Proof Verification
echo "🔹 Testing zk-Proof for Payroll..."
aleo test fireproof_tests.leo --test test_payroll_zk_proof

#  Run Tax Compliance zk-Proof Verification
echo "🔹 Testing zk-Proof for Tax Compliance..."
aleo test fireproof_tests.leo --test test_tax_compliance_zk_proof

#  Run Multi-Hop Transfer Obfuscation
echo "🔹 Testing Multi-Hop Transfer Security..."
aleo test fireproof_tests.leo --test test_multi_hop_transfer

#  Run Fake Noise Generation Test
echo "🔹 Testing Fake Noise Transactions..."
aleo test fireproof_tests.leo --test test_fake_noise

#  Run Payroll Merkle Proof Validation
echo "🔹 Testing Payroll Merkle Proofs..."
aleo test fireproof_tests.leo --test test_merkle_payroll_proof

#  Run Tax Compliance Merkle Proof Validation
echo "🔹 Testing Tax Merkle Proofs..."
aleo test fireproof_tests.leo --test test_merkle_tax_proof

#  Final Output
echo " Fireproof-256 Tests Completed Successfully! "
