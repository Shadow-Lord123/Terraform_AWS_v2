
# Data source for Ubuntu AMI
data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) Official AMI Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Generate SSH key
resource "tls_private_key" "document_db_instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "document_db_instance_key" {
  key_name   = "KritagyaTerraform-document-db-credentials"
  public_key = tls_private_key.document_db_instance_key.public_key_openssh
}

# Save private key locally with proper .pem extension
resource "local_file" "private_key" {
  filename        = "${path.module}/KritagyaTerraform-document-db-credentials.pem"
  content         = tls_private_key.document_db_instance_key.private_key_pem
  file_permission = "0600"
}

# EC2 instance to connect to DocDB
resource "aws_instance" "rds_connector" {
  ami                         = data.aws_ami.ubuntu-ami.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_1_id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.document_db_instance_key.key_name

  tags = {
    Name = "document_db_instance"
  }
}
