# AWS 3-Tier DevSecOps Automation Project

This repository contains the Terraform Infrastructure as Code (IaC) and Jenkins pipeline for a highly available, 3-tier web architecture on AWS.

## Architecture Highlights
- **Tier 1 (Web)**: Public Network Load Balancer routing to an Auto Scaling Group in public subnets.
- **Tier 2 (App)**: Internal Network Load Balancer routing to an Auto Scaling Group in private subnets.
- **Tier 3 (Database)**: Amazon RDS primary instance with a cross-region read replica for Disaster Recovery.
- **Backup & DR**: Centralized AWS Backup vault protecting Web and App tiers.
- **Monitoring**: CloudWatch Alarms for CPU, disk, and status checks with SNS notifications.
- **CI/CD**: Jenkins pipeline automating Terraform `init`, `plan`, and `apply` with approval gates.

## Directory Structure
- `/modules`: Contains reusable Terraform modules for each AWS service.
- `/environments/dev`: The root module wiring the child modules together.
- `Jenkinsfile`: The Declarative Pipeline for automated deployment.

## Prerequisites
- AWS CLI configured with appropriate IAM permissions.
- Terraform >= 1.6 installed locally (for testing).
- S3 Bucket and DynamoDB table for Terraform remote state locking.
- A running Jenkins server configured with AWS credentials.

## How to Deploy
Deployments should be triggered via Jenkins. 
If running locally for testing:
1. `cd environments/dev`
2. `cp ../../terraform.tfvars.example terraform.tfvars` (and fill in values)
3. `terraform init`
4. `terraform plan`
5. `terraform apply`

## How to Destroy
To avoid orphaned billing items, destroy the infrastructure:
1. `terraform destroy`
