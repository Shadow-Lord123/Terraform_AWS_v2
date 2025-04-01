resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "TerraformVPC"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1

  tags = {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "mtc_public_subnet_2" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_2

  tags = {
    Name = "PublicSubnet2"
  }
}

resource "aws_subnet" "mtc_private_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private_subnet_1_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_1

  tags = {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "mtc_private_subnet2" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private_subnet_2_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_2

  tags = {
    Name = "PrivateSubnet2"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_eip" "example" {
 # domain = "vpc"
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.mtc_public_subnet.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.mtc_internet_gateway]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mtc_internet_gateway.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.mtc_public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.mtc_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.mtc_private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "mtc_sg" {
  vpc_id = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
    description = "Allow SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "mtc_security_group"
  }
}
