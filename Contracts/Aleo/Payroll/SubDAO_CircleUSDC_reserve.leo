//  Fireproof-256 Enhanced SubDAO CircleUSDC Payroll Reserve Contract
program SubDAO_CircleUSDC_Reserve.aleo;

// Import necessary functions
import oversightdao_reserve.leo;
import aleo_ans::*;
import fireproof_crypto.leo; // Includes MiMC, Poseidon, zk-Proofs
import circle_usdc.leo; // Circle USDC module

//  Fireproof SubDAO Payroll Pool Struct
struct SubDAO_CircleUSDC_Pool {
    subdao_id: field,
    subdao_ans: string,
    encrypted_balance: field,
}

//  Mapping of SubDAO CircleUSDC Pools
mapping subdao_circle_pools: mapping(field, SubDAO_CircleUSDC_Pool);

//  Encrypt USDC Balance Using MiMC (Fireproof-256)
function fireproof_encrypt_balance(balance: field, key: field, nonce: field) -> field {
    return mimc_hash(balance + key + nonce);
}

//  One-Time Address Shuffling Using Ephemeral Public Keys
function generate_shuffled_subdao_address(subdao_id: field, shuffle_seed: field) -> field {
    return hash(subdao_id + shuffle_seed);
}

//  Function: Deposit CircleUSDC for Payroll (Multi-Hop + zk-Proof)
function deposit_circle_usdc(
    subdao_id: field,
    employer_id: field,
    amount: field,
    key: field,
    nonce: field,
    shuffle_seed: field,
    random_seed: field
) {
    let subdao_ans = aleo_ans::get_ans(subdao_id);
    ensure!(subdao_ans != "", "Invalid SubDAO ANS registration");

    let encrypted_balance = fireproof_encrypt_balance(amount, key, nonce);

    // Generate Shuffled Employer Address
    let shuffled_employer = generate_shuffled_subdao_address(employer_id, shuffle_seed);

    // Multi-Hop Transfers for Employer Deposits
    let (hop1, hop2, hop3) = generate_hop_addresses(random_seed);
    transfer_private(shuffled_employer, hop1, encrypted_balance);
    transfer_private(hop1, hop2, encrypted_balance);
    transfer_private(hop2, hop3, encrypted_balance);
    transfer_private(hop3, subdao_id, encrypted_balance);

    //  Fake Noise Deposits for Obfuscation
    let fake_deposit = mimc_hash(random_seed + 77);
    transfer_private(shuffled_employer, hop1, fake_deposit);

    // Update Payroll Pool
    if subdao_circle_pools.contains(subdao_id) {
        let existing_pool = subdao_circle_pools[subdao_id];
        existing_pool.encrypted_balance += encrypted_balance;
        subdao_circle_pools[subdao_id] = existing_pool;
    } else {
        let new_pool = SubDAO_CircleUSDC_Pool {
            subdao_id,
            subdao_ans,
            encrypted_balance,
        };
        subdao_circle_pools[subdao_id] = new_pool;
    }
}

//  Function: Process Payroll with zk-Proof Withdrawals
function process_circle_payroll(
    subdao_id: field,
    worker_id: field,
    salary: field,
    key: field,
    nonce: field,
    shuffle_seed: field,
    random_seed: field
) -> bool {

    ensure!(subdao_circle_pools.contains(subdao_id), "SubDAO not registered");

    // Generate Shuffled Worker Address
    let shuffled_worker = generate_shuffled_subdao_address(worker_id, shuffle_seed);

    // Encrypt Salary
    let encrypted_salary = fireproof_encrypt_balance(salary, key, nonce);

    // Multi-Hop Transfers for Payroll
    let (hop1, hop2, hop3) = generate_hop_addresses(random_seed);
    transfer_private(subdao_id, hop1, encrypted_salary);
    transfer_private(hop1, hop2, encrypted_salary);
    transfer_private(hop2, hop3, encrypted_salary);
    transfer_private(hop3, shuffled_worker, encrypted_salary);

    //  Fake Noise Payroll Transactions for Obfuscation
    let fake_worker = hash(random_seed + 99);
    let fake_salary = mimc_hash(random_seed + 77);
    transfer_private(subdao_id, fake_worker, fake_salary);

    // zk-Proof Required for Worker Withdrawals
    return true;
}

//  zk-Proof Payroll Withdrawals
function zk_withdraw_salary(worker_id: field, proof_of_salary: field) -> bool {
    let is_valid = verify_fireproof_payroll(worker_id, proof_of_salary);
    ensure!(is_valid, "Invalid payroll proof");

    // Transfer Encrypted Salary to Worker
    return transfer_private(worker_id, proof_of_salary);
}

//  Function: Get Encrypted SubDAO Balance (Publicly Visible)
function get_subdao_balance(subdao_id: field) -> field {
    if subdao_circle_pools.contains(subdao_id) {
        return subdao_circle_pools[subdao_id].encrypted_balance;
    }
    return 0;
}

//  Event Emitters
event payroll_disbursement_event(subdao_id: field, worker_id: field, amount: field);
