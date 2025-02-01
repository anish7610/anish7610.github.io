---
layout: default
title: ipc-patterns-shared-memory-pipes-queues
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


### Shared Memory, Pipes, and Message Queues: IPC Patterns in Linux

Interprocess Communication (IPC) is essential in multitasking operating systems like Linux where processes often need to coordinate or share data. Linux offers several IPC mechanisms, each with trade-offs in speed, complexity, and use cases. Three of the most commonly used IPC methods are **Shared Memory**, **Pipes**, and **Message Queues**.

---

## 1. **Pipes**

### Overview:

Pipes provide a unidirectional communication channel between processes. They are commonly used between related processes like a parent and its child.

### Types:

* **Anonymous Pipes**: Exist only while the process is alive. Typically used for parent-child communication.
* **Named Pipes (FIFOs)**: Persist in the file system and allow communication between unrelated processes.

### Example:

```c
int pipefd[2];
pipe(pipefd); // pipefd[0] for reading, pipefd[1] for writing

if (fork() == 0) {
    // Child
    close(pipefd[1]);
    read(pipefd[0], buffer, sizeof(buffer));
} else {
    // Parent
    close(pipefd[0]);
    write(pipefd[1], "hello", 5);
}
```

### Pros:

* Simple to use.
* Supported in all POSIX systems.

### Cons:

* Unidirectional.
* Limited buffer size.
* Only suitable for byte-stream communication.

---

## 2. **Shared Memory**

### Overview:

Allows multiple processes to access the same physical memory space. It’s the fastest IPC mechanism because it avoids kernel/user space copying once mapped.

### Usage Steps:

1. Create/obtain a shared memory segment using `shmget()`.
2. Attach it to process memory space using `shmat()`.
3. Use normal memory operations to access it.
4. Detach and delete using `shmdt()` and `shmctl()`.

### Example:

```c
int shmid = shmget(IPC_PRIVATE, 1024, IPC_CREAT | 0666);
char *data = (char *)shmat(shmid, NULL, 0);
strcpy(data, "Shared Data");
shmdt(data);
shmctl(shmid, IPC_RMID, NULL);
```

### Pros:

* Very fast data transfer.
* Efficient for large datasets.

### Cons:

* No synchronization—must use semaphores/mutexes externally.
* More complex to manage lifecycle and cleanup.

---

## 3. **Message Queues**

### Overview:

Message queues allow processes to exchange discrete messages via the kernel. Each message has a type and content.

### Usage:

* Create using `msgget()`.
* Send using `msgsnd()`.
* Receive using `msgrcv()`.

### Example:

```c
struct msgbuf {
    long mtype;
    char mtext[100];
};

int msgid = msgget(IPC_PRIVATE, IPC_CREAT | 0666);
struct msgbuf msg = {1, "Hello"};
msgsnd(msgid, &msg, sizeof(msg.mtext), 0);
msgrcv(msgid, &msg, sizeof(msg.mtext), 1, 0);
```

### Pros:

* Messages are typed and buffered by the kernel.
* Can be prioritized and selectively received.

### Cons:

* Slower than shared memory.
* Kernel-imposed size and message limits.

---

## Choosing the Right IPC Mechanism

| Feature           | Pipes                      | Shared Memory               | Message Queues    |
| ----------------- | -------------------------- | --------------------------- | ----------------- |
| Speed             | Moderate                   | Fastest                     | Slower            |
| Direction         | Uni (or bi for socketpair) | Bi-directional (needs sync) | Bi-directional    |
| Synchronization   | No                         | External needed             | Built-in          |
| Suitable for      | Simple data                | Large data                  | Discrete messages |
| Related processes | Required (anonymous)       | Not required                | Not required      |

---

## Conclusion

Understanding IPC patterns is crucial for building efficient and responsive systems, especially in OS-level programming, system services, and performance-critical applications. Shared memory is ideal for large, fast data exchange (with synchronization), pipes are great for simple parent-child workflows, and message queues offer flexibility and safety when message ordering and delivery are important.
