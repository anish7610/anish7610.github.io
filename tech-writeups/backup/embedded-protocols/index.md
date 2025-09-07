---
layout: default
title: embedded-protocols 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# UART, SPI, I2C Protocols in Embedded Systems

Communication between microcontrollers and peripheral devices is a cornerstone of embedded systems. Three widely used communication protocols for this purpose are **UART**, **SPI**, and **I2C**. Each protocol has distinct characteristics, trade-offs, and use cases.

---

##  1. UART (Universal Asynchronous Receiver/Transmitter)

###  Overview

UART is a **full-duplex**, **asynchronous** serial communication protocol that transmits data **bit by bit** between two devices — a **transmitter** and a **receiver**.

###  Characteristics

* **Lines Required**: 2 (TX, RX)
* **Speed**: Typically up to 1 Mbps (can vary by hardware)
* **Synchronous?**:  No clock line, uses start/stop bits and baud rate
* **Point-to-Point**:  Only 1-to-1 communication

###  Frame Format

* Start bit → Data bits (usually 8) → Optional parity → Stop bit(s)

###  Pros

* Simple and widely supported
* Good for short-distance communication
* Works well for console/debug logging

###  Cons

* No built-in addressing → only one device can be connected per UART port
* Baud rate must be matched between devices

---

##  2. SPI (Serial Peripheral Interface)

###  Overview

SPI is a **synchronous**, **full-duplex** protocol typically used for high-speed communication between a master device and one or more slaves.

###  Characteristics

* **Lines Required**: 4+

  * MOSI (Master Out Slave In)
  * MISO (Master In Slave Out)
  * SCLK (Serial Clock)
  * SS/CS (Slave Select)
* **Speed**: Typically up to 10+ Mbps
* **Multi-Device**:  Yes, using separate SS lines or daisy-chaining

###  Pros

* High-speed communication
* Simple protocol, low overhead
* Full-duplex (can send and receive simultaneously)

###  Cons

* Requires more GPIOs for multiple devices
* No error checking or acknowledgment
* No formal standard, leading to compatibility issues

---

##  3. I2C (Inter-Integrated Circuit)

###  Overview

I2C is a **synchronous**, **half-duplex**, **multi-master** serial protocol designed for communication over short distances between ICs on the same PCB.

###  Characteristics

* **Lines Required**: 2 (SDA – data, SCL – clock)
* **Speed**:

  * Standard: 100 kbps
  * Fast: 400 kbps
  * Fast Mode Plus: 1 Mbps
  * High-speed: 3.4 Mbps
* **Multi-Device**:  Yes, using 7-bit or 10-bit addressing

###  Pros

* Only two wires for many devices
* Supports multi-master communication
* Built-in addressing and acknowledgment
* Great for sensor networks or EEPROMs

###  Cons

* Slower than SPI
* Susceptible to noise due to open-drain lines
* More complex to implement (start/stop conditions, ACK/NACK, etc.)

---

##  Protocol Comparison Table

| Feature           | UART            | SPI                       | I2C                  |
| ----------------- | --------------- | ------------------------- | -------------------- |
| Wires Required    | 2 (TX, RX)      | 4+ (MOSI, MISO, SCLK, SS) | 2 (SDA, SCL)         |
| Speed             | Medium          | High                      | Low to Medium        |
| Duplex Mode       | Full            | Full                      | Half                 |
| Clock Sync        | No              | Yes (Master)              | Yes (Master)         |
| Multiple Devices  |                |  (with multiple SS)      |  (with addressing)  |
| Complexity        | Low             | Medium                    | High                 |
| Use Case Examples | Debug UART, GPS | Flash memory, LCD         | Sensors, RTC, EEPROM |

---

##  When to Use What?

* **UART**: Use for **console communication**, **GPS modules**, or where simple one-to-one connection is enough.
* **SPI**: Ideal for **high-speed**, **low-pin-count** communication with **displays**, **flash memory**, or **high-speed ADCs**.
* **I2C**: Best for connecting **multiple low-speed peripherals** like **temperature sensors**, **RTC**, or **EEPROM** on the same bus.
