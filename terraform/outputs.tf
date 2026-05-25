output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = var.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint

}

output "assets_bucket_name" {
  description = "S3 assets bucket name"
  value       = ""
}

output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = aws_db_instance.mysql.address
}

output "postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgresql.address
}