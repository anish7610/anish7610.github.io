---
layout: default
title: git-internals 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Git Internals: How Commits, Trees, and Refs Work

Git is not just a version control system; it's a content-addressable file system with a powerful graph-based history model. Understanding how Git works under the hood—how commits, trees, and refs operate—can demystify its seemingly complex behavior and empower developers to troubleshoot or optimize their workflows.

---

## 1. **Content-Addressable Storage**

At its core, Git stores everything in the `.git/objects/` directory as **objects**. Each object is identified by the SHA-1 hash of its contents. These objects are:

* **Blob**: Stores the actual contents of a file.
* **Tree**: Represents a directory and lists its contents (files and subdirectories).
* **Commit**: Represents a snapshot of the project and metadata (author, timestamp, parent commit).
* **Tag**: A named reference to a commit.

---

## 2. **Blobs and Trees**

### Blob

A `blob` is a binary large object storing the contents of a file.

```bash
echo "hello" | git hash-object --stdin
```

This generates a SHA-1 hash and stores it in `.git/objects/`.

### Tree

A `tree` represents a directory. It maps filenames to blob (file) or tree (subdirectory) objects.

```bash
git cat-file -p <tree-hash>
```

This shows filenames, permissions, and associated object hashes.

Example:

```
100644 blob a1b2c3...    README.md
040000 tree d4e5f6...    src
```

---

## 3. **Commits**

A `commit` object points to a tree and optionally one or more parent commits (for merges).

```bash
git cat-file -p <commit-hash>
```

You’ll see:

```
tree <tree-hash>
parent <parent-hash>
author Anish <anish@example.com>
committer Anish <anish@example.com>

Commit message
```

A commit represents a snapshot of the project state, not a diff. This is why Git can easily traverse and re-apply entire states.

---

## 4. **Refs and HEAD**

Refs are human-readable names pointing to commit hashes:

* `refs/heads/master` → current branch pointer
* `refs/tags/v1.0` → tag pointer
* `HEAD` → points to current branch (symbolic ref)

```bash
cat .git/HEAD
```

Example:

```
ref: refs/heads/main
```

Changing branches updates the `HEAD` pointer.

---

## 5. **How a Commit Happens**

When you run `git commit`:

1. Git creates blobs for any changed files.
2. It creates a tree reflecting the directory structure and file blobs.
3. It creates a commit object pointing to the new tree and the previous commit.
4. It updates the current branch (ref) to point to the new commit.

---

## 6. **DAG and History**

Commits form a **Directed Acyclic Graph (DAG)**. Each commit points to its parent(s). This allows Git to:

* Rebase: move a commit subtree elsewhere.
* Merge: combine histories from multiple parents.
* Cherry-pick: reapply changes elsewhere.

---

## 7. **Conclusion**

Understanding Git internals—objects, trees, commits, and references—helps explain Git's robustness and flexibility. It's why operations like branching, merging, and rebasing are fast and efficient: Git is simply rewriting or redirecting pointers to snapshots.

For power users, tools like `git cat-file`, `git rev-parse`, and `git ls-tree` open a deeper understanding of what's going on behind the scenes.
