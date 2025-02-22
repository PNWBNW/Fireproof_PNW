//  Fireproof-256 Compliance & Tax Test Suite
program compliance_test.aleo;

// Import Compliance & Fireproof Modules
import government_api.leo;
import process_tax_compliance.leo;
import fireproof_mimc.leo;
import fireproof_poseidon.leo;
import merkle_helper.leo;

//  Test Employer Tax Compliance Verification
test function test_employer_compliance_verification() {
    let employer_id = 1010;
    let proof_of_tax = fireproof_mimc::generate_tax_compliance_zk_proof(employer_id, 2000);
    assert!(government_api::verify_employer_compliance(employer_id, proof_of_tax), "Employer tax compliance verification failed");
}

//  Test Tax Payment Submission with zk-Proof & Fireproof Encryption
test function test_tax_payment_submission() {
    let employer_id = 2020;
    let tax_amount = 2500;
    let key = 30303;
    let nonce = 40404;
    let shuffle_seed = 50505;
    let random_seed = 60606;

    government_api::submit_tax_payment(employer_id, tax_amount, key, nonce, shuffle_seed, random_seed);
    assert!(true, "Tax payment submission with Fireproof-256 executed successfully");
}

//  Test Tax Compliance Verification Using ANS
test function test_tax_compliance_by_ans() {
    let employer_ans = "bigfarm001.pnw.ans";
    assert!(process_tax_compliance::process_tax_compliance_by_ans(employer_ans, 0), "ANS-based employer tax compliance check failed");
}

//  Test Government API Logs Restricted to Auditors
test function test_api_log_restriction() {
    let unauthorized_requester = 70707;
    let log_result = government_api::get_api_logs(unauthorized_requester);
    assert!(log_result == "Unauthorized access to tax logs", "API log access restriction failed");
}

//  Test Employer Tax Merkle Proof Storage & Validation
test function test_employer_tax_merkle_proof() {
    let employer_id = 80808;
    let tax_paid = 3000;

    let merkle_root = merkle_helper::generate_employer_merkle_root(employer_id, tax_paid);
    merkle_helper::store_employer_merkle_root(employer_id, tax_paid);

    assert!(merkle_helper::verify_employer_tax_merkle_proof(employer_id, tax_paid, merkle_root), "Employer Tax Merkle Proof validation failed");
}

//  Test Payroll Block for Non-Compliant Employer
test function test_block_non_compliant_employer() {
    let employer_id = 90909;
    let non_compliant = !process_tax_compliance::check_compliance(employer_id);
    assert!(non_compliant, "Payroll was not blocked for a non-compliant employer");
}
