---
layout: default
title: device-drivers 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Writing Device Drivers in Linux: A Beginner's Guide

Device drivers act as the bridge between the hardware and the kernel. They allow user applications to interact with hardware devices without knowing the intricate details of how they operate. Linux, being an open-source OS, provides a rich environment for writing, testing, and deploying custom device drivers.

---

##  What is a Linux Device Driver?

A **Linux device driver** is a kernel module that controls a specific piece of hardware. These modules can be loaded and unloaded dynamically using tools like `insmod` and `rmmod`.

There are different types of drivers:

* **Character drivers** – Accessed as a stream of bytes (e.g., serial ports)
* **Block drivers** – Read/write data in blocks (e.g., hard drives)
* **Network drivers** – Facilitate network interfaces
* **USB, PCI, framebuffer drivers**, etc.

---

##  Anatomy of a Simple Character Device Driver

Here's what’s typically needed for a character device:

1. **Register the device** with the kernel
2. **Define file operations** (open, read, write, release)
3. **Handle data exchange**
4. **Unregister on exit**

---

## ️ Minimal Skeleton of a Character Driver

```c
#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>

#define DEVICE_NAME "mychardev"

static int major;

static int my_open(struct inode *inode, struct file *file) {
    printk(KERN_INFO "Device opened\n");
    return 0;
}

static int my_release(struct inode *inode, struct file *file) {
    printk(KERN_INFO "Device closed\n");
    return 0;
}

static ssize_t my_read(struct file *file, char __user *buf, size_t len, loff_t *offset) {
    printk(KERN_INFO "Read called\n");
    return 0;
}

static ssize_t my_write(struct file *file, const char __user *buf, size_t len, loff_t *offset) {
    printk(KERN_INFO "Write called\n");
    return len;
}

static struct file_operations fops = {
    .open = my_open,
    .release = my_release,
    .read = my_read,
    .write = my_write,
};

static int __init my_driver_init(void) {
    major = register_chrdev(0, DEVICE_NAME, &fops);
    printk(KERN_INFO "Registered with major number %d\n", major);
    return 0;
}

static void __exit my_driver_exit(void) {
    unregister_chrdev(major, DEVICE_NAME);
    printk(KERN_INFO "Unregistered device\n");
}

module_init(my_driver_init);
module_exit(my_driver_exit);

MODULE_LICENSE("GPL");
```

---

##  Testing the Driver

1. **Compile** with a Makefile
2. **Insert** using `insmod mydriver.ko`
3. **Create device node**:

   ```bash
   mknod /dev/mychardev c <major> 0
   ```
4. **Interact**:

   ```bash
   echo "hello" > /dev/mychardev
   cat /dev/mychardev
   ```

---

##  Kernel Space vs User Space

* Drivers run in **kernel space**, unlike applications that run in **user space**.
* Kernel-space code has full access to hardware, making it powerful but dangerous (a bug can crash the system).

---

##  Key Concepts

* **Device number (major/minor)**: Identifies the driver and the device.
* **File operations struct**: Maps system calls (`read`, `write`, etc.) to your driver’s functions.
* **Copy\_to\_user / copy\_from\_user**: Used for safely transferring data between kernel and user space.

---

##  Next Steps

* Handle **interrupts** and **DMA**
* Add **IOCTL** support for custom commands
* Learn **platform drivers** and **device trees** for embedded devices
* Explore **udev rules** for dynamic device management

---

##  Precautions

* Always test drivers on virtual machines or non-critical systems.
* Use logging (`printk`) generously.
* Be cautious with memory access and pointer dereferencing.

---

##  References

* [Linux Device Drivers, 3rd Edition](https://lwn.net/Kernel/LDD3/)
* `man 9` pages: `man 9 register_chrdev`, `man 9 file_operations`
* [kernel.org documentation](https://www.kernel.org/doc/html/latest/)
