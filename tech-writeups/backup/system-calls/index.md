---
layout: default
title: system-calls 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


#  System Calls in Linux and How They Work

In Linux (and Unix-like systems), **system calls** are the **primary interface between user-space applications and the kernel**. When a program wants to perform a privileged operation—like reading a file, allocating memory, or creating a process—it uses a system call.

---

##  What is a System Call?

A **system call** (or syscall) is a **controlled entry point into the operating system kernel**. It allows user applications to request services from the kernel securely.

>  For example, calling `read()` in C doesn't directly access hardware—it triggers a system call to the kernel to read from a file descriptor.

---

##  User Space vs Kernel Space

* **User Space**: Where applications like editors, browsers, and your shell run.
* **Kernel Space**: Privileged mode with direct access to hardware and core system resources.

System calls act as the **gateway between these two spaces**. Direct access is not allowed for security and stability reasons.

---

##  How a System Call Works (Simplified Flow)

```c
// C code:
write(1, "Hello\n", 6);
```

1. **Library Call (glibc)**: `write()` is a function in the C standard library (`glibc`), which internally prepares the syscall.
2. **Syscall Invocation**:

   * The syscall number for `write` (e.g., `__NR_write`) is placed in a CPU register (`rax` on x86\_64).
   * Arguments (file descriptor, buffer, length) go into other registers (`rdi`, `rsi`, `rdx`).
3. **Software Interrupt / Trap**:

   * CPU executes the `syscall` instruction (or `int 0x80` on 32-bit systems).
   * Switches from **user mode** to **kernel mode**.
4. **Kernel Handler**:

   * The kernel dispatches the syscall based on its number.
   * It performs the requested operation (e.g., writing to a file descriptor).
5. **Return to User Mode**:

   * Result (e.g., bytes written or error code) is placed in `rax`.
   * CPU switches back to user mode and returns control to the program.

---

##  Registers Used in x86-64 Syscalls

| Purpose        | Register |
| -------------- | -------- |
| Syscall number | `rax`    |
| arg1           | `rdi`    |
| arg2           | `rsi`    |
| arg3           | `rdx`    |
| arg4           | `r10`    |
| arg5           | `r8`     |
| arg6           | `r9`     |
| Return value   | `rax`    |

---

##  Common Linux System Calls

| Syscall    | Description                                   |
| ---------- | --------------------------------------------- |
| `read()`   | Reads data from a file descriptor             |
| `write()`  | Writes data to a file descriptor              |
| `open()`   | Opens a file                                  |
| `close()`  | Closes a file descriptor                      |
| `fork()`   | Creates a new process                         |
| `execve()` | Executes a new program                        |
| `wait()`   | Waits for process termination                 |
| `mmap()`   | Maps files or devices into memory             |
| `ioctl()`  | Device-specific input/output operations       |
| `clone()`  | Low-level thread creation (used in `pthread`) |

>  To see all system calls:
> `man 2 syscalls`
> `ausyscall --dump` (if `auditd` tools are installed)

---

##  Example: Raw syscall in Assembly (x86-64)

```asm
section .data
    msg db "Hello, world!", 0xA
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1          ; syscall number for write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, msg        ; message to write
    mov rdx, len        ; message length
    syscall             ; make the syscall

    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; exit code 0
    syscall
```

Assembled and run with:

```bash
nasm -f elf64 hello.asm && ld -o hello hello.o && ./hello
```

---

##  Viewing System Calls in Action

###  `strace` – Trace System Calls

```bash
strace ls
```

Example output:

```
openat(AT_FDCWD, ".", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
read(3, ...
write(1, "file.txt\n", 9) = 9
```

###  `perf` – Performance analysis of syscalls

```bash
perf stat -e syscalls:sys_enter_* ls
```

---

##  System Call Filtering: seccomp

Linux provides **seccomp** (Secure Computing Mode) to restrict the system calls a process can make.

Example: Block everything except `read`, `write`, and `exit`.

Used in:

* Containers (e.g., Docker)
* Sandboxing tools (e.g., Firejail)
* Browser and VM isolation

---

##  Summary

| Feature             | Description                             |
| ------------------- | --------------------------------------- |
| Purpose             | Gateway from user space to kernel       |
| Mechanism           | Registers + `syscall`/`int 0x80`        |
| Controlled by       | Kernel syscall table                    |
| Observable via      | `strace`, `perf`, `/proc/<pid>/syscall` |
| Secure handling via | seccomp, AppArmor, SELinux              |

---

##  Bonus: System Call vs Function Call

| Feature        | Function Call      | System Call                |
| -------------- | ------------------ | -------------------------- |
| Context Switch | No                 | Yes (user → kernel → user) |
| Scope          | Within the process | Into the kernel            |
| Overhead       | Low                | High                       |
| Example        | `strlen("abc")`    | `write(1, "abc", 3)`       |
