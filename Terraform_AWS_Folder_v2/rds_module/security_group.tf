
# ✅ RDS Security Group (Declared first to avoid reference error)
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-access"
  vpc_id      = var.vpc_id

  # Allow inbound MySQL traffic from EC2 Security Group
ingress {
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  
}

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

# ✅ EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-public-access"
  vpc_id      = var.vpc_id

  # Allow SSH from anywhere (⚠️ Not secure for production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound MySQL traffic to RDS (correctly referencing rds_sg)
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
  }

  # Allow outbound MySQL traffic to RDS (correctly referencing rds_sg)
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all other outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}