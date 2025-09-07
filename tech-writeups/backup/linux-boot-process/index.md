---
layout: default
title: linux-boot-process 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


#  Technical Writeup: Linux Boot Process — From BIOS to Shell

The Linux boot process is a sequence of steps that your system follows to transition from powered-off hardware to a fully functional Linux environment, complete with a shell. Understanding each stage is crucial for system administrators, developers, and security professionals.

---

##  1. BIOS / UEFI: Power-On and Hardware Initialization

### BIOS (Basic Input/Output System)

* BIOS is firmware embedded in the motherboard.
* It performs POST (Power-On Self-Test) to check hardware integrity (RAM, CPU, keyboard, etc.).
* After POST, it locates a bootable device using a **boot sequence** (HDD, SSD, USB, etc.).
* BIOS loads the first 512 bytes of the bootable device — the **MBR (Master Boot Record)** — into memory and hands control to it.

### UEFI (Unified Extensible Firmware Interface)

* Modern replacement for BIOS with enhanced features (larger drive support, secure boot).
* Loads a **.efi** bootloader from the EFI system partition (usually `/boot/efi`).
* UEFI directly loads the Linux bootloader, bypassing the MBR.

>  **Key Difference**: BIOS uses MBR and legacy bootloaders like GRUB Legacy; UEFI uses GPT and newer bootloaders like GRUB2 or systemd-boot.

---

##  2. Bootloader: GRUB or systemd-boot

The bootloader is responsible for loading the Linux kernel into memory.

### GRUB (GRand Unified Bootloader)

* Reads its configuration file: `/boot/grub/grub.cfg`
* Presents a menu to choose the kernel (if multiple available).
* Loads the selected kernel image (`vmlinuz-<version>`) and **initramfs** (initial RAM filesystem) into memory.
* Passes control to the kernel with selected parameters (e.g., root filesystem).

### systemd-boot (alternative to GRUB on UEFI systems)

* Simpler than GRUB, reads `/boot/loader/loader.conf` and entries in `/boot/loader/entries/`.

---

##  3. Kernel Initialization

Once the kernel is loaded into memory:

* **Decompresses itself** (vmlinuz is a compressed image).
* Initializes low-level hardware: memory management, device drivers, CPU scheduling.
* Mounts the **initramfs** (temporary root filesystem in RAM) to access basic binaries and drivers.

### Role of initramfs:

* Provides a minimal root environment.
* Loads drivers required for accessing the real root filesystem (e.g., LVM, RAID).
* Once the real root is accessible, it hands control to the **init system**.

---

##  4. init System: PID 1

The init system is the first userspace process (PID 1) that manages user-space services.

### Options:

* **Systemd** (default in most modern distros): Reads configuration from `/etc/systemd/`
* **SysVinit** (older): Executes scripts in `/etc/init.d/`
* **Upstart** (legacy Ubuntu): Uses `.conf` files in `/etc/init/`

#### What init does:

* Mounts remaining filesystems.
* Starts essential services (udev, networking, cron, syslog).
* Spawns **getty** processes to manage TTYs (terminals).
* Launches the **default target** (multi-user, graphical, etc.).

---

##  5. Login Prompt and Shell

Once the system reaches the default target:

* A **login manager** or `getty` provides a login prompt on virtual terminals.
* Upon successful login, the user is dropped into a **shell** (bash, zsh, etc.).
* The shell executes initialization scripts (`.bashrc`, `.profile`) and presents a command prompt.

---

##  Summary Diagram

```
[Power On]
     ↓
[BIOS / UEFI]
     ↓
[Bootloader (GRUB / systemd-boot)]
     ↓
[Kernel + initramfs]
     ↓
[Init system (systemd, SysV)]
     ↓
[Login Prompt (TTY or GUI)]
     ↓
[Shell or Desktop Environment]
```

---

##  Troubleshooting Tools

* `dmesg` — Kernel ring buffer logs.
* `journalctl` — Logs managed by systemd.
* `/var/log/boot.log` — System boot messages.
* `systemctl list-units` — Services started at boot.

---

##  Final Notes

* **Fast Boot** options in UEFI/BIOS can skip POST checks.
* **Secure Boot** restricts unsigned kernel/modules — must be configured correctly for custom kernels.
* **initrd vs initramfs**: initrd is a block device image, initramfs is a cpio archive in RAM.
