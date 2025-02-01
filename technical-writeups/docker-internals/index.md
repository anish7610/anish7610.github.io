---
layout: default
title: docker-internals 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Docker Internals: Layers, Volumes, and Networking

Docker revolutionized how developers build, ship, and run applications by using containers to encapsulate environments. Understanding Docker internals like layers, volumes, and networking is essential for optimizing container performance, managing persistent data, and ensuring smooth communication across containers.

---

## 1. Docker Image Layers: Union Filesystems

### 📦 What are Layers?

Docker images are built in layers using a **union filesystem** (like AUFS, OverlayFS, or Btrfs). Each instruction in a Dockerfile (e.g., `RUN`, `COPY`, `ADD`) creates a new layer. Layers are **read-only** and **cached**, allowing for:

* Efficient reuse
* Faster builds
* Smaller storage footprint

### 🔄 Layer Composition

* **Base image layer**: Starts from an OS like `ubuntu`, `alpine`, etc.
* **Intermediate layers**: Commands like `RUN apt-get update`.
* **Top layer**: Container writable layer — changes during container runtime live here.

```bash
docker history <image-name>
```

### 🔧 Example:

```Dockerfile
FROM python:3.9
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

Each of these commands creates a new immutable layer.

---

## 2. Docker Volumes: Persistent Storage

### 💾 Why Volumes?

Containers are **ephemeral** — once destroyed, data in them is lost. Volumes provide a **persistent storage mechanism**.

### 🔍 Types of Mounts:

* **Volumes**: Managed by Docker (`/var/lib/docker/volumes/`)
* **Bind Mounts**: Maps host path to container path
* **tmpfs Mounts**: RAM-only storage, useful for sensitive data

### 📘 Use Cases:

* Database storage
* Sharing logs between containers
* Caching dependencies

```bash
# Create and mount volume
docker volume create mydata
docker run -v mydata:/data myimage
```

### 🧹 Volume Lifecycle:

Volumes persist beyond the life of a container unless manually removed:

```bash
docker volume rm mydata
```

---

## 3. Docker Networking: Bridging Communication

Docker provides multiple **network drivers** to allow containers to communicate internally or with the outside world.

### 🔌 Common Network Drivers:

| Driver  | Description                                 |
| ------- | ------------------------------------------- |
| bridge  | Default driver for standalone containers    |
| host    | Shares the host network stack               |
| overlay | Used for multi-host swarm setups            |
| none    | Isolated container, no networking           |
| macvlan | Assigns MAC to container for LAN visibility |

### 🧱 Bridge Network (Default):

* Each container gets a virtual NIC (veth pair)
* Docker manages a bridge (e.g., `docker0`) for internal communication
* Containers can talk to each other via **container names** as DNS names

```bash
docker network inspect bridge
```

### 🌐 Creating Custom Networks:

Useful for service discovery and isolated communication.

```bash
docker network create my_net
docker run -d --name web --network my_net nginx
docker run -it --name busybox --network my_net busybox
```

Now, `busybox` can ping `web`.

---

## 4. Advanced Concepts

### 🔄 Copy-on-Write (COW)

When a container writes to a file, it's copied from the underlying image layer to the writable container layer. This is how Docker maintains immutability of base image layers.

### 🕵️ Debugging:

```bash
docker inspect <container-name>
```

Useful to understand:

* Network settings
* Volume mounts
* Layer diffs

---

## 🔚 Conclusion

Understanding Docker's internal workings — how it builds images with layers, manages persistent state with volumes, and connects containers through networks — empowers developers to write efficient, scalable, and secure containerized applications. Mastery of these concepts also helps in debugging complex container orchestration setups in tools like Docker Compose and Kubernetes.
