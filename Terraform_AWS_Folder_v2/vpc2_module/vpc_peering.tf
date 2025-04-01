
resource "aws_vpc_peering_connection" "foo" {
  #peer_owner_id = var.vpc_id
  peer_vpc_id   = var.vpc_id
  vpc_id        = var.vpc2_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between foo and bar"
  }
}

resource "aws_vpc" "foo" {
  cidr_block = var.vpc_cidr
}

resource "aws_vpc" "bar" {
  cidr_block = var.vpc_cidr2
}