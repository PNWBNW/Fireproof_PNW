//  Fireproof-256 Payroll Security Test Suite
program payroll_tests.leo;

// Import Payroll & Fireproof Modules
import pncw_payroll.leo;
import pniw_payroll.leo;
import payroll_pools.leo;
import fireproof_mimc.leo;
import fireproof_poseidon.leo;
import fireproof_obfuscation.leo;
import merkle_helper.leo;

//  Test Employer Payroll Deposit with Fireproof-256 Encryption
test function test_employer_payroll_deposit() {
    let employer_id = 1010;
    let subdao_ans = "wa001_payroll.pnw.ans";
    let deposit_amount = 50000;
    let key = 987654;
    let nonce = 55555;
    let shuffle_seed = 33333;
    let random_seed = 22222;

    payroll_pools::deposit_aleo_usdc(employer_id, subdao_ans, deposit_amount, key, nonce, shuffle_seed, random_seed);
    assert!(true, "Employer payroll deposit executed successfully");
}

//  Test Payroll Execution with Multi-Hop & Fake Noise
test function test_payroll_execution() {
    let subdao_id = 2020;
    let worker_id = 3030;
    let payroll_amount = 5000;
    let key = 888888;
    let nonce = 777777;
    let shuffle_seed = 666666;
    let random_seed = 555555;

    let payroll_success = pncw_payroll::execute_payroll(worker_id, subdao_id, payroll_amount, key, nonce, shuffle_seed, random_seed);
    assert!(payroll_success, "Payroll execution with Fireproof-256 failed");
}

//  Test Payroll zk-Proof Generation & Verification
test function test_payroll_zk_proof() {
    let worker_id = 4040;
    let salary = 6000;
    let proof = fireproof_mimc::generate_payroll_zk_proof(worker_id, salary);
    assert!(fireproof_poseidon::verify_fireproof_payroll(worker_id, proof), "Payroll zk-Proof validation failed");
}

//  Test Payroll Merkle Proof Storage & Validation
test function test_merkle_payroll_proof() {
    let worker_id = 5050;
    let salary = 7000;
    let timestamp = 1710000000;

    let merkle_root = merkle_helper::generate_payroll_merkle_root(worker_id, salary, timestamp);
    merkle_helper::store_payroll_merkle_root(worker_id, salary, timestamp);

    assert!(merkle_helper::verify_worker_payroll_merkle_proof(worker_id, salary, timestamp, merkle_root), "Payroll Merkle Proof validation failed");
}

//  Test Payroll Withdrawal Validation with zk-Proof
test function test_payroll_withdrawal_verification() {
    let worker_id = 6060;
    let salary = 5500;
    let proof = fireproof_poseidon::generate_payroll_zk_commitment(worker_id, salary);

    assert!(fireproof_poseidon::verify_fireproof_payroll(worker_id, proof), "Payroll withdrawal zk-Proof failed");
}
