
output "replica_vpc_id" {
  value = aws_vpc.replica_vpc.id
}

output "subnet_1_vpc_id" {
  value = aws_subnet.replica_subnet_1.vpc_id
}

output "subnet_2_vpc_id" {
  value = aws_subnet.replica_subnet_2.vpc_id
}
