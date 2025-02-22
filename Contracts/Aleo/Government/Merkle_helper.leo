//  Fireproof-256 Merkle Proof Helper
program merkle_helper.aleo;

//  Employer Payroll & Tax Merkle Roots
mapping employer_merkle_roots: mapping(field, field);  // Employer compliance roots
mapping payroll_merkle_roots: mapping(field, field);   // Worker payroll history roots

//  Generate Merkle Root for Employer Tax Compliance
function generate_employer_merkle_root(employer_id: field, tax_paid: field) -> field {
    return poseidon_hash(employer_id + tax_paid);
}

//  Generate Merkle Root for Worker Payroll
function generate_payroll_merkle_root(worker_id: field, salary: field, timestamp: field) -> field {
    return poseidon_hash(worker_id + salary + timestamp);
}

//  Store Merkle Root for Employer Tax Compliance
function store_employer_merkle_root(employer_id: field, tax_paid: field) {
    let merkle_root = generate_employer_merkle_root(employer_id, tax_paid);
    employer_merkle_roots.insert(employer_id, merkle_root);
}

//  Store Merkle Root for Worker Payroll
function store_payroll_merkle_root(worker_id: field, salary: field, timestamp: field) {
    let merkle_root = generate_payroll_merkle_root(worker_id, salary, timestamp);
    payroll_merkle_roots.insert(worker_id, merkle_root);
}

//  Verify Merkle Proof for Employer Tax Compliance
function verify_employer_tax_merkle_proof(employer_id: field, tax_paid: field, proof: field) -> bool {
    let expected_root = employer_merkle_roots.get_or_use(employer_id, 0);
    return expected_root == proof;
}

//  Verify Merkle Proof for Worker Payroll
function verify_worker_payroll_merkle_proof(worker_id: field, salary: field, timestamp: field, proof: field) -> bool {
    let expected_root = payroll_merkle_roots.get_or_use(worker_id, 0);
    return expected_root == proof;
}
