# Project Bedrock – InnovateMart EKS Deployment

## Architecture
This project provisions a production-grade Kubernetes environment on AWS EKS for InnovateMart's microservices retail application.

## Infrastructure
- **VPC:** project-bedrock-vpc (us-east-1, 2 AZs)
- **EKS Cluster:** project-bedrock-cluster (v1.34)
- **Databases:** RDS MySQL, RDS PostgreSQL, DynamoDB
- **Ingress:** AWS Load Balancer Controller + ALB
- **Observability:** CloudWatch + FluentBit
- **Serverless:** S3 + Lambda (bedrock-asset-processor)

## Architecture Diagram


```
                        ┌─────────────────┐
                        │  Internet/Users  │
                        └────────┬────────┘
                                 │
                        ┌────────▼────────┐
                        │      ALB        │
                        └────────┬────────┘
                                 │
┌────────────────────────────────▼──────────────────────────────────┐
│  project-bedrock-vpc (us-east-1)                                   │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Public Subnets — NAT Gateway │ Internet Gateway             │  │
│  └──────────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Private Subnets                                             │  │
│  │  ┌─────────────────────────┐   ┌──────────────────────────┐ │  │
│  │  │ EKS (retail-app ns)     │   │ bedrock-dev-view          │ │  │
│  │  │ ui │ catalog │ orders   │   │ IAM ReadOnly + RBAC view  │ │  │
│  │  │ RabbitMQ │ Redis        │   └──────────────────────────┘ │  │
│  │  └─────────────────────────┘   ┌──────────────────────────┐ │  │
│  │  ┌──────────────────────────┐  │ Secrets Manager           │ │  │
│  │  │ RDS MySQL │ RDS Postgres │  └──────────────────────────┘ │  │
│  │  │ DynamoDB                 │                               │  │
│  │  └──────────────────────────┘                               │  │
│  │  ┌──────────────────────────┐                               │  │
│  │  │ CloudWatch Logs          │                               │  │
│  │  └──────────────────────────┘                               │  │
│  └──────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────┘

S3 (bedrock-assets-alt-soe-025-4190) ──► Lambda (bedrock-asset-processor) ──► CloudWatch

GitHub Actions: PR → terraform plan │ Merge → terraform apply
```

The infrastructure lives inside a custom VPC (`project-bedrock-vpc`) in `us-east-1`, spread across two Availability Zones for high availability. Public subnets host the **Internet Gateway** which handles inbound traffic from the internet, and the **NAT Gateway** which allows resources in private subnets to reach the internet without being publicly exposed.

Incoming traffic first hits the **Application Load Balancer (ALB)** which routes requests into the private subnets where the application lives. The heart of the architecture is the **EKS cluster** (`project-bedrock-cluster` v1.34) where the retail store microservices — ui, catalog, orders, checkout, and cart — run as pods inside the `retail-app` namespace. **RabbitMQ** handles messaging between services and **Redis** manages session caching, both running as in-cluster pods.

All databases are managed AWS services — **RDS MySQL** for the catalog service, **RDS PostgreSQL** for the orders service, and **DynamoDB** for the cart service. Database credentials are securely stored in **AWS Secrets Manager** and injected into the application at runtime, never hardcoded.

A dedicated IAM user (`bedrock-dev-view`) provides the development team with read-only access to both the AWS Console and the Kubernetes cluster via RBAC. Container logs and EKS control plane logs are shipped to **CloudWatch** via FluentBit running as a DaemonSet on every node. Product image uploads to the **S3 bucket** (`bedrock-assets-alt-soe-025-4190`) automatically trigger the **Lambda function** `bedrock-asset-processor` which logs each filename to CloudWatch. All infrastructure changes are automated through a **GitHub Actions** CI/CD pipeline that plans on Pull Requests and applies on merge to main.

## Live Application URL
http://k8s-retailap-retailst-17d19cf248-479854556.us-east-1.elb.amazonaws.com

## How to Trigger the Pipeline

### Terraform Plan (Pull Request)
1. Create a new branch
2. Make changes to Terraform files
3. Open a Pull Request to main
4. GitHub Actions will automatically run terraform plan and post the output as a PR comment

### Terraform Apply (Merge to Main)
1. Review the plan output in the PR comment
2. Merge the PR to main
3. GitHub Actions will automatically run terraform apply

## Deploy Application
```bash
kubectl apply -f k8s/kubernetes.yaml -n retail-app
kubectl apply -f k8s/ingress.yaml
```

## Generate Grading Output
```bash
cd terraform
terraform output -json > ../grading.json
```
## Helm Deployment

To deploy the retail store application using Helm:

```bash
helm upgrade --install retail-store ./helm/retail-store \
  -n retail-app \
  --create-namespace \
  -f helm/retail-store/values.yaml
```
