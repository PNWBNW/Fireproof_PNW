//  Fireproof-256 Enhanced Payroll Pool Contract
program payroll_pools.aleo;

//  Payroll Pool Mappings (Per SubDAO)
mapping payroll_balances: public hashmap<string, field>;  // SubDAO payroll fund pools (ANS-based, encrypted)
mapping employer_obligations: public hashmap<address, u64>;  // Employer payroll obligations
mapping restricted_employers: public hashmap<address, bool>;  // Employer restriction for non-compliance

//  Encrypt Payroll Balances Using MiMC (Fireproof-256)
function fireproof_encrypt_balance(balance: field, key: field, nonce: field) -> field {
    return mimc_hash(balance + key + nonce);
}

//  One-Time Employer Address Shuffling
function generate_shuffled_employer_address(employer: address, shuffle_seed: field) -> address {
    return hash(employer as field + shuffle_seed);
}

//  Multi-Hop Transfers for Deposits
function generate_hop_addresses(random_seed: field) -> (address, address, address) {
    let hop1 = hash(random_seed + 1);
    let hop2 = hash(random_seed + 2);
    let hop3 = hash(random_seed + 3);
    return (hop1, hop2, hop3);
}

//  Deposits USDC into a specific SubDAO payroll pool (Fireproof-256)
function deposit_aleo_usdc(
    public employer: address, 
    public subdao_ans: string, 
    public amount: field, 
    public key: field, 
    public nonce: field, 
    public shuffle_seed: field, 
    public random_seed: field
) -> bool {
    
    let encrypted_balance = fireproof_encrypt_balance(amount, key, nonce);
    
    // Generate Shuffled Employer Address
    let shuffled_employer = generate_shuffled_employer_address(employer, shuffle_seed);

    // Multi-Hop Transfers for Employer Deposits
    let (hop1, hop2, hop3) = generate_hop_addresses(random_seed);
    transfer_private(shuffled_employer, hop1, encrypted_balance);
    transfer_private(hop1, hop2, encrypted_balance);
    transfer_private(hop2, hop3, encrypted_balance);
    transfer_private(hop3, subdao_ans, encrypted_balance);

    //  Fake Noise Deposits for Obfuscation
    let fake_deposit = mimc_hash(random_seed + 77);
    transfer_private(shuffled_employer, hop1, fake_deposit);

    // Update Payroll Pool
    let current_balance = payroll_balances.get_or_use(subdao_ans, 0u64);
    payroll_balances.insert(subdao_ans, current_balance + encrypted_balance);
    
    return true;
}

//  Withdraws USDC from a SubDAO payroll pool for payroll processing
function withdraw_for_payroll(
    public employer: address, 
    public subdao_ans: string, 
    public amount: field, 
    public key: field, 
    public nonce: field
) -> bool {

    let current_balance = payroll_balances.get_or_use(subdao_ans, 0u64);
    let employer_obligation = employer_obligations.get_or_use(employer, 0u64);

    // Ensure employer maintains 25% more than total obligations
    let required_balance = employer_obligation * 125u64 / 100u64;
    ensure!(current_balance >= required_balance, "SubDAO Payroll Pool is below the required threshold");
    ensure!(current_balance >= amount, "Insufficient USDC balance in payroll pool");

    let encrypted_amount = fireproof_encrypt_balance(amount, key, nonce);
    payroll_balances.insert(subdao_ans, current_balance - encrypted_amount);
    
    return true;
}

//  Sets the required employer payroll obligation
function set_employer_obligation(public employer: address, public obligation: u64) -> bool {
    employer_obligations.insert(employer, obligation);
    return true;
}

//  Restricts an employer from using payroll funds due to non-compliance
function restrict_employer(public employer: address) -> bool {
    restricted_employers.insert(employer, true);
    return true;
}

//  Reinstates a previously restricted employer
function reinstate_employer(public employer: address) -> bool {
    ensure!(restricted_employers.contains(employer), "Employer is not restricted");
    restricted_employers.insert(employer, false);
    return true;
}

//  Retrieves the encrypted payroll balance of a specific SubDAO payroll pool
function get_subdao_payroll_balance(public subdao_ans: string) -> field {
    return payroll_balances.get_or_use(subdao_ans, 0u64);
}

//  Retrieves the required minimum balance for a SubDAO payroll pool
function get_required_pool_balance(public employer: address) -> u64 {
    let employer_obligation = employer_obligations.get_or_use(employer, 0u64);
    return employer_obligation * 125u64 / 100u64;
}

//  Checks if an employer is restricted from payroll access
function is_employer_restricted(public employer: address) -> bool {
    return restricted_employers.get_or_use(employer, false);
}
