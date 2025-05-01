output "vpc_1_cidr" {
  description = "CIDR block of the first VPC"
  value       = var.vpc_cidr
}

output "vpc_2_cidr" {
  description = "CIDR block of the second VPC"
  value       = var.vpc_cidr2
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc2_id" {
  description = "The ID of the mtc_vpc"
  value       = module.vpc2.vpc2_id
}

output "public_subnet_1_id" {
  value = module.vpc.public_subnet_1_id
  description = "The ID of Public Subnet 2"
}

output "public_subnet_2_id" {
  value = module.vpc.public_subnet_2_id
  description = "The ID of Public Subnet 2"
}

output "public_subnet2_cidr_block" {
  value = module.vpc.public_subnet_2_cidr
  description = "The CIDR Block off the public subnet 2 id"
}

output "private_subnet_1_id" {
  value = module.vpc.private_subnet_1_id
  description = "The ID of Private Subnet 1"
}

output "private_subnet_2_id" {
  value = module.vpc.private_subnet_2_id
  description = "The ID of Private Subnet 2"
}

#output "eks_cluster_name" {
#  description = "The name of the created EKS cluster"
#  value      = module.eks.eks_cluster_name
#}

#output "node_group_name" {
#  description = "The name off the node group"
#  value       = var.node_group_name
#}

#output "cluster_role_arn" {
#  description = "The arn of the iam role of the cluster"
#  value       = module.iam_role.eks_cluster_role_arn
#}

#output "node_role_arn" {
#  description = "This is the node role for arn"
#  value        = module.iam_role.eks_node_group_role_arn
#}

#output "node_role_name" {
#  description = "This is the node role name"
#  value       = module.iam_role.eks_node_group_role_name
#}

#output "replica_vpc_id" {
#  value = module.rds_module.replica_vpc_id
#}

#output "replica_subnet_1_vpc_id" {
#  value = module.rds_module.subnet_1_vpc_id
#}

#output "replica_subnet_2_vpc_id" {
#  value = module.rds_module.subnet_2_vpc_id
#}
