---
layout: default
title: process-vs-threads 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# ️ Process vs Thread vs Coroutine: Memory and Scheduling Differences

Understanding the distinctions between **processes**, **threads**, and **coroutines** is crucial in systems programming, performance tuning, and concurrent application design. Each model has unique characteristics in terms of memory isolation, execution context, and scheduling behavior.

---

##  1. Processes

###  Definition:

A **process** is an independent, self-contained unit of execution with its **own memory space**, system resources, and at least one thread (main thread).

###  Memory:

* Completely **separate address space**.
* No shared heap or global variables with other processes.
* **Inter-Process Communication (IPC)** is needed to share data (e.g., pipes, sockets, shared memory).

### ⏱ Scheduling:

* Scheduled by the **Operating System kernel**.
* Preemptive multitasking: OS can interrupt and switch between processes.
* Context switch is **expensive** due to:

  * Saving/restoring CPU registers
  * Switching memory address spaces
  * Flushing TLB (Translation Lookaside Buffer)

###  Use Cases:

* Strong isolation needed (e.g., browsers spawning processes per tab, microservices)
* Crashes don't affect others

---

##  2. Threads

###  Definition:

A **thread** is a lightweight unit of execution within a process. Threads share the **same memory space** but have separate stacks and registers.

###  Memory:

* Threads within the same process **share heap and global memory**.
* Each thread has its own **stack** and **thread-local storage**.
* Synchronization primitives (mutex, semaphore) are needed to avoid race conditions.

### ⏱ Scheduling:

* Also scheduled by the OS.
* Lighter than processes but still requires kernel-level context switching.
* Can run concurrently on multi-core CPUs.

###  Use Cases:

* Tasks requiring parallel computation or background work
* Web servers (handling multiple client connections)

---

##  3. Coroutines

###  Definition:

A **coroutine** is a **cooperative** (non-preemptive) unit of execution that runs in user space. It's a generalization of a function that can **pause and resume** its execution.

###  Memory:

* Lives in **user space** and consumes very little memory (just stack + state).
* All coroutines typically share the same thread’s memory space.
* Lightweight: thousands of coroutines can exist simultaneously.

### ⏱ Scheduling:

* **User-space scheduling** — managed by a coroutine framework (e.g., Python asyncio, Go runtime).
* No kernel context switching → **very fast** to switch between coroutines.
* Must explicitly yield control (`await`, `yield`, etc.) — no preemption.

###  Use Cases:

* High-concurrency I/O-bound applications
* Network servers, web scraping, UI event loops

---

## ️ Comparison Table

| Feature             | Process             | Thread           | Coroutine                   |
| ------------------- | ------------------- | ---------------- | --------------------------- |
| Memory Space        | Separate            | Shared           | Shared (same thread)        |
| Isolation           | High                | Medium           | Low                         |
| Scheduling          | OS Kernel           | OS Kernel        | User-space (cooperative)    |
| Context Switch Cost | High                | Medium           | Low                         |
| Creation Overhead   | High                | Medium           | Very Low                    |
| Scalability         | Low (limited)       | Medium           | High (thousands possible)   |
| Communication       | IPC (complex)       | Shared memory    | Shared state                |
| Preemption          | Yes                 | Yes              | No (manual yield/await)     |
| Use Case            | Isolation, security | Parallel compute | Async I/O, high concurrency |

---

##  Example Scenarios

| Scenario                           | Recommended Approach                 |
| ---------------------------------- | ------------------------------------ |
| Image processing pipeline          | Threads or processes                 |
| Web crawler (I/O-bound)            | Coroutines (`asyncio`)               |
| Multi-user terminal shell          | Threads or coroutines                |
| Running untrusted code             | Processes (sandboxing)               |
| HTTP server handling 10K+ requests | Coroutines (e.g., FastAPI + uvicorn) |

---

##  Python Code Glimpse

```python
# Coroutine Example (asyncio)
import asyncio

async def say_hello():
    await asyncio.sleep(1)
    print("Hello")

async def main():
    await asyncio.gather(say_hello(), say_hello())

asyncio.run(main())
```

```python
# Thread Example
from threading import Thread

def say_hello():
    import time
    time.sleep(1)
    print("Hello")

t1 = Thread(target=say_hello)
t2 = Thread(target=say_hello)
t1.start()
t2.start()
t1.join()
t2.join()
```

---

##  Key Takeaways

* **Processes** offer **isolation** but at a higher cost.
* **Threads** enable **true parallelism**, but require synchronization.
* **Coroutines** are ideal for **scalable concurrency** with minimal overhead, especially in **I/O-bound** programs.
