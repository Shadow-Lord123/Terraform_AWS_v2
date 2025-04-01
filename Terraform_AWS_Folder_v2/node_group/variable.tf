
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "The name of the node group"
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role for the EKS node group"
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

