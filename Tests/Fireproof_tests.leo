//  Fireproof-256 Security & zk-Proof Test Suite
program fireproof_tests.aleo;

// Import Fireproof-256 Modules
import fireproof_mimc.leo;
import fireproof_poseidon.leo;
import fireproof_obfuscation.leo;
import merkle_helper.leo;

//  Test MiMC Hashing Function
test function test_mimc_hash() {
    let input = 42;
    let hashed = fireproof_mimc::mimc_hash(input);
    assert!(hashed != input, "MiMC hash function failed");
}

//  Test Poseidon Hashing Function
test function test_poseidon_hash() {
    let input = 99;
    let hashed = fireproof_poseidon::poseidon_hash(input);
    assert!(hashed != input, "Poseidon hash function failed");
}

//  Test zk-Proof Generation for Payroll
test function test_payroll_zk_proof() {
    let worker_id = 1234;
    let salary = 5000;
    let proof = fireproof_mimc::generate_payroll_zk_proof(worker_id, salary);
    assert!(fireproof_poseidon::verify_fireproof_payroll(worker_id, proof), "Payroll zk-Proof verification failed");
}

//  Test zk-Proof Generation for Tax Compliance
test function test_tax_compliance_zk_proof() {
    let employer_id = 9876;
    let tax_paid = 2000;
    let proof = fireproof_mimc::generate_tax_compliance_zk_proof(employer_id, tax_paid);
    assert!(fireproof_poseidon::verify_fireproof_tax_compliance(employer_id, proof, tax_paid), "Tax compliance zk-Proof verification failed");
}

//  Test Multi-Hop Transfer Obfuscation
test function test_multi_hop_transfer() {
    let sender = 1111;
    let recipient = 2222;
    let amount = 3000;
    let random_seed = 8888;

    fireproof_obfuscation::fireproof_multi_hop_transfer(sender, recipient, amount, random_seed);
    assert!(true, "Multi-Hop Transfer executed without error");
}

//  Test Fake Noise Transaction Generator
test function test_fake_noise() {
    let seed = 5555;
    let noise = fireproof_obfuscation::generate_fake_noise(seed);
    assert!(noise != 0, "Fake noise generation failed");
}

//  Test Merkle Proof Generation & Validation (Payroll)
test function test_merkle_payroll_proof() {
    let worker_id = 5678;
    let salary = 7000;
    let timestamp = 1700000000;

    let merkle_root = merkle_helper::generate_payroll_merkle_root(worker_id, salary, timestamp);
    merkle_helper::store_payroll_merkle_root(worker_id, salary, timestamp);

    assert!(merkle_helper::verify_worker_payroll_merkle_proof(worker_id, salary, timestamp, merkle_root), "Payroll Merkle Proof validation failed");
}

//  Test Merkle Proof Generation & Validation (Taxes)
test function test_merkle_tax_proof() {
    let employer_id = 3456;
    let tax_paid = 1000;

    let merkle_root = merkle_helper::generate_employer_merkle_root(employer_id, tax_paid);
    merkle_helper::store_employer_merkle_root(employer_id, tax_paid);

    assert!(merkle_helper::verify_employer_tax_merkle_proof(employer_id, tax_paid, merkle_root), "Employer Tax Merkle Proof validation failed");
}
