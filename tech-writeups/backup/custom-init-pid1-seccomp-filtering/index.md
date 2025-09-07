---
layout: default
title: custom-init-pid1-seccomp-filtering
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


Creating a **custom init system with PID 1 and syscall filtering using seccomp** is a niche but powerful exercise in systems programming and Linux security. It gives insight into how init systems like `systemd`, `SysVinit`, and others orchestrate process lifecycle and apply security hardening.

---

###  Why Create a Custom Init System?

The `init` system (PID 1) is the first userspace process started by the kernel after boot and is responsible for starting all other processes. Writing your own gives you control over:

* **Process supervision**
* **Minimal environments for containers or embedded systems**
* **Applying security policies early (e.g., seccomp filters)**

---

###  Basic Responsibilities of an Init Process

A minimal init process in Linux must:

1. Be assigned PID 1.
2. Reap zombie child processes.
3. Spawn and supervise key daemons or shells.
4. Optionally handle signals like `SIGTERM`, `SIGCHLD`.

---

###  Basic C Implementation of Custom Init

```c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <seccomp.h>

void reap_zombies(int signum) {
    while (waitpid(-1, NULL, WNOHANG) > 0);
}

void setup_seccomp() {
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_KILL); // Kill by default
    if (!ctx) {
        perror("seccomp_init");
        exit(1);
    }

    // Allow some syscalls
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(fork), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(execve), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(wait4), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(nanosleep), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(rt_sigreturn), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(rt_sigaction), 0);

    if (seccomp_load(ctx) < 0) {
        perror("seccomp_load");
        seccomp_release(ctx);
        exit(1);
    }

    seccomp_release(ctx);
}

int main() {
    if (getpid() != 1) {
        fprintf(stderr, "Must be run as PID 1!\n");
        return 1;
    }

    signal(SIGCHLD, reap_zombies);
    setup_seccomp();

    pid_t pid = fork();
    if (pid == 0) {
        // Child - run a shell or target daemon
        execl("/bin/sh", "/bin/sh", NULL);
        perror("execl");
        exit(1);
    }

    // Init loop
    while (1) {
        pause(); // Wait for signals (e.g., SIGCHLD)
    }

    return 0;
}
```

---

###  Running Your Init in a Container

You can test it inside a minimal Docker container:

```Dockerfile
FROM alpine
COPY myinit /sbin/init
ENTRYPOINT ["/sbin/init"]
```

```bash
docker build -t custom-init .
docker run --rm -it --init=false custom-init
```

Note: `--init=false` disables Docker's own tini init process.

---

### ️ Adding More Syscall Filters

Use `strace` or `seccomp-tools` to monitor what syscalls your process actually makes, and refine the filter to allow only necessary ones:

```bash
strace -f -e trace=all ./myinit
```

---

###  Security Hardening Additions

* Use `prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)` before applying filters.
* Use `capset` to drop capabilities.
* Mount `/proc`, `/sys` manually if you're in a custom namespace.
* Apply seccomp at a per-process level to children.

---

###  Summary

A custom init with syscall filtering:

* Helps understand low-level Linux process management.
* Provides security isolation for minimal environments.
* Can serve as a lightweight replacement for full init systems in containers.
