# paymob

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
After applying the Terraform configurations, a secret SSH key named tfkey.pem is generated. This key is essential for establishing SSH communications with the provisioned servers, enabling secure management and operational tasks.

## Jenkins Initial Setup and Plugin Installation

1. **Login to Jenkins Web Interface:**
   - Use the output password obtained from the command:
     ```bash
     sudo cat /var/lib/jenkins/secrets/initialAdminPassword
     ```
   - Visit the Jenkins web interface using the Jenkins server IP address.
   - Log in with the initial password provided.

2. **Change Initial Password:**
   - Upon first login, Jenkins will prompt you to create your own password.
   - Create a secure password and confirm it.

3. **Install Required Plugins:**
   - Once logged in, click on "Install suggested plugins" or "Install all recommended plugins" to install the required plugins automatically.
   - Alternatively, you can manually select plugins to install.

4. **Plugin Installation:**
   - Go to **Manage Jenkins > Manage Plugins**.
   - Select the **Available** tab.
   - Search for the following plugins and install them:
     - **SSH Agent Plugin:** Facilitates Jenkins to connect over SSH using a specified credential.
     - **Docker Plugin:** Integrates Jenkins with Docker to manage containers as part of the build process.
   - Click on the "Download now and install after restart" button to initiate the installation process.

5. **Restart Jenkins:**
   - After plugin installation, Jenkins will prompt you to restart.
   - Click on the "Restart Jenkins when installation is complete and no jobs are running" checkbox and then "Restart after install" button to restart Jenkins.

6. **Verify Plugin Installation:**
   - Once Jenkins restarts, verify that the plugins have been installed successfully by navigating to **Manage Jenkins > Manage Plugins > Installed** tab.
   - Confirm that the SSH Agent Plugin and Docker Plugin are listed among the installed plugins.


