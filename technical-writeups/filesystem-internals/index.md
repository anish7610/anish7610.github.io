---
layout: default
title: file-system-internals 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# 🗂 Technical Writeup: File System Internals – ext4 vs NTFS vs ZFS

A **file system** organizes how data is stored and retrieved on storage media. While all file systems aim to manage files and directories, their internal architecture and feature sets can differ significantly.

In this writeup, we explore the internals of three major file systems:

* **ext4** – default on most Linux systems
* **NTFS** – Windows default file system
* **ZFS** – enterprise-grade file system with built-in volume management

---

## 🧱 1. ext4 (Fourth Extended File System)

### 📌 Overview:

* Introduced in Linux 2.6.28
* Backward-compatible with ext3 and ext2
* Optimized for large storage and performance

### 📂 Internal Structures:

| Component       | Description                                                   |
| --------------- | ------------------------------------------------------------- |
| Superblock      | Stores metadata about the file system (size, status, UUID)    |
| Block Groups    | File system divided into groups for locality optimization     |
| Inodes          | Data structures that store metadata (permissions, timestamps) |
| Data Blocks     | Contain file content                                          |
| Directory Files | Special files mapping names to inode numbers                  |

### ✨ Key Features:

* **Journaling**: Uses a journal to record metadata updates before committing
* **Extent-based Allocation**: Improves performance for large files
* **Delayed Allocation**: Buffers writes to optimize disk layout
* **64-bit Storage**: Supports filesystems up to 1 exabyte

### ⚠️ Limitations:

* Limited checksumming (only journal CRC)
* External volume management needed (LVM, RAID)

---

## 🧾 2. NTFS (New Technology File System)

### 📌 Overview:

* Default file system for Windows since Windows XP
* Designed for security, recoverability, and scalability

### 📂 Internal Structures:

| Component               | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| Master File Table (MFT) | Core metadata structure; each file is a record in MFT    |
| File Record             | Contains attributes: standard info, filename, data, etc. |
| Attribute-Based         | Data and metadata stored as named attributes             |
| Journaling              | Transactional logging for recoverability                 |

### ✨ Key Features:

* **NTFS Journaling**: Logs changes to the MFT and critical metadata
* **Access Control Lists (ACLs)**: Fine-grained permissions
* **Compression & Encryption**: File-level NTFS compression and EFS
* **Alternate Data Streams (ADS)**: Allows multiple data forks per file
* **Sparse Files, Reparse Points, Hard Links**: Advanced features for performance and compatibility

### ⚠️ Limitations:

* No native snapshot support
* Windows-only support (read-only in Linux without extra drivers)

---

## 🧬 3. ZFS (Zettabyte File System)

### 📌 Overview:

* Originally developed by Sun Microsystems
* Combines a file system and volume manager
* Highly robust with self-healing capabilities

### 📂 Internal Structures:

| Component            | Description                                       |
| -------------------- | ------------------------------------------------- |
| Storage Pool (Zpool) | Aggregates devices into a single storage entity   |
| Datasets             | Filesystems and volumes created within a pool     |
| Objects              | ZFS is object-based, not block-based              |
| Uberblock            | Root of all metadata, stored redundantly          |
| Copy-on-Write (CoW)  | New data written elsewhere; metadata updated last |

### ✨ Key Features:

* **Transactional Copy-on-Write (CoW)**: Always-consistent state
* **Checksumming**: Every block has a checksum to detect corruption
* **Snapshots and Clones**: Instant, space-efficient backups and dev branches
* **Compression and Deduplication**: Inline and optional
* **Scrubbing**: Periodic verification of data integrity
* **Built-in RAID-Z**: Software RAID with no “write hole”

### ⚠️ Limitations:

* Higher memory usage (recommendation: 1 GB RAM per 1 TB storage)
* Complex setup; not ideal for embedded/low-resource systems

---

## ⚖️ Comparison Table

| Feature                     | ext4           | NTFS                  | ZFS                        |
| --------------------------- | -------------- | --------------------- | -------------------------- |
| OS Support                  | Linux          | Windows               | Linux, FreeBSD             |
| Journaling                  | Yes (metadata) | Yes (metadata + data) | Copy-on-Write (CoW)        |
| Snapshots                   | No             | No                    | Yes                        |
| Volume Management           | External (LVM) | Basic (Disk Mgmt)     | Built-in (Zpool)           |
| Checksumming                | Journal only   | Partial (metadata)    | Full (data + metadata)     |
| Max Volume Size             | 1 EB           | 256 TB (theoretical)  | 256 quadrillion zettabytes |
| Compression / Deduplication | No             | Compression only      | Yes                        |
| Self-healing                | No             | No                    | Yes                        |
| Memory Requirement          | Low            | Moderate              | High                       |

---

## 📁 Real-World Use Cases

| Scenario                              | Recommended File System |
| ------------------------------------- | ----------------------- |
| General Linux OS or servers           | ext4                    |
| Windows desktop or application server | NTFS                    |
| Enterprise storage / backups          | ZFS                     |
| Media production (large files)        | ZFS                     |
| Embedded devices / low RAM            | ext4                    |

---

## 🔚 Conclusion

* **ext4** is reliable, fast, and easy to manage, ideal for general Linux workloads.
* **NTFS** is tightly integrated with Windows, supporting ACLs and journaling.
* **ZFS** offers enterprise-grade reliability with advanced features like snapshots, CoW, and self-healing.

Each file system comes with trade-offs. Understanding their internals helps in choosing the right one based on performance, integrity, and feature needs.
