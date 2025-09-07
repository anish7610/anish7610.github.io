---
layout: default
title: unix-domain-sockets
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Unix Domain Sockets: Local IPC with File System-Based Endpoints

**Unix Domain Sockets (UDS)** are a powerful form of **inter-process communication (IPC)** available on Unix-like operating systems. Unlike TCP/IP sockets that communicate over a network, UDS operates **locally** between processes on the same host, using the **file system as the addressing namespace**.

---

###  Key Concepts

* **UDS vs TCP/IP**:

  * UDS: Path-based communication via the file system (e.g., `/tmp/mysocket`).
  * TCP/IP: Port-based communication using IP addresses and ports.
* **Types**:

  * **SOCK\_STREAM**: Like TCP – reliable, byte-oriented.
  * **SOCK\_DGRAM**: Like UDP – message-oriented.
  * **SOCK\_SEQPACKET**: Reliable message delivery with message boundaries preserved.

---

###  How It Works

1. **Server process** creates a socket and binds it to a pathname.
2. **Client process** connects to that path to initiate communication.
3. They exchange data via `read/write`, `send/recv`.

The kernel mediates all interactions without going through the network stack.

---

### ️ Example: Stream Socket

#### Server

```c
int sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
struct sockaddr_un addr;
memset(&addr, 0, sizeof(struct sockaddr_un));
addr.sun_family = AF_UNIX;
strcpy(addr.sun_path, "/tmp/mysocket");

bind(sockfd, (struct sockaddr *)&addr, sizeof(struct sockaddr_un));
listen(sockfd, 5);

int client_fd = accept(sockfd, NULL, NULL);
write(client_fd, "Hello from server", 18);
```

#### Client

```c
int sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
struct sockaddr_un addr;
memset(&addr, 0, sizeof(struct sockaddr_un));
addr.sun_family = AF_UNIX;
strcpy(addr.sun_path, "/tmp/mysocket");

connect(sockfd, (struct sockaddr *)&addr, sizeof(struct sockaddr_un));
char buf[100];
read(sockfd, buf, 100);
```

---

###  Advantages

* **Faster than TCP/IP**: No overhead of IP stack, no checksum/fragmentation.
* **Secure**: Access controlled via file system permissions (`chmod`, `chown`).
* **No Port Conflicts**: Uses file paths instead of numeric ports.
* **Pass File Descriptors**: Can send open file descriptors using `sendmsg()` and `SCM_RIGHTS`.

---

###  Use Cases

* **Local daemons**: e.g., systemd’s communication with journald.
* **Docker / Podman API socket**: `/var/run/docker.sock`.
* **Nginx ↔ PHP-FPM**: PHP-FPM listens on a Unix socket for fast IPC.
* **Browser sandboxing**: Isolated processes in Chromium communicate via UDS.

---

### ️ Real-World Integration Example

#### Nginx Configuration

```nginx
upstream php_backend {
    server unix:/run/php/php7.4-fpm.sock;
}
```

This avoids TCP overhead by communicating over a Unix socket instead of localhost TCP.

---

###  Debugging Tips

* Use `lsof | grep mysocket` to check who has the socket open.
* Use `netstat -a | grep unix` or `ss -x` to inspect active Unix sockets.
* Remove stale sockets (`rm /tmp/mysocket`) before restarting servers.

---

### ️ Considerations

* Path length limit (often 108 bytes for `sun_path`).
* Must manually clean up the socket file on shutdown.
* Only usable on the same host – no cross-network communication.

---

### Summary

| Feature     | Unix Domain Socket                   | TCP/IP Socket          |
| ----------- | ------------------------------------ | ---------------------- |
| Performance | Faster (in-memory)                   | Slower (network stack) |
| Scope       | Local only                           | Local and remote       |
| Addressing  | File path (`/tmp/app.sock`)          | IP\:Port               |
| Use Case    | IPC between services on same machine | Remote communication   |

---

Unix Domain Sockets are an ideal choice when building fast, secure, and local IPC mechanisms. They’re widely used across system-level applications and container ecosystems.
