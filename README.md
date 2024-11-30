# MERN DevOps Project

This project consists of a full-stack MERN Application that includes a frontend, backend, and MongoDB database, all managed through Docker containers using Docker Compose.

Project Overview
----------------

This project automates the deployment of a web application using modern DevOps practices, including Infrastructure as Code (IaC) with Terraform, container orchestration with Kubernetes (EKS), continuous integration/continuous deployment (CI/CD) pipelines with Jenkins, and Docker image management via Amazon Elastic Container Registry (ECR). The project integrates multiple AWS services such as EC2, RDS, S3, and AWS Backup for comprehensive cloud-based infrastructure.

Project Components
------------------

1.  **Terraform**: Infrastructure as Code (IaC) for provisioning AWS resources (EKS, RDS, Jenkins EC2, ECR, S3, AWS Backup).
2.  **Ansible**: Configuration management tool to automate Jenkins installation and CloudWatch Agent setup.
3.  **Docker**: Docker container for packaging and deploying the application.
4.  **Kubernetes**: Manages the application deployment on an EKS cluster with secure network policies.
5.  **Jenkins**: Multi-branch CI/CD pipeline to build, push Docker images to ECR, and deploy to Kubernetes on each Git push.

Prerequisites
-------------

-   **AWS CLI**: Installed and configured with sufficient IAM permissions.
-   **Terraform**: Installed to provision the AWS infrastructure.
-   **Ansible**: Installed for configuration management.
-   **Jenkins**: Running on EC2 with the necessary plugins installed.
-   **Docker**: Installed to build and run Docker images.
-   **kubectl**: Installed to manage Kubernetes clusters.
-   **Kubernetes Cluster (EKS)**: Created and accessible for deployment.
-   **AWS ECR**: To store Docker images.

Infrastructure Setup
--------------------

### 1\. Terraform Setup

The infrastructure is defined using Terraform and includes:

-   **Amazon EKS Cluster**: For running the Kubernetes workloads.
-   **Amazon RDS**: A MySQL database for the application.
-   **Jenkins EC2 Instance**: For running the Jenkins CI/CD server.
-   **AWS Backup**: To create daily snapshots of the Jenkins EC2 instance.
-   **Amazon S3 Bucket**: To store ALB access logs.
-   **AWS ECR**: To store Docker images for deployment.

### How to Use Terraform

1.  **Initialize Terraform**:

    `terraform init`

2.  **Plan Infrastructure**:
 
    `terraform plan`

3.  **Apply the Changes**:

    `terraform apply`

This will create all the AWS resources needed for the project.

Jenkins CI/CD Pipeline
----------------------

The project uses Jenkins to automate the CI/CD process. Every Git push triggers the following pipeline stages:

1.  **Build Docker Image**: Jenkins will build the Docker image using the `Dockerfile` in the repo.
2.  **Push to ECR**: The Docker image will be pushed to the Amazon ECR repository.
3.  **Deploy to Kubernetes**: The updated image will be deployed to the EKS cluster.


### Jenkinsfile

A `Jenkinsfile` is present in the root of this repo, defining the multi-branch pipeline

### Setting up Jenkins

1.  Install the necessary Jenkins plugins:
    -   Git Plugin
    -   Docker Pipeline
    -   Kubernetes Plugin
    -   Amazon ECR Plugin
2.  Add AWS and Kubernetes credentials in Jenkins (**Manage Jenkins** > **Manage Credentials**).


Application Deployment
----------------------

The Kubernetes manifests for the application (Deployment, Service, etc.) are located in the `k8s/` directory. After the Jenkins pipeline pushes a new Docker image to ECR, it will automatically update the deployment in the EKS cluster.

### Manual Deployment

If needed, you can manually apply Kubernetes manifests by running:

`kubectl apply -f k8s/deployment.yaml`

`kubectl apply -f k8s/service.yaml`

* * * * *

Monitoring and Backup
---------------------

1.  **CloudWatch Agent**: Installed via Ansible on all EC2 instances for centralized logging.
2.  **AWS Backup**: Configured via Terraform to create daily snapshots of the Jenkins EC2 instance.

* * * * *

Docker Setup
------------

### Local Development

For local development and testing, you can use Docker Compose. A `docker-compose.yml` file is available in the root of the repo.

`docker-compose up`

This command will bring up the application locally.
