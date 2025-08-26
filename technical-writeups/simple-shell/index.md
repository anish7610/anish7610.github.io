---
layout: default
title: simple-shell 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Writing a Simple Shell in C

A **shell** is a command-line interpreter that provides a user interface for accessing an operating system's services. Linux shells like `bash`, `zsh`, and `fish` are sophisticated programs with features like job control, redirection, and scripting. In this writeup, we'll explore how to **write a basic shell in C**, explaining the core components involved.

---

##  Overview of a Shell's Responsibilities

A simple shell performs the following tasks in a loop:

1. **Print prompt** – Show a prompt to the user.
2. **Read input** – Take input from the user (a command).
3. **Parse input** – Split the command into executable and arguments.
4. **Execute command** – Fork a child process, and `exec()` the command.
5. **Wait** – Wait for the child process to finish.

---

## ️ Required System Calls

* `fork()`: Creates a new process (child).
* `execvp()`: Replaces the current process image with a new one.
* `waitpid()`: Parent waits for child to terminate.
* `getline()`: Reads a line of input from the user.

---

##  Minimal Shell Code in C

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

#define MAX_ARGS 64

void shell_loop() {
    char *line = NULL;
    size_t len = 0;

    while (1) {
        printf("mysh> ");
        if (getline(&line, &len, stdin) == -1) {
            perror("getline");
            break;
        }

        // Remove newline character
        line[strcspn(line, "\n")] = 0;

        // Exit command
        if (strcmp(line, "exit") == 0) {
            break;
        }

        // Tokenize input
        char *args[MAX_ARGS];
        int i = 0;
        char *token = strtok(line, " ");
        while (token != NULL && i < MAX_ARGS - 1) {
            args[i++] = token;
            token = strtok(NULL, " ");
        }
        args[i] = NULL;

        // Fork and execute
        pid_t pid = fork();
        if (pid == 0) {
            execvp(args[0], args);
            perror("execvp failed");
            exit(EXIT_FAILURE);
        } else if (pid > 0) {
            waitpid(pid, NULL, 0);
        } else {
            perror("fork failed");
        }
    }

    free(line);
}

int main() {
    shell_loop();
    return 0;
}
```

---

##  Enhancements to Explore

* **Pipelines (`|`)** – Use `pipe()` and `dup2()`.
* **Redirection (`>`, `<`)** – Use `open()` and `dup2()`.
* **Built-in commands** – Implement `cd`, `exit`, etc. without `execvp`.
* **Job control** – Handle background execution with `&`.

---

##  Key Concepts

| Concept             | Explanation                                                 |
| ------------------- | ----------------------------------------------------------- |
| **Fork-Exec Model** | Splits shell and child processes cleanly.                   |
| **Parsing**         | Converts a single input string into structured arguments.   |
| **System Calls**    | Interfaces with the kernel to create and control processes. |
| **Waiting**         | Prevents zombie processes and keeps shell responsive.       |

---

##  Example Run

```
mysh> echo Hello, World!
Hello, World!
mysh> ls -l
(total output)
mysh> exit
```

---

##  Conclusion

Writing a shell helps you deeply understand:

* Process creation
* Inter-process communication
* System calls
* Input parsing and error handling

This exercise is an essential step for systems programmers and anyone interested in OS internals or building minimal containers, scripting environments, or DevOps tools.
