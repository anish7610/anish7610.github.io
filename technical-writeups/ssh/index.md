---
layout: default 
title: SSH
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


#  SSH (Secure Shell) – Technical Writeup

##  Introduction

**SSH (Secure Shell)** is a cryptographic network protocol used for secure communication over an unsecured network. It enables users to securely access remote systems, execute commands, transfer files, and manage services. SSH replaces older protocols like **Telnet**, **FTP**, and **rlogin**, which transmit data in plaintext.

---

##  Key Features

* **End-to-end encryption** of traffic (including passwords and session data).
* **Authentication mechanisms**: Password-based, public-key-based, GSSAPI, etc.
* **Port forwarding / Tunneling**: Securely forward ports through encrypted channels.
* **File transfer support**: via `scp`, `sftp`.
* **Remote command execution**.
* **Secure proxy (jump hosts)** and agent forwarding.

---

##  SSH Protocol Stack

SSH operates at the **application layer** of the OSI model and comprises three major components:

| Layer                            | Description                                                                            |
| -------------------------------- | -------------------------------------------------------------------------------------- |
| **Transport Layer Protocol**     | Provides server authentication, confidentiality, integrity via encryption and MACs.    |
| **User Authentication Protocol** | Handles client authentication (e.g., password, public key).                            |
| **Connection Protocol**          | Multiplexes encrypted tunnel into channels for terminal sessions, file transfers, etc. |

---

##  Authentication Mechanisms

### 1. **Password-Based Authentication**

* User is prompted to enter their password.
* Simple but less secure.

### 2. **Public Key Authentication (Asymmetric)**

* User generates a key pair (`ssh-keygen`):

  * **Private Key**: Stored securely on the client.
  * **Public Key**: Placed in `~/.ssh/authorized_keys` on the server.
* Offers better security and can be automated for scripts.

### 3. **GSSAPI / Kerberos**

* Used in enterprise environments for single sign-on (SSO).

---

##  SSH Key Generation

```bash
# Generate key pair (RSA 4096 bits)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Files generated:

* `~/.ssh/id_rsa` → Private key
* `~/.ssh/id_rsa.pub` → Public key

To copy public key to server:

```bash
ssh-copy-id user@hostname
```

---

##  SSH Commands and Usage

### 1. **Remote Login**

```bash
ssh user@host
```

### 2. **Remote Command Execution**

```bash
ssh user@host 'uptime'
```

### 3. **Port Forwarding**

* **Local Port Forwarding**

  ```bash
  ssh -L 8080:targethost:80 user@sshgateway
  ```
* **Remote Port Forwarding**

  ```bash
  ssh -R 2222:localhost:22 user@host
  ```

### 4. **SCP – Secure Copy**

```bash
scp file.txt user@remote:/path/
scp user@remote:/path/file.txt .
```

### 5. **SFTP – SSH File Transfer**

```bash
sftp user@remote
# or
sftp> get file.txt
sftp> put file.txt
```

---

## ️ SSH Configuration

Global: `/etc/ssh/ssh_config`
User-specific: `~/.ssh/config`

Example `~/.ssh/config`:

```ini
Host devserver
    HostName dev.example.com
    User anish
    Port 2222
    IdentityFile ~/.ssh/id_rsa
```

Usage:

```bash
ssh devserver
```

---

##  Security Best Practices

* Disable root login (`PermitRootLogin no`)
* Use only public key authentication (`PasswordAuthentication no`)
* Use fail2ban or similar to block brute-force attacks
* Limit user access using `AllowUsers` or `Match` blocks in `sshd_config`
* Use a strong key length (`4096` bits or `ed25519`)
* Keep `OpenSSH` updated

---

##  SSH Agent and Agent Forwarding

* `ssh-agent` stores decrypted private keys in memory.
* `ssh-add` adds keys to agent.
* `ForwardAgent yes` allows key forwarding across jump hosts.

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

---

##  SSH Tunneling (Use Case: Secure Database Access)

To forward a remote MySQL database port:

```bash
ssh -L 3306:localhost:3306 user@remote-db
```

Then connect locally to `localhost:3306` as if the DB were local.

---

##  Advanced Tools

| Tool       | Purpose                             |
| ---------- | ----------------------------------- |
| `autossh`  | Auto-reconnect dropped SSH sessions |
| `sshuttle` | VPN-like tunneling using SSH        |
| `mosh`     | UDP-based remote shell over SSH     |
| `paramiko` | Python SSH automation library       |

---

##  Example Python Code Using `paramiko`

```python
import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('hostname', username='user', key_filename='~/.ssh/id_rsa')

stdin, stdout, stderr = ssh.exec_command('ls -l')
print(stdout.read().decode())

ssh.close()
```

---

##  SSH Log Location

* Ubuntu/Debian: `/var/log/auth.log`
* Red Hat/CentOS: `/var/log/secure`

---

##  Conclusion

SSH is a fundamental tool for secure remote administration, scripting, and file transfer in Unix-like systems. Mastering its full capabilities, including tunneling, key management, and secure configurations, significantly enhances your system security posture and operational efficiency.

