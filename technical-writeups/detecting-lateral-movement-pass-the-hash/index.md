---
layout: default
title: detecting-lateral-movement-pass-the-hash
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Detecting Lateral Movement and Pass-the-Hash Attacks in Networks

Lateral movement and Pass-the-Hash (PtH) attacks are key tactics used by attackers after initial compromise to escalate privileges, access sensitive resources, and spread through an environment. Understanding and detecting these behaviors is critical for defending modern enterprise networks.

---

### **1. What is Lateral Movement?**

Lateral movement refers to techniques attackers use to navigate through systems within a network after gaining initial access. Their goal is often to gain elevated privileges or access high-value assets (e.g., domain controllers).

**Key Lateral Movement Techniques:**

* Credential dumping and reuse
* Windows Remote Management (WinRM), PsExec
* RDP (Remote Desktop Protocol)
* SMB and WMI abuse
* SSH pivoting in Unix-like systems

---

### **2. What is Pass-the-Hash (PtH)?**

Pass-the-Hash is a credential replay attack where an attacker uses stolen hashed credentials (typically NTLM hashes on Windows) to authenticate against other systems without cracking them.

**How it works:**

* Extract NTLM hashes from a compromised system (using tools like Mimikatz)
* Reuse the hash to authenticate via SMB or RDP on other machines
* No need to know the actual password

---

### **3. MITRE ATT\&CK Techniques for Reference**

| Technique               | ID        | Description                                             |
| ----------------------- | --------- | ------------------------------------------------------- |
| Credential Dumping      | T1003     | Collecting account credentials, often to facilitate PtH |
| Remote Services         | T1021     | Use of protocols like RDP, SMB for lateral movement     |
| Pass-the-Hash           | T1550.002 | Use of hashed credentials for authentication            |
| Internal Reconnaissance | T1018     | Discovering internal systems and trust relationships    |

---

### **4. Indicators of Lateral Movement**

* **Logons from unusual sources** (new IPs, user workstations logging onto servers)
* **Abnormal use of admin tools** (PsExec, WMI, WinRM)
* **Kerberos ticket anomalies** (unusual ticket-granting behavior)
* **High volume of SMB traffic**
* **Execution of remote commands**

---

### **5. Detection Strategies**

#### a. **SIEM-Based Detection**

* Correlate Windows Event Logs:

  * Event ID 4624 (successful logon)
  * Event ID 4672 (special privileges assigned)
  * Event ID 4688 (process creation)
* Alert on:

  * Multiple logons from the same source to different machines
  * Use of hashes as authentication material
  * Remote execution utilities

#### b. **Honeypots and Canary Accounts**

* Set up decoy user accounts or systems to trap attackers during lateral movement.

#### c. **Behavioral Anomaly Detection**

* Use User and Entity Behavior Analytics (UEBA) to spot deviations from baseline activities.

#### d. **Endpoint Detection and Response (EDR) Tools**

* Tools like Microsoft Defender for Endpoint, CrowdStrike, SentinelOne can detect suspicious token use and credential reuse.

---

### **6. Defense and Mitigation**

* **Enforce least privilege**: Limit lateral movement by restricting admin access.
* **Credential hygiene**: Avoid credential reuse, disable legacy protocols like NTLM.
* **Enable Credential Guard**: Protect LSASS memory in Windows.
* **Segment the network**: Isolate systems to limit movement scope.
* **Log and alert** on suspicious authentication and remote execution behavior.
* **Patch regularly**: Prevent attackers from exploiting known vulnerabilities for pivoting.

---

### **7. Tools for Detection and Response**

* **Sysmon**: Log detailed system activity for correlation
* **Mimikatz**: Use in red team to test your defenses
* **BloodHound**: Map out Active Directory attack paths
* **Wireshark + Zeek**: Monitor lateral movement traffic patterns
* **Elastic Stack**: Use ELK for deep log analysis

---

### **Conclusion**

Detecting lateral movement and Pass-the-Hash attacks requires a combination of strong logging, behavioral analysis, privilege control, and proactive threat hunting. Incorporating these detections into your security posture significantly increases your ability to stop an attacker before they reach critical assets.
