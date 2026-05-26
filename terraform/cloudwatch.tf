# IAM policy for CloudWatch observability
resource "aws_iam_role_policy_attachment" "cloudwatch_observability" {
  role       = module.eks.eks_managed_node_groups["default"].iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# CloudWatch Observability EKS Addon
resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = module.eks.cluster_name
  addon_name   = "amazon-cloudwatch-observability"

  depends_on = [aws_iam_role_policy_attachment.cloudwatch_observability]
}