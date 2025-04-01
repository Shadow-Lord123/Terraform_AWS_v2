resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr2
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "TerraformVPC2"
  }
}
