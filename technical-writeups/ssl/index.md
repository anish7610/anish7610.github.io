---
layout: default 
title: SSL/TLS
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## 🔐 SSL/TLS: Secure Communication Protocols - Technical Writeup

### **Overview**

**SSL (Secure Sockets Layer)** and **TLS (Transport Layer Security)** are cryptographic protocols designed to provide **secure communication** over a network, typically the internet. TLS is the modern, secure version; SSL is deprecated.

---

### 🔄 **Evolution of SSL/TLS**

| Protocol | Release | Status                     |
| -------- | ------- | -------------------------- |
| SSL 2.0  | 1995    | Insecure, Deprecated       |
| SSL 3.0  | 1996    | Deprecated                 |
| TLS 1.0  | 1999    | Deprecated                 |
| TLS 1.1  | 2006    | Deprecated                 |
| TLS 1.2  | 2008    | **Widely used**            |
| TLS 1.3  | 2018    | **Latest and most secure** |

---

### 🧱 **Architecture Stack**

```
Application Layer: HTTPS, FTPS, SMTPS
⬇
TLS Layer: Encryption/Decryption, Authentication
⬇
Transport Layer: TCP
⬇
Network Layer: IP
```

---

### 🔑 **Goals of SSL/TLS**

1. **Confidentiality** – via symmetric encryption
2. **Integrity** – via message authentication codes
3. **Authentication** – via X.509 certificates
4. **Forward Secrecy** – via ephemeral key exchange (TLS 1.3+)

---

## 🤝 TLS Handshake Protocol

The **TLS handshake** establishes a secure session between the client and server. It negotiates cryptographic parameters and securely shares symmetric keys.

---

### ✅ TLS 1.2 Handshake Steps

```
Client                             Server
  | -------- ClientHello --------> |
  |                                |
  | <------- ServerHello --------- |
  | <-------- Certificate -------- |
  | <--- ServerKeyExchange (if DH)|
  | <------ ServerHelloDone ------ |
  |                                |
  | -- ClientKeyExchange --------> |
  | -- [ChangeCipherSpec] -------> |
  | -- Finished (Encrypted) -----> |
  |                                |
  | <--- [ChangeCipherSpec] ------|
  | <--- Finished (Encrypted) ----|
```

---

### 🔍 TLS 1.2 Handshake (Detailed)

1. **ClientHello**

   * Client sends:

     * TLS version
     * Random value (client\_random)
     * List of supported cipher suites
     * Session ID (if resuming)

2. **ServerHello**

   * Server responds with:

     * Chosen TLS version and cipher suite
     * Random value (server\_random)
     * Server certificate
     * Optional: ServerKeyExchange (if using DHE/ECDHE)

3. **Certificate Verification**

   * Client verifies the server’s certificate using the CA chain.

4. **Key Exchange**

   * **RSA**: Client encrypts a premaster secret using the server's public key.
   * **ECDHE**: Both parties exchange ephemeral keys and derive a shared secret.

5. **Session Key Derivation**

   * Both sides generate symmetric keys from premaster secret + randoms.

6. **ChangeCipherSpec & Finished**

   * Both sides send a "ChangeCipherSpec" message and switch to encrypted communication.
   * "Finished" messages are encrypted and confirm handshake success.

---

### ⚡ TLS 1.3 Handshake (Simplified)

TLS 1.3 removes many legacy features and reduces the handshake to **1 round trip**:

```
Client                               Server
  | -------- ClientHello ----------> |
  |                                  |
  | <-------- ServerHello ---------- |
  |         (key share, cert, etc)   |
  | <----- Encrypted Extensions -----|
  | <--- Certificate + Verify -------|
  | <------ Finished (Encrypted) ----|
  |                                  |
  | -- Finished (Encrypted) -------> |
  |        [Start Encrypted Comm]    |
```

### TLS 1.3 Improvements

* Removes RSA key exchange and static DH
* Uses only forward-secure (ephemeral) key exchange
* Encryption starts earlier
* Improved performance (0-RTT support)

---

## 🔒 Cryptographic Components

| Component      | Algorithms                        |
| -------------- | --------------------------------- |
| Key Exchange   | ECDHE, DHE, (RSA in TLS 1.2 only) |
| Authentication | RSA, ECDSA                        |
| Encryption     | AES-GCM, ChaCha20-Poly1305        |
| Integrity      | HMAC-SHA256, AEAD (TLS 1.3)       |

---

## ⚠️ Known SSL/TLS Attacks (Historical)

* **POODLE**: SSL 3.0 padding attack
* **BEAST**: TLS 1.0 CBC vulnerability
* **Heartbleed**: Memory leak in OpenSSL
* **DROWN**: Weak SSLv2 support
* **CRIME/BREACH**: Compression-based attacks

➡️ **Mitigation**: Use TLS 1.3 or TLS 1.2 with strong configs only

---

## 🛡️ Best Practices

1. **Disable SSL, TLS 1.0, and 1.1**
2. Prefer **TLS 1.3**
3. Use strong ciphers (AES-GCM, ChaCha20)
4. Enable **forward secrecy** (ECDHE)
5. Use certificates from trusted CAs (e.g., Let's Encrypt)
6. Rotate certificates regularly
7. Implement **HSTS** for HTTPS-only communication

---

## 📦 Real-World Applications

* Web Browsing: HTTPS (TLS + HTTP)
* Email Security: SMTPS, IMAPS
* VPNs: OpenVPN, WireGuard
* APIs: REST over HTTPS
* VoIP: Secure SIP (SIPS)

---

## 📚 References

* [RFC 8446 - TLS 1.3 Specification](https://datatracker.ietf.org/doc/html/rfc8446)
* [SSL Labs Test Tool](https://www.ssllabs.com/ssltest/)
* [Mozilla TLS Config Generator](https://ssl-config.mozilla.org/)
* [OpenSSL Docs](https://www.openssl.org/docs/)
