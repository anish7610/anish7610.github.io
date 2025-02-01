---
layout: default
title: tcp-fragmentation
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## ⚙️ TCP Fragmentation

---

### 🔹 1. TCP Segmentation vs. IP Fragmentation

| Layer         | Action            | What Happens                                               |
| ------------- | ----------------- | ---------------------------------------------------------- |
| **TCP Layer** | **Segmentation**  | Application sends data → TCP breaks it into segments ≤ MSS |
| **IP Layer**  | **Fragmentation** | If segment > MTU → IP splits it into **fragments**         |

> ⚠️ **TCP does not fragment data** — it segments data. Fragmentation only occurs at the IP layer.

---

### 🔹 2. Path MTU and Fragmentation Trigger

* **MTU (Maximum Transmission Unit)**: Largest IP packet size (typically 1500 bytes for Ethernet).
* **MSS (Maximum Segment Size)**: Largest segment TCP can send (MTU - 40 bytes).
* **Fragmentation occurs** if an IP packet exceeds the MTU and:

  * PMTUD is disabled or fails
  * DF (Don't Fragment) bit is **not set**
  * Underlying path contains small-MTU links (VPNs, tunnels, MPLS)

#### Diagram:

```
App Layer       ─────────────────────> Sends 16KB data
TCP Layer       ─────────────────────> Breaks into 1460B segments (MSS)
IP Layer        ─────────────────────> Each segment + headers (~1500B)
↓
Router detects MTU = 1200
→ Fragments each 1500B packet into:
    - Fragment 1: 1200 bytes
    - Fragment 2: 300 bytes
```

---

### 🔹 3. Packet Structure in Fragmentation

Let’s take an example: A TCP segment of 1400 bytes, but the path MTU is 1000 bytes. IP fragments it:

| Fragment | Offset | More Fragments (MF) | Size |
| -------- | ------ | ------------------- | ---- |
| Frag 1   | 0      | 1                   | 1000 |
| Frag 2   | 985    | 0                   | 420  |

> Offset in 8-byte blocks. Overlapping/incorrect offsets can be used to bypass firewalls or confuse IDS.

---

### 🔹 4. Path MTU Discovery (PMTUD)

* TCP uses PMTUD to avoid IP fragmentation.
* Works by sending packets with the **DF** (Don’t Fragment) bit set.
* If a router can’t forward due to MTU, it sends an ICMP type 3 code 4 message:
  **"Fragmentation needed and DF set"**

#### PMTUD Failure: "Black Hole" Symptoms

* ICMP blocked by firewall (common in enterprises)
* Large packets mysteriously disappear
* Connections hang during TLS handshakes, file transfers, etc.

---

### 🔹 5. Consequences of Fragmentation

#### 🔸 a. Performance

* Increases processing overhead on sender and receiver.
* Causes **head-of-line blocking** if fragments arrive out of order.

#### 🔸 b. Reliability

* IP fragments are individually unreliable.
* **Loss of one fragment = retransmission of entire TCP segment**.
* No per-fragment retransmission in IP.

#### 🔸 c. Security

* **Fragmentation attacks:**

  * **Teardrop attack**: Malformed overlapping fragments crash systems.
  * **Tiny fragment attack**: Evade IDS by splitting malicious payload across fragments.
* IDS/IPS must **reassemble** fragments, which is expensive and error-prone.

---

### 🔹 6. Fragmentation and TCP Performance Tuning

#### 🔸 Tunneling Protocols

* IP-in-IP, GRE, IPSec add 20-60 bytes of headers.
* Reduces effective MTU, often to **\~1400 or lower**.
* Neglecting this causes fragmentation or black holes.

#### 🔸 MSS Clamping

Ensures TCP doesn't try to send segments larger than the path can carry:

```bash
# Example: Clamp MSS to 1360
iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
         -j TCPMSS --clamp-mss-to-pmtu
```

> MSS clamping is especially important on **edge routers**, **VPN concentrators**, and **cloud VPC gateways**.

---

### 🔹 7. Detecting and Debugging Fragmentation

#### 🔸 Tools and Methods

| Tool                      | Usage                                                                |
| ------------------------- | -------------------------------------------------------------------- |
| `tcpdump` or `Wireshark`  | Look for "Fragmented IP Protocol (proto=6, off=X)"                   |
| `ping -M do -s SIZE host` | Sends ping with DF bit. Helps determine PMTU.                        |
| `traceroute -F`           | Sends traceroute with DF bit to trace fragmentation point            |
| `iptables -A INPUT -f`    | Match (and optionally log) all fragmented packets                    |
| `netstat -s`              | Look for IP statistics under “fragments created/successful failures” |

#### 🔸 Example: Detecting PMTUD Failure

```bash
ping -M do -s 1472 <host>    # 1472 + 28 (ICMP/IP header) = 1500
# If it fails, try:
ping -M do -s 1400 <host>
```

---

### 🔹 8. Kernel Internals and Fragmentation

#### Fragmentation Logic in Linux

* Linux fragments **before** queuing to NIC.
* Uses **skb (socket buffer)** structure.
* Fragment queues tracked via `/proc/net/ip_frag` (on older kernels).
* Reassembly timeout is \~30 seconds (`/proc/sys/net/ipv4/ipfrag_time`)

#### Netfilter Hooks

* Fragmented packets hit the `PREROUTING` chain.
* Fragments do **not pass through** `INPUT` in the same form.
* IDS must reassemble fragments **before** TCP stream reassembly.

---

### 🔹 9. Fragmentation in IPv6

> **IPv6 routers do not fragment packets.**
> Only **end hosts** may do so using **IPv6 Fragment Header**.

* No PMTUD = guaranteed black holes.
* End-hosts must use PMTUD or fall back to **PLPMTUD** (Probing variant).
* MTU is at least **1280 bytes** in IPv6.

---

## ✅ Best Practices Summary

| Area            | Recommendation                                      |
| --------------- | --------------------------------------------------- |
| **Security**    | Drop or limit fragmented traffic unless necessary   |
| **Performance** | Enable MSS clamping on tunnels, VPNs                |
| **Debugging**   | Use `ping -M do`, `tcpdump`, `traceroute -F`        |
| **PMTUD**       | Allow ICMP type 3 code 4 messages through firewalls |
| **IPv6**        | Don’t rely on fragmentation; use PMTUD or PLPMTUD   |

---

### 📌 Real-World Scenarios

1. **VPN tunnel breaks large TCP transfers**
   → Fix: Clamp MSS to \~1350

2. **TLS handshake fails intermittently**
   → Root cause: PMTUD broken, fragmentation blocked by intermediate device

3. **IDS/IPS fails to detect attack**
   → Attacker used fragmented payloads to evade deep packet inspection
