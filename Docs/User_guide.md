#  Fireproof-256 User Guide  
**Private & Compliant zk-Payroll for Workers & Employers**  

---  
##  **Overview**  
Fireproof-256 is a **zero-knowledge payroll system** that ensures **privacy, compliance, and security** for workers and employers. It supports both **Aleo & Aztec networks** for payroll execution.  

✅ **Fully zk-Verified Payroll Execution**  
✅ **Multi-Hop Transfers & Fake Noise for Privacy**  
✅ **Automated Tax Compliance with Government API**  
✅ **Seamless Cross-Chain Payroll Between Aleo & Aztec**  

---  
##  **For Workers**  
### **1️⃣ Getting Started with Fireproof-256 Payroll**  
- **You must be ZPass-verified** to receive payroll.  
- **You must register your ANS (Aleo Name Service)** before payroll processing.  
- **You can receive payroll on AleoUSDC (Aleo) or CircleUSDC (Aztec).**  

### **2️⃣ How Payroll Works**  
✔ **Employers deposit funds into SubDAO payroll reserves.**  
✔ **Payroll zk-Proofs validate your identity before processing.**  
✔ **Your payroll is executed with Fireproof-256 encryption.**  
✔ **Taxes are deducted automatically & zk-Proofed.**  
✔ **You receive funds privately via Aleo or Aztec.**  

### **3️⃣ Switching Between Aleo & Aztec Payroll**  
To change payroll networks, use the payroll settings:  
```bash
aleo execute worker_payroll_settings.leo --function set_preferred_network --args worker_id Aztec

This updates your payroll destination without exposing your data.

4️⃣ Checking Your Payroll Balance

You can verify your payroll balance privately:

aleo execute worker_payroll_settings.leo --function check_balance --args worker_id


---

🏢 For Employers

1️⃣ Setting Up Fireproof Payroll

Employers must be ZPass-verified before funding payroll.

Employers deposit payroll into SubDAO-managed reserves.

Tax compliance is required before payroll execution.


2️⃣ Depositing Payroll Funds

aleo execute payroll_pools.leo --function deposit_aleo_usdc --args employer_id subdao_ans amount

Ensures payroll is pre-funded before worker payments.

3️⃣ Paying Workers

aleo execute pncw_payroll.leo --function execute_payroll --args worker_id employer_id amount

Workers are verified before funds are released.

4️⃣ Verifying Tax Compliance

Employers can verify tax compliance before payroll execution:

aleo execute process_tax_compliance.leo --function check_compliance --args employer_id


---

🔥 Privacy & Security

zk-Proof & Multi-Hop Encryption

✔ Payroll zk-Proofs ensure only verified workers get paid.
✔ Multi-Hop Transfers & Fake Noise hide payroll origins.
✔ Employers & workers never see direct payment paths.
✔ Merkle-Proofed tax history for government audits.


---

🔗 Cross-Chain Payroll Execution (Aleo ↔ Aztec)

Workers can choose between AleoUSDC & CircleUSDC payroll.
To convert payroll from Aleo to Aztec, employers can use:

./scripts/convert_aleo_to_aztec.sh

This transfers payroll securely using Fireproof encryption.


---

📌 Need Help?

If you have any issues with Fireproof-256 payroll, reach out to your SubDAO administrator or employer.

📢 Fireproof-256: zk-Verified Payroll for Privacy & Compliance 🚀

---

