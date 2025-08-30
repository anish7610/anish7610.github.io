---
layout: default
title: debugging-with-strace-lsof-gdb
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Debugging with `strace`, `lsof`, and `gdb` for System-Level Errors

When programs fail silently or behave unexpectedly at the system level—such as crashing, hanging, or failing to open files—**system-level debugging tools** become invaluable. Tools like `strace`, `lsof`, and `gdb` let you inspect program behavior from the kernel interaction level up to memory and symbol resolution.

---

##  1. `strace`: Trace System Calls and Signals

`strace` intercepts and logs **system calls** and **signals** made by a process. It's useful for tracking failures related to file access, permissions, segmentation faults, and more.

###  Use Case: Program Fails to Open a File

```bash
strace ./my_program
```

Example output:

```
open("config.json", O_RDONLY) = -1 ENOENT (No such file or directory)
```

 Fix:

> The file `config.json` is missing or mislocated.

###  Use Case: Tracing a Running Process

```bash
strace -p <pid>
```

> Use this to attach to a hung or live-running process and watch system calls in real-time.

###  Filter Specific Calls (e.g., file operations):

```bash
strace -e open,read,write ./my_program
```

---

##  2. `lsof`: List Open Files

Every file, socket, pipe, and device in Unix is a file descriptor. `lsof` shows which files a process has open.

###  Use Case: Check if a File or Port is in Use

```bash
lsof /path/to/file
```

```bash
lsof -i :8080
```

Shows which process is using port 8080.

###  Use Case: See What Files a Process Has Open

```bash
lsof -p <pid>
```

Helpful for debugging leaks, unclosed descriptors, or resource locks.

---

##  3. `gdb`: GNU Debugger

`gdb` is a powerful source-level debugger for compiled programs. It allows inspecting memory, variables, call stacks, and performing line-by-line execution.

###  Use Case: Debug a Crash (Segmentation Fault)

1. Compile with debug symbols:

   ```bash
   gcc -g -o my_program my_program.c
   ```

2. Run under gdb:

   ```bash
   gdb ./my_program
   ```

3. Start execution:

   ```
   (gdb) run
   ```

4. On crash (e.g., segmentation fault), inspect:

   ```
   (gdb) bt        # Show backtrace (call stack)
   (gdb) info locals
   ```

###  Use Case: Attach to a Running Process

```bash
gdb -p <pid>
```

Inspect live memory, break on functions, or debug stuck processes.

---

##  Combine Tools for Power Debugging

| Problem                           | Tool(s)         | Example Command                        |
| --------------------------------- | --------------- | -------------------------------------- |
| File not found / permission issue | `strace`        | `strace ./myapp`                       |
| Process hangs                     | `strace`, `gdb` | `strace -p <pid>`, `gdb -p <pid>`      |
| Port/file already in use          | `lsof`          | `lsof -i :8080`, `lsof /tmp/some.lock` |
| Inspect call stack / variables    | `gdb`           | `gdb ./app`, `(gdb) bt`                |
| Memory access violation           | `gdb`           | Run with debug symbols, trigger crash  |

---

##  Bonus: Integrating with Core Dumps

1. Enable core dumps:

   ```bash
   ulimit -c unlimited
   ```

2. On crash, load core file:

   ```bash
   gdb ./my_program core
   ```

   Then:

   ```
   (gdb) bt
   ```

---

##  Summary

| Tool     | Best For                              | One-Liner Example |
| -------- | ------------------------------------- | ----------------- |
| `strace` | Tracing system calls and errors       | `strace ./myapp`  |
| `lsof`   | Listing open files/ports by process   | `lsof -p <pid>`   |
| `gdb`    | Full debugger: crashes, memory, stack | `gdb ./myapp`     |

These tools together help uncover system-level issues fast—whether it's a missing file, a permission error, a deadlock, or a segmentation fault.
