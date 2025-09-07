---
layout: default
title: doh-vs-dot
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


### DNS over HTTPS (DoH) vs DNS over TLS (DoT)

#### Introduction

Domain Name System (DNS) is a fundamental component of the internet, translating human-readable domain names (like `example.com`) into IP addresses. Traditionally, DNS queries are sent in plaintext over UDP or TCP, exposing them to surveillance, manipulation, and censorship.

To mitigate these privacy and security concerns, two encrypted DNS protocols have emerged:

* **DNS over HTTPS (DoH)**
* **DNS over TLS (DoT)**

While both encrypt DNS traffic, they differ in transport mechanisms, performance, and deployment models.

---

### DNS over TLS (DoT)

**Definition**: DNS over TLS encrypts DNS queries using Transport Layer Security (TLS) over port **853**.

#### Key Characteristics:

* Uses a dedicated port (`853`)
* Maintains DNS structure but adds TLS encryption
* Easily blocked via port-based filtering
* Simpler to implement at the system resolver level
* Supported by many recursive resolvers (e.g., Cloudflare, Quad9, Google)

#### Pros:

* **Improves privacy and security** by encrypting DNS traffic
* **Cleaner separation of concerns** (only DNS traffic over port 853)
* **Easier to audit and log** for security appliances

#### Cons:

* **Can be blocked by firewalls** that filter non-standard ports
* **Less stealthy** than HTTPS traffic (port 853 stands out)
* **Lacks application-level integration** (browser needs OS support)

---

### DNS over HTTPS (DoH)

**Definition**: DNS over HTTPS sends DNS queries over standard HTTPS connections (port **443**) using the HTTP/2 or HTTP/3 protocol.

#### Key Characteristics:

* Encapsulates DNS queries inside HTTPS traffic
* Uses port `443`—the same as regular web traffic
* Often integrated directly into browsers (e.g., Firefox, Chrome)
* Harder to distinguish from normal HTTPS traffic

#### Pros:

* **Difficult to block or censor** due to use of port 443
* **Provides privacy even in restrictive networks**
* **Easily integrated into browsers and apps** for per-app privacy

#### Cons:

* **Harder to filter or log** DNS traffic by enterprises
* **Can bypass local DNS controls**, causing security or compliance concerns
* **Potential centralization** of DNS data with third-party DoH providers

---

### Comparison Table

| Feature                  | DoH                                   | DoT                           |
| ------------------------ | ------------------------------------- | ----------------------------- |
| Transport Protocol       | HTTPS (HTTP/2 or HTTP/3 over TCP/TLS) | TCP over TLS                  |
| Port Used                | 443 (same as web traffic)             | 853 (dedicated)               |
| Visibility to Firewalls  | Obfuscated (hard to block)            | Detectable and blockable      |
| Performance              | May introduce HTTP overhead           | Slightly faster in some cases |
| Integration Level        | App-level (e.g., browser)             | OS-level/system resolver      |
| Logging/Filtering        | Harder to inspect for enterprises     | Easier to monitor             |
| Resistance to Censorship | High                                  | Moderate                      |

---

### Use Cases

* **DoH is ideal for**:

  * Circumventing DNS-based censorship
  * Privacy in public or hostile networks
  * Applications needing built-in DNS privacy

* **DoT is ideal for**:

  * Securing DNS at the network or system resolver level
  * Enterprises that want DNS privacy with more control
  * Networks that rely on traditional DNS monitoring tools

---

### Security and Privacy Considerations

* **Both DoH and DoT encrypt DNS traffic**, preventing eavesdropping and tampering.
* **Neither hides DNS destination from ISPs completely** (e.g., IP addresses are still visible).
* **Encrypted DNS ≠ anonymous browsing**—they prevent local DNS snooping, but not full tracking.
* **Trust still depends on the DNS resolver** (e.g., Cloudflare, Google)—they see your DNS queries.

---

### Conclusion

DoH and DoT represent significant improvements in DNS privacy and integrity, each suited for different environments:

* Use **DoH** when you need stealth, app-level integration, or must bypass network controls.
* Use **DoT** when you want system-wide encrypted DNS with more visibility and control.
