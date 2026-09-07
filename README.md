# Enterprise AWS 3-Tier Architecture: CI/CD Infrastructure Automation

![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4.svg?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900.svg?style=for-the-badge&logo=amazon-aws)
![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-D24939.svg?style=for-the-badge&logo=jenkins)

This repository contains the complete Infrastructure as Code (IaC) to automatically provision a highly available, secure, and cost-optimized **3-Tier Web Architecture** on AWS. The deployment is fully automated using a **Jenkins CI/CD Pipeline**.

## 🏗️ Architecture Overview

The architecture follows best practices for security and high availability, splitting resources across Public, Private, and Database subnets across multiple Availability Zones.

- **Tier 1 (Presentation):** Public Application Load Balancer (ALB) routing traffic to an Nginx Web Server Auto Scaling Group in Public Subnets.
- **Tier 2 (Application):** Private Application Load Balancer (ALB) routing internal traffic to the Backend App Server Auto Scaling Group in Private Subnets.
- **Tier 3 (Data):** Amazon RDS MySQL Database located in isolated Database Subnets.

### Key Features
- **Highly Available**: Resources are spread across `ap-south-1a` and `ap-south-1b`.
- **Auto Scaling**: Web and App tiers automatically scale based on traffic.
- **Strict Security Groups**: The Database only accepts traffic from the App Tier. The App Tier only accepts traffic from the Web Tier.
- **Remote State Management**: Terraform state is stored securely in an S3 Bucket with DynamoDB locking.
- **Governance**: Automated daily AWS Backups for all EC2 instances via tagging (`Backup=true`).
- **Observability**: CloudWatch alarms trigger SNS notifications if CPU utilization exceeds 80%.

## 🛠️ Tech Stack
- **Infrastructure as Code:** Terraform
- **Cloud Provider:** Amazon Web Services (AWS)
- **CI/CD:** Jenkins
- **OS / Web Server:** Ubuntu Linux, Nginx
- **Database:** Amazon RDS (MySQL 8.0)

## 🚀 Deployment Instructions

This infrastructure is not meant to be applied manually from a local machine. It is designed to be deployed via Jenkins.

### 1. Prerequisites
- Create an S3 Bucket and DynamoDB table for Terraform remote state:
  ```bash
  aws s3api create-bucket --bucket <your-bucket-name> --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
  aws s3api put-bucket-versioning --bucket <your-bucket-name> --versioning-configuration Status=Enabled
  aws dynamodb create-table --table-name devsecops-terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region ap-south-1
  ```
- Ensure your `environments/dev/backend.tf` matches your bucket name.

### 2. Configure Jenkins Credentials
Add the following `Secret text` credentials in Jenkins:
- `aws-access-key-id`
- `aws-secret-access-key`
- `db-username` (e.g., admin)
- `db-password` (Strong password)

### 3. Run the Pipeline
1. Create a new Jenkins Pipeline Job and point it to this GitHub repository.
2. Click **Build with Parameters**.
3. Select **APPLY** to provision the 47 AWS resources.
4. The pipeline will pause after the `terraform plan` stage. Review the plan and click **Proceed** to authorize the deployment.

## 🧹 Teardown

To destroy the infrastructure and prevent AWS billing charges:
1. Go to your Jenkins Job.
2. Click **Build with Parameters**.
3. Select **DESTROY**.
4. Approve the teardown prompt. Jenkins will execute `terraform destroy` and safely remove all created resources.
