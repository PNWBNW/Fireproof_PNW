//  Fireproof-256 Enhanced Tax Compliance Contract
program process_tax_compliance.aleo;

// Import necessary modules
import 0x01::payroll;
import 0x01::pncw_payroll;
import 0x01::pniw_payroll;
import 0x01::merkle_helper;
import 0x01::government_api;
import fireproof_crypto.leo; // MiMC, Poseidon, zk-Proofs

//  Mappings
mapping employer_tax:
    key u64 as field;
    value EmployerTaxRecord as record; // Employer tax compliance records

mapping employer_zpass_verified:
    key u64 as field;
    value bool as field; // Employer ZPass verification status

//  New ANS Mappings
mapping ans_registry:
    key u64 as field;
    value string as field;  // Maps employer IDs to ANS names

mapping ans_reverse_lookup:
    key string as field;
    value u64 as field;  // Maps ANS names to employer IDs

//  Fireproof Tax Structs
struct EmployerTaxRecord has store {
    employer_id: u64,
    encrypted_total_tax_paid: field,  // Encrypted tax payments
    last_payment_timestamp: u64,
    is_compliant: bool,
}

//  Encrypt Tax Payments Using MiMC (Fireproof-256)
function fireproof_encrypt_tax(amount: field, key: field, nonce: field) -> field {
    return mimc_hash(amount + key + nonce);
}

//  One-Time Employer Address Shuffling
function generate_shuffled_employer_address(employer_id: field, shuffle_seed: field) -> field {
    return hash(employer_id + shuffle_seed);
}

//  Function: Process Tax Compliance for PNcW and PNiW Payrolls (zk-Proof Verified)
public function process_tax_compliance(employer_id: u64, payroll_type: u8) -> bool {
    ensure!(employer_zpass_verified.get_or_use(employer_id, false), "Employer must be ZPass verified for tax compliance");

    let mut tax_due: field = 0;

    // Determine tax obligations based on payroll type
    match payroll_type {
        0 => tax_due = pncw_payroll::calculate_tax_due(employer_id),
        1 => tax_due = pniw_payroll::calculate_tax_due(employer_id),
        _ => return false, // Invalid payroll type
    };

    let mut employer_record = employer_tax.get_or_use(employer_id, EmployerTaxRecord {
        employer_id: employer_id,
        encrypted_total_tax_paid: 0u64,
        last_payment_timestamp: 0u64,
        is_compliant: false,
    });

    // Update compliance status using zk-Proof verification
    employer_record.is_compliant = verify_fireproof_tax_compliance(employer_id, employer_record.encrypted_total_tax_paid, tax_due);
    employer_tax[employer_id] = employer_record;

    return employer_record.is_compliant;
}

//  Function: Employers Pay Taxes with Fireproof-256 (Multi-Hop + zk-Proof)
public function pay_taxes(
    employer_id: u64, 
    amount: field, 
    key: field, 
    nonce: field, 
    shuffle_seed: field, 
    random_seed: field
) {
    ensure!(employer_zpass_verified.get_or_use(employer_id, false), "Employer must be ZPass verified to pay taxes");

    let mut employer_record = employer_tax.get_or_use(employer_id, EmployerTaxRecord {
        employer_id: employer_id,
        encrypted_total_tax_paid: 0u64,
        last_payment_timestamp: 0u64,
        is_compliant: false,
    });

    // Encrypt Tax Payment
    let encrypted_tax_payment = fireproof_encrypt_tax(amount, key, nonce);

    // Generate Shuffled Employer Address
    let shuffled_employer = generate_shuffled_employer_address(employer_id, shuffle_seed);

    // Multi-Hop Transfers for Tax Payments
    let (hop1, hop2, hop3) = generate_hop_addresses(random_seed);
    transfer_private(shuffled_employer, hop1, encrypted_tax_payment);
    transfer_private(hop1, hop2, encrypted_tax_payment);
    transfer_private(hop2, hop3, encrypted_tax_payment);
    transfer_private(hop3, government_api::tax_authority(), encrypted_tax_payment);

    //  Fake Noise Tax Payments for Obfuscation
    let fake_tax_payment = mimc_hash(random_seed + 77);
    transfer_private(shuffled_employer, hop1, fake_tax_payment);

    // Update Employer Tax Record
    employer_record.encrypted_total_tax_paid += encrypted_tax_payment;
    employer_record.last_payment_timestamp = timestamp();
    employer_record.is_compliant = process_tax_compliance(employer_id, 0) || process_tax_compliance(employer_id, 1);

    employer_tax[employer_id] = employer_record;
}

//  Function: Check Employer Tax Compliance Status (zk-Proof Verified)
public function check_compliance(employer_id: u64) -> bool {
    let employer_record = employer_tax.get_or_use(employer_id, EmployerTaxRecord {
        employer_id: employer_id,
        encrypted_total_tax_paid: 0u64,
        last_payment_timestamp: 0u64,
        is_compliant: false,
    });

    return employer_record.is_compliant;
}

//  Function: Employers Pay Taxes Using ANS (Fireproof-256)
public function pay_taxes_by_ans(employer_ans: string, amount: field, key: field, nonce: field, shuffle_seed: field, random_seed: field) {
    let employer_id = lookup_employer_by_ans(employer_ans);
    pay_taxes(employer_id, amount, key, nonce, shuffle_seed, random_seed);
}

//  Utility function: Lookup an Employer's ANS Name by ID
public function lookup_employer_by_id(employer_id: u64) -> string {
    ensure!(ans_registry.contains(employer_id), "Employer does not have an ANS name");
    return ans_registry[employer_id];
}

//  Utility function: Lookup an Employer's ID by ANS Name
public function lookup_employer_by_ans(ans_name: string) -> u64 {
    ensure!(ans_reverse_lookup.contains(ans_name), "ANS name not found");
    return ans_reverse_lookup[ans_name];
}
