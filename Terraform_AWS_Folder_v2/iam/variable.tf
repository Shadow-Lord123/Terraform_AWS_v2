
#variable "public_subnet_1_id" {
#  description = "ID for another public subnet"
#  type        = string
#}

#variable "public_subnet_2_id" {
#  description = "ID for other public subnet"
#  type        = string
#}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "The description of the node group"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "admin_user" {
  description = "The IAM user who will have full Kubernetes access"
  type        = string
}



