output "eks_node_group_id" {
  description = "The ID of the EKS Node Group"
  value       = aws_eks_node_group.example.id
}

output "eks_node_group_arn" {
  description = "The ARN of the EKS Node Group"
  value       = aws_eks_node_group.example.arn
}

output "eks_node_group_status" {
  description = "The status of the EKS Node Group"
  value       = aws_eks_node_group.example.status
}
