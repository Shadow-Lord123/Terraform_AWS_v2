variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_cidr2" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
  type        = string
}

variable "availability_zone_1" {
  description = "Availability Zone for the first set of subnets"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability Zone for the second set of subnets"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

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