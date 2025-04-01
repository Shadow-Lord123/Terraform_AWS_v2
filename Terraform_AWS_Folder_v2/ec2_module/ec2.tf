data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "example" {
  key_name   = "KeyEC2"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "${path.module}/KeyEC2.pem"
  content         = tls_private_key.example.private_key_pem
  file_permission = "0600"
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (change for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

resource "aws_instance" "example" {
  ami             = data.aws_ami.amzn-linux-2023-ami.id
  instance_type   = "t2.micro"
  subnet_id       = var.public_subnet_2_id
  key_name        = var.ssh_key_name  # Attach the generated key
  vpc_security_group_ids = [aws_security_group.example_sg.id]  # Use vpc_security_group_ids instead of security_groups

  root_block_device {
    volume_size           = 20  # Set disk size in GB (Modify as needed)
    volume_type           = "gp3"  # General Purpose SSD (gp2/gp3)
    delete_on_termination = true  # Delete volume on instance termination
  }

  tags = {
    Name = "tf-example"
  }
}
