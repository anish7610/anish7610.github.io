---
layout: default
title: rtos-basics 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Real-Time Operating Systems (RTOS) Basics

Real-Time Operating Systems (RTOS) are specialized operating systems designed to serve real-time applications that process data as it comes in, typically without buffer delays. RTOSes are crucial in embedded systems, robotics, aerospace, automotive systems, and other domains requiring deterministic and time-critical behavior.

---

## 1. What is Real-Time?

Real-time systems are systems that respond to inputs or events within a **strict time constraint**. The correctness of the system depends not only on the logical result but also on the **time at which the results are produced**.

### Types of Real-Time Systems:

* **Hard Real-Time**: Missing a deadline is a system failure (e.g., anti-lock braking systems).
* **Soft Real-Time**: Occasional deadline misses are acceptable but may degrade performance (e.g., video streaming).
* **Firm Real-Time**: Missing a deadline renders the result useless, but no catastrophic consequence (e.g., stock trading).

---

## 2. Key Components of RTOS

### a. **Task Management**

RTOS manages tasks (or threads) through:

* Priorities
* States (Running, Ready, Blocked)
* Preemption

### b. **Scheduler**

The RTOS scheduler ensures tasks are executed in a predictable order. Common policies include:

* **Preemptive Priority Scheduling**
* **Round Robin**
* **Rate Monotonic Scheduling (RMS)**
* **Earliest Deadline First (EDF)**

### c. **Inter-Task Communication (ITC)**

Mechanisms for communication and synchronization:

* Message Queues
* Semaphores (Binary, Counting)
* Mutexes (for mutual exclusion)
* Events/Flags

### d. **Timers and Clocks**

Used for task delays, timeouts, and periodic scheduling.

### e. **Memory Management**

RTOS typically avoids dynamic memory allocation at runtime; instead, it uses:

* Static memory allocation
* Memory pools (fixed-size block allocation)

---

## 3. RTOS vs General-Purpose OS (e.g., Linux)

| Feature                | RTOS                | General-Purpose OS         |
| ---------------------- | ------------------- | -------------------------- |
| Scheduling             | Deterministic       | Best-effort                |
| Latency                | Low and predictable | Variable and high          |
| Footprint              | Small               | Large                      |
| Preemption             | Fine-grained        | Coarse-grained             |
| Timing Guarantees      | Strict              | None                       |
| Real-Time Applications | Supported           | Limited (with PREEMPT\_RT) |

---

## 4. Popular RTOS Examples

| RTOS Name         | Highlights                                      |
| ----------------- | ----------------------------------------------- |
| **FreeRTOS**      | Open source, lightweight, ARM Cortex-M friendly |
| **RTEMS**         | Used in space and avionics (NASA, ESA)          |
| **VxWorks**       | Commercial, used in aerospace and medical       |
| **Zephyr**        | Linux Foundation project for IoT                |
| **QNX**           | Certified for automotive and medical use        |
| **Micrium uC/OS** | Certified RTOS for safety-critical systems      |

---

## 5. Real-Time Constraints: Jitter, Latency, and Throughput

* **Latency**: Time between event and system response.
* **Jitter**: Variation in task response time.
* **Throughput**: Amount of work performed in a given time.

RTOS prioritizes **low latency and jitter**, often sacrificing throughput for predictability.

---

## 6. Use Case Examples

* **Automotive**: Airbag deployment, ECU control
* **Medical Devices**: Pacemakers, ventilators
* **Industrial Automation**: Robotic arms, PLCs
* **Consumer Electronics**: Smartwatches, drones

---

## 7. RTOS Development Considerations

* Select appropriate scheduling algorithm for timing needs.
* Avoid blocking calls in high-priority tasks.
* Use hardware timers for critical operations.
* Minimize context switch overhead.
* Use watchdog timers for system reliability.

---

## 8. RTOS with Embedded Hardware

RTOSes are typically used on microcontrollers (e.g., ARM Cortex-M, AVR, ESP32) with limited resources. They integrate with drivers for peripherals and often offer:

* Tickless idle modes for power efficiency.
* Hooks for custom interrupt handling.
* Portability across toolchains (GCC, IAR, Keil).

---

## Conclusion

An RTOS enables deterministic behavior essential for time-critical systems. Its design is centered around predictability, task prioritization, and minimal latency. Understanding the internals of RTOS is essential for anyone working with embedded systems or safety-critical applications.
