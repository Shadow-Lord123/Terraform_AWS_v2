# Output the CIDR block for the first VPC
output "vpc_cidr" {
  description = "CIDR block of the first VPC"
  value       = var.vpc_cidr
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.mtc_vpc.id
}

output "public_subnet_2_id" {
  value = aws_subnet.mtc_public_subnet_2.id
  description = "The ID of Public Subnet 2"
}

output "public_subnet_1_id" {
  value = aws_subnet.mtc_public_subnet.id
  description = "The ID of Public Subnet 1"
}

output "private_subnet_1_id" {
  value = aws_subnet.mtc_private_subnet.id
  description = "The ID of Private Subnet 1"
}

output "public_subnet_2_cidr" {
  value       = aws_subnet.mtc_public_subnet_2.cidr_block
  description = "The CIDR block of Public Subnet 2"
}



