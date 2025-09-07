---
layout: default
title: multithreaded-scheduling-and-context-switches
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Multi-threaded Process Scheduling and Context Switch Metrics

Modern operating systems handle multiple processes and threads by interleaving their execution on available CPUs. This is done through **scheduling** and results in **context switching**, especially in multi-threaded applications. Here's a deep dive into how multi-threaded scheduling works and how to observe and measure context switches in Linux.

---

##  Overview of Multi-threaded Process Scheduling

A **multi-threaded process** consists of multiple threads of execution within the same process space. Threads share memory but have separate registers and stacks.

The OS scheduler must:

* Allocate CPU time to each thread fairly or based on priority.
* Perform context switches between threads (both within the same process and across processes).
* Keep track of thread states (running, ready, blocked, etc.)

### Scheduler Policies in Linux:

* `SCHED_OTHER` – Default time-sharing policy.
* `SCHED_FIFO`, `SCHED_RR` – Real-time policies.
* `SCHED_BATCH` – For CPU-intensive but non-interactive tasks.
* `SCHED_IDLE` – For very low-priority background jobs.

Each thread is treated as a separate "task" by the Linux scheduler, identified by its **Thread ID (TID)**.

---

##  Context Switching: What Happens?

**Context Switch** is the process where the CPU switches from one task (process/thread) to another. This involves:

* Saving the state (registers, stack pointer, program counter) of the currently running thread.
* Loading the state of the next thread to be scheduled.

Types of context switches:

* **Voluntary:** When a thread sleeps or yields.
* **Involuntary:** When the scheduler preempts a thread due to time slice expiration or higher-priority thread.

Context switching is **CPU-intensive** and too many context switches can lead to performance degradation (thrashing).

---

##  Tools to Observe Thread Scheduling and Context Switches

### 1. `top` or `htop`

* Shows number of context switches per process.
* Look under `CSWCH` (context switches) or `S` column (state).

### 2. `pidstat -w -p <PID>`

```bash
sudo apt install sysstat
pidstat -w -p <PID> 1
```

Displays:

* voluntary and involuntary context switches per second.

### 3. `perf stat`

```bash
perf stat -p <PID>
```

* Measures total context switches and CPU cycles.

### 4. `strace -c -f -e trace=none -e context=1 <cmd>`

```bash
strace -c -f ./multi_threaded_app
```

* Captures syscall and context switch info.

### 5. `vmstat`

```bash
vmstat 1
```

* Shows `cs` (context switch) column globally.

---

##  Multi-threaded Programming Impact

* Threads that block frequently (I/O-bound) may result in many **voluntary context switches**.
* CPU-bound threads may face **involuntary context switches** due to time-sharing.

 High thread count apps (like Nginx, JVM apps) must balance between concurrency and switch overhead.

---

##  Tuning & Mitigation

* **Thread Affinity (CPU pinning):** Bind threads to specific cores using `taskset` or `pthread_setaffinity_np`.
* **Reduce Thread Count:** Avoid oversubscribing cores.
* **Lock-Free Programming:** Minimizes blocking, reducing voluntary switches.
* **Use Real-time Scheduling** (with care) for latency-sensitive threads.

---

##  Example

```c
// multithreaded.c
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

void* busy_loop(void* arg) {
    while (1);
}

int main() {
    pthread_t tid[4];
    for (int i = 0; i < 4; ++i)
        pthread_create(&tid[i], NULL, busy_loop, NULL);
    sleep(30);
    return 0;
}
```

Run with:

```bash
gcc multithreaded.c -o mt -lpthread
./mt &
pidstat -w -p $(pidof mt) 1
```

You’ll observe high context switch counts due to constant thread competition.

---

##  Summary

| Metric             | Tool                |
| ------------------ | ------------------- |
| Vol/Invol switches | `pidstat`, `perf`   |
| Scheduler behavior | `schedtool`, `chrt` |
| Global switch rate | `vmstat`            |
| Thread view        | `htop`, `top -H`    |

Understanding thread scheduling and context switching is crucial for building **scalable**, **real-time**, or **low-latency** applications in Linux environments.
