---
layout: default 
title: Layer 2 Protocols
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# 🔧 **L2 Networking Protocols - Technical Writeup**

## 📘 **1. What is Layer 2?**

Layer 2 of the OSI model is the **Data Link Layer**. It ensures reliable **node-to-node** delivery and works **locally** (within the same broadcast domain). It includes MAC addressing and defines how devices on the same LAN communicate.

---

## 📂 **2. Layer 2 Protocols and Their Functionality**

### 🔸 **2.1 Ethernet (IEEE 802.3)**

* Standard for wired LANs.
* Uses MAC addresses to identify hosts.
* Transmits frames using a specific frame format.

#### ✅ Example: Ethernet Frame

```
+--------+-------------+-------------+---------+----------+-----+
|Preamble| Dest MAC    | Src MAC     | Type    | Payload  | CRC |
+--------+-------------+-------------+---------+----------+-----+
```

#### 🔧 Example: MAC address lookup in Linux

```bash
ip link show
ip neigh  # shows IP to MAC mapping (ARP table)
```

---

### 🔸 **2.2 ARP (Address Resolution Protocol)**

* Resolves IP → MAC within the same LAN.
* ARP Request is a broadcast (`ff:ff:ff:ff:ff:ff`), ARP Reply is unicast.

#### ✅ Example: Using ARP in Linux

```bash
arping 192.168.1.1
```

#### 🧪 Output:

```
ARPING 192.168.1.1
60 bytes from 192.168.1.1 (xx:xx:xx:xx:xx:xx): arp reply ...
```

---

### 🔸 **2.3 VLAN (IEEE 802.1Q)**

* Segments Layer 2 traffic virtually.
* Adds a 4-byte tag in the Ethernet frame.
* Provides isolation and better traffic control.

#### ✅ Example: VLAN Frame Tag

```
+---+------+--------+--------+--------+--------+-----+
|DMAC| SMAC | 802.1Q Tag | EtherType | Payload | CRC |
+---+------+--------+--------+--------+--------+-----+
```

#### 🔧 Example: Create VLAN on Linux

```bash
ip link add link eth0 name eth0.10 type vlan id 10
ip addr add 192.168.10.1/24 dev eth0.10
ip link set dev eth0.10 up
```

---

### 🔸 **2.4 Spanning Tree Protocol (STP - IEEE 802.1D)**

* Prevents Layer 2 loops.
* Elects a **Root Bridge**, blocks redundant paths.
* Convergence may take 30–50 seconds.

#### 🔧 Example: Cisco STP Configuration

```bash
Switch(config)# spanning-tree vlan 10 priority 4096
Switch(config)# show spanning-tree
```

#### 🧪 Output:

```
Root ID: 32778 (priority 32768 + VLAN ID 10)
Root Bridge: 00:11:22:33:44:55
Cost: 19    Port: FastEthernet0/1
```

---

### 🔸 **2.5 LACP (Link Aggregation Control Protocol - IEEE 802.3ad)**

* Bundles multiple physical links into a logical link.
* Increases throughput and provides redundancy.

#### 🔧 Example: LACP on Linux (using `bonding`)

```bash
modprobe bonding mode=4 miimon=100 lacp_rate=1
ip link set eth0 down
ip link set eth1 down
ip link add bond0 type bond
echo +eth0 > /sys/class/net/bond0/bonding/slaves
echo +eth1 > /sys/class/net/bond0/bonding/slaves
ip addr add 192.168.1.10/24 dev bond0
ip link set bond0 up
```

---

### 🔸 **2.6 CSMA/CD (Carrier Sense Multiple Access / Collision Detection)**

* Used in legacy half-duplex Ethernet.
* Detects collisions and waits random time before retransmitting.

#### ℹ️ Note:

Not used in full-duplex modern Ethernet; now replaced by switching infrastructure.

---

## 📌 **3. Layer 2 Switching Example (Real Network Scenario)**

### 💡 Scenario: 3 PCs connected via a Layer 2 Switch

* **PC1**: 192.168.1.10 / MAC: `AA:BB:CC:11:22:33`
* **PC2**: 192.168.1.20 / MAC: `AA:BB:CC:22:33:44`
* **PC3**: 192.168.1.30 / MAC: `AA:BB:CC:33:44:55`

When PC1 pings PC2:

1. PC1 checks ARP table → no entry
2. Sends **ARP Request**: “Who has 192.168.1.20?”
3. PC2 replies with its MAC address.
4. PC1 now sends ICMP Echo to MAC of PC2.

The **switch** learns MAC addresses by inspecting source MAC in frames and builds a MAC table.

#### 🔍 Switch MAC Table:

```
Port 1: AA:BB:CC:11:22:33 (PC1)
Port 2: AA:BB:CC:22:33:44 (PC2)
Port 3: AA:BB:CC:33:44:55 (PC3)
```

---

## 🔐 **4. Layer 2 Security Features**

### Common Threats:

| Threat       | Description                           |
| ------------ | ------------------------------------- |
| ARP Spoofing | Attacker sends forged ARP replies     |
| MAC Flooding | Overflows MAC table, causes broadcast |
| VLAN Hopping | Attacker gains access to other VLANs  |

### Defenses:

* **Port Security**: Limit MACs per port.
* **Dynamic ARP Inspection (DAI)**: Drops invalid ARP.
* **BPDU Guard**: Protects STP topology.

#### 🔧 Cisco Example:

```bash
Switch(config)# interface fa0/1
Switch(config-if)# switchport port-security
Switch(config-if)# switchport port-security maximum 1
Switch(config-if)# switchport port-security violation shutdown
```

---

## 🧠 **5. Summary Table of Layer 2 Protocols**

| Protocol | Purpose              | Key Feature          |
| -------- | -------------------- | -------------------- |
| Ethernet | LAN communication    | MAC-based addressing |
| ARP      | IP → MAC resolution  | Broadcast + reply    |
| VLAN     | Logical segmentation | Tagged frames        |
| STP      | Loop prevention      | Root Bridge election |
| LACP     | Link bundling        | Active/Passive modes |
| CSMA/CD  | Medium access        | Collision detection  |

