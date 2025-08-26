---
layout: default
title: custom-vpn-wireguard-routing-tables
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Implementing a Custom VPN Using WireGuard and Routing Tables

WireGuard is a modern, fast, and simple VPN solution that’s well-suited for both embedded devices and high-throughput servers. It uses state-of-the-art cryptography and operates at Layer 3 (network layer). This write-up covers how to implement a custom VPN using WireGuard and modify routing tables for secure communication between two endpoints.

---

### 1. **Why WireGuard?**

* **Simplicity**: Just a few thousand lines of code.
* **Performance**: Faster than OpenVPN and IPsec in many benchmarks.
* **Security**: Uses modern cryptographic protocols like Curve25519, ChaCha20, and Poly1305.

---

### 2. **WireGuard Basics**

* **Interface**: `wg0`, `wg1`, etc.
* **Peers**: Defined by public key and allowed IPs.
* **Port**: Defaults to UDP 51820.
* **Configuration**: Can be done via `wg-quick` or directly with `wg`.

---

### 3. **Installation**

On Ubuntu:

```bash
sudo apt update
sudo apt install wireguard
```

Enable IP forwarding:

```bash
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
sysctl -p
```

---

### 4. **Configuration Files**

**Server `/etc/wireguard/wg0.conf`:**

```ini
[Interface]
Address = 10.0.0.1/24
PrivateKey = <server-private-key>
ListenPort = 51820

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.0.0.2/32
```

**Client `/etc/wireguard/wg0.conf`:**

```ini
[Interface]
Address = 10.0.0.2/24
PrivateKey = <client-private-key>

[Peer]
PublicKey = <server-public-key>
Endpoint = <server-ip>:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

---

### 5. **Key Generation**

```bash
wg genkey | tee privatekey | wg pubkey > publickey
```

Do this on both client and server. Exchange public keys securely.

---

### 6. **Starting WireGuard**

```bash
sudo wg-quick up wg0
```

To stop:

```bash
sudo wg-quick down wg0
```

---

### 7. **Routing and NAT**

On the **server** (to forward packets from VPN to internet):

```bash
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
```

Make this persistent using `iptables-save`.

---

### 8. **Routing Table Adjustments**

You may want to route only specific subnets (split tunneling) or all traffic.

For split tunneling on client:

```ini
AllowedIPs = 10.0.0.0/24, 192.168.1.0/24
```

For full tunneling:

```ini
AllowedIPs = 0.0.0.0/0, ::/0
```

Check routes:

```bash
ip route show
```

---

### 9. **Testing VPN Tunnel**

From client:

```bash
ping 10.0.0.1
curl ifconfig.me # should return server IP if full tunnel
```

Check `wg` status:

```bash
sudo wg
```

---

### 10. **Use Cases**

* Secure remote access to private networks
* Site-to-site connectivity (e.g., branch office to HQ)
* VPN for Kubernetes pods or microservices

---

### 11. **Security Considerations**

* Only use keys with secure permissions (`chmod 600`)
* Limit `AllowedIPs` to restrict access scope
* Enable firewall rules to prevent abuse
* Use `PersistentKeepalive` for NAT traversal

---

### Summary

Implementing a VPN with WireGuard involves minimal setup but offers robust and performant security. Combined with correct routing table and firewall adjustments, it serves as a lightweight yet production-grade VPN solution suitable for many networking needs.
