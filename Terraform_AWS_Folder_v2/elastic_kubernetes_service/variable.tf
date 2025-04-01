variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "public_subnet_1_id" {
  description = "ID for the first public subnet"
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID for the second public subnet"
  type        = string
}

variable "private_subnet_1_id" {
  description = "ID for the private subnet"
  type        = string
}





