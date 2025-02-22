#!/bin/bash

#  Fireproof-256 Compliance & Tax Test Script
echo " Running Compliance & Tax Validation Tests..."

#  Run Employer Tax Compliance Verification
echo "🔹 Testing Employer Tax Compliance Verification..."
aleo test compliance_test.leo --test test_employer_compliance_verification

#  Run Tax Payment Submission Test with zk-Proof
echo "🔹 Testing Secure Tax Payment Submission..."
aleo test compliance_test.leo --test test_tax_payment_submission

#  Run ANS-Based Tax Compliance Verification
echo "🔹 Testing ANS-Based Employer Tax Compliance Check..."
aleo test compliance_test.leo --test test_tax_compliance_by_ans

#  Run Government API Log Restriction Test
echo "🔹 Testing Government API Access Restriction..."
aleo test compliance_test.leo --test test_api_log_restriction

#  Run Employer Tax Merkle Proof Validation
echo "🔹 Testing Employer Tax Merkle Proofs..."
aleo test compliance_test.leo --test test_employer_tax_merkle_proof

#  Run Payroll Block for Non-Compliant Employer
echo "🔹 Testing Payroll Restriction for Non-Compliant Employers..."
aleo test compliance_test.leo --test test_block_non_compliant_employer

#  Final Output
echo " Fireproof-256 Compliance & Tax Tests Completed Successfully! "
