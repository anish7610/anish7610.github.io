---
layout: default
title: virtual-memory 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# 🧠 Virtual Memory, Paging, and Swapping Explained

Efficient memory management is critical for any modern operating system. **Virtual memory**, **paging**, and **swapping** are key mechanisms that make it possible to run large and multiple applications on limited physical RAM, while maintaining system stability and performance.

---

## 📦 1. Virtual Memory

### 🔍 What is Virtual Memory?

Virtual memory is an abstraction where each process is given the **illusion** of having access to a large, contiguous block of memory, even if the physical RAM is smaller or fragmented.

> 🧠 Think of it as a **virtualized address space** — the OS and CPU translate virtual addresses into physical ones.

### 💡 Why Use Virtual Memory?

* **Isolation**: Each process is protected from accessing another’s memory.
* **Convenience**: Programmers don't need to manage physical addresses.
* **Flexibility**: Enables **memory overcommitment** and efficient use of RAM.

### 🔗 How It Works:

* The **MMU (Memory Management Unit)** in the CPU translates **Virtual Addresses (VA)** to **Physical Addresses (PA)** using **page tables**.
* The OS maintains a mapping for each process's virtual address space.

---

## 📄 2. Paging

### 🔍 What is Paging?

Paging divides memory into fixed-size blocks:

* **Pages** (virtual memory): usually 4 KB each
* **Page Frames** (physical memory): same size

The OS maintains a **page table** for each process, mapping virtual pages to physical frames.

### 💡 Benefits of Paging:

* **No external fragmentation**
* Enables **non-contiguous allocation**
* Easy to implement **demand paging** (load pages only when needed)

### 🔁 Page Table Mechanics:

| Virtual Address | → | Page Table | → | Physical Address |
| --------------- | - | ---------- | - | ---------------- |

* Each memory access goes through the **page table lookup**, often cached via **TLB (Translation Lookaside Buffer)** for performance.

---

## 🧊 3. Swapping

### 🔍 What is Swapping?

Swapping moves **pages of memory** to disk when physical RAM is full.

* Pages not currently in use are written to a **swap space** (a swap file or partition).
* Later, if the process needs that page again, it is **paged back into RAM**, possibly pushing another page out.

> 🔄 This mechanism is called **demand paging with swapping**.

### 📂 Swap Space:

* Defined at install time or dynamically via a file.
* Managed by the OS.
* Much slower than RAM (\~100x slower), but prevents out-of-memory crashes.

### 🔧 Linux Tools:

* `free -h` → See swap usage.
* `swapon -s` → View active swap devices.
* `vmstat` → Monitor swapping activity.
* `top/htop` → Live view of memory and swap usage.

---

## 📉 Performance Implications

| Mechanism    | Speed     | Memory Location   | Use Case                        |
| ------------ | --------- | ----------------- | ------------------------------- |
| RAM Access   | Fast      | Physical RAM      | Active data                     |
| Swapped Page | Very Slow | Disk              | Idle or rarely-used pages       |
| Page Fault   | Slow      | Triggers disk I/O | When accessing swapped-out page |

> ⚠️ **Thrashing** occurs when the system spends more time swapping pages in and out than doing useful work — typically due to insufficient RAM.

---

## 📌 Key Terms Summary

| Term            | Description                                     |
| --------------- | ----------------------------------------------- |
| Virtual Memory  | Abstract memory space provided to each process  |
| Physical Memory | Actual RAM installed on the system              |
| Page            | Fixed-size block of virtual memory (e.g., 4 KB) |
| Frame           | Fixed-size block of physical memory             |
| Page Table      | Maps virtual pages to physical frames           |
| Swap Space      | Disk area used as an overflow when RAM is full  |
| Page Fault      | Interrupt caused by accessing a page not in RAM |
| TLB             | Hardware cache of recent page table entries     |

---

## 🧠 Real-World Analogy

* **Virtual Memory** = A large office desk with many drawers (virtual space)
* **RAM** = The part of the desk where you’re currently working
* **Swap** = A cabinet in another room (slow to reach)
* **Page Table** = The index showing where each document is located

---

## 🧪 Example (Linux)

```bash
# Check total memory and swap usage
free -h

# Add a 1GB swap file
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make it permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 🔚 Conclusion

* **Virtual memory** provides abstraction and isolation.
* **Paging** enables fine-grained memory management without fragmentation.
* **Swapping** allows the system to handle memory pressure, albeit with a performance cost.

Understanding these mechanisms helps in tuning systems, debugging performance issues, and building efficient applications.
