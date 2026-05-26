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

