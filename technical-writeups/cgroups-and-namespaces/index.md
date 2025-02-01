---
layout: default
title: cgroups-and-namespaces 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# 🐳 Understanding cgroups and namespaces in Docker/Containers

Modern container technologies like **Docker** are made possible by two key Linux kernel features:

1. **Namespaces** – provide *isolation*
2. **Control Groups (cgroups)** – provide *resource control*

Together, they form the foundation of container security, performance, and independence — without the need for a full-blown virtual machine.

---

## 🧭 1. What Are Linux Namespaces?

### 🧠 Definition:

**Namespaces** allow a process (or group of processes) to have its own isolated instance of certain kernel resources.

Each namespace type isolates a different part of the system, ensuring containers don’t interfere with each other or the host.

### 📂 Types of Namespaces:

| Namespace | Isolates                                  | CLI flag     |
| --------- | ----------------------------------------- | ------------ |
| `pid`     | Process IDs                               | `--pid`      |
| `mnt`     | Mount points (filesystems)                | `--mount`    |
| `net`     | Network interfaces, routing tables, ports | `--net`      |
| `ipc`     | System V IPC, POSIX message queues        | `--ipc`      |
| `uts`     | Hostname and domain name                  | `--uts`      |
| `user`    | User and group ID mapping                 | `--user`     |
| `cgroup`  | Cgroup root visibility                    | `--cgroupns` |

### 🧪 Example:

When a Docker container is run, it gets its **own PID namespace**. That means:

* Inside the container, `ps` or `top` only shows processes from within that container.
* PID 1 is assigned to the container’s main process, even if the host has hundreds of processes running.

---

## ⚙️ 2. What Are cgroups (Control Groups)?

### 🧠 Definition:

**cgroups** (short for control groups) limit, prioritize, and account for resource usage (CPU, memory, disk I/O, etc.) among process groups.

cgroups ensure that one container can't starve others or the host of system resources.

### 📂 Key Features:

| Feature           | Example                                |
| ----------------- | -------------------------------------- |
| **CPU limits**    | Restrict container to 2 CPU cores      |
| **Memory limits** | Enforce 512MB memory cap               |
| **BlkIO control** | Limit disk I/O read/write speeds       |
| **PIDs limit**    | Max number of processes per container  |
| **Accounting**    | Monitor per-container usage statistics |

### 🧪 Docker Example:

```bash
docker run -m 256m --cpus="1.0" ubuntu
```

* `-m 256m`: Limits memory usage to 256MB
* `--cpus=1.0`: Restricts container to one logical CPU

---

## 🔩 How Docker Uses Namespaces + cgroups Together

| Feature           | Uses                              |
| ----------------- | --------------------------------- |
| Process Isolation | PID namespace                     |
| File System View  | Mount (`mnt`) namespace + UnionFS |
| Network Isolation | NET namespace                     |
| Hostname          | UTS namespace                     |
| Resource Limits   | Cgroups                           |

### Diagram:

```
       +-------------------+
       |  Host Kernel      |
       |                   |
       |  +------------+   |
       |  | Container  |   |
       |  | Namespaces |<-- Isolates view of system
       |  +------------+   |
       |  +------------+   |
       |  |  cgroups   |<-- Limits access to system resources
       |  +------------+   |
       +-------------------+
```

---

## 🛡️ Benefits for Containers

| Feature               | Enabled By     | Benefit                                    |
| --------------------- | -------------- | ------------------------------------------ |
| Process isolation     | PID namespace  | Each container sees only its own processes |
| Filesystem separation | MNT namespace  | Unique root filesystem per container       |
| Network independence  | NET namespace  | Independent IP stack, ports                |
| Resource fairness     | cgroups        | Prevent resource hogging                   |
| Secure multi-tenancy  | user namespace | UID/GID remapping for safety               |

---

## 🔍 Inspecting from the Host

### View namespaces:

```bash
lsns
```

### View cgroups:

```bash
cat /proc/$(pidof containerd)/cgroup
```

### View resource limits:

```bash
docker inspect <container_id> | grep -A5 "HostConfig"
```

---

## 🧪 Manual Namespace (Example)

```bash
unshare --pid --mount --uts --ipc --net --user --fork bash
```

This launches a shell with isolated namespaces — similar to a minimal container environment.

---

## 📌 Summary Table

| Feature     | Namespaces                           | cgroups                              |
| ----------- | ------------------------------------ | ------------------------------------ |
| Purpose     | Isolation of system resources        | Limiting and accounting of resources |
| Scope       | Per process or process group         | Per control group (cgroup)           |
| Granularity | Type-specific (e.g., net, pid, etc.) | Per resource (cpu, mem, io)          |
| Used by     | Docker, LXC, Podman, systemd         | Docker, LXC, Kubernetes, systemd     |

---

## 🔚 Conclusion

* **Namespaces** isolate containers from each other and the host.
* **Cgroups** control and limit how much a container can use.
* Together, they provide the foundational mechanisms that make containerization secure, efficient, and scalable.
