---
layout: default
title: numa-and-memory-pinning
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## **NUMA (Non-Uniform Memory Access) and Memory Pinning**

Modern multi-CPU systems increasingly rely on **NUMA architectures** to scale memory and compute performance. But performance gains are only realized when developers and operating systems are NUMA-aware. Memory pinning further fine-tunes control by locking memory to specific NUMA nodes.

---

###  1. What is NUMA?

**NUMA (Non-Uniform Memory Access)** is a memory architecture where:

* Each CPU (or socket) has **local memory** it can access **quickly**.
* CPUs can access **remote memory** (attached to other sockets), but with **higher latency** and **lower bandwidth**.

#### Example Layout:

```
+------------+       +------------+
| CPU Socket 0|<----->| Memory Node 0 |
|            |       +------------+
|            |
|            |       +------------+
|            |<----->| Memory Node 1 |
+------------+       +------------+
```

Access to **local memory** is faster than to **remote memory**.

---

###  2. NUMA Implications on Performance

* **Local memory access**: Low latency, high throughput.
* **Remote memory access**: High latency, potential bottlenecks.
* **Memory bandwidth contention**: May occur if many threads access a remote node’s memory.

Poor NUMA locality leads to:

* Cache misses.
* Memory access delays.
* Reduced overall throughput.

---

###  3. What is Memory Pinning?

**Memory Pinning** (also called memory binding or affinity) is the act of:

* **Allocating memory on a specific NUMA node**.
* **Ensuring a thread accesses memory from its local NUMA node** to reduce latency.

Pinned memory:

* Stays in RAM (not swapped out).
* Remains bound to a particular NUMA node or device (e.g., for DMA transfers).

---

###  4. Tools for NUMA Awareness

| Tool       | Purpose                                     |
| ---------- | ------------------------------------------- |
| `numactl`  | Run programs with specific NUMA bindings.   |
| `numastat` | Show memory usage per NUMA node.            |
| `hwloc`    | Visualize hardware layout (topology-aware). |
| `taskset`  | Bind process to specific CPUs.              |
| `libnuma`  | C library to manage memory/node affinity.   |

#### Example using `numactl`:

```bash
# Run a process on CPU node 0 and allocate memory from node 0
numactl --cpunodebind=0 --membind=0 ./my_app
```

---

###  5. Programming with libnuma (C API)

```c
#include <numa.h>

if (numa_available() != -1) {
    struct bitmask *nodes = numa_allocate_nodemask();
    numa_bitmask_setbit(nodes, 0);  // bind to NUMA node 0
    numa_set_membind(nodes);
}
```

This ensures memory allocations go to NUMA node 0.

---

###  6. NUMA and Multi-threading

In multithreaded applications (e.g., using `pthread`, OpenMP):

* Threads should be **affinitized to cores**.
* Memory allocations should be **localized to the threads’ NUMA nodes**.

#### Example:

* Bind threads in a worker pool to separate NUMA nodes.
* Use per-node memory pools for data locality.

---

###  7. NUMA in High-Performance Computing (HPC) and Databases

**HPC systems, databases, and low-latency applications** like:

* In-memory DBs (e.g., Redis, Memcached)
* Scientific simulations
* Machine learning inference engines

... all benefit from NUMA-aware memory allocation.

Memory pinning also matters in:

* **RDMA (Remote Direct Memory Access)**, where memory must be fixed for zero-copy data transfers.
* **GPU programming**, where pinned host memory improves PCIe transfers.

---

###  8. Performance Tips

| Tip                                      | Benefit                                |
| ---------------------------------------- | -------------------------------------- |
| Pin threads and memory to same NUMA node | Reduced latency, increased cache hits  |
| Avoid cross-node memory access           | Prevents bus congestion and slowdowns  |
| Use per-node memory pools                | Better scaling with more cores/sockets |
| Monitor with `numastat`, `perf`, `htop`  | Detect imbalances or remote memory use |

---

###  9. Conclusion

NUMA and memory pinning are critical for performance on modern multicore/multisocket systems. Developers writing low-latency, high-throughput applications must:

* Be aware of the memory topology.
* Use tools and APIs to enforce memory locality.
* Align thread and memory placement for optimal performance.

Failing to consider NUMA effects can result in underutilized hardware, memory stalls, and unnecessary cross-node traffic.
