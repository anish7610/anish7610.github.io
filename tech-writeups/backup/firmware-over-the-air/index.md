---
layout: default
title: firmware-over-the-air 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Firmware Over-The-Air (FOTA) Update Mechanism

Firmware Over-The-Air (FOTA) is a method for remotely updating the firmware of embedded devices through a wireless communication channel. Common in IoT devices, smartphones, and automotive systems, FOTA ensures devices stay secure and up-to-date without physical access.

---

## Why FOTA?

1. **Security**: Fix vulnerabilities without physical intervention.
2. **Scalability**: Update thousands or millions of devices remotely.
3. **Reduced Costs**: No need for on-site service or recalls.
4. **Improved UX**: Feature additions, performance enhancements.

---

## High-Level Architecture

```
+---------------------+          +----------------------+
| Device Management   | <----->  | Cloud Update Server  |
| Backend (API, Auth) |          | (Firmware Repo)      |
+---------------------+          +----------------------+
            ^                             |
            |                             v
     +------------------+     +---------------------+
     | Embedded Device  | <-- | Firmware Binary (.bin) |
     +------------------+     +---------------------+
```

---

## Key Components

### 1. **Firmware Image**

* A binary file containing the new firmware.
* Usually signed and checksummed to ensure authenticity and integrity.

### 2. **Bootloader**

* Resides in protected flash memory.
* Handles:

  * Checking firmware signature.
  * Flashing new firmware.
  * Fallback to previous version if update fails.

### 3. **Update Server**

* Hosts firmware binaries.
* Serves metadata (version, checksum).
* Uses HTTPS or MQTT for delivery.

### 4. **Update Agent (Client Side)**

* Periodically checks for new versions.
* Downloads, verifies, and stages firmware.
* Triggers bootloader for installation.

---

## FOTA Process Flow

1. **Version Check**
   Device queries server: “Is a new firmware available?”

2. **Download Phase**
   If yes, device downloads the binary in chunks using:

   * HTTP(S)
   * MQTT
   * CoAP
   * LwM2M

3. **Verification**

   * Signature verification using public key cryptography (e.g., RSA/ECC).
   * CRC or SHA-based hash verification.

4. **Flashing**

   * Bootloader writes new firmware to flash.
   * Often done to a secondary slot to support rollback.

5. **Reboot and Validation**

   * Reboot to new firmware.
   * Bootloader performs post-flash health check (e.g., watchdog, diagnostics).
   * If failed, rollback to previous firmware.

---

## Design Considerations

* **Atomicity**: Prevent bricking due to partial writes or power loss.
* **Rollback Mechanism**: Required for resilience.
* **Security**:

  * TLS transport
  * Signed firmware
  * Secure boot
* **Resource Constraints**: Low-memory devices may use delta updates (e.g., bsdiff).

---

## Tools and Frameworks

* **Mender.io**
* **Balena**
* **RAUC (Robust Auto Update Controller)**
* **Google OTA (A/B partitions in Android)**
* **SWUpdate**

---

## Real-World Use Cases

| Use Case           | Details                                                |
| ------------------ | ------------------------------------------------------ |
| Automotive ECUs    | Update ECU firmware remotely (e.g., Tesla).            |
| IoT Smart Devices  | Update home devices like smart thermostats.            |
| Mobile Phones      | Android/iOS OTA updates.                               |
| Industrial Sensors | Maintain secure sensor networks in inaccessible areas. |

---

## Summary

FOTA is essential for maintaining, securing, and enhancing connected devices in production. It enables cost-effective, scalable updates while minimizing physical intervention. Designing a robust and secure FOTA mechanism is crucial for modern embedded and IoT systems.
