---
layout: default
title: ebpf-packet-filtering-kernel-tracing
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## BPF (eBPF) for Packet Filtering and Kernel Tracing

eBPF (Extended Berkeley Packet Filter) is a revolutionary technology in the Linux kernel that allows safe and efficient execution of user-defined programs in kernel space. Initially designed for packet filtering (classic BPF), eBPF has evolved into a powerful sandboxed virtual machine inside the Linux kernel that supports networking, security, tracing, and performance profiling.

---

###  Origins and Evolution of BPF

* **Classic BPF (cBPF):** Introduced for efficient packet filtering in tools like `tcpdump`, providing a low-level in-kernel VM to evaluate packet headers.
* **Extended BPF (eBPF):** Introduced in Linux 3.15+ with a more expressive instruction set, ability to hook into various kernel subsystems (e.g., network stack, syscalls), and support for safe memory access and JIT compilation.

---

###  Use Cases of eBPF

| Category                    | Example Use Cases                                                      |
| --------------------------- | ---------------------------------------------------------------------- |
| **Packet Filtering**        | Firewall rules (e.g., XDP), DDoS mitigation                            |
| **Tracing & Observability** | System call tracing, performance monitoring (`bcc`, `bpftrace`)        |
| **Security**                | Syscall filtering, process activity monitoring (`seccomp`, `Tetragon`) |
| **Performance Tuning**      | CPU/memory profiling, disk I/O latency debugging                       |
| **Networking**              | Load balancing (Cilium), deep packet inspection                        |

---

###  eBPF for Packet Filtering

#### Mechanisms:

* **XDP (eXpress Data Path):**

  * Attaches eBPF programs directly to the network driver receive path.
  * Enables ultra-low-latency packet processing before it enters the kernel networking stack.
  * Used for packet drop, redirect, or pass decisions.

* **tc (Traffic Control) eBPF:**

  * Allows attaching eBPF programs at various points in the Linux traffic control pipeline.
  * More flexible than XDP; operates further up the stack, suitable for QoS or shaping.

#### Example: Drop all ICMP packets using XDP

```c
SEC("xdp")
int xdp_drop_icmp(struct xdp_md *ctx) {
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;
    
    struct ethhdr *eth = data;
    if ((void *)eth + sizeof(*eth) > data_end) return XDP_PASS;

    if (eth->h_proto == htons(ETH_P_IP)) {
        struct iphdr *ip = data + sizeof(*eth);
        if ((void *)ip + sizeof(*ip) > data_end) return XDP_PASS;

        if (ip->protocol == IPPROTO_ICMP) return XDP_DROP;
    }

    return XDP_PASS;
}
```

---

###  eBPF for Kernel Tracing

eBPF can attach probes to various kernel or user-space events:

* **kprobes / kretprobes:** Attach to kernel function entry/exit.
* **uprobes:** Attach to user-space binary functions.
* **tracepoints:** Static instrumentation points in kernel code.
* **perf events:** CPU performance counters.

#### Tools & Frameworks:

* **BCC (BPF Compiler Collection):** Python-based front end for writing and running eBPF tracing programs.
* **bpftrace:** High-level tracing language similar to `awk`, great for one-liners.
* **Perf / SystemTap:** Older tools, partially superseded by eBPF.

#### Example: Trace open syscalls with `bpftrace`

```bash
bpftrace -e 'tracepoint:syscalls:sys_enter_openat { printf("%s opened %s\n", comm, str(args->filename)); }'
```

---

###  Safety and Verification

* eBPF programs are **verified** before execution to ensure:

  * No loops (bounded execution).
  * Valid memory accesses.
  * Stack size constraints.
* Programs are **JIT-compiled** to native instructions for performance.

---

###  Real-World Applications

* **Cilium:** Kubernetes CNI plugin that uses eBPF for load balancing, network policy enforcement, and observability.
* **Falco:** Runtime security tool using eBPF to detect suspicious syscalls.
* **Facebook / Netflix:** Use eBPF extensively for performance debugging and latency tracing at scale.

---

###  Advantages of eBPF

* No kernel changes needed to add tracing/logging.
* Efficient and safe (runs in a VM with strict safety checks).
* Dynamically insert logic into kernel at runtime.
* High performance: low overhead JIT-compiled programs.

---

###  Development Toolchain

* **LLVM/Clang:** For compiling C code into eBPF bytecode.
* **libbpf:** C API to load and interact with eBPF programs.
* **bpftool:** CLI for inspecting and managing eBPF programs.
* **CO-RE (Compile Once – Run Everywhere):** Mechanism to write portable eBPF programs that adapt to kernel versions.

---

###  Summary

| Feature              | Description                                             |
| -------------------- | ------------------------------------------------------- |
| **Packet Filtering** | Drop or reroute packets in kernel space (XDP, tc)       |
| **Tracing**          | Kernel/user-space visibility without recompiling kernel |
| **Security**         | Runtime process and syscall monitoring                  |
| **Performance**      | Minimal overhead; safe and fast execution               |

eBPF represents a paradigm shift in systems programming by safely extending kernel capabilities **without writing kernel modules**, enabling deep observability, fine-grained control, and performance that rivals native code.
