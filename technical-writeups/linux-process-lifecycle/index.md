---
layout: default
title: linux-process-lifecycle
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


## Linux Process Lifecycle: `fork`–`exec`–`wait` Mechanics

---

###  Introduction

The Linux process lifecycle revolves around the creation, execution, and termination of processes. The core system calls that manage this lifecycle are:

* `fork()` — to create a new process (a copy of the parent)
* `exec()` family — to replace the current process image with a new program
* `wait()` / `waitpid()` — to wait for child process termination and collect its exit status

Together, these implement the **parent-child process** model used by shells, daemons, and service supervisors in Unix-like systems.

---

###  1. `fork()` — Cloning a Process

#### Purpose:

`fork()` creates a **new child process** by duplicating the **parent's memory space**, file descriptors, and execution context.

#### Key Characteristics:

* Returns **0** in the child process
* Returns **child PID** in the parent process
* Returns **-1** on error

```c
pid_t pid = fork();
if (pid == 0) {
    // Child process
} else if (pid > 0) {
    // Parent process
} else {
    // Error
}
```

#### Behind the Scenes:

* **Copy-on-write (COW)** is used — memory is not physically copied unless modified.
* The child gets a new PID, but shares open file descriptors initially.

---

###  2. `exec()` — Replacing the Process Image

#### Purpose:

`exec()` replaces the **current process** image with a **new program**, preserving the same PID.

#### Variants:

```c
execl(path, arg0, arg1, ..., NULL);
execp(file, arg0, arg1, ..., NULL);   // searches in $PATH
execv(path, argv);                    // argv is a vector
execvp(file, argv);                   // vector + $PATH
execve(path, argv, envp);             // low-level
```

#### Example:

```c
execl("/bin/ls", "ls", "-l", NULL);
// Replaces current process with /bin/ls
```

#### Behavior:

* If `exec()` is successful, **it never returns**.
* If it returns, an error occurred (e.g., file not found).

---

### ⏳ 3. `wait()` / `waitpid()` — Synchronizing with Child Termination

#### Purpose:

Allows a parent process to **pause** until its child process **exits**, so it can collect the **exit status** and prevent **zombie processes**.

#### Example:

```c
pid_t pid = wait(&status);  // blocks until any child exits
```

```c
pid_t pid = waitpid(child_pid, &status, 0);  // wait for a specific child
```

* Macros like `WIFEXITED(status)` and `WEXITSTATUS(status)` extract exit codes.

---

###  Process Lifecycle Summary

```txt
+-------------------+         fork()         +--------------------+
|   Parent Process  |----------------------->|   Child Process    |
+-------------------+                        +--------------------+
                                                |
                                                |  exec("/bin/ls")
                                                v
                                           +--------------------+
                                           | Replaced Process   |
                                           | (e.g., /bin/ls)    |
                                           +--------------------+
                                                |
                                                | exits (status)
                                                v
                                      Parent calls wait() / waitpid()
```

---

### ️ Zombie and Orphan Processes

* **Zombie**: A child that has exited but has not been waited on; still occupies an entry in the process table.
* **Orphan**: A child whose parent exited before it; reparented to `init` (`PID 1`) which will reap it.

---

###  Example: A Simple Shell

```c
int main() {
    char *argv[] = {"/bin/ls", "-l", NULL};
    pid_t pid = fork();

    if (pid == 0) {
        execvp(argv[0], argv);  // Replace with ls
        perror("exec failed");  // Only if exec fails
    } else {
        wait(NULL);             // Parent waits for child to finish
    }
}
```

---

###  Tools to Observe This Lifecycle

* `strace ./a.out` — trace system calls like `fork`, `execve`, `wait`
* `ps -ef` — view process hierarchy
* `top` or `htop` — live process info

---

###  Conclusion

Understanding `fork()`, `exec()`, and `wait()` is crucial for:

* Writing custom shells or process supervisors
* Building daemons and services
* Handling concurrency and job control

This trio defines how processes are spawned, programs are executed, and resources are released — forming the backbone of Unix/Linux multitasking.
