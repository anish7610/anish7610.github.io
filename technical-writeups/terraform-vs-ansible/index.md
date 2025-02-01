---
layout: default
title: terraform-vs-ansible 
---

<a href="https://anish7600.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# Infrastructure as Code: Terraform vs Ansible

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure through code instead of manual processes. This approach brings automation, repeatability, and version control to infrastructure provisioning, aligning it closely with modern DevOps practices.

Two of the most popular tools in the IaC ecosystem are **Terraform** and **Ansible**. While both are used to automate infrastructure, they differ in purpose, approach, and underlying architecture.

---

## ❓ What Is IaC?

IaC allows you to:

* Define infrastructure declaratively (in code).
* Use version control (e.g., Git) to track changes.
* Apply automation and validation processes.
* Reuse templates and scale infrastructure quickly and consistently.

---

## 🛠️ Terraform: Declarative Provisioning

**Terraform**, developed by HashiCorp, is a tool focused on **provisioning infrastructure**.

### Key Features:

* **Declarative Syntax** (HCL): You describe what the infrastructure should look like, not how to create it.
* **Immutable Infrastructure**: Rather than modifying existing infrastructure, Terraform often destroys and recreates resources to reach the desired state.
* **State Management**: Maintains a `.tfstate` file that tracks real infrastructure vs. desired state.
* **Provider Ecosystem**: Supports AWS, Azure, GCP, Kubernetes, and more through plugins called providers.

### Use Cases:

* Provisioning EC2 instances, load balancers, databases, VPCs.
* Setting up cloud resources across multi-cloud environments.
* Managing Kubernetes infrastructure.

---

## 🧰 Ansible: Configuration Management and Orchestration

**Ansible**, developed by Red Hat, is an **agentless configuration management and automation** tool.

### Key Features:

* **Procedural YAML (Playbooks)**: You define steps to configure a system.
* **Push-Based**: Uses SSH to connect to remote systems; no need for agents.
* **Idempotency**: Ensures running the same playbook repeatedly yields the same result.
* **Broad Capabilities**: Besides provisioning, it’s also used for software deployment, patching, and configuration.

### Use Cases:

* Installing and configuring software (e.g., NGINX, Docker).
* Managing configuration drift.
* Orchestrating updates and patches on fleets of servers.

---

## 🔍 Terraform vs Ansible: Key Differences

| Feature           | Terraform                         | Ansible                         |
| ----------------- | --------------------------------- | ------------------------------- |
| Type              | Infrastructure Provisioning       | Configuration Management        |
| Language          | Declarative (HCL)                 | Procedural (YAML)               |
| State Management  | Yes (tfstate)                     | No (stateless)                  |
| Execution Mode    | Plan → Apply                      | Ad-hoc or Playbook-driven       |
| Agent Requirement | No                                | No (uses SSH)                   |
| Best For          | Provisioning infrastructure       | Configuring OS and software     |
| Cloud Support     | Excellent (AWS, Azure, GCP, etc.) | Good (through modules)          |
| Orchestration     | Limited (via `depends_on`)        | Strong (task sequencing, roles) |

---

## 🧪 Complementary Usage

In real-world DevOps workflows, **Terraform and Ansible are often used together**:

1. Use **Terraform** to provision cloud infrastructure (VMs, networks).
2. Use **Ansible** to configure the machines (install software, set up security, etc.).

**Example:**

```bash
terraform apply  # Launches EC2 instances
ansible-playbook -i inventory.ini configure.yml  # Installs Docker, sets up apps
```

---

## 🧠 Summary

* **Terraform** is best for infrastructure provisioning in a consistent, version-controlled manner.
* **Ansible** excels at post-provisioning configuration and ongoing system management.
* They solve different problems but together enable robust, scalable, and automated infrastructure.
