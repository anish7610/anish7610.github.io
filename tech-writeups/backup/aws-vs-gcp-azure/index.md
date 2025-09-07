---
layout: default
title: aws-vs-gcp-azure 
---

<a href="https://anish7610.github.io/technical-writeups" style="text-decoration: none;">← Back</a>


# AWS vs Azure vs GCP: Core Services Compared

---

###  Introduction

The three major cloud providers—**Amazon Web Services (AWS)**, **Microsoft Azure**, and **Google Cloud Platform (GCP)**—offer robust, scalable cloud computing services. Though similar in foundational services (compute, storage, networking), they differ in implementation, ecosystem, pricing, and target audience.

This writeup compares their **core services** across critical categories:

---

### ️ 1. **Compute Services**

| Feature            | AWS                         | Azure                          | GCP                            |
| ------------------ | --------------------------- | ------------------------------ | ------------------------------ |
| Virtual Machines   | EC2 (Elastic Compute Cloud) | Azure Virtual Machines         | Compute Engine                 |
| Serverless         | AWS Lambda                  | Azure Functions                | Cloud Functions                |
| Container Services | ECS, EKS                    | Azure Kubernetes Service (AKS) | GKE (Google Kubernetes Engine) |
| Autoscaling        | Auto Scaling Groups (ASG)   | VM Scale Sets                  | Managed Instance Groups        |

* **Highlight**: AWS offers more instance types and customization; GCP emphasizes fast boot and billing per second.

---

### ️ 2. **Storage Services**

| Feature               | AWS     | Azure           | GCP              |
| --------------------- | ------- | --------------- | ---------------- |
| Object Storage        | S3      | Blob Storage    | Cloud Storage    |
| Block Storage         | EBS     | Managed Disks   | Persistent Disks |
| File Storage          | EFS     | Azure Files     | Filestore        |
| Cold/Archival Storage | Glacier | Archive Storage | Archive Storage  |

* **Highlight**: S3 is the industry standard for object storage; GCP shines with lifecycle rules and multi-region buckets.

---

###  3. **Networking Services**

| Feature         | AWS                    | Azure                        | GCP                  |
| --------------- | ---------------------- | ---------------------------- | -------------------- |
| Virtual Network | VPC                    | Virtual Network (VNet)       | VPC                  |
| Load Balancer   | Elastic Load Balancing | Azure Load Balancer / App GW | Cloud Load Balancing |
| DNS             | Route 53               | Azure DNS                    | Cloud DNS            |
| CDN             | CloudFront             | Azure CDN                    | Cloud CDN            |

* **Highlight**: GCP provides global load balancers that aren’t region-bound, making it strong for multi-region apps.

---

###  4. **Identity & Access Management**

| Feature           | AWS       | Azure                        | GCP               |
| ----------------- | --------- | ---------------------------- | ----------------- |
| IAM               | IAM       | Azure Active Directory (AAD) | IAM               |
| Role-Based Access | Supported | Supported                    | Supported         |
| SSO               | AWS SSO   | Azure AD with SSO            | Identity Platform |

* **Highlight**: Azure’s strength lies in its tight integration with AAD for enterprise identity systems.

---

###  5. **Databases**

| Type             | AWS                           | Azure              | GCP                  |
| ---------------- | ----------------------------- | ------------------ | -------------------- |
| Relational       | RDS (MySQL, PostgreSQL, etc.) | Azure SQL Database | Cloud SQL            |
| NoSQL            | DynamoDB                      | Cosmos DB          | Firestore / Bigtable |
| Data Warehousing | Redshift                      | Synapse Analytics  | BigQuery             |

* **Highlight**: BigQuery is highly optimized for analytics; Cosmos DB is globally distributed and multi-model.

---

###  6. **AI/ML Services**

| Feature         | AWS                   | Azure                      | GCP                             |
| --------------- | --------------------- | -------------------------- | ------------------------------- |
| ML Platform     | SageMaker             | Azure ML Studio            | Vertex AI                       |
| NLP/Translation | Comprehend, Translate | Text Analytics, Translator | Natural Language API, Translate |
| Vision          | Rekognition           | Azure Computer Vision      | Vision API                      |

* **Highlight**: GCP leads in AI with Vertex AI and tight TensorFlow integration.

---

### ️ 7. **DevOps & CI/CD Tools**

| Feature                | AWS                     | Azure                        | GCP                           |
| ---------------------- | ----------------------- | ---------------------------- | ----------------------------- |
| CI/CD                  | CodePipeline, CodeBuild | Azure DevOps, GitHub Actions | Cloud Build, Cloud Deploy     |
| Infrastructure as Code | CloudFormation          | ARM/Bicep                    | Deployment Manager, Terraform |
| Monitoring             | CloudWatch              | Azure Monitor                | Cloud Operations Suite        |

---

###  8. **Pricing Model**

* **AWS**: Pay-as-you-go + Reserved + Spot Instances
* **Azure**: Pay-as-you-go + Reserved + Hybrid Benefits
* **GCP**: Per-second billing, sustained use discounts

**GCP** is often considered most cost-effective for **ephemeral** workloads; **AWS** provides fine-grained billing with a rich marketplace.

---

###  Summary Table

| Category                | AWS           | Azure          | GCP            |
| ----------------------- | ------------- | -------------- | -------------- |
| Compute                 | EC2, Lambda   | VM, Functions  | Compute Engine |
| Object Storage          | S3            | Blob Storage   | Cloud Storage  |
| Container Orchestration | ECS, EKS      | AKS            | GKE            |
| DB & Data               | RDS, DynamoDB | SQL DB, Cosmos | Cloud SQL, BQ  |
| IAM & Identity          | IAM           | AAD            | IAM            |
| AI/ML                   | SageMaker     | Azure ML       | Vertex AI      |
| CI/CD                   | CodePipeline  | Azure DevOps   | Cloud Build    |

---

###  Conclusion

* **AWS** is the most mature and has the largest ecosystem.
* **Azure** integrates deeply with Windows environments and Active Directory.
* **GCP** excels at data analytics, ML, and developer-friendly pricing.
