---
layout: default
title: Uwriting-linux-kernel-module
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Writing a Kernel Module in C for Linux

Writing a Linux kernel module allows you to extend or modify the behavior of the Linux kernel without needing to reboot or recompile the kernel itself. Kernel modules can be drivers, filesystems, or other system utilities.

---

### 1. **What is a Kernel Module?**

A kernel module is a piece of code that can be loaded into the Linux kernel at runtime using tools like `insmod` and unloaded using `rmmod`. It runs in kernel space (as opposed to user space) and has access to internal kernel APIs.

---

### 2. **Development Environment Setup**

Install the required tools and headers:

```bash
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r)
```

---

### 3. **Minimal Kernel Module Code**

**Filename**: `hello_module.c`

```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Anish");
MODULE_DESCRIPTION("A simple Linux kernel module");
MODULE_VERSION("1.0");

static int __init hello_init(void) {
    printk(KERN_INFO "Hello, kernel!\n");
    return 0;
}

static void __exit hello_exit(void) {
    printk(KERN_INFO "Goodbye, kernel!\n");
}

module_init(hello_init);
module_exit(hello_exit);
```

---

### 4. **Writing the Makefile**

**Filename**: `Makefile`

```Makefile
obj-m += hello_module.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

---

### 5. **Building and Running the Module**

```bash
make
sudo insmod hello_module.ko
dmesg | tail  # Should show "Hello, kernel!"
sudo rmmod hello_module
dmesg | tail  # Should show "Goodbye, kernel!"
```

---

### 6. **Debugging and Logging**

Use `dmesg` to view kernel logs.
Use `printk()` for logging—use log levels like `KERN_INFO`, `KERN_WARNING`, `KERN_ERR`.

---

### 7. **Safety Considerations**

* Kernel modules run with high privileges.
* A buggy module can crash the entire system.
* Always test modules in a VM or sandboxed environment.

---

### 8. **Advanced Topics**

* Working with device drivers
* Using `procfs` or `sysfs` for user-space communication
* Handling interrupts
* Writing character device drivers

---

### 9. **Useful Tools**

* `insmod`, `rmmod`, `modinfo`, `lsmod`
* `dmesg` for kernel logs
* `gdb` with `kgdb` for kernel debugging (advanced)

---

### 10. **Conclusion**

Kernel modules are powerful tools for extending kernel capabilities on demand. Learning to write them improves your understanding of how the Linux kernel operates under the hood. Always follow best practices and test thoroughly.
