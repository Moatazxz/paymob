# paymob

# Infrastructure Setup with Terraform

## Overview
The infrastructure supports the CI/CD pipelines and includes several critical components such as a VPC, subnets, route tables, security groups, EC2 instances, and an EKS cluster.

## Terraform Configuration Steps

### 1. VPC, Subnets, Route Table, and Security Groups
This section involves setting up a VPC, allocating resources via subnets, managing traffic with a route table, and securing resources with security groups.

### 2. EC2 Instances
Three EC2 instances are provisioned, each configured for specific roles critical to the operations of CI/CD pipelines:

- **Jenkins Server**: Hosts Jenkins and manages the CI/CD pipelines. It is configured with necessary tools and plugins to integrate with Docker and Ansible.
- **Ansible Server**: Manages deployment configurations to the Docker host and Kubernetes cluster using Ansible playbooks.
- **Docker Host**: Serves as the deployment server for Docker containers. It is set up to run and manage Docker containers based on the builds and deployments orchestrated by Jenkins and Ansible.

### 3. Kubernetes Cluster
An Elastic Kubernetes Service (EKS) cluster is established to manage and orchestrate containerized applications, utilizing Kubernetes for automated deployment, scaling, and management.

## Applying Terraform Configuration

**For EC2 Instances:**
Navigate to the Terraform configuration directory for hosting servers and apply the Terraform scripts to provision the infrastructure.
```bash
cd terraform/hostingservers
terraform init    # Initializes the Terraform configuration
terraform apply   # Provisions the EC2 instances
```
**For EKS Instances:**
Navigate to the Terraform configuration directory for hosting servers and apply the Terraform scripts to provision the infrastructure.
```bash
cd terraform/k8s
terraform init    # Initializes the Terraform configuration
terraform apply   # Provisions the EC2 instances
```
