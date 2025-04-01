
output "eks_node_group_role_arn" {
  description = "IAM Role ARN for the EKS Node Group"
  value       = aws_iam_role.eks_node_group_role.arn
}

output "eks_node_group_role_name" {
  description = "IAM Role Name for the EKS Node Group"
  value       = aws_iam_role.eks_node_group_role.name
}

output "eks_cluster_role_arn" {
  description = "ARN of the IAM role for EKS Cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}