variable "public_subnet_1_id" {
  description = "ID for the first public subnet"
  type        = string
}

variable "public_subnet_2_id" {
  description = "ID for the second public subnet"
  type        = string
}

variable "replica_vpc_id" {
  description = "ID for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "ID for other vpc"
  type        = string
}

#variable "replica_subnet_1_vpc_id" {
#  description = "ID for the replica subnet"
#  type        = string
#}

#variable "replica_subnet_2_vpc_id" {
#  description = "ID for the replica subnet"
#  type        = string
#}