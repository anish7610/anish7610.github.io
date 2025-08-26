---
layout: default 
title: IDS/IPS
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Intrusion Detection and Prevention Systems (IDS/IPS)

## Overview

Intrusion Detection and Prevention Systems (IDS/IPS) are critical components in a layered security architecture. They monitor network traffic or system activity for malicious actions or policy violations and act upon detection. While both aim to detect threats, the key difference lies in prevention: **IDS detects**, whereas **IPS detects and blocks** malicious activity in real time.

---

## Types of IDS/IPS

### 1. **Host-Based IDS/IPS (HIDS/HIPS)**

* Monitors a **single host** for suspicious activity.
* Examines system calls, application logs, file-system modifications, etc.
* **Example Tools:** OSSEC, Tripwire

### 2. **Network-Based IDS/IPS (NIDS/NIPS)**

* Monitors **network traffic** in real time.
* Uses packet inspection techniques to analyze network protocol behavior.
* **Example Tools:** Snort, Suricata, Cisco Firepower

---

## Key Functionalities

| Feature       | IDS                   | IPS                            |
| ------------- | --------------------- | ------------------------------ |
| Detection     |                      |                               |
| Prevention    |                      |                               |
| Response Type | Passive (alerts/logs) | Active (blocks, drops packets) |
| Deployment    | Out-of-band           | Inline                         |

---

## Detection Techniques

### 1. **Signature-Based Detection**

* Uses known patterns of malicious behavior (signatures).
* **Pros:** Fast, low false positives.
* **Cons:** Cannot detect unknown (zero-day) attacks.

### 2. **Anomaly-Based Detection**

* Establishes a baseline of "normal" behavior and flags deviations.
* **Pros:** Can detect unknown threats.
* **Cons:** Higher false positive rate, requires tuning.

### 3. **Hybrid Detection**

* Combines signature and anomaly detection.
* Provides balanced coverage and accuracy.

---

## IDS/IPS Lifecycle in a Network

1. **Traffic Capture**
   NIDS tools capture packets via network tap or span port.

2. **Analysis**
   Data is parsed and analyzed for matches with known signatures or behavioral anomalies.

3. **Alerting/Blocking**

   * IDS: Sends alerts to SIEM or administrators.
   * IPS: Blocks traffic, resets connections, or modifies firewall rules.

4. **Logging and Forensics**
   Events are logged for post-incident investigation.

---

## Real-World Example: Snort as IDS/IPS

* **Snort** is a popular open-source NIDS/NIPS.
* Uses rule-based detection:

  ```snort
  alert tcp any any -> 192.168.1.0/24 80 (msg:"Possible HTTP Attack"; content:"/cmd.exe"; nocase; sid:1000001;)
  ```
* Can operate in:

  * **IDS mode:** Logs suspicious activity.
  * **IPS mode:** Blocks matching packets (with tools like `inline` or `NFQUEUE`).

---

## Use Cases

* **Enterprise Perimeter Defense**: Detect lateral movement or external attacks.
* **Data Center Security**: Monitor east-west traffic inside VLANs.
* **Cloud Security**: Virtual IDS/IPS monitor traffic between virtual machines.
* **Regulatory Compliance**: Enforce PCI DSS, HIPAA, and other mandates.

---

## Limitations

* **Encrypted Traffic Blindness**: Cannot inspect HTTPS without SSL decryption.
* **False Positives/Negatives**: May miss stealthy attacks or flag benign traffic.
* **Performance Bottleneck (IPS)**: Inline placement can introduce latency.

---

## Best Practices

* **Regularly Update Signatures**.
* **Tune Rules to Environment** to reduce false positives.
* **Integrate with SIEM** for centralized log management and correlation.
* **Use in conjunction with firewalls and endpoint protection** for defense-in-depth.

---

## Future of IDS/IPS

* **AI/ML Integration** for behavioral analysis and anomaly detection.
* **Deep Packet Inspection (DPI)** for more accurate threat detection.
* **Cloud-native IDS/IPS** solutions like AWS GuardDuty, Azure Defender.
* **Zero Trust Architectures** incorporating micro-segmentation and continuous monitoring.

---

## Conclusion

IDS and IPS are foundational tools for threat detection and network security enforcement. While IDS provides visibility and early warning, IPS adds a layer of proactive defense by blocking malicious traffic. The choice between the two—or combining both—depends on the organization’s risk posture, infrastructure complexity, and performance requirements.
