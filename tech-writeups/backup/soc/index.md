---
layout: default 
title: SOC And SIEM
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Security Operations Center (SOC) and SIEM Systems: Architecture and Log Analysis

## Introduction

Modern organizations face increasing cybersecurity threats. To monitor, detect, and respond to these threats in real time, two critical components are employed:

* **SOC (Security Operations Center)** – A centralized facility where security professionals monitor, analyze, and respond to security incidents.
* **SIEM (Security Information and Event Management)** – A software solution that collects and analyzes security logs from various sources to identify anomalies or attacks.

Together, SOC and SIEM form the foundation of an organization’s cybersecurity monitoring and response strategy.

---

## 1. Security Operations Center (SOC): Overview

### 1.1 Definition

A SOC is a **dedicated team and infrastructure** responsible for the **continuous monitoring, assessment, and defense** of IT infrastructure from cybersecurity threats.

### 1.2 Key Functions

* **Threat Detection**: Using tools like SIEM, IDS/IPS, and EDR.
* **Incident Response**: Coordinating containment and recovery.
* **Forensic Analysis**: Investigating breach scope and root causes.
* **Compliance Monitoring**: Ensuring adherence to regulations (e.g., PCI-DSS, HIPAA, GDPR).
* **Threat Hunting**: Proactively searching for undetected threats.

### 1.3 SOC Team Roles

* **Tier 1 Analyst**: Monitors dashboards, filters false positives.
* **Tier 2 Analyst**: Investigates incidents, performs deeper analysis.
* **Tier 3 Analyst**: Threat hunting, malware reverse engineering.
* **SOC Manager**: Oversees operations, strategy, and coordination.
* **Incident Responder**: Handles escalation, recovery, and reporting.

---

## 2. SIEM Systems: Architecture and Components

### 2.1 What is SIEM?

SIEM (Security Information and Event Management) is a platform that provides:

* **Real-time analysis of security alerts**
* **Correlation of log data from multiple systems**
* **Historical data storage for compliance and investigation**

### 2.2 SIEM Architecture

```plaintext
+------------------+      +------------------+      +-------------------+
|  Log Sources     | ---> |   Log Collector  | ---> |   SIEM Engine     |
|  (Firewalls, IDS)|      | (Syslog, Agents) |      | (Parser, Rules,   |
|  Servers, Apps)  |      +------------------+      | Correlator, DB)   |
+------------------+                                 +--------+----------+
                                                            |
                                                            v
                                                   +------------------+
                                                   |   Dashboards,    |
                                                   | Alerts & Reports |
                                                   +------------------+
```

### 2.3 Components

* **Log Collectors**: Agents or services that gather logs from endpoints, applications, and network devices.
* **Normalization/Parsing**: Converts raw log formats into a consistent, structured format.
* **Correlation Engine**: Applies rules or machine learning to detect suspicious patterns across multiple sources.
* **Data Store**: Archives raw and processed logs for retention and forensic analysis.
* **Dashboards & Alerts**: Visualize security events and generate real-time alerts.

---

## 3. Common Log Sources for SIEM

* **Firewalls**: Denied/allowed traffic, IP blocks.
* **Endpoint Detection & Response (EDR)**: File access, process creation, registry changes.
* **Web Servers**: HTTP access logs, 404 errors.
* **Authentication Systems**: Successful and failed logins (e.g., AD, LDAP).
* **Cloud Providers**: AWS CloudTrail, Azure Activity Logs, GCP Audit Logs.

---

## 4. Log Analysis in SIEM

### 4.1 Parsing and Normalization

Logs from different sources are parsed using regular expressions or parsing rules. The normalized format includes fields like:

```json
{
  "timestamp": "2025-07-21T01:00:00Z",
  "src_ip": "10.0.0.5",
  "dst_ip": "192.168.1.10",
  "event_type": "login_failure",
  "username": "admin"
}
```

### 4.2 Correlation Rules

Correlation links multiple log events into a meaningful alert:

* **Example 1**: 5 failed logins followed by a successful login from the same IP → brute-force attack.
* **Example 2**: User downloads >500 MB of data outside business hours → potential data exfiltration.

### 4.3 Use Cases

* **Insider Threat Detection**: Privileged users accessing restricted data.
* **Advanced Persistent Threats (APT)**: Long dwell-time, multi-stage attacks.
* **Malware Outbreaks**: Identifying lateral movement and command & control (C2) traffic.
* **Compliance Violations**: Logins from blacklisted IPs, disabled accounts used.

---

## 5. Advanced Capabilities

### 5.1 User and Entity Behavior Analytics (UEBA)

Applies machine learning to baseline user behavior and flag anomalies (e.g., user downloads 10x more data than usual).

### 5.2 Threat Intelligence Integration

Matches log indicators (e.g., IPs, hashes, URLs) with threat intel feeds for proactive detection.

### 5.3 SOAR Integration

**Security Orchestration, Automation, and Response (SOAR)** platforms integrate with SIEM to automate response workflows (e.g., isolate endpoint, disable user).

---

## 6. Challenges

* **False Positives**: Alert fatigue due to noisy rules.
* **Log Volume**: High ingestion costs and storage overhead.
* **Complex Configuration**: Rules and normalization can be time-consuming.
* **Encrypted Traffic**: Limits visibility without SSL interception.

---

## 7. Popular SIEM Tools

| Tool               | Description                                    |
| ------------------ | ---------------------------------------------- |
| Splunk             | Powerful search, customizable dashboards       |
| IBM QRadar         | Enterprise-grade with strong correlation       |
| ELK Stack          | Open-source; ElasticSearch + Logstash + Kibana |
| Microsoft Sentinel | Cloud-native SIEM on Azure                     |
| ArcSight           | Legacy tool with extensive integrations        |
| Graylog            | Lightweight and open-source                    |

---

## Conclusion

The integration of a well-staffed SOC and a powerful SIEM system enables organizations to detect, investigate, and respond to cyber threats efficiently. By analyzing logs from across the IT landscape, SIEM tools offer invaluable insights, and with automated response through SOAR or threat intelligence enrichment, organizations can stay ahead of adversaries in today’s dynamic threat environment.
