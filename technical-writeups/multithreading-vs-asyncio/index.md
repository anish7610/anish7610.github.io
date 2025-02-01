---
layout: default
title: multithreading-vs-asyncio
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Multithreading vs Async IO in Python

Python offers multiple paradigms to manage concurrency and parallelism in applications, particularly in I/O-bound and CPU-bound tasks. Two of the most discussed approaches are **Multithreading** and **Asynchronous I/O (Async IO)**. While both aim to improve performance and responsiveness, their underlying models and use cases differ significantly.

---

## 📌 Overview

| Feature                 | Multithreading                             | Async IO                            |
| ----------------------- | ------------------------------------------ | ----------------------------------- |
| Concurrency Model       | Preemptive threads                         | Cooperative coroutines              |
| Suitable For            | I/O-bound operations (with blocking calls) | I/O-bound operations (non-blocking) |
| Threading Model         | OS-level threads                           | Single-threaded event loop          |
| Memory Overhead         | Higher (thread stack per thread)           | Lower (no separate stacks)          |
| CPU-bound Task Handling | Poor (due to GIL)                          | Poor (still single-threaded)        |
| Syntax Complexity       | Easier                                     | Requires `async/await` keywords     |

---

## 🧵 Multithreading in Python

### ✅ What It Is:

Multithreading uses the `threading` module in Python to spawn OS-level threads that can run concurrently. However, due to the **Global Interpreter Lock (GIL)** in CPython, only one thread executes Python bytecode at a time.

### ✅ When to Use:

* When tasks spend time **waiting** (e.g., for I/O, network responses).
* When you want to write **simpler** concurrent code without managing an event loop.

### ❌ When to Avoid:

* In **CPU-bound** tasks (e.g., computation-heavy loops).
* When spawning **too many threads** — overhead is non-trivial.

### ✅ Example:

```python
import threading
import time

def fetch_data():
    print("Start fetching")
    time.sleep(2)  # Simulates I/O
    print("Done fetching")

threads = []
for _ in range(5):
    t = threading.Thread(target=fetch_data)
    t.start()
    threads.append(t)

for t in threads:
    t.join()
```

---

## ⚙️ Async IO in Python

### ✅ What It Is:

`asyncio` provides a single-threaded, single-process model that runs code using an **event loop**. Tasks cooperatively yield control using `await` and resume when I/O is ready.

### ✅ When to Use:

* High-concurrency, I/O-bound applications (web scraping, socket servers).
* When managing thousands of lightweight tasks.

### ❌ When to Avoid:

* For CPU-intensive workloads.
* When dealing with non-async APIs without wrappers.

### ✅ Example:

```python
import asyncio

async def fetch_data():
    print("Start fetching")
    await asyncio.sleep(2)  # Non-blocking
    print("Done fetching")

async def main():
    tasks = [fetch_data() for _ in range(5)]
    await asyncio.gather(*tasks)

asyncio.run(main())
```

---

## 🔄 Key Differences: Scheduling & Memory

| Aspect                 | Multithreading            | Async IO                       |
| ---------------------- | ------------------------- | ------------------------------ |
| Scheduling             | OS-based                  | Event-loop based               |
| Context Switch         | Costly (kernel-managed)   | Lightweight (user-managed)     |
| Memory Footprint       | Larger (stack per thread) | Smaller (single thread)        |
| Blocking Call Handling | Thread blocked            | Coroutine suspends only itself |

---

## 🧠 Use Case Comparison

| Use Case                           | Best Option                   | Reason                                            |
| ---------------------------------- | ----------------------------- | ------------------------------------------------- |
| Web Scraping                       | Async IO                      | Efficient for thousands of concurrent connections |
| File Reading                       | Multithreading                | Async file I/O is not well-supported              |
| Real-time Chat Server              | Async IO                      | Scales better with clients                        |
| Data Crunching (e.g., ML training) | Neither (use multiprocessing) | GIL prevents CPU-bound performance gain           |

---

## 🧰 Tools and Libraries

### Multithreading:

* `threading`
* `concurrent.futures.ThreadPoolExecutor`

### Async IO:

* `asyncio`
* `aiohttp` (HTTP client)
* `uvloop` (faster event loop)

---

## 🧵🔁 Multithreading + Async IO?

It’s possible to combine both:

* Run `asyncio` in the main thread
* Use threads for blocking tasks via `run_in_executor`

```python
loop.run_in_executor(None, blocking_function)
```

---

## 🧩 Conclusion

* For modern **I/O-bound** Python applications, **Async IO is generally more scalable and memory-efficient**.
* For legacy code or when using **blocking APIs**, **multithreading** can be easier.
* Neither is suitable for **CPU-bound** tasks — use **multiprocessing** for that.
