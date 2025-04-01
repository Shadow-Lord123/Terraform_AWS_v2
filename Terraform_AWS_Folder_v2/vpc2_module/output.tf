# Output the CIDR block for the second VPC
output "vpc2_cidr" {
  description = "CIDR block of the second VPC"
  value       = var.vpc_cidr
}

output "vpc2_id" {
  description = "The ID of the mtc_vpc"
  value       = aws_vpc.mtc_vpc.id
}

