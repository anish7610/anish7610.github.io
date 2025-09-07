---
layout: default
title: mounting-filesystems-with-mount-and-loop-devices
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Mounting File Systems Manually with `mount` and Loop Devices

Mounting file systems manually is a core task in Linux system administration. It allows a system to access storage devices or filesystems not automatically mounted at boot time. One powerful but less commonly discussed capability is mounting **loop devices**, which lets you mount disk images as if they were physical devices.

---

##  What is Mounting in Linux?

In Linux, everything is treated as a file—including disks and partitions. The `mount` command links a storage device (like `/dev/sda1`) or file (like an `.iso`) to a directory (called a **mount point**) so its contents can be accessed.

**Syntax:**

```bash
mount <device> <mount_point>
```

---

##  Loop Devices: Mounting Disk Images

A **loop device** is a pseudo-device that allows a file to be accessed as a block device. This is useful for mounting ISO files or raw disk images.

###  Use Case: Mounting an ISO File

1. **Create a mount point:**

   ```bash
   sudo mkdir /mnt/iso
   ```

2. **Mount using `mount` with `-o loop`:**

   ```bash
   sudo mount -o loop file.iso /mnt/iso
   ```

   * `-o loop` tells the kernel to treat the file as a block device using a loop device.
   * Contents of `file.iso` can now be accessed at `/mnt/iso`.

3. **Unmount when done:**

   ```bash
   sudo umount /mnt/iso
   ```

---

##  Mounting a Raw Disk Image (e.g., `.img` from `dd`)

If you're working with full disk images (e.g., Raspberry Pi OS image), you can mount partitions inside the image:

1. **Find partition offsets using `fdisk`:**

   ```bash
   fdisk -l disk.img
   ```

2. **Mount the partition (e.g., if offset is 8192 sectors, sector size is 512):**

   ```bash
   sudo mount -o loop,offset=$((8192 * 512)) disk.img /mnt/image
   ```

---

##  Mounting File Systems Manually

### Mounting a USB drive (e.g., `/dev/sdb1`):

```bash
sudo mkdir /mnt/usb
sudo mount /dev/sdb1 /mnt/usb
```

To **specify file system type** (optional):

```bash
sudo mount -t vfat /dev/sdb1 /mnt/usb  # For FAT32
```

### Unmount:

```bash
sudo umount /mnt/usb
```

---

##  Useful Options with `mount`

| Option        | Description                                 |
| ------------- | ------------------------------------------- |
| `-t <fstype>` | Specify file system type (e.g., ext4, vfat) |
| `-o loop`     | Use loopback device for mounting a file     |
| `-o ro`       | Mount as read-only                          |
| `-o rw`       | Mount as read-write                         |

---

##  Summary

| Task                               | Command                                  |
| ---------------------------------- | ---------------------------------------- |
| Mount ISO using loop               | `mount -o loop file.iso /mnt/iso`        |
| Mount USB drive                    | `mount /dev/sdb1 /mnt/usb`               |
| Mount specific partition in `.img` | `mount -o loop,offset=... disk.img /mnt` |
| Unmount any mount point            | `umount /mnt/...`                        |

---

Loop mounting is particularly useful for:

* Mounting OS images for inspection.
* Testing ISO contents before burning.
* Performing forensic analysis on disk images.

