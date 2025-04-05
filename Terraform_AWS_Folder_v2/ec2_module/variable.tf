variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "ID for other vpc"
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID for other public subnet"
  type        = string
}

variable "public_subnet_2_cidr_block" {
  description = "CIDR Block off public subnet 2"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}
