---
layout: default
title: ssl-tls-handshake-packet-capture
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


### SSL/TLS Handshake with Packet Capture Analysis (Wireshark)

---

### 1. Introduction

The **SSL/TLS handshake** is the foundational process for establishing a secure communication channel over the internet. It ensures:

* **Confidentiality** using encryption
* **Integrity** using message authentication codes (MACs)
* **Authentication** through certificates

Wireshark, a network protocol analyzer, is a powerful tool to observe and analyze the handshake in real-time, packet-by-packet.

---

### 2. SSL vs TLS

* **SSL (Secure Sockets Layer)** is deprecated due to vulnerabilities.
* **TLS (Transport Layer Security)** is the modern and secure alternative (TLS 1.2 and TLS 1.3 are widely used).

---

### 3. TLS Handshake Steps (TLS 1.2)

The handshake happens before any application data is transmitted. Here's a breakdown of the typical flow:

#### Step 1: ClientHello

* Initiated by the client.
* Contains supported **TLS versions**, **cipher suites**, **compression methods**, and **random number**.
* May include **Server Name Indication (SNI)** and **extensions**.

#### Step 2: ServerHello

* Chosen **TLS version**, **cipher suite**, and another **random number**.
* Server’s **digital certificate**.
* **ServerKeyExchange** (if using DHE/ECDHE).
* **CertificateRequest** (optional, for mutual authentication).

#### Step 3: ClientKeyExchange

* Client sends a **pre-master secret**, usually encrypted with the server’s public key.
* Both sides derive a **session key** from the pre-master and random numbers.

#### Step 4: ChangeCipherSpec & Finished

* Both parties signal readiness to switch to encrypted communication.
* Exchanged **Finished** messages confirm the handshake is complete.

---

### 4. TLS 1.3 Differences

TLS 1.3 significantly streamlines the handshake:

* Removes many insecure cipher suites.
* Merges steps to improve performance.
* Always uses forward secrecy.
* Faster (1-RTT instead of 2-RTT).

---

### 5. Capturing SSL/TLS Handshake in Wireshark

#### Step-by-step:

1. **Start Wireshark** and begin capture on the network interface.
2. Use the display filter:

   ```
   tls.handshake
   ```
3. Initiate an HTTPS request (e.g., visit `https://example.com`).
4. Observe the packets:

   * **Packet 1**: ClientHello
   * **Packet 2-3**: ServerHello, Certificate
   * **Later**: Key exchange, ChangeCipherSpec, Finished

---

### 6. Interpreting Key Fields in Wireshark

* **Version**: TLS version being negotiated (e.g., TLS 1.2).
* **Cipher Suite**: The algorithm combination selected (e.g., TLS\_ECDHE\_RSA\_WITH\_AES\_128\_GCM\_SHA256).
* **Extensions**: ALPN, SNI, etc.
* **Certificate Info**: Issuer, subject, validity, etc.
* **Random values**: Used for key derivation.

---

### 7. Decrypting TLS in Wireshark

To decrypt TLS traffic:

* Use **pre-master secrets** with browser support (like Chrome or Firefox).
* Set the environment variable:

  ```
  SSLKEYLOGFILE=/path/to/sslkeys.log
  ```
* Load this file in Wireshark under:

  ```
  Preferences → Protocols → TLS → (Pre)-Master-Secret log filename
  ```

Note: This only works with TLS 1.2 and earlier unless TLS 1.3 is supported in logging.

---

### 8. Detecting Issues

Wireshark helps diagnose:

* **Certificate mismatches**
* **Handshake failures**
* **Unsupported cipher suite errors**
* **Version negotiation problems**
* **Improper certificate chains**

Look for `Alert` messages in the TLS stream:

* Level: **fatal**
* Description: e.g., **handshake\_failure**, **bad\_certificate**

---

### 9. Real-World Use Cases

* Debugging HTTPS problems in web applications
* Validating certificate chains and expiry
* Investigating MITM attacks
* Auditing TLS configurations during pentesting or blue-team analysis

---

### 10. Conclusion

Understanding the SSL/TLS handshake at the packet level is vital for secure communications troubleshooting, pentesting, and compliance checks. Wireshark provides an accessible, visual way to trace and validate each handshake phase, from cipher negotiation to certificate exchange.
