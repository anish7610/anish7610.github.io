---
layout: default
title: secure-boot-measured-boot-uefi
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Secure Boot and Measured Boot in UEFI Systems

Secure Boot and Measured Boot are two critical components in the UEFI (Unified Extensible Firmware Interface) specification that enhance the integrity and trustworthiness of a system during the boot process. While both aim to protect against rootkits and bootkits, they operate with different mechanisms and goals.

---

###  Secure Boot

**Objective:** Prevent unauthorized or malicious bootloaders, kernels, or OS components from executing during system startup.

#### How It Works:

1. **Digital Signature Verification:** UEFI firmware verifies the signature of the next component (e.g., bootloader). Only signed and trusted binaries, according to the UEFI firmware’s database (`db`), are allowed to load.
2. **Key Management:**

   * **Platform Key (PK):** Establishes platform ownership.
   * **Key Exchange Key (KEK):** Used to manage updates to the `db` and `dbx`.
   * **db:** List of trusted signatures.
   * **dbx:** List of revoked (blacklisted) signatures.
3. **Chain of Trust:** Begins at the firmware and proceeds through the bootloader, kernel, and OS components—each component must be signed and verified.

#### Benefits:

* Prevents rootkits and early-boot malware.
* Ensures only vendor-trusted software runs during startup.

#### Limitations:

* May restrict use of unsigned or custom OS kernels unless enrolled manually.
* Can be disabled in BIOS/UEFI settings (unless locked by vendor policy).

---

###  Measured Boot

**Objective:** Record and report the integrity of the boot process, allowing detection of unauthorized modifications.

#### How It Works:

1. **TPM (Trusted Platform Module):** Each stage of the boot process calculates a hash of the next stage and stores it in TPM Platform Configuration Registers (PCRs).
2. **Measurements:** Include UEFI firmware, bootloaders, kernel, and critical configuration files.
3. **Remote Attestation:** A remote system (e.g., enterprise attestation server) can request a quote of the TPM PCR values to verify boot integrity.
4. **Integrity Validation:** Based on known-good hashes (golden measurements), an enterprise system can determine if the boot process was tampered with.

#### Benefits:

* Detects unauthorized changes even if Secure Boot was bypassed.
* Enables remote auditing and policy enforcement (e.g., deny network access to tampered systems).

#### Limitations:

* Requires TPM hardware and proper attestation infrastructure.
* Doesn’t block execution; it only records for later analysis.

---

###  Secure Boot vs Measured Boot

| Feature     | Secure Boot                         | Measured Boot                         |
| ----------- | ----------------------------------- | ------------------------------------- |
| Purpose     | Prevent execution of untrusted code | Record integrity for later validation |
| Mechanism   | Signature verification              | Hash measurement into TPM             |
| Enforcement | Active (blocks bad code)            | Passive (logs bad code)               |
| Dependency  | UEFI, signed binaries               | TPM hardware                          |
| Use Case    | End-user security (consumer PCs)    | Enterprise policy enforcement         |

---

###  Real-World Example

**Secure Boot in Action:** On a Windows 11 machine, the bootloader and kernel are signed by Microsoft. If a rootkit modifies the bootloader, the signature won’t match, and the firmware blocks it.

**Measured Boot in Action:** In an enterprise network, the TPM records boot measurements. During login, the enterprise server checks the TPM quote. If bootloader hashes don’t match the golden image, access is denied or flagged.

---

###  Implementation Tips

* Enable Secure Boot in UEFI BIOS settings.
* Maintain updated keys and revocation lists.
* Use tools like `tpm2-tools` to inspect PCR values on Linux.
* Integrate Measured Boot with Microsoft Defender for Endpoint or Linux attestation frameworks for centralized monitoring.

---

By combining Secure Boot and Measured Boot, modern systems gain both **protection** and **visibility**—one prevents threats at the source, the other detects them when prevention fails.
