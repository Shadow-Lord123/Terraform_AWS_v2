
output "eks_cluster_name" {
  description = "The name of the created EKS cluster"
  value       = var.eks_cluster_name
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "node_group_name" {
  value = aws_eks_node_group.node_group.node_group_name
}