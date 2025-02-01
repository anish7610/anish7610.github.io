---
layout: default
title: interrupt-driven-vs-polling 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Interrupt-Driven vs Polling in Embedded Design

Embedded systems often need to respond to external events—such as user input, sensor readings, or communication data. The choice between **interrupt-driven** and **polling-based** mechanisms to handle these events is fundamental to system performance, power consumption, and responsiveness.

## 🔁 What is Polling?

Polling is a **synchronous** method where the processor continuously checks (or "polls") a device or register to see if an event has occurred.

### 📌 How It Works

* CPU repeatedly reads a status register in a loop.
* If the event hasn't occurred, the CPU keeps checking.
* When the event occurs (e.g., data ready), the CPU handles it.

### ✅ Pros

* Simple to implement.
* Predictable timing.
* No concurrency issues; all logic is in a single thread/loop.

### ❌ Cons

* Inefficient for low-frequency events (wastes CPU cycles).
* Higher power consumption.
* Reduces processor availability for other tasks.

### Example:

```c
while (1) {
    if (UART_DataReady()) {
        char c = UART_Read();
        process_char(c);
    }
}
```

---

## ⚡ What is Interrupt-Driven Handling?

Interrupt-driven design allows a peripheral to **asynchronously notify** the processor when it requires attention, suspending the current flow to handle the event.

### 📌 How It Works

* The CPU performs normal operations.
* When an event occurs (e.g., button press), an **interrupt request (IRQ)** is triggered.
* CPU stops current execution, saves context, and jumps to an **Interrupt Service Routine (ISR)**.
* After the ISR executes, normal execution resumes.

### ✅ Pros

* Efficient: CPU only acts when needed.
* Ideal for low-frequency or unpredictable events.
* Allows multitasking or power-saving modes.

### ❌ Cons

* More complex to implement (needs ISRs, priorities, etc.).
* Risk of race conditions or re-entrancy bugs if not handled properly.
* Harder to debug.

### Example:

```c
void UART_ISR() {
    char c = UART_Read();
    process_char(c);
}

// Somewhere in init:
enable_UART_interrupts();
```

---

## 🧠 Choosing Between the Two

| Criteria                 | Polling             | Interrupt                   |
| ------------------------ | ------------------- | --------------------------- |
| Event Frequency          | High and consistent | Low or sporadic             |
| Power Sensitivity        | Not ideal           | More efficient              |
| Code Simplicity          | Simple              | Complex                     |
| CPU Usage                | Constant            | Only on event               |
| Real-Time Responsiveness | Poor                | Excellent (with priorities) |

---

## 🛠️ Real-World Embedded Example

**Scenario**: A temperature sensor sends data every 1 second.

* **Polling**: Good if the system does nothing else and sensor timing is regular.
* **Interrupt**: Better if the system is multitasking or in sleep mode.

**Scenario**: A user button press.

* **Polling**: Bad, wastes cycles checking the button.
* **Interrupt**: Best—respond only when button is pressed.

---

## 🧩 Hybrid Approach

Some systems use a **hybrid** model:

* Use interrupts to wake the CPU.
* Use polling in tight timing loops (e.g., reading multiple bytes from SPI quickly).

---

## 🧵 Summary

| Aspect         | Polling | Interrupt |
| -------------- | ------- | --------- |
| CPU Efficiency | ❌       | ✅         |
| Simplicity     | ✅       | ❌         |
| Real-Time Use  | ❌       | ✅         |
| Power Saving   | ❌       | ✅         |

Choose **interrupts** when:

* Events are asynchronous.
* You want better power/performance efficiency.
* You have limited CPU resources.

Choose **polling** when:

* You need deterministic timing.
* The system has a simple loop and no multitasking.
* Peripheral access is fast and frequent.
