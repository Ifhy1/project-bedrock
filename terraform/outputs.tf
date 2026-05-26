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
  value       = aws_s3_bucket.assets.bucket
}

output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = aws_db_instance.mysql.address
}

output "postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgresql.address
}

output "dev_user_access_key" {
  description = "Access key for bedrock-dev-view"
  value       = aws_iam_access_key.dev_view.id
}

output "dev_user_secret_key" {
  description = "Secret key for bedrock-dev-view"
  value       = aws_iam_access_key.dev_view.secret
  sensitive   = true
}

output "dev_user_password" {
  description = "Console password for bedrock-dev-view"
  value       = aws_iam_user_login_profile.dev_view.password
  sensitive   = true
}